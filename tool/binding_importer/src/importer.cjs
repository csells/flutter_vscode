const crypto = require('node:crypto');

const ts = require('typescript');

function importVscodeDeclarations(source, fileName) {
  const sourceFile = ts.createSourceFile(
    fileName,
    source,
    ts.ScriptTarget.Latest,
    true,
    ts.ScriptKind.TS,
  );
  if (sourceFile.parseDiagnostics.length > 0) {
    const error = new Error(
      `Cannot parse ${fileName}: ${sourceFile.parseDiagnostics[0].messageText}`,
    );
    error.code = 'TYPESCRIPT_PARSE_FAILED';
    throw error;
  }

  const state = {
    sourceFile,
    declarations: [],
    declarationsById: new Map(),
  };
  let vscodeModuleCount = 0;
  for (const statement of sourceFile.statements) {
    if (
      ts.isModuleDeclaration(statement) &&
      ts.isStringLiteral(statement.name) &&
      statement.name.text === 'vscode'
    ) {
      vscodeModuleCount += 1;
      if (!statement.body) {
        throwUnclassifiedPublicSyntax(
          state,
          statement,
          'module:vscode',
          'module declaration',
        );
      }
      visitModuleBody(statement.body, 'vscode', 'module:vscode', state);
      continue;
    }
    visitDeclarationStatement(statement, 'global', 'global:global', state);
  }
  if (vscodeModuleCount === 0) {
    const error = new Error(`${fileName} does not declare module 'vscode'.`);
    error.code = 'VSCODE_MODULE_MISSING';
    throw error;
  }
  state.declarations.sort(compareDeclarations);

  return {
    schemaVersion: 1,
    module: {
      id: 'module:vscode',
      name: 'vscode',
    },
    declarations: state.declarations,
  };
}

function visitModuleBody(body, parentName, parentId, state) {
  if (ts.isModuleDeclaration(body) && ts.isIdentifier(body.name)) {
    visitNamespaceDeclaration(body, parentName, parentId, state);
    return;
  }
  if (!ts.isModuleBlock(body)) {
    throwUnclassifiedPublicSyntax(
      state,
      body,
      parentId,
      'namespace body',
    );
  }

  for (const statement of body.statements) {
    visitDeclarationStatement(statement, parentName, parentId, state);
  }
}

function visitDeclarationStatement(statement, parentName, parentId, state) {
  if (ts.isModuleDeclaration(statement) && ts.isIdentifier(statement.name)) {
    visitNamespaceDeclaration(statement, parentName, parentId, state);
    return;
  }

  if (ts.isFunctionDeclaration(statement) && statement.name) {
    addSignatureDeclaration(
      state,
      'function',
      statement.name.text,
      `${parentName}.${statement.name.text}`,
      parentId,
      statement,
    );
    return;
  }

  if (ts.isInterfaceDeclaration(statement)) {
    visitInterface(statement, parentName, parentId, state);
    return;
  }

  if (ts.isClassDeclaration(statement) && statement.name) {
    visitClass(statement, parentName, parentId, state);
    return;
  }

  if (ts.isEnumDeclaration(statement)) {
    visitEnum(statement, parentName, parentId, state);
    return;
  }

  if (ts.isTypeAliasDeclaration(statement)) {
    visitTypeAlias(statement, parentName, parentId, state);
    return;
  }

  if (ts.isVariableStatement(statement)) {
    visitVariableStatement(statement, parentName, parentId, state);
    return;
  }

  throwUnclassifiedPublicSyntax(state, statement, parentId, 'statement');
}

function visitNamespaceDeclaration(statement, parentName, parentId, state) {
  const qualifiedName = `${parentName}.${statement.name.text}`;
  const id = `namespace:${qualifiedName}`;
  addDeclaration(state, {
    id,
    kind: 'namespace',
    name: statement.name.text,
    qualifiedName,
    parentId,
    deprecated: isDeprecated(statement),
  });
  if (!statement.body) {
    throwUnclassifiedPublicSyntax(
      state,
      statement,
      id,
      'namespace declaration',
    );
  }
  visitModuleBody(statement.body, qualifiedName, id, state);
}

