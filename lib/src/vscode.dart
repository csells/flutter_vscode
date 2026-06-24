import 'package:flutter_vscode/src/vscode_controller_base.dart';

/// Dynamic access to VS Code extension APIs without `@VSCodeCommand` annotations.
///
/// Use [invoke] to call any dotted VS Code API path (for example
/// `window.showInputBox`) when the extension host routes messages through
/// `handleInvoke` from `src/vscode_invoke.ts`.
///
/// Annotated controllers remain the typed, codegen-backed option for stable
/// extension APIs. [VSCode.invoke] is ideal for experiments and one-off calls
/// without running `build_runner`.
class VSCode {
  const VSCode._();

  /// Shared entry point for dynamic VS Code API calls.
  static const VSCode instance = VSCode._();

  /// Invokes a VS Code API by dotted path (for example `window.showInputBox`).
  ///
  /// [params] are passed as positional arguments to the resolved host function.
  /// Set [expectsResponse] to `false` for fire-and-forget calls such as
  /// `showInformationMessage`.
  Future<T> invoke<T>(
    String apiPath,
    List<dynamic> params, {
    bool expectsResponse = true,
  }) {
    return VSCodeControllerBase.sendCommand<T>(
      apiPath,
      params,
      expectsResponse: expectsResponse,
    );
  }
}
