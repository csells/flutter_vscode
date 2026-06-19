import 'package:flutter_vscode/runtime.dart';

part 'api_controller.vscode.g.part';

/// Example API controller demonstrating dotted command ids and common patterns.
///
/// See `docs/reference/vscode-api-mapping.md` in the flutter_vscode package for
/// more annotation examples.
@VSCodeController()
abstract class ApiController {
  /// Shows an information message in VS Code.
  @VSCodeCommand('window.showInformationMessage')
  Future<void> showInformationMessage(String message);

  /// Shows a warning message in VS Code.
  @VSCodeCommand('window.showWarningMessage')
  Future<void> showWarningMessage(String message);

  /// Shows an error message in VS Code.
  @VSCodeCommand('window.showErrorMessage')
  Future<void> showErrorMessage(String message);

  /// Shows an input box and returns the user's input.
  @VSCodeCommand('window.showInputBox')
  Future<String?> showInputBox(Map<String, dynamic> options);

  /// Shows a quick pick list and returns the selected item.
  @VSCodeCommand('window.showQuickPick')
  Future<String?> showQuickPick(List<String> items);
}

/// Factory function to create a concrete implementation of [ApiController].
ApiController createApiController() => _$ApiController();
