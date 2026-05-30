# Quickstart

## 1) Scaffold a project

Run in your extension project root:

```bash
dart run flutter_vscode:generate_vscode_extension
```

Then install dependencies:

```bash
flutter pub get
npm install
```

## 2) Define controller API in Dart

Create an abstract controller with annotations in `lib/vscode_api.dart` (or another Dart library):

```dart
@VSCodeController()
abstract class VSCodeApi {
  @VSCodeCommand('window.showInformationMessage')
  Future<void> info(String message);
}
```

Run generation:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## 3) Initialize bridge in Flutter app

In `main()`:

```dart
VSCodeWebViewHelper.initialize();
```

## 4) Build extension artifacts

```bash
npm run compile
```

This compiles TypeScript and builds Flutter web output used by the VS Code webview.

## 5) Debug

Open project in VS Code and press F5 to start the extension host.
