/// The embedded source templates rendered by the binding generator.
///
/// Each function renders one generated artifact from the values the
/// generator resolves out of the reviewed inventory selection; the
/// literal bodies are byte-identical to the strings previously
/// embedded in `generator.dart`.
library;

/// Renders the generated `host_exports.g.dart` module.
String hostExportsTemplate({
  required String dartExtensionId,
  required String extensionKey,
}) {
  return '''
// GENERATED CODE - DO NOT MODIFY BY HAND.

import 'dart:js_interop';

/// Fully qualified extension identifier used by the generated host.
// The JSON encoder deliberately emits a double-quoted, escaped Dart literal.
// ignore: prefer_single_quotes
const generatedExtensionId = $dartExtensionId;

/// Collision-resistant key used for this extension's JavaScript globals.
const generatedExtensionKey =
    '$extensionKey';

@JS(
  '__flutterVscode.hosts.$extensionKey',
)
external set _hostExports(JSObject value);

/// Publishes the Dart lifecycle object for the CommonJS bootstrap.
void registerHostExports(JSObject value) {
  _hostExports = value;
}
''';
}

/// Renders the generated CommonJS bootstrap, `host/bootstrap.cjs`.
String bootstrapTemplate({
  required String javaScriptExtensionKey,
  required String javaScriptHostContractId,
}) {
  return '''
'use strict';

const crypto = require('node:crypto');
const fs = require('node:fs');
const manifest = require('../package.json');
const moduleApi = require('node:module');
const path = require('node:path');
const vscode = require('vscode');

process.setSourceMapsEnabled?.(true);
globalThis.self ??= globalThis;
const namespace = (globalThis.__flutterVscode ??= Object.create(null));
namespace.hosts ??= Object.create(null);
namespace.apis ??= Object.create(null);
namespace.bindingCallbackWrappers ??= Object.create(null);
namespace.bindingObservers ??= Object.create(null);
namespace.callbackWrappers ??= Object.create(null);
namespace.stackMappers ??= Object.create(null);
const extensionId = `\${manifest.publisher}.\${manifest.name}`;
const extensionKey = `e_\${crypto
  .createHash('sha256')
  .update(extensionId)
  .digest('hex')}`;
const emittedExtensionKey = $javaScriptExtensionKey;
if (extensionKey !== emittedExtensionKey) {
  throw new Error('Generated Dart and manifest extension identities differ.');
}
namespace.apis[extensionKey] = vscode;

const observedBindingIds = new Set();
namespace.bindingObservers[extensionKey] = (bindingId) => {
  if (typeof bindingId !== 'string' || bindingId.length === 0) {
    throw new TypeError('Generated Host Contract binding ID must be a string.');
  }
  observedBindingIds.add(bindingId);
};
namespace.bindingCallbackWrappers[extensionKey] = (
  callback,
  bindingIds,
) => function (...args) {
  const callbackResult = Reflect.apply(callback, this, args);
  for (const bindingId of bindingIds) {
    namespace.bindingObservers[extensionKey](bindingId);
  }
  return callbackResult;
};
const evidencePath = process.env.FLUTTER_VSCODE_HOST_EVIDENCE_PATH;
if (evidencePath) {
  process.once('exit', () => {
    fs.writeFileSync(
      evidencePath,
      `\${JSON.stringify({
        schemaVersion: 1,
        contract: $javaScriptHostContractId,
        boundary: 'vscodeExtensionHost',
        observedBindingIds: [...observedBindingIds].sort(),
      }, null, 2)}\n`,
    );
  });
}

const hostBundlePath = path.resolve(__dirname, '../out/extension.dart.js');
const hostSourceMap = new moduleApi.SourceMap(
  JSON.parse(fs.readFileSync(`\${hostBundlePath}.map`, 'utf8')),
);
const mapHostStack = (stack) => stack.replace(
  /[^\\s()]*extension\\.dart\\.js:(\\d+):(\\d+)/g,
  (location, line, column) => {
    const entry = hostSourceMap.findEntry(
      Number(line) - 1,
      Number(column) - 1,
    );
    if (entry.originalSource === undefined) {
      return location;
    }
    const source = entry.originalSource.replace(/^(\\.\\.\\/)+/, '');
    return `\${source}:\${entry.originalLine + 1}:\${entry.originalColumn + 1}`;
  },
);
namespace.stackMappers[extensionKey] = mapHostStack;
namespace.callbackWrappers[extensionKey] = (callback) => function (...args) {
  try {
    return Reflect.apply(callback, this, args);
  } catch (error) {
    if (error && typeof error.stack === 'string') {
      error.stack = mapHostStack(error.stack);
    }
    throw error;
  }
};

require('../out/extension.dart.js');

const host = namespace.hosts[extensionKey];
if (!host) {
  throw new Error('Dart host did not register its lifecycle exports.');
}

let devReloadWatcher;
const startDevReload = (context) => {
  if (devReloadWatcher) {
    return;
  }
  const bundlePath = path.join(__dirname, '..', 'out', 'extension.dart.js');
  let debounce;
  devReloadWatcher = fs.watch(path.dirname(bundlePath), (_event, filename) => {
    if (filename !== path.basename(bundlePath)) {
      return;
    }
    clearTimeout(debounce);
    debounce = setTimeout(() => {
      vscode.commands.executeCommand('workbench.action.reloadWindow');
    }, 150);
  });
  context.subscriptions.push({
    dispose() {
      clearTimeout(debounce);
      try {
        devReloadWatcher.close();
      } catch {
        // The watcher may already be gone during host shutdown.
      }
      devReloadWatcher = undefined;
    },
  });
};

exports.activate = async (context) => {
  if (
    vscode.ExtensionMode &&
    context.extensionMode === vscode.ExtensionMode.Development
  ) {
    startDevReload(context);
  }
  const firstActivationSubscription = context.subscriptions.length;
  try {
    return await host.activate(context, vscode);
  } catch (error) {
    const registrations = context.subscriptions.splice(
      firstActivationSubscription,
    );
    for (const registration of registrations.reverse()) {
      try {
        await registration.dispose();
      } catch {
        // Preserve the activation failure after attempting every rollback.
      }
    }
    throw error;
  }
};
exports.deactivate = () => host.deactivate();
''';
}

