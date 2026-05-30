// Defines the annotations that developers will use.

/// A class-level annotation to mark a class as a VS Code controller.
///
/// The generator will process classes with this annotation to create
/// the communication bridge to the VS Code extension runtime.
class VSCodeController {
  /// Creates a [VSCodeController] annotation instance.
  const VSCodeController();
}

/// A method-level annotation to mark a method as a command
/// that can be called on the VS Code extension runtime.
///
/// The annotated method must be abstract and part of a class
/// annotated with [VSCodeController].
class VSCodeCommand {
  /// Creates a [VSCodeCommand] annotation instance.
  ///
  /// [command] is an optional command identifier used over the method name.
  /// If omitted, generators use the annotated method's name.
  ///
  /// Examples:
  /// - `@VSCodeCommand('showInformationMessage')` (defaults to `vscode.window.*`)
  /// - `@VSCodeCommand('window.showInformationMessage')`
  /// - `@VSCodeCommand('myExtension.someCommand')` (treated as VS Code command id)
  const VSCodeCommand([this.command]);

  /// Optional command identifier used over the method name.
  ///
  /// If omitted, generators use the annotated method's name.
  final String? command;
}
