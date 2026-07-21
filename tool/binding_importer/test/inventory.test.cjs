const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const test = require('node:test');

const {importVscodeDeclarations} = require('../src/importer.cjs');

const pendingCoverage = {
  discovery: 'discovered',
  semantics: 'pending',
  binding: 'pending',
  host: 'pending',
};

test('imports module, namespace, and function into canonical IR', () => {
  const source = `
    declare module 'vscode' {
      export namespace commands {
        export function ping(message: string): Disposable;
      }
    }
  `;

  assert.deepEqual(importVscodeDeclarations(source, 'fixture.d.ts'), {
    schemaVersion: 1,
    module: {
      id: 'module:vscode',
      name: 'vscode',
    },
    declarations: [
      {
        id: 'namespace:vscode.commands',
        kind: 'namespace',
        name: 'commands',
        qualifiedName: 'vscode.commands',
        parentId: 'module:vscode',
        deprecated: false,
        visibility: 'public',
        coverage: pendingCoverage,
      },
      {
        id:
          'function:vscode.commands.ping@' +
          'ebfe0aaf239337bd13815365e2ddd66659aa68c9c5505e9a82d5160f8bf1f4fc',
        kind: 'function',
        name: 'ping',
        qualifiedName: 'vscode.commands.ping',
        parentId: 'namespace:vscode.commands',
        deprecated: false,
        visibility: 'public',
        coverage: pendingCoverage,
        canonicalSignature:
          '{"typeParameters":[],"parameters":[{"optional":false,' +
          '"rest":false,"type":{"kind":"primitive","name":"string"}}],' +
          '"returnType":{"kind":"reference","name":"Disposable",' +
          '"typeArguments":[]}}',
        typeParameters: [],
        parameters: [
          {
            name: 'message',
            optional: false,
            rest: false,
            type: {
              kind: 'primitive',
              name: 'string',
            },
          },
        ],
        returnType: {
          kind: 'reference',
          name: 'Disposable',
          typeArguments: [],
        },
      },
    ],
  });
});

test('merged namespaces and reordered overloads have stable unique IDs', () => {
  const first = `
    declare module 'vscode' {
      export namespace commands {
        /** @deprecated Use executeNew. */
        export function execute(value: string): Disposable;
        export function execute(value: number): Disposable;
      }
      export namespace commands {
        export function ping(): void;
      }
    }
  `;
  const reordered = `
    declare module 'vscode' {
      export namespace commands { export function ping(): void; }
      export namespace commands {
        export function execute(value: number): Disposable;
        /** @deprecated Use executeNew. */
        export function execute(value: string): Disposable;
      }
    }
  `;

  const firstIr = importVscodeDeclarations(first, 'first.d.ts');
  const reorderedIr = importVscodeDeclarations(reordered, 'reordered.d.ts');

  assert.deepEqual(firstIr, reorderedIr);
  assert.equal(
    firstIr.declarations.filter((item) => item.kind === 'namespace').length,
    1,
  );
  assert.equal(
    new Set(firstIr.declarations.map((item) => item.id)).size,
    firstIr.declarations.length,
  );
  assert.equal(
    firstIr.declarations.find(
      (item) =>
        item.qualifiedName === 'vscode.commands.execute' &&
        item.parameters[0].type.name === 'string',
    ).deprecated,
    true,
  );
});

test('inventories supported global declarations beside the vscode module', () => {
  const source = `
    type GlobalOptions = string;
    declare module 'vscode' {}
  `;

  const declarations = importVscodeDeclarations(
    source,
    'global-declaration.d.ts',
  ).declarations;

  assert.deepEqual(
    declarations.map((item) => [item.id, item.kind]),
    [['typeAlias:global.GlobalOptions', 'typeAlias']],
  );
});

test('inventories every merged vscode module declaration', () => {
  const source = `
    declare module 'vscode' { export function first(): void; }
    declare module 'vscode' { export function second(): void; }
  `;

  const declarations = importVscodeDeclarations(
    source,
    'merged-module.d.ts',
  ).declarations;

  assert.deepEqual(
    declarations.map((item) => item.qualifiedName),
    ['vscode.first', 'vscode.second'],
  );
});

test('inventories every segment of a dotted namespace', () => {
  const source = `
    declare module 'vscode' {
      export namespace languages.providers {
        export function ping(): void;
      }
    }
  `;

  const declarations = importVscodeDeclarations(
    source,
    'dotted-namespace.d.ts',
  ).declarations;

  assert.deepEqual(
    declarations.map((item) => [item.qualifiedName, item.kind]),
    [
      ['vscode.languages', 'namespace'],
      ['vscode.languages.providers', 'namespace'],
      ['vscode.languages.providers.ping', 'function'],
    ],
  );
});