/// Renders the walking-slice parity module, `vscode_parity.g.dart`.
String walkingSliceParityTemplate({
  required String inventoryVersion,
  required String commandNamespaceType,
  required String commandNamespaceName,
  required String languageNamespaceType,
  required String languageNamespaceName,
  required String windowNamespaceType,
  required String windowNamespaceName,
  required String workspaceNamespaceType,
  required String workspaceNamespaceName,
  required String disposableType,
  required String commandRegistrationName,
  required String commandRegistrationIdParameter,
  required String commandRegistrationCallbackParameter,
  required String commandRegistrationThisParameter,
  required String thenableType,
  required String commandExecutionName,
  required String commandExecutionIdParameter,
  required String disposeName,
  required String extensionContextType,
  required String uriType,
  required String extensionUriName,
  required String contextSubscriptionsName,
  required String hoverRegistrationName,
  required String hoverProviderType,
  required String providerCallbackName,
  required String textDocumentType,
  required String cancellationTokenType,
  required String cancellationRequestedName,
  required String eventType,
  required String workspaceEventName,
  required String webviewPanelType,
  required String panelCreationName,
  required String optionsType,
  required String enumType,
  required String enumMemberName,
  required int enumValue,
  required String optionsScriptsName,
  required String optionsRootsName,
  required String positionType,
  required String positionFields,
  required String extensionKey,
  required String uriJoinPathName,
  required String upstreamUriToStringName,
  required String dartUriToStringName,
  required String webviewType,
  required String panelWebviewName,
  required String panelDisposeEventName,
  required String panelDisposeName,
  required String webviewHtmlName,
  required String webviewCspName,
  required String webviewAsUriName,
  required String webviewAsUriParameter,
  required String webviewPostMessageName,
  required String webviewReceiveName,
  required String markdownType,
  required String rangeType,
  required String hoverType,
}) {
  return '''
// GENERATED CODE - DO NOT MODIFY BY HAND.
// VS Code $inventoryVersion mechanically reviewed API slice.

import 'dart:js_interop';

/// Selected root namespaces from the native VS Code API object.
extension type VSCode.fromJS(JSObject _) implements JSObject {
  /// Command registration and execution APIs.
  external $commandNamespaceType get $commandNamespaceName;

  /// Language feature registration APIs.
  external $languageNamespaceType get $languageNamespaceName;

  /// Window and Flutter View panel APIs.
  external $windowNamespaceType get $windowNamespaceName;

  /// Workspace state and event APIs.
  external $workspaceNamespaceType get $workspaceNamespaceName;
}

/// Selected `vscode.commands` operations.
extension type $commandNamespaceType.fromJS(JSObject _) implements JSObject {
  /// Registers [callback] for [command].
  external $disposableType $commandRegistrationName(
    JSString $commandRegistrationIdParameter,
    JSFunction $commandRegistrationCallbackParameter, [
    JSAny? $commandRegistrationThisParameter,
  ]);

  /// Executes [command] and returns its host thenable.
  external $thenableType<T> $commandExecutionName<T extends JSAny?>(
    JSString $commandExecutionIdParameter,
  );
}

/// A host thenable represented by a native JavaScript promise contract.
extension type $thenableType<T extends JSAny?>.fromJS(JSPromise<T> _)
    implements JSPromise<T> {}

/// Structural host object that can release its resource.
extension type DisposableLike.fromJS(JSObject _) implements JSObject {
  /// Releases the resource.
  external JSAny? $disposeName();
}

/// Native VS Code disposable registration.
extension type $disposableType.fromJS(JSObject _)
    implements JSObject, DisposableLike {
  /// Releases the registration.
  external JSAny? $disposeName();
}

/// Native VS Code extension activation context.
extension type $extensionContextType.fromJS(JSObject _) implements JSObject {
  /// Root URI of the installed extension.
  external $uriType get $extensionUriName;

  /// Registrations VS Code disposes with the extension.
  external JSArray<DisposableLike> get $contextSubscriptionsName;
}

/// Selected `vscode.languages` operations.
extension type $languageNamespaceType.fromJS(JSObject _) implements JSObject {
  /// Registers [provider] for the selected documents.
  external $disposableType $hoverRegistrationName(
    JSAny selector,
    $hoverProviderType provider,
  );
}

/// Native hover provider callback object.
@JS()
extension type $hoverProviderType._(JSObject _) implements JSObject {
  /// Creates a provider backed by [provideHover].
  external factory $hoverProviderType({JSFunction $providerCallbackName});
}

/// Native VS Code text document whose identity is preserved.
extension type $textDocumentType.fromJS(JSObject _) implements JSObject {}

/// Native cancellation token supplied to provider callbacks.
extension type $cancellationTokenType.fromJS(JSObject _) implements JSObject {
  /// Whether the host requested cancellation.
  external bool get $cancellationRequestedName;
}

/// Selected `vscode.workspace` events.
extension type $workspaceNamespaceType.fromJS(JSObject _) implements JSObject {
  /// Fires when a text document opens.
  external $eventType<$textDocumentType> get $workspaceEventName;
}

/// Selected `vscode.window` operations.
extension type $windowNamespaceType.fromJS(JSObject _) implements JSObject {
  /// Creates a native VS Code panel that hosts one Flutter View.
  external $webviewPanelType $panelCreationName(
    JSString viewType,
    JSString title,
    int showOptions, [
    $optionsType options,
  ]);
}

/// Reviewed numeric values from VS Code's `ViewColumn` enum.
abstract final class $enumType {
  /// The first editor column.
  static const int $enumMemberName = $enumValue;
}

/// Native options passed when a Flutter View panel is created.
@JS()
extension type $optionsType._(JSObject _) implements JSObject {
  /// Creates the reviewed options shape used by Flutter Views.
  external factory $optionsType({
    bool $optionsScriptsName,
    JSArray<$uriType> $optionsRootsName,
  });
}

/// Callable native VS Code event.
extension type $eventType<T extends JSAny?>.fromJS(JSFunction _)
    implements JSFunction {
  /// Subscribes [listener] and returns its native disposable.
  $disposableType call(
    JSFunction listener, [
    JSAny? thisArgs,
    JSArray<$disposableType>? disposables,
  ]) {
    final JSAny? result;
    if (disposables != null) {
      result = _.callAsFunction(null, listener, thisArgs, disposables);
    } else if (thisArgs != null) {
      result = _.callAsFunction(null, listener, thisArgs);
    } else {
      result = _.callAsFunction(null, listener);
    }
    return $disposableType.fromJS(result! as JSObject);
  }
}

/// Callable native VS Code event that carries no value.
extension type VoidEvent.fromJS(JSFunction _) implements JSFunction {
  /// Subscribes [listener] and returns its native disposable.
  $disposableType call(
    JSFunction listener, [
    JSAny? thisArgs,
    JSArray<$disposableType>? disposables,
  ]) {
    final JSAny? result;
    if (disposables != null) {
      result = _.callAsFunction(null, listener, thisArgs, disposables);
    } else if (thisArgs != null) {
      result = _.callAsFunction(null, listener, thisArgs);
    } else {
      result = _.callAsFunction(null, listener);
    }
    return $disposableType.fromJS(result! as JSObject);
  }
}

/// Native VS Code zero-based document position.
extension type $positionType.fromJS(JSObject _) implements JSObject {
$positionFields
}

/// Native VS Code URI with the reviewed Flutter View operations.
@JS(
  '__flutterVscode.apis.$extensionKey.$uriType',
)
extension type $uriType._(JSObject _) implements JSObject {
  /// Joins one path segment onto [base].
  @JS('$uriJoinPathName')
  external static $uriType $uriJoinPathName(
    $uriType base,
    JSString pathSegment,
  );

  /// Serializes this URI using VS Code's URI implementation.
  @JS('$upstreamUriToStringName')
  // VS Code defines this as a positional boolean parameter.
  // ignore: avoid_positional_boolean_parameters
  external JSString $dartUriToStringName([bool skipEncoding]);
}

/// Native VS Code panel that hosts one Flutter View.
extension type $webviewPanelType.fromJS(JSObject _)
    implements JSObject, DisposableLike {
  /// The panel's web content surface.
  external $webviewType get $panelWebviewName;

  /// Fires once when the panel is disposed.
  external VoidEvent get $panelDisposeEventName;

  /// Closes the panel and releases its resources.
  external JSAny? $panelDisposeName();
}

/// Native VS Code web content surface for a Flutter View.
extension type $webviewType.fromJS(JSObject _) implements JSObject {
  /// Current HTML document source.
  external JSString get $webviewHtmlName;

  /// Replaces the HTML document source.
  external set $webviewHtmlName(JSString value);

  /// Source allowed by VS Code's content security policy.
  external JSString get $webviewCspName;

  /// Converts an extension resource URI into a panel-safe URI.
  external $uriType $webviewAsUriName($uriType $webviewAsUriParameter);

  /// Posts [message] to the Flutter View runtime.
  external $thenableType<JSBoolean> $webviewPostMessageName(JSAny? message);

  /// Fires when the Flutter View posts a message to Host Dart.
  external $eventType<JSAny?> get $webviewReceiveName;
}

/// Native VS Code markdown content.
@JS(
  '__flutterVscode.apis.$extensionKey.$markdownType',
)
extension type $markdownType._(JSObject _) implements JSObject {
  /// Creates markdown initialized with [value].
  external factory $markdownType([JSString value]);
}

/// Native VS Code range between two numeric coordinates.
@JS(
  '__flutterVscode.apis.$extensionKey.$rangeType',
)
extension type $rangeType._(JSObject _) implements JSObject {
  /// Creates a range from zero-based start and end coordinates.
  external factory $rangeType(
    int startLine,
    int startCharacter,
    int endLine,
    int endCharacter,
  );
}

/// Native VS Code hover result.
@JS(
  '__flutterVscode.apis.$extensionKey.$hoverType',
)
extension type $hoverType._(JSObject _) implements JSObject {
  /// Creates a hover with [contents] and an optional [range].
  external factory $hoverType($markdownType contents, [$rangeType range]);
}
''';
}