function visitInterface(node, parentName, parentId, state) {
  const qualifiedName = `${parentName}.${node.name.text}`;
  const id = `interface:${qualifiedName}`;
  addDeclaration(state, {
    id,
    kind: 'interface',
    name: node.name.text,
    qualifiedName,
    parentId,
    deprecated: isDeprecated(node),
    typeParameters: normalizeTypeParameters(node.typeParameters, state),
    extends: normalizeHeritageClauses(
      node.heritageClauses,
      ts.SyntaxKind.ExtendsKeyword,
      state,
      id,
    ),
  });
  visitTypeMembers(node.members, qualifiedName, id, state);
}

function visitClass(node, parentName, parentId, state) {
  const qualifiedName = `${parentName}.${node.name.text}`;
  const id = `class:${qualifiedName}`;
  addDeclaration(state, {
    id,
    kind: 'class',
    name: node.name.text,
    qualifiedName,
    parentId,
    deprecated: isDeprecated(node),
    abstract: hasModifier(node, ts.SyntaxKind.AbstractKeyword),
    typeParameters: normalizeTypeParameters(node.typeParameters, state),
    extends: normalizeHeritageClauses(
      node.heritageClauses,
      ts.SyntaxKind.ExtendsKeyword,
      state,
      id,
    ),
    implements: normalizeHeritageClauses(
      node.heritageClauses,
      ts.SyntaxKind.ImplementsKeyword,
      state,
      id,
    ),
  });
  visitTypeMembers(node.members, qualifiedName, id, state);
}

function visitEnum(node, parentName, parentId, state) {
  const qualifiedName = `${parentName}.${node.name.text}`;
  const id = `enum:${qualifiedName}`;
  addDeclaration(state, {
    id,
    kind: 'enum',
    name: node.name.text,
    qualifiedName,
    parentId,
    deprecated: isDeprecated(node),
    constant: hasModifier(node, ts.SyntaxKind.ConstKeyword),
  });

  for (const member of node.members) {
    const name = normalizeDeclarationName(member.name, state, id);
    const memberQualifiedName = `${qualifiedName}.${name}`;
    const record = {
      id: `enumMember:${id}/${encodeIdPart(name)}`,
      kind: 'enumMember',
      name,
      qualifiedName: memberQualifiedName,
      parentId: id,
      deprecated: isDeprecated(member),
    };
    if (member.initializer) {
      record.initializer = normalizeExpression(member.initializer, state, id);
    }
    addDeclaration(state, record);
  }
}

function visitTypeAlias(node, parentName, parentId, state) {
  const qualifiedName = `${parentName}.${node.name.text}`;
  const id = `typeAlias:${qualifiedName}`;
  const type = normalizeType(node.type, state, {
    qualifiedName,
    parentId: id,
    role: 'type',
  });
  addDeclaration(state, {
    id,
    kind: 'typeAlias',
    name: node.name.text,
    qualifiedName,
    parentId,
    deprecated: isDeprecated(node),
    typeParameters: normalizeTypeParameters(node.typeParameters, state),
    type,
  });
}

function visitVariableStatement(node, parentName, parentId, state) {
  const constant = (node.declarationList.flags & ts.NodeFlags.Const) !== 0;
  for (const declaration of node.declarationList.declarations) {
    if (!ts.isIdentifier(declaration.name)) {
      throwUnclassifiedPublicSyntax(
        state,
        declaration,
        parentId,
        'variable declaration',
      );
    }
    const name = declaration.name.text;
    const qualifiedName = `${parentName}.${name}`;
    const id = `variable:${qualifiedName}`;
    addDeclaration(state, {
      id,
      kind: 'variable',
      name,
      qualifiedName,
      parentId,
      deprecated: isDeprecated(declaration) || isDeprecated(node),
      constant,
      type: normalizeType(declaration.type, state, {
        qualifiedName,
        parentId: id,
        role: 'type',
      }),
    });
  }
}

