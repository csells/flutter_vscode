
## 0.1.0

- First release: the complete typed Dart mapping of the VS Code extension
  API, extracted from `flutter_vscode` so that Host Dart can reach it
  without pulling the Flutter SDK into its dependency graph. Carries the
  generated API layer, the Host/Flutter View protocol, `ExtensionCommands`,
  the Flutter View host module, and the Host Dart runtime seam.