test('signature IDs ignore parameter names', () => {
  const withValue = `
    declare module 'vscode' {
      export namespace commands {
        export function ping(value: string): Disposable;
      }
    }
  `;
  const withMessage = `
    declare module 'vscode' {
      export namespace commands {
        export function ping(message: string): Disposable;
      }
    }
  `;

  const valueId = importVscodeDeclarations(
    withValue,
    'value.d.ts',
  ).declarations.find((item) => item.kind === 'function').id;
  const messageId = importVscodeDeclarations(
    withMessage,
    'message.d.ts',
  ).declarations.find((item) => item.kind === 'function').id;

  assert.equal(valueId, messageId);
});

test('signature IDs ignore nested callback and tuple labels', () => {
  const first = `
    declare module 'vscode' {
      export function register(
        callback: (value: string) => void,
        tuple: [first: string],
      ): void;
    }
  `;
  const renamed = `
    declare module 'vscode' {
      export function register(
        handler: (message: string) => void,
        coordinates: [label: string],
      ): void;
    }
  `;

  const firstId = importVscodeDeclarations(
    first,
    'first-labels.d.ts',
  ).declarations.find((item) => item.kind === 'function').id;
  const renamedId = importVscodeDeclarations(
    renamed,
    'renamed-labels.d.ts',
  ).declarations.find((item) => item.kind === 'function').id;

  assert.equal(firstId, renamedId);
});

test('inventories every declaration and member category', () => {
  const source = `
    declare module 'vscode' {
      export namespace nested {}

      export interface Service<T> extends Base<T> {
        readonly value?: T;
        call(input: string): Thenable<T>;
        call(input: number): Thenable<T>;
        (input: T): void;
        [key: string]: T;
      }

      export class Widget {
        readonly label: string;
        constructor(label: string);
        constructor(label: string, count: number);
        run(): void;
      }

      export enum Mode { first, second = 'second' }
      export type Options = { enabled: boolean; [key: string]: unknown };
      export const first: string, second: number;
      export function create(value: string): Widget;
      export function create(value: number): Widget;
    }
  `;

  const declarations = importVscodeDeclarations(
    source,
    'all-categories.d.ts',
  ).declarations;
  const kinds = Object.fromEntries(
    [...new Set(declarations.map((item) => item.kind))]
      .sort()
      .map((kind) => [
        kind,
        declarations.filter((item) => item.kind === kind).length,
      ]),
  );

  assert.deepEqual(kinds, {
    callSignature: 1,
    class: 1,
    constructor: 2,
    enum: 1,
    enumMember: 2,
    function: 2,
    indexSignature: 2,
    interface: 1,
    method: 3,
    namespace: 1,
    property: 3,
    typeAlias: 1,
    typeLiteral: 1,
    variable: 2,
  });
  assert.equal(
    new Set(declarations.map((item) => item.id)).size,
    declarations.length,
  );
});

test('distinguishes static and instance method signatures', () => {
  const source = `
    declare module 'vscode' {
      export class Service {
        static run(): void;
        run(): void;
      }
    }
  `;

  const methods = importVscodeDeclarations(
    source,
    'static-instance.d.ts',
  ).declarations.filter((item) => item.kind === 'method');

  assert.equal(methods.length, 2);
  assert.equal(new Set(methods.map((item) => item.id)).size, 2);
  assert.deepEqual(
    methods.map((item) => item.static).sort(),
    [false, true],
  );
});

test('distinguishes static and instance properties', () => {
  const source = `
    declare module 'vscode' {
      export class Service {
        static readonly value: string;
        readonly value: string;
      }
    }
  `;

  const properties = importVscodeDeclarations(
    source,
    'static-instance-properties.d.ts',
  ).declarations.filter((item) => item.kind === 'property');

  assert.equal(properties.length, 2);
  assert.equal(new Set(properties.map((item) => item.id)).size, 2);
  assert.deepEqual(
    properties.map((item) => item.static).sort(),
    [false, true],
  );
});