/// Renders the walking-slice facade module, `vscode_facade.g.dart`.
String walkingSliceFacadeTemplate({
  required String observationConstants,
  required String commandNamespaceType,
  required String commandNamespaceName,
  required String languageNamespaceType,
  required String languageNamespaceName,
  required String windowNamespaceType,
  required String windowNamespaceName,
  required String workspaceNamespaceType,
  required String workspaceNamespaceName,
  required String disposableType,
  required String commandRegistrationName,
  required String commandExecutionName,
  required String extensionContextType,
  required String uriType,
  required String extensionUriName,
  required String contextSubscriptionsName,
  required String disposeName,
  required String hoverProviderType,
  required String hoverRegistrationName,
  required String providerCallbackName,
  required String positionFacade,
  required String cancellationTokenType,
  required String cancellationRequestedName,
  required String markdownType,
  required String rangeType,
  required String hoverType,
  required String workspaceEventName,
  required String webviewPanelType,
  required String enumType,
  required String enumMemberName,
  required String panelCreationName,
  required String optionsType,
  required String optionsScriptsName,
  required String optionsRootsName,
  required String dartUriToStringName,
  required String uriJoinPathName,
  required String webviewType,
  required String panelWebviewName,
  required String panelDisposeEventName,
  required String panelDisposeName,
  required String webviewHtmlName,
  required String webviewCspName,
  required String webviewAsUriName,
  required String webviewPostMessageName,
  required String webviewReceiveName,
}) {
  return '''
// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: always_use_package_imports

import 'dart:js_interop';

import 'vscode_parity.g.dart';
import 'vscode_runtime.g.dart';

export 'host_exports.g.dart';
export 'vscode_parity.g.dart';
export 'vscode_runtime.g.dart';

$observationConstants
/// Observed access to the selected root VS Code namespaces.
extension VSCodeFacade on VSCode {
  /// Command registration and execution APIs.
  $commandNamespaceType get commandApi {
    final api = $commandNamespaceName;
    observeHostBindings(const [_bindingCommandsNamespace]);
    return api;
  }

  /// Language feature registration APIs.
  $languageNamespaceType get languageApi {
    final api = $languageNamespaceName;
    observeHostBindings(const [_bindingLanguagesNamespace]);
    return api;
  }

  /// Window and Flutter View panel APIs.
  $windowNamespaceType get windowApi {
    final api = $windowNamespaceName;
    observeHostBindings(const [_bindingWindowNamespace]);
    return api;
  }

  /// Workspace state and event APIs.
  $workspaceNamespaceType get workspaceApi {
    final api = $workspaceNamespaceName;
    observeHostBindings(const [_bindingWorkspaceNamespace]);
    return api;
  }
}

/// Dart-friendly command helpers over the parity layer.
extension ${commandNamespaceType}Facade on $commandNamespaceType {
  /// Registers a callback and preserves mapped Dart frames for sync failures.
  $disposableType registerCommandCallback(
    JSString command,
    JSFunction callback,
  ) {
    final registration = $commandRegistrationName(
      command,
      toHostCallback(callback),
    );
    observeHostBindings(const [
      _bindingRegisterCommand,
      _bindingDisposableClass,
    ]);
    return registration;
  }

  /// Executes [command] and converts its thenable to a Dart future.
  Future<JSAny?> executeCommandFuture(JSString command) async {
    final result = await $commandExecutionName<JSAny?>(command).toDart;
    observeHostBindings(const [
      _bindingExecuteCommand,
      _bindingThenableInterface,
    ]);
    return result;
  }
}

/// Dart-friendly activation-context helpers.
extension ${extensionContextType}Facade on $extensionContextType {
  /// Root URI of the installed extension.
  $uriType get extensionRootUri {
    final uri = $extensionUriName;
    observeHostBindings(const [
      _bindingExtensionContextInterface,
      _bindingExtensionUri,
    ]);
    return uri;
  }

  /// Adds [registration] to the native extension subscription collection.
  void addSubscription(DisposableLike registration) {
    $contextSubscriptionsName.toDart.add(registration);
    observeHostBindings(const [
      _bindingExtensionContextInterface,
      _bindingContextSubscriptions,
      _bindingContextSubscriptionType,
      _bindingContextSubscriptionDispose,
    ]);
  }
}

/// Dart-friendly disposal for native command, event, and provider resources.
extension ${disposableType}Facade on $disposableType {
  /// Releases this registration through the generated binding.
  void disposeHostResource() {
    $disposeName();
    observeHostBindings(const [
      _bindingDisposableClass,
      _bindingDisposableDispose,
    ]);
  }
}

/// Dart-friendly language feature helpers over the parity layer.
extension ${languageNamespaceType}Facade on $languageNamespaceType {
  /// Registers [provider] for a string document selector.
  $disposableType registerHoverProviderForString(
    JSString selector,
    $hoverProviderType provider,
  ) {
    final registration = $hoverRegistrationName(selector, provider);
    observeHostBindings(const [
      _bindingRegisterHoverProvider,
      _bindingDocumentSelector,
    ]);
    return registration;
  }
}

/// Creates a provider whose actual callback invocation is host-observed.
$hoverProviderType createHostHoverProvider(JSFunction provideHover) {
  final provider = $hoverProviderType(
    $providerCallbackName: observeHostCallback(
      toHostCallback(provideHover),
      const [
        _bindingHoverProviderCallback,
        _bindingTextDocumentInterface,
        _bindingCancellationTokenInterface,
        _bindingProviderResult,
      ],
    ),
  );
  observeHostBindings(const [_bindingHoverProviderInterface]);
  return provider;
}

$positionFacade

/// Observed cancellation state supplied by VS Code provider callbacks.
extension ${cancellationTokenType}Facade on $cancellationTokenType {
  /// Whether the host requested cancellation.
  bool get cancellationRequested {
    final requested = $cancellationRequestedName;
    observeHostBindings(const [_bindingCancellationRequested]);
    return requested;
  }
}

/// Creates observed native markdown content.
$markdownType createHostMarkdownString(JSString value) {
  final markdown = $markdownType(value);
  observeHostBindings(const [
    _bindingMarkdownStringClass,
    _bindingMarkdownStringConstructor,
  ]);
  return markdown;
}

/// Creates an observed native numeric range.
$rangeType createHostRange(
  int startLine,
  int startCharacter,
  int endLine,
  int endCharacter,
) {
  final range = $rangeType(
    startLine,
    startCharacter,
    endLine,
    endCharacter,
  );
  observeHostBindings(const [
    _bindingRangeClass,
    _bindingRangeConstructor,
  ]);
  return range;
}

/// Creates an observed native hover result.
$hoverType createHostHover($markdownType contents, [$rangeType? range]) {
  final hover = range == null
      ? $hoverType(contents)
      : $hoverType(contents, range);
  observeHostBindings(const [
    _bindingHoverClass,
    _bindingHoverConstructor,
  ]);
  return hover;
}

/// Dart-friendly workspace event helpers over the parity layer.
extension ${workspaceNamespaceType}Facade on $workspaceNamespaceType {
  /// Subscribes [listener] to opened text documents.
  $disposableType listenOnDidOpenTextDocument(JSFunction listener) {
    final registration = $workspaceEventName(listener);
    observeHostBindings(const [
      _bindingWorkspaceOpenEvent,
      _bindingEventInterface,
      _bindingEventCall,
    ]);
    return registration;
  }
}

/// Dart-friendly Flutter View panel creation over the parity layer.
extension ${windowNamespaceType}Facade on $windowNamespaceType {
  /// Creates a panel with scripts enabled and scoped local resource roots.
  $webviewPanelType createFlutterViewPanel({
    required String viewType,
    required String title,
    required List<$uriType> localResourceRoots,
    int viewColumn = $enumType.$enumMemberName,
  }) {
    final panel = $panelCreationName(
      viewType.toJS,
      title.toJS,
      viewColumn,
      $optionsType(
        $optionsScriptsName: true,
        $optionsRootsName: localResourceRoots.toJS,
      ),
    );
    observeHostBindings(const [
      _bindingCreateWebviewPanel,
      _bindingWebviewOptionsInterface,
      _bindingOptionsScripts,
      _bindingOptionsRoots,
      _bindingWebviewPanelInterface,
    ]);
    if (viewColumn == $enumType.$enumMemberName) {
      observeHostBindings(const [
        _bindingViewColumnEnum,
        _bindingViewColumnOne,
      ]);
    }
    return panel;
  }
}

/// Dart-friendly URI helpers over VS Code's native URI values.
extension ${uriType}Facade on $uriType {
  /// Serializes this URI to a Dart string.
  String toDartString({bool skipEncoding = false}) {
    final result = $dartUriToStringName(skipEncoding).toDart;
    observeHostBindings(const [
      _bindingUriClass,
      _bindingUriToString,
    ]);
    return result;
  }
}

/// Joins one observed path segment onto [base].
$uriType joinHostUriPath($uriType base, JSString pathSegment) {
  final uri = $uriType.$uriJoinPathName(base, pathSegment);
  observeHostBindings(const [
    _bindingUriClass,
    _bindingUriJoinPath,
  ]);
  return uri;
}

/// Dart-friendly lifecycle helpers for a Flutter View panel.
extension ${webviewPanelType}Facade on $webviewPanelType {
  /// The panel's observed web content surface.
  $webviewType get webviewSurface {
    final surface = $panelWebviewName;
    observeHostBindings(const [
      _bindingWebviewPanelInterface,
      _bindingPanelWebview,
      _bindingWebviewInterface,
    ]);
    return surface;
  }

  /// Subscribes [listener] to panel disposal.
  $disposableType listenOnDidDispose(JSFunction listener) {
    final registration = $panelDisposeEventName(listener);
    observeHostBindings(const [_bindingPanelDisposeEvent]);
    return registration;
  }

  /// Closes the panel through the observed native binding.
  void disposeHostPanel() {
    $panelDisposeName();
    observeHostBindings(const [
      _bindingWebviewPanelInterface,
      _bindingWebviewPanelDispose,
    ]);
  }
}

/// Dart-friendly messaging helpers for a Flutter View.
extension ${webviewType}Facade on $webviewType {
  /// Current HTML as a Dart string.
  String get htmlText {
    final value = $webviewHtmlName.toDart;
    observeHostBindings(const [
      _bindingWebviewInterface,
      _bindingWebviewHtml,
    ]);
    return value;
  }

  /// Replaces the HTML from a Dart string.
  set htmlText(String value) {
    $webviewHtmlName = value.toJS;
    observeHostBindings(const [
      _bindingWebviewInterface,
      _bindingWebviewHtml,
    ]);
  }

  /// Content security policy source as a Dart string.
  String get contentSecurityPolicySource {
    final value = $webviewCspName.toDart;
    observeHostBindings(const [
      _bindingWebviewInterface,
      _bindingWebviewCsp,
    ]);
    return value;
  }

  /// Converts an extension resource URI into a panel-safe URI.
  $uriType asFlutterViewUri($uriType localResource) {
    final uri = $webviewAsUriName(localResource);
    observeHostBindings(const [
      _bindingWebviewInterface,
      _bindingWebviewAsUri,
    ]);
    return uri;
  }

  /// Posts [message] and reports whether it was accepted by the panel.
  Future<bool> postMessageFuture(JSAny? message) async {
    final result = await $webviewPostMessageName(message).toDart;
    final accepted = result.toDart;
    if (accepted) {
      observeHostBindings(const [
        _bindingWebviewInterface,
        _bindingWebviewPostMessage,
        _bindingThenableInterface,
      ]);
    }
    return accepted;
  }

  /// Subscribes [listener] to messages from the Flutter View.
  $disposableType listenOnDidReceiveMessage(JSFunction listener) {
    final registration = $webviewReceiveName(listener);
    observeHostBindings(const [
      _bindingWebviewInterface,
      _bindingWebviewReceive,
      _bindingEventInterface,
      _bindingEventCall,
    ]);
    return registration;
  }
}
''';
}