function visitTypeMembers(members, parentName, parentId, state) {
  for (const member of members) {
    if (ts.isPropertySignature(member) || ts.isPropertyDeclaration(member)) {
      addPropertyDeclaration(member, parentName, parentId, state);
      continue;
    }

    if (ts.isMethodSignature(member) || ts.isMethodDeclaration(member)) {
      const name = normalizeDeclarationName(member.name, state, parentId);
      addSignatureDeclaration(
        state,
        'method',
        name,
        `${parentName}.${name}`,
        parentId,
        member,
      );
      continue;
    }

    if (ts.isConstructorDeclaration(member)) {
      addSignatureDeclaration(
        state,
        'constructor',
        'constructor',
        `${parentName}.constructor`,
        parentId,
        member,
      );
      continue;
    }

    if (ts.isCallSignatureDeclaration(member)) {
      addSignatureDeclaration(
        state,
        'callSignature',
        '$call',
        `${parentName}.$call`,
        parentId,
        member,
      );
      continue;
    }

    if (ts.isIndexSignatureDeclaration(member)) {
      addSignatureDeclaration(
        state,
        'indexSignature',
        '$index',
        `${parentName}.$index`,
        parentId,
        member,
      );
      continue;
    }

    throwUnclassifiedPublicSyntax(state, member, parentId, 'type member');
  }
}

function addPropertyDeclaration(node, parentName, parentId, state) {
  const name = normalizeDeclarationName(node.name, state, parentId);
  const qualifiedName = `${parentName}.${name}`;
  const staticMember = hasModifier(node, ts.SyntaxKind.StaticKeyword);
  const scope = staticMember ? '$static' : '$instance';
  const id = `property:${parentId}/${scope}/${encodeIdPart(name)}`;
  addDeclaration(state, {
    id,
    kind: 'property',
    name,
    qualifiedName,
    parentId,
    deprecated: isDeprecated(node),
    visibility: declarationVisibility(node),
    optional: node.questionToken !== undefined,
    readonly: hasModifier(node, ts.SyntaxKind.ReadonlyKeyword),
    static: staticMember,
    type: normalizeType(node.type, state, {
      qualifiedName,
      parentId: id,
      role: 'type',
    }),
  });
}

function addSignatureDeclaration(
  state,
  kind,
  name,
  qualifiedName,
  parentId,
  node,
) {
  const preview = normalizeSignature(node, state, {
    qualifiedName,
    parentId,
    recordTypeLiterals: false,
  });
  const canonical = {...preview.canonical};
  if (kind === 'method') {
    canonical.static = hasModifier(node, ts.SyntaxKind.StaticKeyword);
    canonical.optional = node.questionToken !== undefined;
  }
  const canonicalSignature = JSON.stringify(canonical);
  const signatureHash = sha256(canonicalSignature);
  const id = `${kind}:${qualifiedName}@${signatureHash}`;
  const normalized = normalizeSignature(node, state, {
    qualifiedName: `${qualifiedName}.$signature@${signatureHash}`,
    parentId: id,
    recordTypeLiterals: true,
  });
  addDeclaration(state, {
    id,
    kind,
    name,
    qualifiedName,
    parentId,
    deprecated: isDeprecated(node),
    visibility: declarationVisibility(node),
    canonicalSignature,
    ...(kind === 'method'
      ? {
          static: hasModifier(node, ts.SyntaxKind.StaticKeyword),
          optional: node.questionToken !== undefined,
          abstract: hasModifier(node, ts.SyntaxKind.AbstractKeyword),
        }
      : {}),
    typeParameters: normalized.typeParameters,
    parameters: normalized.parameters,
    returnType: normalized.returnType,
  });
}

