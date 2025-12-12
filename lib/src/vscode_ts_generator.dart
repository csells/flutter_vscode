import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import '../annotations.dart';

/// Generates TypeScript handler files from classes annotated with [VSCodeController].
class VSCodeTsGenerator implements Builder {
  @override
  Map<String, List<String>> get buildExtensions => {
        '.dart': ['.handlers.ts']
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    if (!inputId.path.endsWith('.dart')) return;

    final library = LibraryReader(await buildStep.inputLibrary);
    final output = await _generate(library, buildStep);
    
    if (output != null) {
      final outputId = inputId.changeExtension('.handlers.ts');
      await buildStep.writeAsString(outputId, output);
    }
  }

  Future<String?> _generate(LibraryReader library, BuildStep buildStep) async {
    final buffer = StringBuffer();
    buffer.writeln('import * as vscode from \'vscode\';');
    buffer.writeln();
    buffer.writeln('/* eslint-disable @typescript-eslint/no-explicit-any */');
    buffer.writeln();
    buffer.writeln('function resolveVscodeFn(commandId: string): ((...args: any[]) => any) | undefined {');
    buffer.writeln('  // If the id contains a dot, treat it as a path off the vscode module.');
    buffer.writeln('  // Examples: "window.showInformationMessage", "workspace.getConfiguration".');
    buffer.writeln('  if (commandId.includes(\'.\')) {');
    buffer.writeln('    const parts = commandId.split(\'.\');');
    buffer.writeln('    let cur: any = vscode as any;');
    buffer.writeln('    let parent: any = undefined;');
    buffer.writeln('    for (const part of parts) {');
    buffer.writeln('      parent = cur;');
    buffer.writeln('      cur = cur?.[part];');
    buffer.writeln('    }');
    buffer.writeln('    if (typeof cur === \'function\') return cur.bind(parent);');
    buffer.writeln('    return undefined;');
    buffer.writeln('  }');
    buffer.writeln();
    buffer.writeln('  // Backwards compatible default: treat as vscode.window.*');
    buffer.writeln('  const fn = (vscode.window as any)?.[commandId];');
    buffer.writeln('  return typeof fn === \'function\' ? fn.bind(vscode.window) : undefined;');
    buffer.writeln('}');
    buffer.writeln();

    final controllers = library.classes
        .where((c) => const TypeChecker.fromRuntime(VSCodeController).hasAnnotationOf(c));

    if (controllers.isEmpty) {
      return null;
    }

    buffer.writeln('export async function handleCommand(message: any, webview: vscode.Webview) {');
    buffer.writeln('  const command = message?.command;');
    buffer.writeln('  const params: any[] = message?.params ?? [];');
    buffer.writeln('  const requestId: string | undefined = message?.requestId;');
    buffer.writeln();
    buffer.writeln('  try {');
    buffer.writeln('    switch (command) {');

    for (final controller in controllers) {
      for (final method in controller.methods) {
        if (const TypeChecker.fromRuntime(VSCodeCommand).hasAnnotationOf(method)) {
          buffer.writeln(_generateCommandHandler(method));
        }
      }
    }

    buffer.writeln('      default:');
    buffer.writeln('        return;');
    buffer.writeln('    }');
    buffer.writeln('  } catch (error) {');
    buffer.writeln('    if (requestId) {');
    buffer.writeln('      void webview.postMessage({ requestId, error: String(error) });');
    buffer.writeln('    }');
    buffer.writeln('  }');
    buffer.writeln('}');

    return buffer.toString();
  }

  String _generateCommandHandler(MethodElement method) {
    final methodName = method.name;
    final commandId = _commandIdFor(method) ?? methodName;
    final parameters = method.parameters;

    final buffer = StringBuffer();
    buffer.writeln('      case \'$commandId\': {');

    final paramNames =
        parameters.asMap().entries.map((entry) => 'params[${entry.key}]').join(', ');

    final isVoid = method.returnType is VoidType ||
        method.returnType.toString().contains('Future<void>');

    // Default behavior: if the command id doesn't contain a dot, treat it as
    // a vscode.window method for backwards compatibility with the example.
    buffer.writeln('        const fn = resolveVscodeFn(${_tsString(commandId)});');
    buffer.writeln('        if (!fn) return;');
    if (isVoid) {
      buffer.writeln('        void fn(${paramNames});');
      buffer.writeln('        return;');
    } else {
      buffer.writeln('        const result = await fn(${paramNames});');
      buffer.writeln('        if (requestId) {');
      buffer.writeln('          void webview.postMessage({ requestId, result });');
      buffer.writeln('        }');
      buffer.writeln('        return;');
    }

    buffer.writeln('      }');

    return buffer.toString();
  }

  String? _commandIdFor(MethodElement method) {
    final ann = const TypeChecker.fromRuntime(VSCodeCommand).firstAnnotationOf(method);
    if (ann == null) return null;
    final reader = ConstantReader(ann);
    final field = reader.peek('command');
    if (field == null || field.isNull) return null;
    return field.stringValue;
  }

  String _tsString(String s) => "'${s.replaceAll("'", "\\'")}'";
}