/// Renders the walking-slice runtime module, `vscode_runtime.g.dart`.
String walkingSliceRuntimeTemplate(String extensionKey) {
  return '''
// GENERATED CODE - DO NOT MODIFY BY HAND.

import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

@JS('__flutterVscode.stackMappers.$extensionKey')
external JSString _mapHostStack(JSString stack);

@JS('__flutterVscode.callbackWrappers.$extensionKey')
external JSFunction _wrapHostCallback(JSFunction callback);

@JS('__flutterVscode.bindingObservers.$extensionKey')
external void _observeHostBinding(JSString bindingId);

@JS('__flutterVscode.bindingCallbackWrappers.$extensionKey')
external JSFunction _wrapObservedHostCallback(
  JSFunction callback,
  JSArray<JSString> bindingIds,
);
'''
      r'''

/// Native JavaScript error used to preserve Dart failure details.
@JS('Error')
extension type JavaScriptError._(JSObject _) implements JSObject {
  /// Creates an error with [message].
  external factory JavaScriptError(JSString message);

  /// Host-visible stack trace.
  external JSString get stack;

  /// Replaces the host-visible stack trace.
  external set stack(JSString value);
}

/// Creates a native host error whose stack retains mapped Dart source frames.
JavaScriptError toHostError(Object error, StackTrace stackTrace) {
  final hostError = JavaScriptError(error.toString().toJS);
  final stack = '${hostError.stack.toDart}\n$stackTrace';
  hostError.stack = _mapHostStack(stack.toJS);
  return hostError;
}

/// Wraps [callback] so synchronous throws retain mapped Dart source frames.
JSFunction toHostCallback(JSFunction callback) => _wrapHostCallback(callback);

/// Records binding IDs reached through an actual generated host operation.
void observeHostBindings(Iterable<String> bindingIds) {
  for (final bindingId in bindingIds) {
    _observeHostBinding(bindingId.toJS);
  }
}

/// Records [bindingIds] only when the native host invokes [callback].
JSFunction observeHostCallback(
  JSFunction callback,
  List<String> bindingIds,
) =>
    _wrapObservedHostCallback(
      callback,
      bindingIds.map((bindingId) => bindingId.toJS).toList().toJS,
    );

/// One HTTP response snapshot from the Extension Host's global `fetch`.
final class HostFetchResponse {
  /// Creates a response snapshot.
  const HostFetchResponse({required this.status, required this.body});

  /// HTTP status code.
  final int status;

  /// Response body decoded as text.
  final String body;

  /// Whether [status] is in the 2xx range.
  bool get ok => status >= 200 && status < 300;
}

@JS('fetch')
external JSPromise<JSObject> _hostGlobalFetch(JSString url, JSObject init);

/// Performs an HTTP request with the Extension Host's global `fetch`.
///
/// The supported host network path: Node's WHATWG `fetch`, bound by the
/// generated runtime and returned as a protocol-safe snapshot.
Future<HostFetchResponse> hostFetch(
  String url, {
  String method = 'GET',
  Map<String, String> headers = const {},
  String? body,
}) async {
  final init = JSObject()..setProperty('method'.toJS, method.toJS);
  if (headers.isNotEmpty) {
    final headerBag = JSObject();
    for (final entry in headers.entries) {
      headerBag.setProperty(entry.key.toJS, entry.value.toJS);
    }
    init.setProperty('headers'.toJS, headerBag);
  }
  if (body != null) {
    init.setProperty('body'.toJS, body.toJS);
  }
  final response = await _hostGlobalFetch(url.toJS, init).toDart;
  final status =
      (response.getProperty('status'.toJS)! as JSNumber).toDartInt;
  final text =
      await (response.callMethod('text'.toJS)! as JSPromise<JSString>)
          .toDart;
  return HostFetchResponse(status: status, body: text.toDart);
}

/// Converts [future] to a host promise while retaining Dart stack frames.
JSPromise<T> toHostPromise<T extends JSAny?>(Future<T> future) {
  return JSPromise<T>(
    (JSFunction resolve, JSFunction reject) {
      unawaited(
        future.then<void>(
          (value) {
            resolve.callAsFunction(resolve, value);
          },
          onError: (Object error, StackTrace stackTrace) {
            reject.callAsFunction(
              reject,
              toHostError(error, stackTrace),
            );
          },
        ),
      );
    }.toJS,
  );
}
''';
}
