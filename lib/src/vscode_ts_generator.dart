// ignore_for_file: missing_whitespace_between_adjacent_strings for command concatinations

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:flutter_vscode/src/vscode_codegen_helpers.dart';
import 'package:flutter_vscode/src/vscode_validation.dart';
import 'package:source_gen/source_gen.dart';

/// Generates TypeScript handler files from classes annotated with [VSCodeController].
class VSCodeTsGenerator implements Builder {
  @override
  Map<String, List<String>> get buildExtensions => {
        '.dart': ['.handlers.ts'],
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
    final buffer = StringBuffer()
      ..writeln("import * as vscode from 'vscode';")
      ..writeln()
      ..writeln('/* eslint-disable @typescript-eslint/no-explicit-any */')
      ..writeln()
      ..writeln(
        'function resolveVscodeFn('
        'commandId: string'
        '): ((...args: any[]) => any) | undefined {',
      )
      ..writeln(
        '  // If the id contains a dot, treat it as a path off the vscode module.',
      )
      ..writeln(
        '  // Examples: "window.showInformationMessage", "workspace.getConfiguration".',
      )
      ..writeln("  if (commandId.includes('.')) {")
      ..writeln("    const parts = commandId.split('.');")
      ..writeln('    let cur: any = vscode as any;')
      ..writeln('    let parent: any = undefined;')
      ..writeln('    for (const part of parts) {')
      ..writeln('      parent = cur;')
      ..writeln('      cur = cur?.[part];')
      ..writeln('    }')
      ..writeln("    if (typeof cur === 'function') return cur.bind(parent);")
      ..writeln('    return undefined;')
      ..writeln('  }')
      ..writeln()
      ..writeln('  // Backwards compatible default: treat as vscode.window.*')
      ..writeln('  const fn = (vscode.window as any)?.[commandId];')
      ..writeln(
        "  return typeof fn === 'function' ? fn.bind(vscode.window) : undefined;",
      )
      ..writeln('}')
      ..writeln();

    final controllers = library.classes.where(
      vscodeControllerChecker.hasAnnotationOf,
    );

    if (controllers.isEmpty) {
      return null;
    }

    buffer
      ..writeln(
        'export async function handleCommand(message: any, '
        'webview: vscode.Webview) {',
      )
      ..writeln('  const command = message?.command;')
      ..writeln('  const params: any[] = message?.params ?? [];')
      ..writeln('  const requestId: string | undefined = message?.requestId;')
      ..writeln()
      ..writeln('  try {')
      ..writeln('    switch (command) {');

    for (final controller in controllers) {
      validateController(controller);
      for (final method in controller.methods) {
        if (vscodeCommandChecker.hasAnnotationOf(method)) {
          validateCommandMethod(method);
          final functionTyped = method as FunctionTypedElement;
          final parameters = functionTyped.formalParameters;

          final isVoid = _isVoidLike(method.returnType);

          final effectiveCommandId = commandIdFor(method) ?? method.name;
          buffer.writeln(
            buildTsCommandHandler(
              commandId: effectiveCommandId,
              isVoidLike: isVoid,
              positionalParamCount: parameters.length,
            ),
          );
        }
      }
    }

    buffer
      ..writeln('      default:')
      ..writeln('        return;')
      ..writeln('    }')
      ..writeln('  } catch (error) {')
      ..writeln('    if (requestId) {')
      ..writeln(
        '      void webview.postMessage({ requestId, error: String(error) });',
      )
      ..writeln('    }')
      ..writeln('  }')
      ..writeln('}');

    return buffer.toString();
  }

  bool _isVoidLike(DartType returnType) {
    if (returnType is VoidType) {
      return true;
    }

    if (returnType is InterfaceType && returnType.isDartAsyncFuture) {
      if (returnType.typeArguments.isEmpty) {
        return false;
      }
      return returnType.typeArguments.first is VoidType;
    }

    return false;
  }
}
