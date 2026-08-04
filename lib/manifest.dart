/// The typed Extension Manifest an Extension Project declares in its root
/// `extension.dart`.
///
/// An Extension Project's descriptor is one constant:
///
/// ```dart
/// import 'package:flutter_vscode/manifest.dart';
///
/// const extension = ExtensionManifest(
///   apiTarget: '1.129.1',
///   name: 'my-extension',
///   displayName: 'My Extension',
///   description: 'A VS Code extension written in Dart.',
///   version: '0.0.1',
///   publisher: 'local',
///   activationEvents: ['onLanguage:json'],
///   commands: [
///     ExtensionCommand(
///       command: 'my-extension.hello',
///       title: 'Say Hello from Dart',
///     ),
///   ],
/// );
/// ```
///
/// The declaration is ordinary, analyzable Dart — the editor completes and
/// type-checks it — but `flutter_vscode build` reads it as data: the CLI
/// parses the constant invocation and never loads or executes project code.
/// Every value must therefore be a constant literal.
library;

/// The Dart-owned metadata of one VS Code extension.
///
/// `flutter_vscode build` projects this manifest into the generated
/// `package.json` and builds against the one VS Code baseline this
/// `flutter_vscode` release pins. Only constant literal values are
/// supported; the CLI parses the declaration as data and never executes it.
final class ExtensionManifest {
  /// Creates the manifest an Extension Project declares as
  /// `const extension = ExtensionManifest(...)`.
  const ExtensionManifest({
    required this.name,
    required this.displayName,
    required this.description,
    required this.version,
    required this.publisher,
    required this.activationEvents,
    this.commands = const [],
    this.schemaVersion = 1,
  });

  /// The extension identifier component, in lower-kebab-case, for example
  /// `'my-extension'`.
  ///
  /// Combined with [publisher] it forms the installed extension identifier
  /// `publisher.name`.
  final String name;

  /// The human-readable extension name VS Code shows in the UI, for example
  /// in the Extensions view.
  final String displayName;

  /// The short description VS Code shows beneath the display name.
  final String description;

  /// The extension's own semantic version, for example `'0.0.1'`.
  final String version;

  /// The publisher identifier component, in lower-kebab-case.
  ///
  /// Combined with [name] it forms the installed extension identifier
  /// `publisher.name`. Use `'local'` for extensions that are not published
  /// to a marketplace.
  final String publisher;

  /// The VS Code activation events that load the extension, for example
  /// `['onLanguage:json']` or `['onStartupFinished']`.
  ///
  /// Declare an empty list for an extension activated only by its own
  /// [commands].
  final List<String> activationEvents;

  /// The commands this extension contributes to the Command Palette.
  ///
  /// Defaults to none. Each contributed command's handler is registered by
  /// the Host Dart entrypoint under the same command identifier.
  final List<ExtensionCommand> commands;

  /// The descriptor schema revision, currently always `1`.
  final int schemaVersion;
}

/// One command contribution: an identifier plus its Command Palette title.
final class ExtensionCommand {
  /// Creates a contributed command named [command] titled [title].
  const ExtensionCommand({required this.command, required this.title});

  /// The command identifier, conventionally `<extension-name>.<action>`,
  /// for example `'my-extension.hello'`.
  ///
  /// The Host Dart entrypoint registers the handler under this identifier.
  final String command;

  /// The human-readable title VS Code shows in the Command Palette.
  final String title;
}