test('inventories the complete pinned VS Code API without omissions', () => {
  const inputPath = path.resolve(
    __dirname,
    '../../bindings/inputs/vscode/1.129.1/vscode.d.ts',
  );
  const declarations = importVscodeDeclarations(
    fs.readFileSync(inputPath, 'utf8'),
    inputPath,
  ).declarations;
  const kinds = Object.fromEntries(
    [...new Set(declarations.map((item) => item.kind))]
      .sort()
      .map((kind) => [
        kind,
        declarations.filter((item) => item.kind === kind).length,
      ]),
  );

  assert.deepEqual(kinds, {
    callSignature: 1,
    class: 122,
    constructor: 123,
    enum: 64,
    enumMember: 234,
    function: 151,
    indexSignature: 28,
    interface: 303,
    method: 394,
    namespace: 16,
    property: 1334,
    typeAlias: 20,
    typeLiteral: 91,
    variable: 98,
  });
  assert.equal(
    new Set(declarations.map((item) => item.id)).size,
    declarations.length,
  );
  assert.equal(
    declarations
      .filter((item) => item.kind === 'function')
      .reduce((total, item) => total + (item.occurrenceCount ?? 1), 0),
    154,
  );
  assert.equal(
    declarations.some((item) => item.id === 'interface:global.Thenable'),
    true,
  );
});

test('fails closed on an unclassified public type member', () => {
  const source = `
    declare module 'vscode' {
      export interface FutureShape {
        new (): FutureShape;
      }
    }
  `;

  assert.throws(
    () => importVscodeDeclarations(source, 'unsupported-member.d.ts'),
    (error) => {
      assert.equal(error.code, 'UNCLASSIFIED_PUBLIC_SYNTAX');
      assert.match(error.message, /unsupported-member\.d\.ts/);
      assert.match(error.message, /interface:vscode\.FutureShape/);
      assert.match(error.message, /ConstructSignature/);
      assert.match(error.message, /new \(\): FutureShape/);
      return true;
    },
  );
});

test('fails closed on an unclassified public module statement', () => {
  const source = `
    declare module 'vscode' {
      export import futureApi = FutureNamespace;
    }
  `;

  assert.throws(
    () => importVscodeDeclarations(source, 'unsupported-statement.d.ts'),
    (error) => {
      assert.equal(error.code, 'UNCLASSIFIED_PUBLIC_SYNTAX');
      assert.match(error.message, /unsupported-statement\.d\.ts/);
      assert.match(error.message, /module:vscode/);
      assert.match(error.message, /ImportEqualsDeclaration/);
      assert.match(error.message, /futureApi = FutureNamespace/);
      return true;
    },
  );
});

test('nested unsupported syntax has a contextual fail-closed diagnostic', () => {
  const source = `
    declare module 'vscode' {
      export interface FutureShape<T> {
        value: T extends string ? true : false;
      }
    }
  `;

  assert.throws(
    () => importVscodeDeclarations(source, 'unsupported-nested-type.d.ts'),
    (error) => {
      assert.equal(error.code, 'UNCLASSIFIED_PUBLIC_SYNTAX');
      assert.match(error.message, /unsupported-nested-type\.d\.ts/);
      assert.match(
        error.message,
        /property:interface:vscode\.FutureShape\/\$instance\/value/,
      );
      assert.match(error.message, /ConditionalType/);
      assert.match(error.message, /T extends string \? true : false/);
      return true;
    },
  );
});

test('records orthogonal coverage states and explicit visibility exclusions', () => {
  const inputPath = path.resolve(
    __dirname,
    '../../bindings/inputs/vscode/1.129.1/vscode.d.ts',
  );
  const declarations = importVscodeDeclarations(
    fs.readFileSync(inputPath, 'utf8'),
    inputPath,
  ).declarations;
  const excluded = declarations.filter(
    (item) => item.coverage.semantics === 'excluded',
  );

  assert.equal(
    declarations.every(
      (item) => item.coverage.discovery === 'discovered',
    ),
    true,
  );
  assert.deepEqual(
    Object.fromEntries(
      ['private', 'protected'].map((visibility) => [
        visibility,
        excluded.filter((item) => item.visibility === visibility).length,
      ]),
    ),
    {private: 9, protected: 1},
  );
  assert.equal(excluded.every((item) => item.kind === 'constructor'), true);
  assert.equal(
    excluded.every(
      (item) =>
        item.coverage.binding === 'excluded' &&
        item.coverage.host === 'notApplicable',
    ),
    true,
  );
  assert.equal(
    declarations
      .filter((item) => item.visibility === 'public')
      .every(
        (item) =>
          item.coverage.semantics === 'pending' &&
          item.coverage.binding === 'pending' &&
          item.coverage.host === 'pending',
      ),
    true,
  );
});