function normalizeSignature(node, state, context) {
  const typeParameters = normalizeTypeParameters(node.typeParameters, state);
  const parameters = node.parameters.map((parameter, index) => ({
    name: parameter.name.getText(state.sourceFile),
    optional:
      parameter.questionToken !== undefined || parameter.initializer !== undefined,
    rest: parameter.dotDotDotToken !== undefined,
    type: normalizeType(parameter.type, state, {
      qualifiedName: `${context.qualifiedName}.$parameter${index}`,
      parentId: context.parentId,
      role: 'parameterType',
      recordTypeLiterals: context.recordTypeLiterals,
    }),
  }));
  const returnType = normalizeType(node.type, state, {
    qualifiedName: `${context.qualifiedName}.$return`,
    parentId: context.parentId,
    role: 'returnType',
    recordTypeLiterals: context.recordTypeLiterals,
  });
  return {
    typeParameters,
    parameters,
    returnType,
    canonical: {
      typeParameters: canonicalTypeParameters(typeParameters),
      parameters: parameters.map((parameter) => ({
        optional: parameter.optional,
        rest: parameter.rest,
        type: canonicalSignatureType(parameter.type, typeParameters),
      })),
      returnType: canonicalSignatureType(returnType, typeParameters),
    },
  };
}

function normalizeTypeParameters(nodes, state) {
  return (nodes ?? []).map((node) => {
    const parameter = {name: node.name.text};
    if (node.constraint) {
      parameter.constraint = normalizeType(node.constraint, state);
    }
    if (node.default) {
      parameter.default = normalizeType(node.default, state);
    }
    return parameter;
  });
}

function canonicalTypeParameters(typeParameters) {
  return typeParameters.map((parameter) => {
    const canonical = {};
    if (parameter.constraint) {
      canonical.constraint = canonicalSignatureType(
        parameter.constraint,
        typeParameters,
      );
    }
    if (parameter.default) {
      canonical.default = canonicalSignatureType(
        parameter.default,
        typeParameters,
      );
    }
    return canonical;
  });
}

function canonicalSignatureType(type, typeParameters) {
  if (type === null || typeof type !== 'object') {
    return type;
  }
  if (type.kind === 'reference') {
    const typeParameterIndex = typeParameters.findIndex(
      (parameter) => parameter.name === type.name,
    );
    if (typeParameterIndex >= 0) {
      return {kind: 'typeParameter', index: typeParameterIndex};
    }
  }
  if (type.kind === 'function') {
    return {
      kind: 'function',
      canonicalSignature: type.canonicalSignature,
    };
  }
  if (type.kind === 'tuple') {
    return {
      kind: 'tuple',
      elements: type.elements.map((element) => ({
        optional: element.optional,
        rest: element.rest,
        type: canonicalSignatureType(element.type, typeParameters),
      })),
    };
  }
  if (type.kind === 'typeLiteral') {
    return {kind: 'typeLiteral', shapeHash: type.shapeHash};
  }
  if (Array.isArray(type)) {
    return type.map((item) => canonicalSignatureType(item, typeParameters));
  }
  return Object.fromEntries(
    Object.entries(type).map(([key, value]) => [
      key,
      canonicalSignatureType(value, typeParameters),
    ]),
  );
}

