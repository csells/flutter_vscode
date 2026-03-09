// This is the heart of the code generation.
// It finds annotated code and generates the necessary files.
// Note: This is a simplified skeleton for now.

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:flutter_vscode/annotations.dart';
import 'package:flutter_vscode/src/vscode_codegen_helpers.dart';
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
    // Ensure we are working with a class element.
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '`@VSCodeController` can only be used on classes.',
        element: element,
      );
    }

    final classElement = element;
    final className = classElement.name;

    // We will generate the implementation for the abstract class.
    final buffer = StringBuffer()

      // Generate the part-of directive.
      ..writeln("part of '${_partOf(buildStep)}';")
      ..writeln();

    // Generate the implementation class.
    const implClassName = r'_$';
    buffer.writeln('class $implClassName$className implements $className {');

    // Find all methods annotated with @VSCodeCommand.
    for (final method in classElement.methods) {
      if (const TypeChecker.fromUrl(
        'package:flutter_vscode/annotations.dart#VSCodeCommand',
      ).hasAnnotationOf(method)) {
        buffer.writeln(_generateMethodImplementation(method));
      }
    }

    buffer
      ..writeln('}')
      ..writeln();

    // In a real implementation, we would also generate the TypeScript file here.
    // For now, we'll just focus on the Dart side.

    return buffer.toString();
  }

  /// Helper to get the file name for the 'part of' directive.
  String _partOf(BuildStep buildStep) {
    return buildStep.inputId.pathSegments.last;
  }

  String _generateMethodImplementation(MethodElement method) {
    final methodName = method.name;
    // MethodElement implements ExecutableElement which implements FunctionTypedElement
    // FunctionTypedElement provides formalParameters with proper typing
    final functionTyped = method as FunctionTypedElement;
    final parameters = functionTyped.formalParameters;

    final returnType = method.returnType;
    final commandId = _commandIdFor(method) ?? methodName;

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

  String? _commandIdFor(MethodElement method) {
    final ann = const TypeChecker.fromUrl(
      'package:flutter_vscode/annotations.dart#VSCodeCommand',
    ).firstAnnotationOf(method);
    if (ann == null) return null;
    final reader = ConstantReader(ann);
    final field = reader.peek('command');
    if (field == null || field.isNull) return null;
    return field.stringValue;
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
      final futureTypeArg = returnType.typeArguments.isNotEmpty
          ? returnType.typeArguments.first
          : null;

      if (futureTypeArg != null && futureTypeArg is VoidType) {
        return buildDartSendCommandBody(
          commandId: commandId,
          paramListExpression: paramListExpression,
          returnKind: VSCodeReturnKind.futureVoid,
        );
      }

      final returnTypeName = futureTypeArg!.getDisplayString();
      return buildDartSendCommandBody(
        commandId: commandId,
        paramListExpression: paramListExpression,
        returnKind: VSCodeReturnKind.futureValue,
        futureValueType: returnTypeName,
      );
    }

    // This is a synchronous method with a return value, which isn't supported.
    throw InvalidGenerationSourceError(
      'Methods annotated with @VSCodeCommand must return a Future or void.',
      element: method,
    );
  }
}
