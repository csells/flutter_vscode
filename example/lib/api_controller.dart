import 'package:flutter_vscode/flutter_vscode.dart';

part 'api_controller.vscode.g.part';

/// Example API controller demonstrating how to expose commands to VS Code.
@VSCodeController()
abstract class ApiController {
  /// Shows an information message in VS Code.
  @VSCodeCommand()
  Future<void> showInformationMessage(String message);

  /// Shows an input box in VS Code and returns the user's input.
  @VSCodeCommand()
  Future<String> showInputBox(String prompt);

  /// Shows an error message in VS Code.
  @VSCodeCommand()
  Future<void> showErrorMessage(String message);
}

/// Factory function to create a concrete implementation of [ApiController].
ApiController createApiController() => _$ApiController();
