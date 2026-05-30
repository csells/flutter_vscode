import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';

/// Type checker for [@VSCodeCommand].
const vscodeCommandChecker = TypeChecker.fromUrl(
  'package:flutter_vscode/annotations.dart#VSCodeCommand',
);

/// Type checker for [@VSCodeController].
const vscodeControllerChecker = TypeChecker.fromUrl(
  'package:flutter_vscode/annotations.dart#VSCodeController',
);

/// Reads the command id from a [@VSCodeCommand] annotation, if present.
String? commandIdFor(MethodElement method) {
  final ann = vscodeCommandChecker.firstAnnotationOf(method);
  if (ann == null) {
    return null;
  }
  final reader = ConstantReader(ann);
  final field = reader.peek('command');
  if (field == null || field.isNull) {
    return null;
  }
  return field.stringValue;
}

/// Validates that [classElement] is a valid [@VSCodeController] target.
void validateController(ClassElement classElement) {
  if (!classElement.isAbstract) {
    throw InvalidGenerationSourceError(
      'Classes annotated with @VSCodeController must be abstract. '
      'Define an abstract API and use the generated factory '
      '(e.g., createMyController()).',
      element: classElement,
    );
  }
}

/// Validates that [method] is a valid [@VSCodeCommand] target.
void validateCommandMethod(MethodElement method) {
  if (!method.isAbstract) {
    throw InvalidGenerationSourceError(
      'Methods annotated with @VSCodeCommand must be abstract.',
      element: method,
    );
  }

  if (method.typeParameters.isNotEmpty) {
    throw InvalidGenerationSourceError(
      'Methods annotated with @VSCodeCommand cannot declare generic type parameters.',
      element: method,
    );
  }

  final functionTyped = method as FunctionTypedElement;
  final parameters = functionTyped.formalParameters;
  if (parameters.any((p) => p.isNamed || p.isOptional)) {
    throw InvalidGenerationSourceError(
      'Methods annotated with @VSCodeCommand only support required positional parameters.',
      element: method,
    );
  }

  final returnType = method.returnType;
  final interfaceReturnType = returnType is InterfaceType ? returnType : null;
  final isFuture =
      interfaceReturnType != null && interfaceReturnType.isDartAsyncFuture;
  if (returnType is! VoidType && !isFuture) {
    throw InvalidGenerationSourceError(
      'Methods annotated with @VSCodeCommand must return a Future or void.',
      element: method,
    );
  }

  if (isFuture && interfaceReturnType.typeArguments.isEmpty) {
    throw InvalidGenerationSourceError(
      'Methods annotated with @VSCodeCommand must use Future<T> with an explicit type argument.',
      element: method,
    );
  }

  final commandId = commandIdFor(method);
  if (commandId != null && commandId.trim().isEmpty) {
    throw InvalidGenerationSourceError(
      'The command id passed to @VSCodeCommand cannot be empty.',
      element: method,
    );
  }
}
