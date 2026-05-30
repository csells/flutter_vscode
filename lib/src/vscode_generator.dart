// Generates Dart implementation files for classes annotated with [VSCodeController].

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:flutter_vscode/annotations.dart';
import 'package:flutter_vscode/src/vscode_codegen_helpers.dart';
import 'package:flutter_vscode/src/vscode_validation.dart';
import 'package:source_gen/source_gen.dart';

/// Generates Dart implementation files for classes annotated with [VSCodeController].
///
/// This generator creates concrete implementations of abstract methods annotated
/// with [VSCodeCommand], providing the communication bridge to the VS Code
/// extension runtime.
class VSCodeGenerator extends GeneratorForAnnotation<VSCodeController> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '`@VSCodeController` can only be used on classes.',
        element: element,
      );
    }

    final classElement = element;
    validateController(classElement);
    final className = classElement.name;

    final buffer = StringBuffer()
      ..writeln("part of '${_partOf(buildStep)}';")
      ..writeln();

    const implClassName = r'_$';
    buffer.writeln('class $implClassName$className implements $className {');

    for (final method in classElement.methods) {
      if (vscodeCommandChecker.hasAnnotationOf(method)) {
        validateCommandMethod(method);
        buffer.writeln(_generateMethodImplementation(method));
      }
    }

    buffer
      ..writeln('}')
      ..writeln();

    return buffer.toString();
  }

  String _partOf(BuildStep buildStep) {
    return buildStep.inputId.pathSegments.last;
  }

  String _generateMethodImplementation(MethodElement method) {
    final methodName = method.name;
    final functionTyped = method as FunctionTypedElement;
    final parameters = functionTyped.formalParameters;

    final returnType = method.returnType;
    final commandId = commandIdFor(method) ?? methodName;

    final buffer = StringBuffer()
      ..write('@override ')
      ..write('$returnType $methodName(')
      ..write(
        parameters.map<String>((p) => '${p.type} ${p.name}').join(', '),
      )
      ..writeln(') {');

    final paramList = parameters
        .where((p) => p.name != null)
        .map<String>((p) => p.name!)
        .join(', ');
    final body = _buildSendCommandBody(
      returnType: returnType,
      commandId: commandId,
      paramListExpression: paramList,
      method: method,
    );

    buffer
      ..writeln(body)
      ..writeln('}');

    return buffer.toString();
  }

  String _buildSendCommandBody({
    required DartType returnType,
    required String? commandId,
    required String paramListExpression,
    required MethodElement method,
  }) {
    if (returnType is VoidType) {
      return buildDartSendCommandBody(
        commandId: commandId,
        paramListExpression: paramListExpression,
        returnKind: VSCodeReturnKind.voidSync,
      );
    }

    if (returnType is InterfaceType && returnType.isDartAsyncFuture) {
      final futureTypeArg = returnType.typeArguments.first;

      if (futureTypeArg is VoidType) {
        return buildDartSendCommandBody(
          commandId: commandId,
          paramListExpression: paramListExpression,
          returnKind: VSCodeReturnKind.futureVoid,
        );
      }

      final returnTypeName = futureTypeArg.getDisplayString();
      return buildDartSendCommandBody(
        commandId: commandId,
        paramListExpression: paramListExpression,
        returnKind: VSCodeReturnKind.futureValue,
        futureValueType: returnTypeName,
      );
    }

    throw InvalidGenerationSourceError(
      'Methods annotated with @VSCodeCommand must return a Future or void.',
      element: method,
    );
  }
}