function normalizeType(type, state, context) {
  if (!type) {
    return {kind: 'primitive', name: 'void'};
  }
  const primitive = primitiveTypeName(type.kind);
  if (primitive) {
    return {kind: 'primitive', name: primitive};
  }
  if (ts.isTypeReferenceNode(type)) {
    return {
      kind: 'reference',
      name: normalizeEntityName(
        type.typeName,
        state,
        context?.parentId ?? 'module:vscode',
      ),
      typeArguments: (type.typeArguments ?? []).map((argument, index) =>
        normalizeType(argument, state, childTypeContext(context, `argument${index}`)),
      ),
    };
  }
  if (ts.isArrayTypeNode(type)) {
    return {
      kind: 'array',
      elementType: normalizeType(
        type.elementType,
        state,
        childTypeContext(context, 'element'),
      ),
    };
  }
  if (ts.isUnionTypeNode(type) || ts.isIntersectionTypeNode(type)) {
    const types = type.types.map((item, index) =>
      normalizeType(item, state, childTypeContext(context, `item${index}`)),
    );
    types.sort(compareCanonicalValues);
    return {
      kind: ts.isUnionTypeNode(type) ? 'union' : 'intersection',
      types,
    };
  }
  if (ts.isParenthesizedTypeNode(type)) {
    return normalizeType(type.type, state, context);
  }
  if (ts.isLiteralTypeNode(type)) {
    return {
      kind: 'literal',
      value: normalizeLiteral(
        type.literal,
        state,
        context?.parentId ?? 'module:vscode',
      ),
    };
  }
  if (ts.isTupleTypeNode(type)) {
    return {
      kind: 'tuple',
      elements: type.elements.map((element, index) =>
        normalizeTupleElement(
          element,
          state,
          childTypeContext(context, `element${index}`),
        ),
      ),
    };
  }
  if (ts.isTypeOperatorNode(type)) {
    const operator = typeOperatorName(type.operator);
    if (operator === undefined) {
      throwUnclassifiedPublicSyntax(
        state,
        type,
        context?.parentId ?? 'module:vscode',
        'type operator',
      );
    }
    return {
      kind: 'operator',
      operator,
      type: normalizeType(type.type, state, childTypeContext(context, 'operand')),
    };
  }
  if (ts.isFunctionTypeNode(type)) {
    const signature = normalizeSignature(type, state, {
      qualifiedName: context?.qualifiedName ?? '$functionType',
      parentId: context?.parentId ?? 'module:vscode',
      recordTypeLiterals: context?.recordTypeLiterals,
    });
    return {
      kind: 'function',
      typeParameters: signature.typeParameters,
      parameters: signature.parameters,
      returnType: signature.returnType,
      canonicalSignature: JSON.stringify(signature.canonical),
    };
  }
  if (ts.isTypeLiteralNode(type)) {
    return normalizeTypeLiteral(type, state, context);
  }
  throwUnclassifiedPublicSyntax(
    state,
    type,
    context?.parentId ?? 'module:vscode',
    'type syntax',
  );
}

function normalizeTypeLiteral(node, state, context) {
  const ownerId = context?.parentId ?? 'module:vscode';
  const shape = canonicalTypeLiteralShape(node, state, ownerId);
  const shapeHash = sha256(JSON.stringify(shape));
  if (!context || context.recordTypeLiterals === false) {
    return {kind: 'typeLiteral', shape};
  }

  const qualifiedName = `${context.qualifiedName}.$type`;
  const id = `typeLiteral:${qualifiedName}@${shapeHash}`;
  addDeclaration(state, {
    id,
    kind: 'typeLiteral',
    name: '$type',
    qualifiedName,
    parentId: context.parentId,
    deprecated: false,
    shapeHash,
  });
  visitTypeMembers(node.members, qualifiedName, id, state);
  return {kind: 'typeLiteral', id, shapeHash};
}

function canonicalTypeLiteralShape(node, state, ownerId) {
  const members = node.members.map((member) => {
    if (ts.isPropertySignature(member)) {
      return {
        kind: 'property',
        name: normalizeDeclarationName(member.name, state, ownerId),
        optional: member.questionToken !== undefined,
        readonly: hasModifier(member, ts.SyntaxKind.ReadonlyKeyword),
        type: normalizeType(member.type, state),
      };
    }
    if (ts.isMethodSignature(member)) {
      return canonicalMemberSignature('method', member, state, ownerId);
    }
    if (ts.isCallSignatureDeclaration(member)) {
      return canonicalMemberSignature('callSignature', member, state, ownerId);
    }
    if (ts.isIndexSignatureDeclaration(member)) {
      return canonicalMemberSignature('indexSignature', member, state, ownerId);
    }
    throwUnclassifiedPublicSyntax(
      state,
      member,
      ownerId,
      'type literal member',
    );
  });
  members.sort(compareCanonicalValues);
  return {members};
}

function canonicalMemberSignature(kind, node, state, ownerId) {
  const signature = normalizeSignature(node, state, {
    qualifiedName: '$shape',
    parentId: 'module:vscode',
    recordTypeLiterals: false,
  });
  const result = {kind, signature: signature.canonical};
  if (node.name) {
    result.name = normalizeDeclarationName(node.name, state, ownerId);
  }
  return result;
}

function normalizeTupleElement(node, state, context) {
  if (ts.isNamedTupleMember(node)) {
    return {
      name: node.name.text,
      optional: node.questionToken !== undefined,
      rest: node.dotDotDotToken !== undefined,
      type: normalizeType(node.type, state, context),
    };
  }
  if (ts.isOptionalTypeNode(node)) {
    return {
      optional: true,
      rest: false,
      type: normalizeType(node.type, state, context),
    };
  }
  if (ts.isRestTypeNode(node)) {
    return {
      optional: false,
      rest: true,
      type: normalizeType(node.type, state, context),
    };
  }
  return {
    optional: false,
    rest: false,
    type: normalizeType(node, state, context),
  };
}

function normalizeHeritageClauses(clauses, token, state, ownerId) {
  return (clauses ?? [])
    .filter((clause) => clause.token === token)
    .flatMap((clause) => clause.types)
    .map((type) => ({
      kind: 'reference',
      name: normalizeExpressionName(type.expression, state, ownerId),
      typeArguments: (type.typeArguments ?? []).map((argument) =>
        normalizeType(argument, state),
      ),
    }))
    .sort(compareCanonicalValues);
}

function normalizeExpression(node, state, ownerId) {
  if (ts.isStringLiteral(node) || ts.isNumericLiteral(node)) {
    return {kind: 'literal', value: node.text};
  }
  if (node.kind === ts.SyntaxKind.TrueKeyword) {
    return {kind: 'literal', value: true};
  }
  if (node.kind === ts.SyntaxKind.FalseKeyword) {
    return {kind: 'literal', value: false};
  }
  if (ts.isPrefixUnaryExpression(node)) {
    return {
      kind: 'unary',
      operator: ts.tokenToString(node.operator),
      operand: normalizeExpression(node.operand, state, ownerId),
    };
  }
  if (ts.isIdentifier(node) || ts.isPropertyAccessExpression(node)) {
    return {
      kind: 'reference',
      name: normalizeExpressionName(node, state, ownerId),
    };
  }
  throwUnclassifiedPublicSyntax(
    state,
    node,
    ownerId,
    'expression syntax',
  );
}

function normalizeLiteral(node, state, ownerId) {
  if (ts.isStringLiteral(node) || ts.isNumericLiteral(node)) {
    return node.text;
  }
  if (node.kind === ts.SyntaxKind.TrueKeyword) {
    return true;
  }
  if (node.kind === ts.SyntaxKind.FalseKeyword) {
    return false;
  }
  if (node.kind === ts.SyntaxKind.NullKeyword) {
    return null;
  }
  if (ts.isPrefixUnaryExpression(node) && ts.isNumericLiteral(node.operand)) {
    return `${ts.tokenToString(node.operator)}${node.operand.text}`;
  }
  throwUnclassifiedPublicSyntax(state, node, ownerId, 'literal type');
}

function normalizeDeclarationName(node, state, ownerId) {
  if (
    ts.isIdentifier(node) ||
    ts.isPrivateIdentifier(node) ||
    ts.isStringLiteral(node) ||
    ts.isNumericLiteral(node)
  ) {
    return node.text;
  }
  if (ts.isComputedPropertyName(node)) {
    return `[${normalizeExpressionName(node.expression, state, ownerId)}]`;
  }
  throwUnclassifiedPublicSyntax(state, node, ownerId, 'declaration name');
}

function normalizeEntityName(node, state, ownerId) {
  if (ts.isIdentifier(node)) {
    return node.text;
  }
  if (ts.isQualifiedName(node)) {
    return `${normalizeEntityName(node.left, state, ownerId)}.${node.right.text}`;
  }
  throwUnclassifiedPublicSyntax(state, node, ownerId, 'entity name');
}

function normalizeExpressionName(node, state, ownerId) {
  if (ts.isIdentifier(node)) {
    return node.text;
  }
  if (ts.isPropertyAccessExpression(node)) {
    return `${normalizeExpressionName(node.expression, state, ownerId)}.${node.name.text}`;
  }
  throwUnclassifiedPublicSyntax(state, node, ownerId, 'expression name');
}

function childTypeContext(context, child) {
  if (!context) {
    return undefined;
  }
  return {
    qualifiedName: `${context.qualifiedName}.$${child}`,
    parentId: context.parentId,
    role: child,
    recordTypeLiterals: context.recordTypeLiterals,
  };
}

function primitiveTypeName(kind) {
  switch (kind) {
    case ts.SyntaxKind.AnyKeyword:
      return 'any';
    case ts.SyntaxKind.BooleanKeyword:
      return 'boolean';
    case ts.SyntaxKind.NeverKeyword:
      return 'never';
    case ts.SyntaxKind.NumberKeyword:
      return 'number';
    case ts.SyntaxKind.ObjectKeyword:
      return 'object';
    case ts.SyntaxKind.StringKeyword:
      return 'string';
    case ts.SyntaxKind.UndefinedKeyword:
      return 'undefined';
    case ts.SyntaxKind.UnknownKeyword:
      return 'unknown';
    case ts.SyntaxKind.VoidKeyword:
      return 'void';
    default:
      return undefined;
  }
}

function typeOperatorName(kind) {
  switch (kind) {
    case ts.SyntaxKind.KeyOfKeyword:
      return 'keyof';
    case ts.SyntaxKind.ReadonlyKeyword:
      return 'readonly';
    case ts.SyntaxKind.UniqueKeyword:
      return 'unique';
    default:
      return undefined;
  }
}

function addDeclaration(state, declaration) {
  declaration.visibility ??= 'public';
  declaration.coverage ??= initialCoverage(declaration.visibility);
  const existing = state.declarationsById.get(declaration.id);
  if (existing) {
    existing.deprecated ||= declaration.deprecated;
    existing.occurrenceCount = (existing.occurrenceCount ?? 1) + 1;
    return existing;
  }
  state.declarationsById.set(declaration.id, declaration);
  state.declarations.push(declaration);
  return declaration;
}

function compareDeclarations(left, right) {
  return compareStrings(left.qualifiedName, right.qualifiedName) ||
    compareStrings(left.id, right.id);
}

function compareCanonicalValues(left, right) {
  return compareStrings(JSON.stringify(left), JSON.stringify(right));
}

function compareStrings(left, right) {
  if (left < right) {
    return -1;
  }
  if (left > right) {
    return 1;
  }
  return 0;
}

function encodeIdPart(value) {
  return encodeURIComponent(value);
}

function sha256(value) {
  return crypto.createHash('sha256').update(value).digest('hex');
}

function hasModifier(node, kind) {
  return node.modifiers?.some((modifier) => modifier.kind === kind) ?? false;
}

function declarationVisibility(node) {
  if (hasModifier(node, ts.SyntaxKind.PrivateKeyword)) {
    return 'private';
  }
  if (hasModifier(node, ts.SyntaxKind.ProtectedKeyword)) {
    return 'protected';
  }
  return 'public';
}

function initialCoverage(visibility) {
  if (visibility !== 'public') {
    return {
      discovery: 'discovered',
      semantics: 'excluded',
      binding: 'excluded',
      host: 'notApplicable',
    };
  }
  return {
    discovery: 'discovered',
    semantics: 'pending',
    binding: 'pending',
    host: 'pending',
  };
}

function isDeprecated(node) {
  return ts.getJSDocDeprecatedTag(node) !== undefined;
}

function throwUnclassifiedPublicSyntax(state, node, ownerId, category) {
  const syntaxKind = ts.SyntaxKind[node.kind];
  const snippet = node
    .getText(state.sourceFile)
    .replace(/\s+/g, ' ')
    .trim();
  const error = new Error(
    `${state.sourceFile.fileName}: unclassified public ${category} ` +
      `${syntaxKind} under ${ownerId}: ${snippet}`,
  );
  error.code = 'UNCLASSIFIED_PUBLIC_SYNTAX';
  throw error;
}

module.exports = {importVscodeDeclarations};
