// GENERATED CODE - DO NOT MODIFY BY HAND.
//
// The complete typed VS Code Parity Layer (ADR 0012),
// produced only by Total Mapping Rules. Regenerate with:
//   dart tool/binding_generator/generate.dart --parity-layer .
//
// JS `undefined` and `null` both surface as Dart `null`
// (documented platform-wide conflation).
// ignore_for_file: type=lint
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

typedef AuthenticationForceNewSessionOptions = AuthenticationGetSessionPresentationOptions;

typedef CharacterPair = JSTuple_58c6c79a4e36;

typedef ChatParticipantToolToken = JSAny?;

typedef ChatRequestHandler = JSFunction;

typedef ChatResponsePart = JSObject;

typedef ChatResultFeedbackKind = int;
typedef CodeActionTriggerKind = int;
typedef ColorThemeKind = int;
typedef CommentMode = int;
typedef CommentThreadCollapsibleState = int;
typedef CommentThreadState = int;
typedef CompletionItemKind = int;
typedef CompletionItemTag = int;
typedef CompletionTriggerKind = int;
typedef ConfigurationScope = JSObject;

typedef ConfigurationTarget = int;
typedef DebugAdapterDescriptor = JSObject;

typedef DebugConfigurationProviderTriggerKind = int;
typedef DebugConsoleMode = int;
typedef Declaration = JSObject;

typedef DecorationRangeBehavior = int;
typedef Definition = JSObject;

typedef DefinitionLink = LocationLink;

typedef DiagnosticSeverity = int;
typedef DiagnosticTag = int;
typedef DocumentHighlightKind = int;
typedef DocumentPasteTriggerKind = int;
typedef DocumentSelector = JSAny;

typedef EndOfLine = int;
typedef EnvironmentVariableMutatorType = int;
typedef ExtensionKind = int;
typedef ExtensionMode = int;
typedef FileChangeType = int;
typedef FileCoverageDetail = JSObject;

typedef FilePermission = int;
typedef FileType = int;
typedef FoldingRangeKind = int;
typedef GlobPattern = JSAny;

typedef IconPath = JSObject;

typedef IndentAction = int;
typedef InlayHintKind = int;
typedef InlineCompletionTriggerKind = int;
typedef InlineValue = JSObject;

typedef InputBoxValidationSeverity = int;
typedef LanguageModelChatMessageRole = int;
typedef LanguageModelChatToolMode = int;
typedef LanguageModelInputPart = JSObject;

typedef LanguageModelResponsePart = JSObject;

typedef LanguageStatusSeverity = int;
typedef LogLevel = int;
typedef MarkedString = JSAny;

typedef McpServerDefinition = JSObject;

typedef NotebookCellKind = int;
typedef NotebookCellStatusBarAlignment = int;
typedef NotebookControllerAffinity = int;
typedef NotebookEditorRevealType = int;
typedef OverviewRulerLane = int;
typedef ProgressLocation = int;
typedef ProviderResult<T extends JSAny?> = JSAny?;

typedef QuickInputButtonLocation = int;
typedef QuickPickItemKind = int;
typedef ShellQuoting = int;
typedef SignatureHelpTriggerKind = int;
typedef StatusBarAlignment = int;
typedef SymbolKind = int;
typedef SymbolTag = int;
typedef SyntaxTokenType = int;
typedef TaskPanelKind = int;
typedef TaskRevealKind = int;
typedef TaskScope = int;
typedef TerminalExitReason = int;
typedef TerminalLocation = int;
typedef TerminalShellExecutionCommandLineConfidence = int;
typedef TestRunProfileKind = int;
typedef TextDocumentChangeReason = int;
typedef TextDocumentSaveReason = int;
typedef TextEditorCursorStyle = int;
typedef TextEditorLineNumbersStyle = int;
typedef TextEditorRevealType = int;
typedef TextEditorSelectionChangeKind = int;
typedef TreeItemCheckboxState = int;
typedef TreeItemCollapsibleState = int;
typedef UIKind = int;
typedef ViewColumn = int;
typedef NotebookCellOutputConstructor$1 = JSAnon_90b1eaa702e4;
typedef AuthenticationGetSession$1 = JSAnon_af97be86c0c7;
typedef AuthenticationGetSession$2 = JSAnon_cdd103013c05;
typedef L10nT$1 = JSAnon_190a3fc62b24;
typedef WindowCreateOutputChannel$1 = JSAnon_0937a16a6355;
typedef WindowCreateWebviewPanel$1 = JSAnon_fc85cbbeff88;
typedef WindowRegisterCustomEditorProvider$1 = JSAnon_544a305acd79;
typedef WindowRegisterWebviewViewProvider$1 = JSAnon_202de06b6fac;
typedef WindowShowQuickPick$1 = JSAnon_997f9ce7b5db;
typedef WindowShowQuickPick$2 = JSAnon_997f9ce7b5db;
typedef WindowWithProgress$1 = JSAnon_879fda8037df;
typedef WorkspaceDecode$1 = JSAnon_bce51fc74910;
typedef WorkspaceDecode$2 = JSAnon_5f13b3458117;
typedef WorkspaceEncode$1 = JSAnon_5f13b3458117;
typedef WorkspaceEncode$2 = JSAnon_bce51fc74910;
typedef WorkspaceOpenTextDocument$1 = JSAnon_d8666bad7f07;
typedef WorkspaceOpenTextDocument$2 = JSAnon_46c65550b867;
typedef WorkspaceOpenTextDocument$3 = JSAnon_d8666bad7f07;
typedef WorkspaceRegisterFileSystemProvider$1 = JSAnon_3b8881df895e;
typedef WorkspaceUpdateWorkspaceFolders$1 = JSAnon_ca4121a2aaf6;
typedef DisposableFrom$1 = JSAnon_0a93578cd4a3;
typedef DocumentColorProviderProvideColorPresentations$1 = JSAnon_e0c29a989921;
typedef FileSystemCopy$1 = JSAnon_b2623fd46fde;
typedef FileSystemDelete$1 = JSAnon_576b1a88ebc3;
typedef FileSystemRename$1 = JSAnon_b2623fd46fde;
typedef FileSystemProviderCopy$1 = JSAnon_f4ceea3f5f6f;
typedef FileSystemProviderDelete$1 = JSAnon_4ae6d0aa1bdf;
typedef FileSystemProviderRename$1 = JSAnon_f4ceea3f5f6f;
typedef FileSystemProviderWatch$1 = JSAnon_ce282821cb2a;
typedef FileSystemProviderWriteFile$1 = JSAnon_95947812f514;
typedef NotebookEditUpdateCellMetadata$1 = JSAnon_90b1eaa702e4;
typedef NotebookEditUpdateNotebookMetadata$1 = JSAnon_90b1eaa702e4;
typedef NotebookRangeWith$1 = JSAnon_d702e8e12ae8;
typedef PositionTranslate$1 = JSAnon_5687bad38499;
typedef PositionWith$1 = JSAnon_91ec0d04130c;
typedef RangeWith$1 = JSAnon_471b06108965;
typedef RenameProviderPrepareRename$1 = JSAnon_834452ade499;
typedef TextEditorEdit$1 = JSAnon_c32f2c0618c1;
typedef TextEditorInsertSnippet$1 = JSAnon_d6158a9f7600;
typedef TreeViewReveal$1 = JSAnon_49025246bc6f;
typedef UriFrom$1 = JSAnon_5503263f5517;
typedef UriWith$1 = JSAnon_67772e4ecc2b;
typedef WorkspaceConfigurationInspect$1 = JSAnon_406956b7ed59;
typedef WorkspaceEditCreateFile$1 = JSAnon_05617a7b4547;
typedef WorkspaceEditDeleteFile$1 = JSAnon_6f600fe6d695;
typedef WorkspaceEditRenameFile$1 = JSAnon_ed2698223f98;
typedef CodeActionDisabled$1 = JSAnon_4caec6211e15;
typedef CompletionItemRange$1 = JSAnon_f7c793236eba;
typedef DiagnosticCode$1 = JSAnon_588b120e4aae;
typedef MarkdownStringIsTrusted$1 = JSAnon_8ecf0c868e89;
typedef NotebookCellDataMetadata$1 = JSAnon_90b1eaa702e4;
typedef NotebookCellOutputMetadata$1 = JSAnon_90b1eaa702e4;
typedef NotebookDataMetadata$1 = JSAnon_90b1eaa702e4;
typedef NotebookEditNewCellMetadata$1 = JSAnon_90b1eaa702e4;
typedef NotebookEditNewNotebookMetadata$1 = JSAnon_90b1eaa702e4;
typedef TreeItemCheckboxState$1 = JSAnon_ef7f0ac74d5c;
typedef ChatResultMetadata$1 = JSAnon_cd1da709a211;
typedef CodeActionProviderMetadataDocumentation$1 = JSAnon_f698f56281f5;
typedef DebugAdapterExecutableOptionsEnv$1 = JSAnon_c77c8585355a;
typedef ExtensionContextGlobalState$1 = JSAnon_185648dab94d;
typedef ExtensionContextSubscriptions$1 = JSAnon_ffa2e03c40a2;
typedef FileRenameEventFiles$1 = JSAnon_7c30c4713d83;
typedef FileWillRenameEventFiles$1 = JSAnon_7c30c4713d83;
typedef LanguageConfigurationCharacterPairSupport$1 = JSAnon_3800d8dfe13a;
typedef LanguageConfigurationElectricCharacterSupport$1 = JSAnon_7e699a4ba0b6;
typedef LanguageModelChatRequestOptionsModelOptions$1 = JSAnon_90b1eaa702e4;
typedef NotebookCellMetadata$1 = JSAnon_cd1da709a211;
typedef NotebookCellExecutionSummaryTiming$1 = JSAnon_2ef6a897fc39;
typedef NotebookControllerOnDidChangeSelectedNotebooks$1 = JSAnon_a6a068851ba0;
typedef NotebookDocumentMetadata$1 = JSAnon_90b1eaa702e4;
typedef NotebookDocumentCellChangeMetadata$1 = JSAnon_90b1eaa702e4;
typedef NotebookDocumentChangeEventMetadata$1 = JSAnon_90b1eaa702e4;
typedef NotebookDocumentContentOptionsTransientCellMetadata$1 = JSAnon_8493e550322c;
typedef NotebookDocumentContentOptionsTransientDocumentMetadata$1 = JSAnon_8493e550322c;
typedef NotebookRendererMessagingOnDidReceiveMessage$1 = JSAnon_68b4d8c85bba;
typedef OpenDialogOptionsFilters$1 = JSAnon_04cd047eb59c;
typedef ProcessExecutionOptionsEnv$1 = JSAnon_c77c8585355a;
typedef ProgressOptionsLocation$1 = JSAnon_d424d3df46f9;
typedef ProvideLanguageModelChatResponseOptionsModelOptions$1 = JSAnon_cd1da709a211;
typedef QuickInputButtonToggle$1 = JSAnon_dc1f16364c4a;
typedef SaveDialogOptionsFilters$1 = JSAnon_04cd047eb59c;
typedef ShellExecutionOptionsEnv$1 = JSAnon_c77c8585355a;
typedef ShellQuotingOptionsEscape$1 = JSAnon_1507e616ac62;
typedef TerminalOptionsEnv$1 = JSAnon_5cec6a3f14bb;
typedef WindowRegisterWebviewViewProviderWebviewOptions$1 = JSAnon_337f2402bc9d;
typedef LanguageConfigurationCharacterPairSupportAutoClosingPairs$1 = JSAnon_393d84ef6035;
typedef LanguageConfigurationElectricCharacterSupportDocComment$1 = JSAnon_e6d00e2e01a5;
typedef ConfigurationScope$1 = JSAnon_61f1b291a4f5;
typedef IconPath$1 = JSAnon_a5a3481054d2;
typedef MarkedString$1 = JSAnon_a905fa8af122;
typedef L10nBundle$1 = JSAnon_c77c8585355a;

extension type JSTuple_171b5687ecdc(JSArray<JSAny?> _self) implements JSObject {
  JSString get $1 => _self[0] as JSString;
  JSNumber get $2 => _self[1] as JSNumber;
}

extension type JSTuple_25eb84db6d3d(JSArray<JSAny?> _self) implements JSObject {
  Uri get $1 => _self[0] as Uri;
  JSArray<Diagnostic>? get $2 => _self[1] as JSArray<Diagnostic>?;
}

extension type JSTuple_36b05bc0bf39(JSArray<JSAny?> _self) implements JSObject {
  Uri get $1 => _self[0] as Uri;
  JSArray<Diagnostic> get $2 => _self[1] as JSArray<Diagnostic>;
}

extension type JSTuple_581eb76c2fe4(JSArray<JSAny?> _self) implements JSObject {
  Uri get $1 => _self[0] as Uri;
  JSArray<TextEdit> get $2 => _self[1] as JSArray<TextEdit>;
}

extension type JSTuple_58c6c79a4e36(JSArray<JSAny?> _self) implements JSObject {
  JSString get $1 => _self[0] as JSString;
  JSString get $2 => _self[1] as JSString;
}

extension type JSTuple_87f74e97d0da(JSArray<JSAny?> _self) implements JSObject {
  JSAny? get $1 => _self[0];
  JSNumber get $2 => _self[1] as JSNumber;
}

extension type JSTuple_9b5999d5c048(JSArray<JSAny?> _self) implements JSObject {
  JSNumber get $1 => _self[0] as JSNumber;
  JSNumber get $2 => _self[1] as JSNumber;
}

extension type JSTuple_ce311b95ee43(JSArray<JSAny?> _self) implements JSObject {
  NotebookEdit get $1 => _self[0] as NotebookEdit;
  WorkspaceEditEntryMetadata? get $2 => _self[1] as WorkspaceEditEntryMetadata?;
}

extension type JSTuple_de3a98144066(JSArray<JSAny?> _self) implements JSObject {
  JSObject get $1 => _self[0] as JSObject;
  WorkspaceEditEntryMetadata? get $2 => _self[1] as WorkspaceEditEntryMetadata?;
}

extension type JSIntersection_18ddc81c2d41(JSObject _self) implements QuickPickOptions, JSAnon_997f9ce7b5db, JSObject {
  external bool? get canPickMany;
  external set canPickMany(bool? value);
}

extension type JSIntersection_36a7d28cc578(JSObject _self) implements AuthenticationGetSessionOptions, JSAnon_af97be86c0c7, JSObject {
  external JSAny? get createIfNone;
  external set createIfNone(JSAny? value);
}

extension type JSIntersection_559b79086707(JSObject _self) implements AuthenticationGetSessionOptions, JSAnon_cdd103013c05, JSObject {
  external JSAny? get forceNewSession;
  external set forceNewSession(JSAny? value);
}

extension type JSIntersection_9b95285c216c(JSObject _self) implements WebviewPanelOptions, WebviewOptions, JSObject {
}

extension type JSIntersection_c8c004dd0b99(JSObject _self) implements Memento, JSAnon_185648dab94d, JSObject {
  external JSAny? get<T extends JSAny?>(String key);
}

extension type JSAnon_90b1eaa702e4(JSObject _self) implements JSObject {
  external JSAny? operator [](String key);
  external void operator []=(String key, JSAny? value);
}

extension type JSAnon_af97be86c0c7(JSObject _self) implements JSObject {
  external factory JSAnon_af97be86c0c7.lit$({JSAny? createIfNone});
  external JSAny get createIfNone;
  external set createIfNone(JSAny value);
}

extension type JSAnon_cdd103013c05(JSObject _self) implements JSObject {
  external factory JSAnon_cdd103013c05.lit$({JSAny? forceNewSession});
  external JSAny get forceNewSession;
  external set forceNewSession(JSAny value);
}

extension type JSAnon_190a3fc62b24(JSObject _self) implements JSObject {
  external factory JSAnon_190a3fc62b24.lit$({JSObject? args, JSAny? comment, JSString? message});
  external JSObject? get args;
  external set args(JSObject? value);
  external JSAny get comment;
  external set comment(JSAny value);
  external String get message;
  external set message(String value);
}

extension type JSAnon_0937a16a6355(JSObject _self) implements JSObject {
  external factory JSAnon_0937a16a6355.lit$({JSBoolean? log});
  external bool get log;
  external set log(bool value);
}

extension type JSAnon_fc85cbbeff88(JSObject _self) implements JSObject {
  external factory JSAnon_fc85cbbeff88.lit$({JSBoolean? preserveFocus, JSNumber? viewColumn});
  external bool? get preserveFocus;
  external int get viewColumn;
}

extension type JSAnon_544a305acd79(JSObject _self) implements JSObject {
  external factory JSAnon_544a305acd79.lit$({JSBoolean? supportsMultipleEditorsPerDocument, WebviewPanelOptions? webviewOptions});
  external bool? get supportsMultipleEditorsPerDocument;
  external WebviewPanelOptions? get webviewOptions;
}

extension type JSAnon_202de06b6fac(JSObject _self) implements JSObject {
  external factory JSAnon_202de06b6fac.lit$({JSAnon_337f2402bc9d? webviewOptions});
  external JSAnon_337f2402bc9d? get webviewOptions;
}

extension type JSAnon_997f9ce7b5db(JSObject _self) implements JSObject {
  external factory JSAnon_997f9ce7b5db.lit$({JSBoolean? canPickMany});
  external bool get canPickMany;
  external set canPickMany(bool value);
}

extension type JSAnon_879fda8037df(JSObject _self) implements JSObject {
  external factory JSAnon_879fda8037df.lit$({JSNumber? increment, JSString? message});
  external num? get increment;
  external set increment(num? value);
  external String? get message;
  external set message(String? value);
}

extension type JSAnon_bce51fc74910(JSObject _self) implements JSObject {
  external factory JSAnon_bce51fc74910.lit$({JSString? encoding});
  external String get encoding;
}

extension type JSAnon_5f13b3458117(JSObject _self) implements JSObject {
  external factory JSAnon_5f13b3458117.lit$({Uri? uri});
  external Uri get uri;
}

extension type JSAnon_d8666bad7f07(JSObject _self) implements JSObject {
  external factory JSAnon_d8666bad7f07.lit$({JSString? encoding});
  external String? get encoding;
}

extension type JSAnon_46c65550b867(JSObject _self) implements JSObject {
  external factory JSAnon_46c65550b867.lit$({JSString? content, JSString? encoding, JSString? language});
  external String? get content;
  external set content(String? value);
  external String? get encoding;
  external String? get language;
  external set language(String? value);
}

extension type JSAnon_3b8881df895e(JSObject _self) implements JSObject {
  external factory JSAnon_3b8881df895e.lit$({JSBoolean? isCaseSensitive, JSAny? isReadonly});
  external bool? get isCaseSensitive;
  external JSAny? get isReadonly;
}

extension type JSAnon_ca4121a2aaf6(JSObject _self) implements JSObject {
  external factory JSAnon_ca4121a2aaf6.lit$({JSString? name, Uri? uri});
  external String? get name;
  external Uri get uri;
}

extension type JSAnon_0a93578cd4a3(JSObject _self) implements JSObject {
  external factory JSAnon_0a93578cd4a3.lit$({JSFunction? dispose});
  external JSFunction get dispose;
  external set dispose(JSFunction value);
}

extension type JSAnon_e0c29a989921(JSObject _self) implements JSObject {
  external factory JSAnon_e0c29a989921.lit$({TextDocument? document, Range? range});
  external TextDocument get document;
  external Range get range;
}

extension type JSAnon_b2623fd46fde(JSObject _self) implements JSObject {
  external factory JSAnon_b2623fd46fde.lit$({JSBoolean? overwrite});
  external bool? get overwrite;
  external set overwrite(bool? value);
}

extension type JSAnon_576b1a88ebc3(JSObject _self) implements JSObject {
  external factory JSAnon_576b1a88ebc3.lit$({JSBoolean? recursive, JSBoolean? useTrash});
  external bool? get recursive;
  external set recursive(bool? value);
  external bool? get useTrash;
  external set useTrash(bool? value);
}

extension type JSAnon_f4ceea3f5f6f(JSObject _self) implements JSObject {
  external factory JSAnon_f4ceea3f5f6f.lit$({JSBoolean? overwrite});
  external bool get overwrite;
}

extension type JSAnon_4ae6d0aa1bdf(JSObject _self) implements JSObject {
  external factory JSAnon_4ae6d0aa1bdf.lit$({JSBoolean? recursive});
  external bool get recursive;
}

extension type JSAnon_ce282821cb2a(JSObject _self) implements JSObject {
  external factory JSAnon_ce282821cb2a.lit$({JSArray<JSString>? excludes, JSBoolean? recursive});
  external JSArray<JSString> get excludes;
  external bool get recursive;
}

extension type JSAnon_95947812f514(JSObject _self) implements JSObject {
  external factory JSAnon_95947812f514.lit$({JSBoolean? create, JSBoolean? overwrite});
  external bool get create;
  external bool get overwrite;
}

extension type JSAnon_d702e8e12ae8(JSObject _self) implements JSObject {
  external factory JSAnon_d702e8e12ae8.lit$({JSNumber? end, JSNumber? start});
  external num? get end;
  external set end(num? value);
  external num? get start;
  external set start(num? value);
}

extension type JSAnon_5687bad38499(JSObject _self) implements JSObject {
  external factory JSAnon_5687bad38499.lit$({JSNumber? characterDelta, JSNumber? lineDelta});
  external num? get characterDelta;
  external set characterDelta(num? value);
  external num? get lineDelta;
  external set lineDelta(num? value);
}

extension type JSAnon_91ec0d04130c(JSObject _self) implements JSObject {
  external factory JSAnon_91ec0d04130c.lit$({JSNumber? character, JSNumber? line});
  external num? get character;
  external set character(num? value);
  external num? get line;
  external set line(num? value);
}

extension type JSAnon_471b06108965(JSObject _self) implements JSObject {
  external factory JSAnon_471b06108965.lit$({Position? end, Position? start});
  external Position? get end;
  external set end(Position? value);
  external Position? get start;
  external set start(Position? value);
}

extension type JSAnon_834452ade499(JSObject _self) implements JSObject {
  external factory JSAnon_834452ade499.lit$({JSString? placeholder, Range? range});
  external String get placeholder;
  external set placeholder(String value);
  external Range get range;
  external set range(Range value);
}

extension type JSAnon_c32f2c0618c1(JSObject _self) implements JSObject {
  external factory JSAnon_c32f2c0618c1.lit$({JSBoolean? undoStopAfter, JSBoolean? undoStopBefore});
  external bool get undoStopAfter;
  external bool get undoStopBefore;
}

extension type JSAnon_d6158a9f7600(JSObject _self) implements JSObject {
  external factory JSAnon_d6158a9f7600.lit$({JSBoolean? keepWhitespace, JSBoolean? undoStopAfter, JSBoolean? undoStopBefore});
  external bool? get keepWhitespace;
  external bool get undoStopAfter;
  external bool get undoStopBefore;
}

extension type JSAnon_49025246bc6f(JSObject _self) implements JSObject {
  external factory JSAnon_49025246bc6f.lit$({JSAny? expand, JSBoolean? focus, JSBoolean? select});
  external JSAny? get expand;
  external bool? get focus;
  external bool? get select;
}

extension type JSAnon_5503263f5517(JSObject _self) implements JSObject {
  external factory JSAnon_5503263f5517.lit$({JSString? authority, JSString? fragment, JSString? path, JSString? query, JSString? scheme});
  external String? get authority;
  external String? get fragment;
  external String? get path;
  external String? get query;
  external String get scheme;
}

extension type JSAnon_67772e4ecc2b(JSObject _self) implements JSObject {
  external factory JSAnon_67772e4ecc2b.lit$({JSString? authority, JSString? fragment, JSString? path, JSString? query, JSString? scheme});
  external String? get authority;
  external set authority(String? value);
  external String? get fragment;
  external set fragment(String? value);
  external String? get path;
  external set path(String? value);
  external String? get query;
  external set query(String? value);
  external String? get scheme;
  external set scheme(String? value);
}

extension type JSAnon_406956b7ed59(JSObject _self) implements JSObject {
  external factory JSAnon_406956b7ed59.lit$({JSAny? defaultLanguageValue, JSAny? defaultValue, JSAny? globalLanguageValue, JSAny? globalValue, JSString? key, JSArray<JSString>? languageIds, JSAny? workspaceFolderLanguageValue, JSAny? workspaceFolderValue, JSAny? workspaceLanguageValue, JSAny? workspaceValue});
  external JSAny? get defaultLanguageValue;
  external set defaultLanguageValue(JSAny? value);
  external JSAny? get defaultValue;
  external set defaultValue(JSAny? value);
  external JSAny? get globalLanguageValue;
  external set globalLanguageValue(JSAny? value);
  external JSAny? get globalValue;
  external set globalValue(JSAny? value);
  external String get key;
  external set key(String value);
  external JSArray<JSString>? get languageIds;
  external set languageIds(JSArray<JSString>? value);
  external JSAny? get workspaceFolderLanguageValue;
  external set workspaceFolderLanguageValue(JSAny? value);
  external JSAny? get workspaceFolderValue;
  external set workspaceFolderValue(JSAny? value);
  external JSAny? get workspaceLanguageValue;
  external set workspaceLanguageValue(JSAny? value);
  external JSAny? get workspaceValue;
  external set workspaceValue(JSAny? value);
}

extension type JSAnon_05617a7b4547(JSObject _self) implements JSObject {
  external factory JSAnon_05617a7b4547.lit$({JSObject? contents, JSBoolean? ignoreIfExists, JSBoolean? overwrite});
  external JSObject? get contents;
  external bool? get ignoreIfExists;
  external bool? get overwrite;
}

extension type JSAnon_6f600fe6d695(JSObject _self) implements JSObject {
  external factory JSAnon_6f600fe6d695.lit$({JSBoolean? ignoreIfNotExists, JSBoolean? recursive});
  external bool? get ignoreIfNotExists;
  external bool? get recursive;
}

extension type JSAnon_ed2698223f98(JSObject _self) implements JSObject {
  external factory JSAnon_ed2698223f98.lit$({JSBoolean? ignoreIfExists, JSBoolean? overwrite});
  external bool? get ignoreIfExists;
  external bool? get overwrite;
}

extension type JSAnon_4caec6211e15(JSObject _self) implements JSObject {
  external factory JSAnon_4caec6211e15.lit$({JSString? reason});
  external String get reason;
}

extension type JSAnon_f7c793236eba(JSObject _self) implements JSObject {
  external factory JSAnon_f7c793236eba.lit$({Range? inserting, Range? replacing});
  external Range get inserting;
  external set inserting(Range value);
  external Range get replacing;
  external set replacing(Range value);
}

extension type JSAnon_588b120e4aae(JSObject _self) implements JSObject {
  external factory JSAnon_588b120e4aae.lit$({Uri? target, JSAny? value});
  external Uri get target;
  external set target(Uri value);
  external JSAny get value;
  external set value(JSAny value);
}

extension type JSAnon_8ecf0c868e89(JSObject _self) implements JSObject {
  external factory JSAnon_8ecf0c868e89.lit$({JSArray<JSString>? enabledCommands});
  external JSArray<JSString> get enabledCommands;
}

extension type JSAnon_ef7f0ac74d5c(JSObject _self) implements JSObject {
  external factory JSAnon_ef7f0ac74d5c.lit$({AccessibilityInformation? accessibilityInformation, JSNumber? state, JSString? tooltip});
  external AccessibilityInformation? get accessibilityInformation;
  external int get state;
  external String? get tooltip;
}

extension type JSAnon_cd1da709a211(JSObject _self) implements JSObject {
  external JSAny? operator [](String key);
}

extension type JSAnon_f698f56281f5(JSObject _self) implements JSObject {
  external factory JSAnon_f698f56281f5.lit$({Command? command, CodeActionKind? kind});
  external Command get command;
  external CodeActionKind get kind;
}

extension type JSAnon_c77c8585355a(JSObject _self) implements JSObject {
  external String operator [](String key);
  external void operator []=(String key, String value);
}

extension type JSAnon_185648dab94d(JSObject _self) implements JSObject {
  external factory JSAnon_185648dab94d.lit$({JSFunction? setKeysForSync});
  external void setKeysForSync(JSArray<JSString> keys);
}

extension type JSAnon_ffa2e03c40a2(JSObject _self) implements JSObject {
  external factory JSAnon_ffa2e03c40a2.lit$({JSFunction? dispose});
  external JSAny? dispose();
}

extension type JSAnon_7c30c4713d83(JSObject _self) implements JSObject {
  external factory JSAnon_7c30c4713d83.lit$({Uri? newUri, Uri? oldUri});
  external Uri get newUri;
  external Uri get oldUri;
}

extension type JSAnon_3800d8dfe13a(JSObject _self) implements JSObject {
  external factory JSAnon_3800d8dfe13a.lit$({JSArray<JSAnon_393d84ef6035>? autoClosingPairs});
  external JSArray<JSAnon_393d84ef6035> get autoClosingPairs;
  external set autoClosingPairs(JSArray<JSAnon_393d84ef6035> value);
}

extension type JSAnon_7e699a4ba0b6(JSObject _self) implements JSObject {
  external factory JSAnon_7e699a4ba0b6.lit$({JSAny? brackets, JSAnon_e6d00e2e01a5? docComment});
  external JSAny? get brackets;
  external set brackets(JSAny? value);
  external JSAnon_e6d00e2e01a5? get docComment;
  external set docComment(JSAnon_e6d00e2e01a5? value);
}

extension type JSAnon_2ef6a897fc39(JSObject _self) implements JSObject {
  external factory JSAnon_2ef6a897fc39.lit$({JSNumber? endTime, JSNumber? startTime});
  external num get endTime;
  external num get startTime;
}

extension type JSAnon_a6a068851ba0(JSObject _self) implements JSObject {
  external factory JSAnon_a6a068851ba0.lit$({NotebookDocument? notebook, JSBoolean? selected});
  external NotebookDocument get notebook;
  external bool get selected;
}

extension type JSAnon_8493e550322c(JSObject _self) implements JSObject {
  external bool? operator [](String key);
  external void operator []=(String key, bool? value);
}

extension type JSAnon_68b4d8c85bba(JSObject _self) implements JSObject {
  external factory JSAnon_68b4d8c85bba.lit$({NotebookEditor? editor, JSAny? message});
  external NotebookEditor get editor;
  external JSAny? get message;
}

extension type JSAnon_04cd047eb59c(JSObject _self) implements JSObject {
  external JSArray<JSString>? operator [](String key);
  external void operator []=(String key, JSArray<JSString>? value);
}

extension type JSAnon_d424d3df46f9(JSObject _self) implements JSObject {
  external factory JSAnon_d424d3df46f9.lit$({JSString? viewId});
  external String get viewId;
  external set viewId(String value);
}

extension type JSAnon_dc1f16364c4a(JSObject _self) implements JSObject {
  external factory JSAnon_dc1f16364c4a.lit$({JSBoolean? checked});
  external bool get checked;
  external set checked(bool value);
}

extension type JSAnon_1507e616ac62(JSObject _self) implements JSObject {
  external factory JSAnon_1507e616ac62.lit$({JSString? charsToEscape, JSString? escapeChar});
  external String get charsToEscape;
  external set charsToEscape(String value);
  external String get escapeChar;
  external set escapeChar(String value);
}

extension type JSAnon_5cec6a3f14bb(JSObject _self) implements JSObject {
  external JSAny? operator [](String key);
  external void operator []=(String key, JSAny? value);
}

extension type JSAnon_337f2402bc9d(JSObject _self) implements JSObject {
  external factory JSAnon_337f2402bc9d.lit$({JSBoolean? retainContextWhenHidden});
  external bool? get retainContextWhenHidden;
}

extension type JSAnon_393d84ef6035(JSObject _self) implements JSObject {
  external factory JSAnon_393d84ef6035.lit$({JSString? close, JSArray<JSString>? notIn, JSString? open});
  external String get close;
  external set close(String value);
  external JSArray<JSString>? get notIn;
  external set notIn(JSArray<JSString>? value);
  external String get open;
  external set open(String value);
}

extension type JSAnon_e6d00e2e01a5(JSObject _self) implements JSObject {
  external factory JSAnon_e6d00e2e01a5.lit$({JSString? close, JSString? lineStart, JSString? open, JSString? scope});
  external String? get close;
  external set close(String? value);
  external String get lineStart;
  external set lineStart(String value);
  external String get open;
  external set open(String value);
  external String get scope;
  external set scope(String value);
}

extension type JSAnon_61f1b291a4f5(JSObject _self) implements JSObject {
  external factory JSAnon_61f1b291a4f5.lit$({JSString? languageId, Uri? uri});
  external String get languageId;
  external set languageId(String value);
  external Uri? get uri;
  external set uri(Uri? value);
}

extension type JSAnon_a5a3481054d2(JSObject _self) implements JSObject {
  external factory JSAnon_a5a3481054d2.lit$({Uri? dark, Uri? light});
  external Uri get dark;
  external set dark(Uri value);
  external Uri get light;
  external set light(Uri value);
}

extension type JSAnon_a905fa8af122(JSObject _self) implements JSObject {
  external factory JSAnon_a905fa8af122.lit$({JSString? language, JSString? value});
  external String get language;
  external set language(String value);
  external String get value;
  external set value(String value);
}

extension type ChatResultFeedbackKindValues(JSObject _self) implements JSObject {
  external int get Helpful;
  external int get Unhelpful;
}

extension type CodeActionTriggerKindValues(JSObject _self) implements JSObject {
  external int get Automatic;
  external int get Invoke;
}

extension type ColorThemeKindValues(JSObject _self) implements JSObject {
  external int get Dark;
  external int get HighContrast;
  external int get HighContrastLight;
  external int get Light;
}

extension type CommentModeValues(JSObject _self) implements JSObject {
  external int get Editing;
  external int get Preview;
}

extension type CommentThreadCollapsibleStateValues(JSObject _self) implements JSObject {
  external int get Collapsed;
  external int get Expanded;
}

extension type CommentThreadStateValues(JSObject _self) implements JSObject {
  external int get Resolved;
  external int get Unresolved;
}

extension type CompletionItemKindValues(JSObject _self) implements JSObject {
  external int get Class;
  external int get Color;
  external int get Constant;
  external int get Constructor;
  external int get Enum;
  external int get EnumMember;
  external int get Event;
  external int get Field;
  external int get File;
  external int get Folder;
  external int get Function;
  external int get Interface;
  external int get Issue;
  external int get Keyword;
  external int get Method;
  external int get Module;
  external int get Operator;
  external int get Property;
  external int get Reference;
  external int get Snippet;
  external int get Struct;
  external int get Text;
  external int get TypeParameter;
  external int get Unit;
  external int get User;
  external int get Value;
  external int get Variable;
}

extension type CompletionItemTagValues(JSObject _self) implements JSObject {
  external int get Deprecated;
}

extension type CompletionTriggerKindValues(JSObject _self) implements JSObject {
  external int get Invoke;
  external int get TriggerCharacter;
  external int get TriggerForIncompleteCompletions;
}

extension type ConfigurationTargetValues(JSObject _self) implements JSObject {
  external int get Global;
  external int get Workspace;
  external int get WorkspaceFolder;
}

extension type DebugConfigurationProviderTriggerKindValues(JSObject _self) implements JSObject {
  external int get Dynamic;
  external int get Initial;
}

extension type DebugConsoleModeValues(JSObject _self) implements JSObject {
  external int get MergeWithParent;
  external int get Separate;
}

extension type DecorationRangeBehaviorValues(JSObject _self) implements JSObject {
  external int get ClosedClosed;
  external int get ClosedOpen;
  external int get OpenClosed;
  external int get OpenOpen;
}

extension type DiagnosticSeverityValues(JSObject _self) implements JSObject {
  external int get Error;
  external int get Hint;
  external int get Information;
  external int get Warning;
}

extension type DiagnosticTagValues(JSObject _self) implements JSObject {
  external int get Deprecated;
  external int get Unnecessary;
}

extension type DocumentHighlightKindValues(JSObject _self) implements JSObject {
  external int get Read;
  external int get Text;
  external int get Write;
}

extension type DocumentPasteTriggerKindValues(JSObject _self) implements JSObject {
  external int get Automatic;
  external int get PasteAs;
}

extension type EndOfLineValues(JSObject _self) implements JSObject {
  external int get CRLF;
  external int get LF;
}

extension type EnvironmentVariableMutatorTypeValues(JSObject _self) implements JSObject {
  external int get Append;
  external int get Prepend;
  external int get Replace;
}

extension type ExtensionKindValues(JSObject _self) implements JSObject {
  external int get UI;
  external int get Workspace;
}

extension type ExtensionModeValues(JSObject _self) implements JSObject {
  external int get Development;
  external int get Production;
  external int get Test;
}

extension type FileChangeTypeValues(JSObject _self) implements JSObject {
  external int get Changed;
  external int get Created;
  external int get Deleted;
}

extension type FilePermissionValues(JSObject _self) implements JSObject {
  external int get Readonly;
}

extension type FileTypeValues(JSObject _self) implements JSObject {
  external int get Directory;
  external int get File;
  external int get SymbolicLink;
  external int get Unknown;
}

extension type FoldingRangeKindValues(JSObject _self) implements JSObject {
  external int get Comment;
  external int get Imports;
  external int get Region;
}

extension type IndentActionValues(JSObject _self) implements JSObject {
  external int get Indent;
  external int get IndentOutdent;
  external int get None;
  external int get Outdent;
}

extension type InlayHintKindValues(JSObject _self) implements JSObject {
  external int get Parameter;
  external int get Type;
}

extension type InlineCompletionTriggerKindValues(JSObject _self) implements JSObject {
  external int get Automatic;
  external int get Invoke;
}

extension type InputBoxValidationSeverityValues(JSObject _self) implements JSObject {
  external int get Error;
  external int get Info;
  external int get Warning;
}

extension type LanguageModelChatMessageRoleValues(JSObject _self) implements JSObject {
  external int get Assistant;
  external int get User;
}

extension type LanguageModelChatToolModeValues(JSObject _self) implements JSObject {
  external int get Auto;
  external int get Required;
}

extension type LanguageStatusSeverityValues(JSObject _self) implements JSObject {
  external int get Error;
  external int get Information;
  external int get Warning;
}

extension type LogLevelValues(JSObject _self) implements JSObject {
  external int get Debug;
  external int get Error;
  external int get Info;
  external int get Off;
  external int get Trace;
  external int get Warning;
}

extension type NotebookCellKindValues(JSObject _self) implements JSObject {
  external int get Code;
  external int get Markup;
}

extension type NotebookCellStatusBarAlignmentValues(JSObject _self) implements JSObject {
  external int get Left;
  external int get Right;
}

extension type NotebookControllerAffinityValues(JSObject _self) implements JSObject {
  external int get Default;
  external int get Preferred;
}

extension type NotebookEditorRevealTypeValues(JSObject _self) implements JSObject {
  external int get AtTop;
  external int get Default;
  external int get InCenter;
  external int get InCenterIfOutsideViewport;
}

extension type OverviewRulerLaneValues(JSObject _self) implements JSObject {
  external int get Center;
  external int get Full;
  external int get Left;
  external int get Right;
}

extension type ProgressLocationValues(JSObject _self) implements JSObject {
  external int get Notification;
  external int get SourceControl;
  external int get Window;
}

extension type QuickInputButtonLocationValues(JSObject _self) implements JSObject {
  external int get Inline;
  external int get Input;
  external int get Title;
}

extension type QuickPickItemKindValues(JSObject _self) implements JSObject {
  external int get Default;
  external int get Separator;
}

extension type ShellQuotingValues(JSObject _self) implements JSObject {
  external int get Escape;
  external int get Strong;
  external int get Weak;
}

extension type SignatureHelpTriggerKindValues(JSObject _self) implements JSObject {
  external int get ContentChange;
  external int get Invoke;
  external int get TriggerCharacter;
}

extension type StatusBarAlignmentValues(JSObject _self) implements JSObject {
  external int get Left;
  external int get Right;
}

extension type SymbolKindValues(JSObject _self) implements JSObject {
  external int get Array;
  external int get Boolean;
  external int get Class;
  external int get Constant;
  external int get Constructor;
  external int get Enum;
  external int get EnumMember;
  external int get Event;
  external int get Field;
  external int get File;
  external int get Function;
  external int get Interface;
  external int get Key;
  external int get Method;
  external int get Module;
  external int get Namespace;
  external int get Null;
  external int get Number;
  external int get Object;
  external int get Operator;
  external int get Package;
  external int get Property;
  external int get String;
  external int get Struct;
  external int get TypeParameter;
  external int get Variable;
}

extension type SymbolTagValues(JSObject _self) implements JSObject {
  external int get Deprecated;
}

extension type SyntaxTokenTypeValues(JSObject _self) implements JSObject {
  external int get Comment;
  external int get Other;
  external int get RegEx;
  external int get String;
}

extension type TaskPanelKindValues(JSObject _self) implements JSObject {
  external int get Dedicated;
  external int get New;
  external int get Shared;
}

extension type TaskRevealKindValues(JSObject _self) implements JSObject {
  external int get Always;
  external int get Never;
  external int get Silent;
}

extension type TaskScopeValues(JSObject _self) implements JSObject {
  external int get Global;
  external int get Workspace;
}

extension type TerminalExitReasonValues(JSObject _self) implements JSObject {
  external int get Extension;
  external int get Process;
  external int get Shutdown;
  external int get Unknown;
  external int get User;
}

extension type TerminalLocationValues(JSObject _self) implements JSObject {
  external int get Editor;
  external int get Panel;
}

extension type TerminalShellExecutionCommandLineConfidenceValues(JSObject _self) implements JSObject {
  external int get High;
  external int get Low;
  external int get Medium;
}

extension type TestRunProfileKindValues(JSObject _self) implements JSObject {
  external int get Coverage;
  external int get Debug;
  external int get Run;
}

extension type TextDocumentChangeReasonValues(JSObject _self) implements JSObject {
  external int get Redo;
  external int get Undo;
}

extension type TextDocumentSaveReasonValues(JSObject _self) implements JSObject {
  external int get AfterDelay;
  external int get FocusOut;
  external int get Manual;
}

extension type TextEditorCursorStyleValues(JSObject _self) implements JSObject {
  external int get Block;
  external int get BlockOutline;
  external int get Line;
  external int get LineThin;
  external int get Underline;
  external int get UnderlineThin;
}

extension type TextEditorLineNumbersStyleValues(JSObject _self) implements JSObject {
  external int get Interval;
  external int get Off;
  external int get On;
  external int get Relative;
}

extension type TextEditorRevealTypeValues(JSObject _self) implements JSObject {
  external int get AtTop;
  external int get Default;
  external int get InCenter;
  external int get InCenterIfOutsideViewport;
}

extension type TextEditorSelectionChangeKindValues(JSObject _self) implements JSObject {
  external int get Command;
  external int get Keyboard;
  external int get Mouse;
}

extension type TreeItemCheckboxStateValues(JSObject _self) implements JSObject {
  external int get Checked;
  external int get Unchecked;
}

extension type TreeItemCollapsibleStateValues(JSObject _self) implements JSObject {
  external int get Collapsed;
  external int get Expanded;
  external int get None;
}

extension type UIKindValues(JSObject _self) implements JSObject {
  external int get Desktop;
  external int get Web;
}

extension type ViewColumnValues(JSObject _self) implements JSObject {
  external int get Active;
  external int get Beside;
  external int get Eight;
  external int get Five;
  external int get Four;
  external int get Nine;
  external int get One;
  external int get Seven;
  external int get Six;
  external int get Three;
  external int get Two;
}

typedef Thenable<T extends JSAny?> = JSPromise<T>;

extension type AuthenticationNs(JSObject _self) implements JSObject {
  external JSPromise<JSArray<AuthenticationSessionAccountInformation>> getAccounts(String providerId);
  external JSPromise<AuthenticationSession> getSession(String providerId, JSObject scopeListOrRequest, JSIntersection_36a7d28cc578 options);
  @JS('getSession')
  external JSPromise<AuthenticationSession> getSession$2(String providerId, JSObject scopeListOrRequest, JSIntersection_559b79086707 options);
  @JS('getSession')
  external JSPromise<AuthenticationSession?> getSession$3(String providerId, JSObject scopeListOrRequest, [AuthenticationGetSessionOptions? options]);
  external Event<AuthenticationSessionsChangeEvent> get onDidChangeSessions;
  external Disposable registerAuthenticationProvider(String id, String label, AuthenticationProvider provider, [AuthenticationProviderOptions? options]);
}

extension type ChatNs(JSObject _self) implements JSObject {
  external ChatParticipant createChatParticipant(String id, JSFunction handler);
}

extension type CommandsNs(JSObject _self) implements JSObject {
  JSPromise<T> executeCommand<T extends JSAny?>(JSString command, [List<JSAny?> rest = const []]) {
    final args$ = <JSAny?>[command, ...rest];
    return _self.callMethodVarArgs<JSPromise<T>>('executeCommand'.toJS, args$.sublist(0, args$.length));
  }
  external JSPromise<JSArray<JSString>> getCommands([bool? filterInternal]);
  external Disposable registerCommand(String command, JSFunction callback, [JSAny? thisArg]);
  external Disposable registerTextEditorCommand(String command, JSFunction callback, [JSAny? thisArg]);
}

extension type CommentsNs(JSObject _self) implements JSObject {
  external CommentController createCommentController(String id, String label);
}

extension type DebugNs(JSObject _self) implements JSObject {
  external DebugConsole get activeDebugConsole;
  external set activeDebugConsole(DebugConsole value);
  external DebugSession? get activeDebugSession;
  external set activeDebugSession(DebugSession? value);
  external JSObject? get activeStackItem;
  external void addBreakpoints(JSArray<Breakpoint> breakpoints);
  external Uri asDebugSourceUri(DebugProtocolSource source, [DebugSession? session]);
  external JSArray<Breakpoint> get breakpoints;
  external set breakpoints(JSArray<Breakpoint> value);
  external Event<DebugSession?> get onDidChangeActiveDebugSession;
  external Event<JSObject?> get onDidChangeActiveStackItem;
  external Event<BreakpointsChangeEvent> get onDidChangeBreakpoints;
  external Event<DebugSessionCustomEvent> get onDidReceiveDebugSessionCustomEvent;
  external Event<DebugSession> get onDidStartDebugSession;
  external Event<DebugSession> get onDidTerminateDebugSession;
  external Disposable registerDebugAdapterDescriptorFactory(String debugType, DebugAdapterDescriptorFactory factory);
  external Disposable registerDebugAdapterTrackerFactory(String debugType, DebugAdapterTrackerFactory factory);
  external Disposable registerDebugConfigurationProvider(String debugType, DebugConfigurationProvider provider, [int? triggerKind]);
  external void removeBreakpoints(JSArray<Breakpoint> breakpoints);
  external JSPromise<JSBoolean> startDebugging(WorkspaceFolder? folder, JSAny nameOrConfiguration, [JSObject? parentSessionOrOptions]);
  external JSPromise<JSAny?> stopDebugging([DebugSession? session]);
}

extension type EnvNs(JSObject _self) implements JSObject {
  external String get appHost;
  external String get appName;
  external String get appRoot;
  external JSPromise<Uri> asExternalUri(Uri target);
  external Clipboard get clipboard;
  external TelemetryLogger createTelemetryLogger(TelemetrySender sender, [TelemetryLoggerOptions? options]);
  external bool get isAppPortable;
  external bool get isNewAppInstall;
  external bool get isTelemetryEnabled;
  external String get language;
  external int get logLevel;
  external String get machineId;
  external Event<JSNumber> get onDidChangeLogLevel;
  external Event<JSString> get onDidChangeShell;
  external Event<JSBoolean> get onDidChangeTelemetryEnabled;
  external JSPromise<JSBoolean> openExternal(Uri target);
  external String? get remoteName;
  external String get sessionId;
  external String get shell;
  external int get uiKind;
  external String get uriScheme;
}

extension type ExtensionsNs(JSObject _self) implements JSObject {
  external JSArray<Extension<JSAny?>> get all;
  external Extension<T>? getExtension<T extends JSAny?>(String extensionId);
  external Event<JSAny?> get onDidChange;
}

extension type L10nNs(JSObject _self) implements JSObject {
  external JSAnon_c77c8585355a? get bundle;
  JSString t(JSString message, [List<JSAny?> args = const []]) {
    final args$ = <JSAny?>[message, ...args];
    return _self.callMethodVarArgs<JSString>('t'.toJS, args$.sublist(0, args$.length));
  }
  @JS('t')
  external String t$2(String message, JSObject args);
  @JS('t')
  external String t$3(JSAnon_190a3fc62b24 options);
  external Uri? get uri;
}

extension type LanguagesNs(JSObject _self) implements JSObject {
  external DiagnosticCollection createDiagnosticCollection([String? name]);
  external LanguageStatusItem createLanguageStatusItem(String id, JSAny selector);
  external JSArray<Diagnostic> getDiagnostics(Uri resource);
  @JS('getDiagnostics')
  external JSArray<JSTuple_36b05bc0bf39> getDiagnostics$2();
  external JSPromise<JSArray<JSString>> getLanguages();
  external num match(JSAny selector, TextDocument document);
  external Event<DiagnosticChangeEvent> get onDidChangeDiagnostics;
  external Disposable registerCallHierarchyProvider(JSAny selector, CallHierarchyProvider provider);
  external Disposable registerCodeActionsProvider(JSAny selector, CodeActionProvider<JSAny?> provider, [CodeActionProviderMetadata? metadata]);
  external Disposable registerCodeLensProvider(JSAny selector, CodeLensProvider<JSAny?> provider);
  external Disposable registerColorProvider(JSAny selector, DocumentColorProvider provider);
  Disposable registerCompletionItemProvider(JSAny selector, CompletionItemProvider<JSAny?> provider, [List<JSAny?> triggerCharacters = const []]) {
    final args$ = <JSAny?>[selector, provider, ...triggerCharacters];
    return _self.callMethodVarArgs<Disposable>('registerCompletionItemProvider'.toJS, args$.sublist(0, args$.length));
  }
  external Disposable registerDeclarationProvider(JSAny selector, DeclarationProvider provider);
  external Disposable registerDefinitionProvider(JSAny selector, DefinitionProvider provider);
  external Disposable registerDocumentDropEditProvider(JSAny selector, DocumentDropEditProvider<JSAny?> provider, [DocumentDropEditProviderMetadata? metadata]);
  external Disposable registerDocumentFormattingEditProvider(JSAny selector, DocumentFormattingEditProvider provider);
  external Disposable registerDocumentHighlightProvider(JSAny selector, DocumentHighlightProvider provider);
  external Disposable registerDocumentLinkProvider(JSAny selector, DocumentLinkProvider<JSAny?> provider);
  external Disposable registerDocumentPasteEditProvider(JSAny selector, DocumentPasteEditProvider<JSAny?> provider, DocumentPasteProviderMetadata metadata);
  external Disposable registerDocumentRangeFormattingEditProvider(JSAny selector, DocumentRangeFormattingEditProvider provider);
  external Disposable registerDocumentRangeSemanticTokensProvider(JSAny selector, DocumentRangeSemanticTokensProvider provider, SemanticTokensLegend legend);
  external Disposable registerDocumentSemanticTokensProvider(JSAny selector, DocumentSemanticTokensProvider provider, SemanticTokensLegend legend);
  external Disposable registerDocumentSymbolProvider(JSAny selector, DocumentSymbolProvider provider, [DocumentSymbolProviderMetadata? metaData]);
  external Disposable registerEvaluatableExpressionProvider(JSAny selector, EvaluatableExpressionProvider provider);
  external Disposable registerFoldingRangeProvider(JSAny selector, FoldingRangeProvider provider);
  external Disposable registerHoverProvider(JSAny selector, HoverProvider provider);
  external Disposable registerImplementationProvider(JSAny selector, ImplementationProvider provider);
  external Disposable registerInlayHintsProvider(JSAny selector, InlayHintsProvider<JSAny?> provider);
  external Disposable registerInlineCompletionItemProvider(JSAny selector, InlineCompletionItemProvider provider);
  external Disposable registerInlineValuesProvider(JSAny selector, InlineValuesProvider provider);
  external Disposable registerLinkedEditingRangeProvider(JSAny selector, LinkedEditingRangeProvider provider);
  Disposable registerOnTypeFormattingEditProvider(JSAny selector, OnTypeFormattingEditProvider provider, JSString firstTriggerCharacter, [List<JSAny?> moreTriggerCharacter = const []]) {
    final args$ = <JSAny?>[selector, provider, firstTriggerCharacter, ...moreTriggerCharacter];
    return _self.callMethodVarArgs<Disposable>('registerOnTypeFormattingEditProvider'.toJS, args$.sublist(0, args$.length));
  }
  external Disposable registerReferenceProvider(JSAny selector, ReferenceProvider provider);
  external Disposable registerRenameProvider(JSAny selector, RenameProvider provider);
  external Disposable registerSelectionRangeProvider(JSAny selector, SelectionRangeProvider provider);
  Disposable registerSignatureHelpProvider(JSAny selector, SignatureHelpProvider provider, [List<JSAny?> triggerCharacters = const []]) {
    final args$ = <JSAny?>[selector, provider, ...triggerCharacters];
    return _self.callMethodVarArgs<Disposable>('registerSignatureHelpProvider'.toJS, args$.sublist(0, args$.length));
  }
  @JS('registerSignatureHelpProvider')
  external Disposable registerSignatureHelpProvider$2(JSAny selector, SignatureHelpProvider provider, SignatureHelpProviderMetadata metadata);
  external Disposable registerTypeDefinitionProvider(JSAny selector, TypeDefinitionProvider provider);
  external Disposable registerTypeHierarchyProvider(JSAny selector, TypeHierarchyProvider provider);
  external Disposable registerWorkspaceSymbolProvider(WorkspaceSymbolProvider<JSAny?> provider);
  external Disposable setLanguageConfiguration(String language, LanguageConfiguration configuration);
  external JSPromise<TextDocument> setTextDocumentLanguage(TextDocument document, String languageId);
}

extension type LmNs(JSObject _self) implements JSObject {
  external JSPromise<LanguageModelToolResult> invokeTool(String name, LanguageModelToolInvocationOptions<JSObject> options, [CancellationToken? token]);
  external Event<JSAny?> get onDidChangeChatModels;
  external Disposable registerLanguageModelChatProvider(String vendor, LanguageModelChatProvider<JSAny?> provider);
  external Disposable registerMcpServerDefinitionProvider(String id, McpServerDefinitionProvider<JSAny?> provider);
  external Disposable registerTool<T extends JSAny?>(String name, LanguageModelTool<T> tool);
  external JSPromise<JSArray<LanguageModelChat>> selectChatModels([LanguageModelChatSelector? selector]);
  external JSArray<LanguageModelToolInformation> get tools;
}

extension type NotebooksNs(JSObject _self) implements JSObject {
  external NotebookController createNotebookController(String id, String notebookType, String label, [JSFunction? handler]);
  external NotebookRendererMessaging createRendererMessaging(String rendererId);
  external Disposable registerNotebookCellStatusBarItemProvider(String notebookType, NotebookCellStatusBarItemProvider provider);
}

extension type ScmNs(JSObject _self) implements JSObject {
  external SourceControl createSourceControl(String id, String label, [Uri? rootUri]);
  external SourceControlInputBox get inputBox;
}

extension type TasksNs(JSObject _self) implements JSObject {
  external JSPromise<TaskExecution> executeTask(Task task);
  external JSPromise<JSArray<Task>> fetchTasks([TaskFilter? filter]);
  external Event<TaskEndEvent> get onDidEndTask;
  external Event<TaskProcessEndEvent> get onDidEndTaskProcess;
  external Event<TaskStartEvent> get onDidStartTask;
  external Event<TaskProcessStartEvent> get onDidStartTaskProcess;
  external Disposable registerTaskProvider(String type, TaskProvider<JSAny?> provider);
  external JSArray<TaskExecution> get taskExecutions;
}

extension type TestsNs(JSObject _self) implements JSObject {
  external TestController createTestController(String id, String label);
}

extension type WindowNs(JSObject _self) implements JSObject {
  external ColorTheme get activeColorTheme;
  external set activeColorTheme(ColorTheme value);
  external NotebookEditor? get activeNotebookEditor;
  external Terminal? get activeTerminal;
  external TextEditor? get activeTextEditor;
  external set activeTextEditor(TextEditor? value);
  external InputBox createInputBox();
  external OutputChannel createOutputChannel(String name, [String? languageId]);
  @JS('createOutputChannel')
  external LogOutputChannel createOutputChannel$2(String name, JSAnon_0937a16a6355 options);
  external QuickPick<T> createQuickPick<T extends JSAny?>();
  external StatusBarItem createStatusBarItem(String id, [int? alignment, num? priority]);
  @JS('createStatusBarItem')
  external StatusBarItem createStatusBarItem$2([int? alignment, num? priority]);
  external Terminal createTerminal([String? name, String? shellPath, JSAny? shellArgs]);
  @JS('createTerminal')
  external Terminal createTerminal$2(TerminalOptions options);
  @JS('createTerminal')
  external Terminal createTerminal$3(ExtensionTerminalOptions options);
  external TextEditorDecorationType createTextEditorDecorationType(DecorationRenderOptions options);
  external TreeView<T> createTreeView<T extends JSAny?>(String viewId, TreeViewOptions<T> options);
  external WebviewPanel createWebviewPanel(String viewType, String title, JSAny showOptions, [JSIntersection_9b95285c216c? options]);
  external Event<ColorTheme> get onDidChangeActiveColorTheme;
  external Event<NotebookEditor?> get onDidChangeActiveNotebookEditor;
  external Event<Terminal?> get onDidChangeActiveTerminal;
  external Event<TextEditor?> get onDidChangeActiveTextEditor;
  external Event<NotebookEditorSelectionChangeEvent> get onDidChangeNotebookEditorSelection;
  external Event<NotebookEditorVisibleRangesChangeEvent> get onDidChangeNotebookEditorVisibleRanges;
  external Event<TerminalShellIntegrationChangeEvent> get onDidChangeTerminalShellIntegration;
  external Event<Terminal> get onDidChangeTerminalState;
  external Event<TextEditorOptionsChangeEvent> get onDidChangeTextEditorOptions;
  external Event<TextEditorSelectionChangeEvent> get onDidChangeTextEditorSelection;
  external Event<TextEditorViewColumnChangeEvent> get onDidChangeTextEditorViewColumn;
  external Event<TextEditorVisibleRangesChangeEvent> get onDidChangeTextEditorVisibleRanges;
  external Event<JSArray<NotebookEditor>> get onDidChangeVisibleNotebookEditors;
  external Event<JSArray<TextEditor>> get onDidChangeVisibleTextEditors;
  external Event<WindowState> get onDidChangeWindowState;
  external Event<Terminal> get onDidCloseTerminal;
  external Event<TerminalShellExecutionEndEvent> get onDidEndTerminalShellExecution;
  external Event<Terminal> get onDidOpenTerminal;
  external Event<TerminalShellExecutionStartEvent> get onDidStartTerminalShellExecution;
  external Disposable registerCustomEditorProvider(String viewType, JSObject provider, [JSAnon_544a305acd79? options]);
  external Disposable registerFileDecorationProvider(FileDecorationProvider provider);
  external Disposable registerTerminalLinkProvider(TerminalLinkProvider<JSAny?> provider);
  external Disposable registerTerminalProfileProvider(String id, TerminalProfileProvider provider);
  external Disposable registerTreeDataProvider<T extends JSAny?>(String viewId, TreeDataProvider<T> treeDataProvider);
  external Disposable registerUriHandler(UriHandler handler);
  external Disposable registerWebviewPanelSerializer(String viewType, WebviewPanelSerializer<JSAny?> serializer);
  external Disposable registerWebviewViewProvider(String viewId, WebviewViewProvider provider, [JSAnon_202de06b6fac? options]);
  external Disposable setStatusBarMessage(String text, num hideAfterTimeout);
  @JS('setStatusBarMessage')
  external Disposable setStatusBarMessage$2(String text, JSPromise<JSAny?> hideWhenDone);
  @JS('setStatusBarMessage')
  external Disposable setStatusBarMessage$3(String text);
  JSPromise<T?> showErrorMessage<T extends JSAny?>(JSString message, [List<JSAny?> items = const []]) {
    final args$ = <JSAny?>[message, ...items];
    return _self.callMethodVarArgs<JSPromise<T?>>('showErrorMessage'.toJS, args$.sublist(0, args$.length));
  }
  JSPromise<T?> showErrorMessage$2<T extends JSAny?>(JSString message, MessageOptions options, [List<JSAny?> items = const []]) {
    final args$ = <JSAny?>[message, options, ...items];
    return _self.callMethodVarArgs<JSPromise<T?>>('showErrorMessage'.toJS, args$.sublist(0, args$.length));
  }
  JSPromise<T?> showErrorMessage$3<T extends JSAny?>(JSString message, [List<JSAny?> items = const []]) {
    final args$ = <JSAny?>[message, ...items];
    return _self.callMethodVarArgs<JSPromise<T?>>('showErrorMessage'.toJS, args$.sublist(0, args$.length));
  }
  JSPromise<T?> showErrorMessage$4<T extends JSAny?>(JSString message, MessageOptions options, [List<JSAny?> items = const []]) {
    final args$ = <JSAny?>[message, options, ...items];
    return _self.callMethodVarArgs<JSPromise<T?>>('showErrorMessage'.toJS, args$.sublist(0, args$.length));
  }
  JSPromise<T?> showInformationMessage<T extends JSAny?>(JSString message, [List<JSAny?> items = const []]) {
    final args$ = <JSAny?>[message, ...items];
    return _self.callMethodVarArgs<JSPromise<T?>>('showInformationMessage'.toJS, args$.sublist(0, args$.length));
  }
  JSPromise<T?> showInformationMessage$2<T extends JSAny?>(JSString message, MessageOptions options, [List<JSAny?> items = const []]) {
    final args$ = <JSAny?>[message, options, ...items];
    return _self.callMethodVarArgs<JSPromise<T?>>('showInformationMessage'.toJS, args$.sublist(0, args$.length));
  }
  JSPromise<T?> showInformationMessage$3<T extends JSAny?>(JSString message, [List<JSAny?> items = const []]) {
    final args$ = <JSAny?>[message, ...items];
    return _self.callMethodVarArgs<JSPromise<T?>>('showInformationMessage'.toJS, args$.sublist(0, args$.length));
  }
  JSPromise<T?> showInformationMessage$4<T extends JSAny?>(JSString message, MessageOptions options, [List<JSAny?> items = const []]) {
    final args$ = <JSAny?>[message, options, ...items];
    return _self.callMethodVarArgs<JSPromise<T?>>('showInformationMessage'.toJS, args$.sublist(0, args$.length));
  }
  external JSPromise<JSString?> showInputBox([InputBoxOptions? options, CancellationToken? token]);
  external JSPromise<NotebookEditor> showNotebookDocument(NotebookDocument document, [NotebookDocumentShowOptions? options]);
  external JSPromise<JSArray<Uri>?> showOpenDialog([OpenDialogOptions? options]);
  external JSPromise<JSArray<JSString>?> showQuickPick(JSObject items, JSIntersection_18ddc81c2d41 options, [CancellationToken? token]);
  @JS('showQuickPick')
  external JSPromise<JSString?> showQuickPick$2(JSObject items, [QuickPickOptions? options, CancellationToken? token]);
  @JS('showQuickPick')
  external JSPromise<JSArray<T>?> showQuickPick$3<T extends JSAny?>(JSObject items, JSIntersection_18ddc81c2d41 options, [CancellationToken? token]);
  @JS('showQuickPick')
  external JSPromise<T?> showQuickPick$4<T extends JSAny?>(JSObject items, [QuickPickOptions? options, CancellationToken? token]);
  external JSPromise<Uri?> showSaveDialog([SaveDialogOptions? options]);
  external JSPromise<TextEditor> showTextDocument(TextDocument document, [int? column, bool? preserveFocus]);
  @JS('showTextDocument')
  external JSPromise<TextEditor> showTextDocument$2(TextDocument document, [TextDocumentShowOptions? options]);
  @JS('showTextDocument')
  external JSPromise<TextEditor> showTextDocument$3(Uri uri, [TextDocumentShowOptions? options]);
  JSPromise<T?> showWarningMessage<T extends JSAny?>(JSString message, [List<JSAny?> items = const []]) {
    final args$ = <JSAny?>[message, ...items];
    return _self.callMethodVarArgs<JSPromise<T?>>('showWarningMessage'.toJS, args$.sublist(0, args$.length));
  }
  JSPromise<T?> showWarningMessage$2<T extends JSAny?>(JSString message, MessageOptions options, [List<JSAny?> items = const []]) {
    final args$ = <JSAny?>[message, options, ...items];
    return _self.callMethodVarArgs<JSPromise<T?>>('showWarningMessage'.toJS, args$.sublist(0, args$.length));
  }
  JSPromise<T?> showWarningMessage$3<T extends JSAny?>(JSString message, [List<JSAny?> items = const []]) {
    final args$ = <JSAny?>[message, ...items];
    return _self.callMethodVarArgs<JSPromise<T?>>('showWarningMessage'.toJS, args$.sublist(0, args$.length));
  }
  JSPromise<T?> showWarningMessage$4<T extends JSAny?>(JSString message, MessageOptions options, [List<JSAny?> items = const []]) {
    final args$ = <JSAny?>[message, options, ...items];
    return _self.callMethodVarArgs<JSPromise<T?>>('showWarningMessage'.toJS, args$.sublist(0, args$.length));
  }
  external JSPromise<WorkspaceFolder?> showWorkspaceFolderPick([WorkspaceFolderPickOptions? options]);
  external WindowState get state;
  external TabGroups get tabGroups;
  external JSArray<Terminal> get terminals;
  external JSArray<NotebookEditor> get visibleNotebookEditors;
  external JSArray<TextEditor> get visibleTextEditors;
  external set visibleTextEditors(JSArray<TextEditor> value);
  external JSPromise<R> withProgress<R extends JSAny?>(ProgressOptions options, JSFunction task);
  external JSPromise<R> withScmProgress<R extends JSAny?>(JSFunction task);
}

extension type WorkspaceNs(JSObject _self) implements JSObject {
  external JSPromise<JSBoolean> applyEdit(WorkspaceEdit edit, [WorkspaceEditMetadata? metadata]);
  external String asRelativePath(JSAny pathOrUri, [bool? includeWorkspaceFolder]);
  external FileSystemWatcher createFileSystemWatcher(JSAny globPattern, [bool? ignoreCreateEvents, bool? ignoreChangeEvents, bool? ignoreDeleteEvents]);
  external JSPromise<JSString> decode(JSUint8Array content);
  @JS('decode')
  external JSPromise<JSString> decode$2(JSUint8Array content, JSAnon_bce51fc74910 options);
  @JS('decode')
  external JSPromise<JSString> decode$3(JSUint8Array content, JSAnon_5f13b3458117 options);
  external JSPromise<JSUint8Array> encode(String content);
  @JS('encode')
  external JSPromise<JSUint8Array> encode$2(String content, JSAnon_bce51fc74910 options);
  @JS('encode')
  external JSPromise<JSUint8Array> encode$3(String content, JSAnon_5f13b3458117 options);
  external JSPromise<JSArray<Uri>> findFiles(JSAny include, [JSAny? exclude, num? maxResults, CancellationToken? token]);
  external FileSystem get fs;
  external WorkspaceConfiguration getConfiguration([String? section, JSAny? scope]);
  external WorkspaceFolder? getWorkspaceFolder(Uri uri);
  external bool get isTrusted;
  external String? get name;
  external JSArray<NotebookDocument> get notebookDocuments;
  external Event<ConfigurationChangeEvent> get onDidChangeConfiguration;
  external Event<NotebookDocumentChangeEvent> get onDidChangeNotebookDocument;
  external Event<TextDocumentChangeEvent> get onDidChangeTextDocument;
  external Event<WorkspaceFoldersChangeEvent> get onDidChangeWorkspaceFolders;
  external Event<NotebookDocument> get onDidCloseNotebookDocument;
  external Event<TextDocument> get onDidCloseTextDocument;
  external Event<FileCreateEvent> get onDidCreateFiles;
  external Event<FileDeleteEvent> get onDidDeleteFiles;
  external Event<JSAny?> get onDidGrantWorkspaceTrust;
  external Event<NotebookDocument> get onDidOpenNotebookDocument;
  external Event<TextDocument> get onDidOpenTextDocument;
  external Event<FileRenameEvent> get onDidRenameFiles;
  external Event<NotebookDocument> get onDidSaveNotebookDocument;
  external Event<TextDocument> get onDidSaveTextDocument;
  external Event<FileWillCreateEvent> get onWillCreateFiles;
  external Event<FileWillDeleteEvent> get onWillDeleteFiles;
  external Event<FileWillRenameEvent> get onWillRenameFiles;
  external Event<NotebookDocumentWillSaveEvent> get onWillSaveNotebookDocument;
  external Event<TextDocumentWillSaveEvent> get onWillSaveTextDocument;
  external JSPromise<NotebookDocument> openNotebookDocument(Uri uri);
  @JS('openNotebookDocument')
  external JSPromise<NotebookDocument> openNotebookDocument$2(String notebookType, [NotebookData? content]);
  external JSPromise<TextDocument> openTextDocument(Uri uri, [JSAnon_d8666bad7f07? options]);
  @JS('openTextDocument')
  external JSPromise<TextDocument> openTextDocument$2(String path, [JSAnon_d8666bad7f07? options]);
  @JS('openTextDocument')
  external JSPromise<TextDocument> openTextDocument$3([JSAnon_46c65550b867? options]);
  external Disposable registerFileSystemProvider(String scheme, FileSystemProvider provider, [JSAnon_3b8881df895e? options]);
  external Disposable registerNotebookSerializer(String notebookType, NotebookSerializer serializer, [NotebookDocumentContentOptions? options]);
  external Disposable registerTaskProvider(String type, TaskProvider<JSAny?> provider);
  external Disposable registerTextDocumentContentProvider(String scheme, TextDocumentContentProvider provider);
  external String? get rootPath;
  external JSPromise<Uri?> save(Uri uri);
  external JSPromise<JSBoolean> saveAll([bool? includeUntitled]);
  external JSPromise<Uri?> saveAs(Uri uri);
  external JSArray<TextDocument> get textDocuments;
  JSBoolean updateWorkspaceFolders(JSNumber start, JSAny? deleteCount, [List<JSAny?> workspaceFoldersToAdd = const []]) {
    final args$ = <JSAny?>[start, deleteCount, ...workspaceFoldersToAdd];
    return _self.callMethodVarArgs<JSBoolean>('updateWorkspaceFolders'.toJS, args$.sublist(0, args$.length));
  }
  external Uri? get workspaceFile;
  external JSArray<WorkspaceFolder>? get workspaceFolders;
}

extension type AccessibilityInformation(JSObject _self) implements JSObject {
  external factory AccessibilityInformation.lit$({JSString? label, JSString? role});
  external String get label;
  external String? get role;
}

extension type AuthenticationGetSessionOptions(JSObject _self) implements JSObject {
  external factory AuthenticationGetSessionOptions.lit$({AuthenticationSessionAccountInformation? account, JSBoolean? clearSessionPreference, JSAny? createIfNone, JSAny? forceNewSession, JSBoolean? silent});
  external AuthenticationSessionAccountInformation? get account;
  external set account(AuthenticationSessionAccountInformation? value);
  external bool? get clearSessionPreference;
  external set clearSessionPreference(bool? value);
  external JSAny? get createIfNone;
  external set createIfNone(JSAny? value);
  external JSAny? get forceNewSession;
  external set forceNewSession(JSAny? value);
  external bool? get silent;
  external set silent(bool? value);
}

extension type AuthenticationGetSessionPresentationOptions(JSObject _self) implements JSObject {
  external factory AuthenticationGetSessionPresentationOptions.lit$({JSString? detail});
  external String? get detail;
  external set detail(String? value);
}

extension type AuthenticationProvider(JSObject _self) implements JSObject {
  external factory AuthenticationProvider.lit$({JSFunction? createSession, JSFunction? getSessions, Event<AuthenticationProviderAuthenticationSessionsChangeEvent>? onDidChangeSessions, JSFunction? removeSession});
  external JSPromise<AuthenticationSession> createSession(JSArray<JSString> scopes, AuthenticationProviderSessionOptions options);
  external JSPromise<JSArray<AuthenticationSession>> getSessions(JSArray<JSString>? scopes, AuthenticationProviderSessionOptions options);
  external Event<AuthenticationProviderAuthenticationSessionsChangeEvent> get onDidChangeSessions;
  external JSPromise<JSAny?> removeSession(String sessionId);
}

extension type AuthenticationProviderAuthenticationSessionsChangeEvent(JSObject _self) implements JSObject {
  external factory AuthenticationProviderAuthenticationSessionsChangeEvent.lit$({JSArray<AuthenticationSession>? added, JSArray<AuthenticationSession>? changed, JSArray<AuthenticationSession>? removed});
  external JSArray<AuthenticationSession>? get added;
  external JSArray<AuthenticationSession>? get changed;
  external JSArray<AuthenticationSession>? get removed;
}

extension type AuthenticationProviderInformation(JSObject _self) implements JSObject {
  external factory AuthenticationProviderInformation.lit$({JSString? id, JSString? label});
  external String get id;
  external String get label;
}

extension type AuthenticationProviderOptions(JSObject _self) implements JSObject {
  external factory AuthenticationProviderOptions.lit$({JSBoolean? supportsMultipleAccounts});
  external bool? get supportsMultipleAccounts;
}

extension type AuthenticationProviderSessionOptions(JSObject _self) implements JSObject {
  external factory AuthenticationProviderSessionOptions.lit$({AuthenticationSessionAccountInformation? account});
  external AuthenticationSessionAccountInformation? get account;
  external set account(AuthenticationSessionAccountInformation? value);
}

extension type AuthenticationSession(JSObject _self) implements JSObject {
  external factory AuthenticationSession.lit$({JSString? accessToken, AuthenticationSessionAccountInformation? account, JSString? id, JSString? idToken, JSArray<JSString>? scopes});
  external String get accessToken;
  external AuthenticationSessionAccountInformation get account;
  external String get id;
  external String? get idToken;
  external JSArray<JSString> get scopes;
}

extension type AuthenticationSessionAccountInformation(JSObject _self) implements JSObject {
  external factory AuthenticationSessionAccountInformation.lit$({JSString? id, JSString? label});
  external String get id;
  external String get label;
}

extension type AuthenticationSessionsChangeEvent(JSObject _self) implements JSObject {
  external factory AuthenticationSessionsChangeEvent.lit$({AuthenticationProviderInformation? provider});
  external AuthenticationProviderInformation get provider;
}

extension type AuthenticationWwwAuthenticateRequest(JSObject _self) implements JSObject {
  external factory AuthenticationWwwAuthenticateRequest.lit$({JSArray<JSString>? fallbackScopes, JSString? wwwAuthenticate});
  external JSArray<JSString>? get fallbackScopes;
  external String get wwwAuthenticate;
}

extension type AutoClosingPair(JSObject _self) implements JSObject {
  external factory AutoClosingPair.lit$({JSString? close, JSArray<JSNumber>? notIn, JSString? open});
  external String get close;
  external set close(String value);
  external JSArray<JSNumber>? get notIn;
  external set notIn(JSArray<JSNumber>? value);
  external String get open;
  external set open(String value);
}

extension type BreakpointsChangeEvent(JSObject _self) implements JSObject {
  external factory BreakpointsChangeEvent.lit$({JSArray<Breakpoint>? added, JSArray<Breakpoint>? changed, JSArray<Breakpoint>? removed});
  external JSArray<Breakpoint> get added;
  external JSArray<Breakpoint> get changed;
  external JSArray<Breakpoint> get removed;
}

extension type CallHierarchyProvider(JSObject _self) implements JSObject {
  external factory CallHierarchyProvider.lit$({JSFunction? prepareCallHierarchy, JSFunction? provideCallHierarchyIncomingCalls, JSFunction? provideCallHierarchyOutgoingCalls});
  external JSAny? prepareCallHierarchy(TextDocument document, Position position, CancellationToken token);
  external JSAny? provideCallHierarchyIncomingCalls(CallHierarchyItem item, CancellationToken token);
  external JSAny? provideCallHierarchyOutgoingCalls(CallHierarchyItem item, CancellationToken token);
}

extension type CancellationToken(JSObject _self) implements JSObject {
  external factory CancellationToken.lit$({JSBoolean? isCancellationRequested, Event<JSAny?>? onCancellationRequested});
  external bool get isCancellationRequested;
  external set isCancellationRequested(bool value);
  external Event<JSAny?> get onCancellationRequested;
}

extension type ChatContext(JSObject _self) implements JSObject {
  external factory ChatContext.lit$({JSArray<JSObject>? history});
  external JSArray<JSObject> get history;
}

extension type ChatErrorDetails(JSObject _self) implements JSObject {
  external factory ChatErrorDetails.lit$({JSString? message, JSBoolean? responseIsFiltered});
  external String get message;
  external set message(String value);
  external bool? get responseIsFiltered;
  external set responseIsFiltered(bool? value);
}

extension type ChatFollowup(JSObject _self) implements JSObject {
  external factory ChatFollowup.lit$({JSString? command, JSString? label, JSString? participant, JSString? prompt});
  external String? get command;
  external set command(String? value);
  external String? get label;
  external set label(String? value);
  external String? get participant;
  external set participant(String? value);
  external String get prompt;
  external set prompt(String value);
}

extension type ChatFollowupProvider(JSObject _self) implements JSObject {
  external factory ChatFollowupProvider.lit$({JSFunction? provideFollowups});
  external JSAny? provideFollowups(ChatResult result, ChatContext context, CancellationToken token);
}

extension type ChatLanguageModelToolReference(JSObject _self) implements JSObject {
  external factory ChatLanguageModelToolReference.lit$({JSString? name, JSTuple_9b5999d5c048? range});
  external String get name;
  external JSTuple_9b5999d5c048? get range;
}

extension type ChatParticipant(JSObject _self) implements JSObject {
  external factory ChatParticipant.lit$({JSFunction? dispose, ChatFollowupProvider? followupProvider, JSObject? iconPath, JSString? id, Event<ChatResultFeedback>? onDidReceiveFeedback, JSFunction? requestHandler});
  external void dispose();
  external ChatFollowupProvider? get followupProvider;
  external set followupProvider(ChatFollowupProvider? value);
  external JSObject? get iconPath;
  external set iconPath(JSObject? value);
  external String get id;
  external Event<ChatResultFeedback> get onDidReceiveFeedback;
  external JSFunction get requestHandler;
  external set requestHandler(JSFunction value);
}

extension type ChatPromptReference(JSObject _self) implements JSObject {
  external factory ChatPromptReference.lit$({JSString? id, JSString? modelDescription, JSTuple_9b5999d5c048? range, JSAny? value});
  external String get id;
  external String? get modelDescription;
  external JSTuple_9b5999d5c048? get range;
  external JSAny get value;
}

extension type ChatRequest(JSObject _self) implements JSObject {
  external factory ChatRequest.lit$({JSString? command, LanguageModelChat? model, JSString? prompt, JSArray<ChatPromptReference>? references, JSAny? toolInvocationToken, JSArray<ChatLanguageModelToolReference>? toolReferences});
  external String? get command;
  external LanguageModelChat get model;
  external String get prompt;
  external JSArray<ChatPromptReference> get references;
  external JSAny? get toolInvocationToken;
  external JSArray<ChatLanguageModelToolReference> get toolReferences;
}

extension type ChatResponseFileTree(JSObject _self) implements JSObject {
  external factory ChatResponseFileTree.lit$({JSArray<ChatResponseFileTree>? children, JSString? name});
  external JSArray<ChatResponseFileTree>? get children;
  external set children(JSArray<ChatResponseFileTree>? value);
  external String get name;
  external set name(String value);
}

extension type ChatResponseStream(JSObject _self) implements JSObject {
  external factory ChatResponseStream.lit$({JSFunction? anchor, JSFunction? button, JSFunction? filetree, JSFunction? markdown, JSFunction? progress, JSFunction? push, JSFunction? reference});
  external void anchor(JSObject value, [String? title]);
  external void button(Command command);
  external void filetree(JSArray<ChatResponseFileTree> value, Uri baseUri);
  external void markdown(JSAny value);
  external void progress(String value);
  external void push(JSObject part);
  external void reference(JSObject value, [JSObject? iconPath]);
}

extension type ChatResult(JSObject _self) implements JSObject {
  external factory ChatResult.lit$({ChatErrorDetails? errorDetails, JSAnon_cd1da709a211? metadata});
  external ChatErrorDetails? get errorDetails;
  external set errorDetails(ChatErrorDetails? value);
  external JSAnon_cd1da709a211? get metadata;
}

extension type ChatResultFeedback(JSObject _self) implements JSObject {
  external factory ChatResultFeedback.lit$({JSNumber? kind, ChatResult? result});
  external int get kind;
  external ChatResult get result;
}

extension type Clipboard(JSObject _self) implements JSObject {
  external factory Clipboard.lit$({JSFunction? readText, JSFunction? writeText});
  external JSPromise<JSString> readText();
  external JSPromise<JSAny?> writeText(String value);
}

extension type CodeActionContext(JSObject _self) implements JSObject {
  external factory CodeActionContext.lit$({JSArray<Diagnostic>? diagnostics, CodeActionKind? only, JSNumber? triggerKind});
  external JSArray<Diagnostic> get diagnostics;
  external CodeActionKind? get only;
  external int get triggerKind;
}

extension type CodeActionProvider<T extends JSAny?>(JSObject _self) implements JSObject {
  external factory CodeActionProvider.lit$({JSFunction? provideCodeActions, JSFunction? resolveCodeAction});
  external JSAny? provideCodeActions(TextDocument document, JSObject range, CodeActionContext context, CancellationToken token);
  external JSAny? resolveCodeAction(T codeAction, CancellationToken token);
}

extension type CodeActionProviderMetadata(JSObject _self) implements JSObject {
  external factory CodeActionProviderMetadata.lit$({JSArray<JSAnon_f698f56281f5>? documentation, JSArray<CodeActionKind>? providedCodeActionKinds});
  external JSArray<JSAnon_f698f56281f5>? get documentation;
  external JSArray<CodeActionKind>? get providedCodeActionKinds;
}

extension type CodeLensProvider<T extends JSAny?>(JSObject _self) implements JSObject {
  external factory CodeLensProvider.lit$({Event<JSAny?>? onDidChangeCodeLenses, JSFunction? provideCodeLenses, JSFunction? resolveCodeLens});
  external Event<JSAny?>? get onDidChangeCodeLenses;
  external set onDidChangeCodeLenses(Event<JSAny?>? value);
  external JSAny? provideCodeLenses(TextDocument document, CancellationToken token);
  external JSAny? resolveCodeLens(T codeLens, CancellationToken token);
}

extension type ColorTheme(JSObject _self) implements JSObject {
  external factory ColorTheme.lit$({JSNumber? kind});
  external int get kind;
}

extension type Command(JSObject _self) implements JSObject {
  external factory Command.lit$({JSArray<JSAny?>? arguments, JSString? command, JSString? title, JSString? tooltip});
  external JSArray<JSAny?>? get arguments;
  external set arguments(JSArray<JSAny?>? value);
  external String get command;
  external set command(String value);
  external String get title;
  external set title(String value);
  external String? get tooltip;
  external set tooltip(String? value);
}

extension type Comment(JSObject _self) implements JSObject {
  external factory Comment.lit$({CommentAuthorInformation? author, JSAny? body, JSString? contextValue, JSString? label, JSNumber? mode, JSArray<CommentReaction>? reactions, JSObject? timestamp});
  external CommentAuthorInformation get author;
  external set author(CommentAuthorInformation value);
  external JSAny get body;
  external set body(JSAny value);
  external String? get contextValue;
  external set contextValue(String? value);
  external String? get label;
  external set label(String? value);
  external int get mode;
  external set mode(int value);
  external JSArray<CommentReaction>? get reactions;
  external set reactions(JSArray<CommentReaction>? value);
  external JSObject? get timestamp;
  external set timestamp(JSObject? value);
}

extension type CommentAuthorInformation(JSObject _self) implements JSObject {
  external factory CommentAuthorInformation.lit$({Uri? iconPath, JSString? name});
  external Uri? get iconPath;
  external set iconPath(Uri? value);
  external String get name;
  external set name(String value);
}

extension type CommentController(JSObject _self) implements JSObject {
  external factory CommentController.lit$({CommentingRangeProvider? commentingRangeProvider, JSFunction? createCommentThread, JSFunction? dispose, JSString? id, JSString? label, CommentOptions? options, JSFunction? reactionHandler});
  external CommentingRangeProvider? get commentingRangeProvider;
  external set commentingRangeProvider(CommentingRangeProvider? value);
  external CommentThread createCommentThread(Uri uri, Range range, JSArray<Comment> comments);
  external void dispose();
  external String get id;
  external String get label;
  external CommentOptions? get options;
  external set options(CommentOptions? value);
  external JSFunction? get reactionHandler;
  external set reactionHandler(JSFunction? value);
}

extension type CommentOptions(JSObject _self) implements JSObject {
  external factory CommentOptions.lit$({JSString? placeHolder, JSString? prompt});
  external String? get placeHolder;
  external set placeHolder(String? value);
  external String? get prompt;
  external set prompt(String? value);
}

extension type CommentReaction(JSObject _self) implements JSObject {
  external factory CommentReaction.lit$({JSBoolean? authorHasReacted, JSNumber? count, JSAny? iconPath, JSString? label});
  external bool get authorHasReacted;
  external num get count;
  external JSAny get iconPath;
  external String get label;
}

extension type CommentReply(JSObject _self) implements JSObject {
  external factory CommentReply.lit$({JSString? text, CommentThread? thread});
  external String get text;
  external set text(String value);
  external CommentThread get thread;
  external set thread(CommentThread value);
}

extension type CommentRule(JSObject _self) implements JSObject {
  external factory CommentRule.lit$({JSTuple_58c6c79a4e36? blockComment, JSAny? lineComment});
  external JSTuple_58c6c79a4e36? get blockComment;
  external set blockComment(JSTuple_58c6c79a4e36? value);
  external JSAny? get lineComment;
  external set lineComment(JSAny? value);
}

extension type CommentThread(JSObject _self) implements JSObject {
  external factory CommentThread.lit$({JSAny? canReply, JSNumber? collapsibleState, JSArray<Comment>? comments, JSString? contextValue, JSFunction? dispose, JSString? label, Range? range, JSNumber? state, Uri? uri});
  external JSAny get canReply;
  external set canReply(JSAny value);
  external int get collapsibleState;
  external set collapsibleState(int value);
  external JSArray<Comment> get comments;
  external set comments(JSArray<Comment> value);
  external String? get contextValue;
  external set contextValue(String? value);
  external void dispose();
  external String? get label;
  external set label(String? value);
  external Range? get range;
  external set range(Range? value);
  external int? get state;
  external set state(int? value);
  external Uri get uri;
}

extension type CommentingRangeProvider(JSObject _self) implements JSObject {
  external factory CommentingRangeProvider.lit$({JSFunction? provideCommentingRanges});
  external JSAny? provideCommentingRanges(TextDocument document, CancellationToken token);
}

extension type CommentingRanges(JSObject _self) implements JSObject {
  external factory CommentingRanges.lit$({JSBoolean? enableFileComments, JSArray<Range>? ranges});
  external bool get enableFileComments;
  external set enableFileComments(bool value);
  external JSArray<Range>? get ranges;
  external set ranges(JSArray<Range>? value);
}

extension type CompletionContext(JSObject _self) implements JSObject {
  external factory CompletionContext.lit$({JSString? triggerCharacter, JSNumber? triggerKind});
  external String? get triggerCharacter;
  external int get triggerKind;
}

extension type CompletionItemLabel(JSObject _self) implements JSObject {
  external factory CompletionItemLabel.lit$({JSString? description, JSString? detail, JSString? label});
  external String? get description;
  external set description(String? value);
  external String? get detail;
  external set detail(String? value);
  external String get label;
  external set label(String value);
}

extension type CompletionItemProvider<T extends JSAny?>(JSObject _self) implements JSObject {
  external factory CompletionItemProvider.lit$({JSFunction? provideCompletionItems, JSFunction? resolveCompletionItem});
  external JSAny? provideCompletionItems(TextDocument document, Position position, CancellationToken token, CompletionContext context);
  external JSAny? resolveCompletionItem(T item, CancellationToken token);
}

extension type ConfigurationChangeEvent(JSObject _self) implements JSObject {
  external factory ConfigurationChangeEvent.lit$({JSFunction? affectsConfiguration});
  external bool affectsConfiguration(String section, [JSObject? scope]);
}

extension type CustomDocument(JSObject _self) implements JSObject {
  external factory CustomDocument.lit$({JSFunction? dispose, Uri? uri});
  external void dispose();
  external Uri get uri;
}

extension type CustomDocumentBackup(JSObject _self) implements JSObject {
  external factory CustomDocumentBackup.lit$({JSFunction? delete, JSString? id});
  external void delete();
  external String get id;
}

extension type CustomDocumentBackupContext(JSObject _self) implements JSObject {
  external factory CustomDocumentBackupContext.lit$({Uri? destination});
  external Uri get destination;
}

extension type CustomDocumentContentChangeEvent<T extends JSAny?>(JSObject _self) implements JSObject {
  external factory CustomDocumentContentChangeEvent.lit$({T? document});
  external T get document;
}

extension type CustomDocumentEditEvent<T extends JSAny?>(JSObject _self) implements JSObject {
  external factory CustomDocumentEditEvent.lit$({T? document, JSString? label, JSFunction? redo, JSFunction? undo});
  external T get document;
  external String? get label;
  external JSAny redo();
  external JSAny undo();
}

extension type CustomDocumentOpenContext(JSObject _self) implements JSObject {
  external factory CustomDocumentOpenContext.lit$({JSString? backupId, JSUint8Array? untitledDocumentData});
  external String? get backupId;
  external JSUint8Array? get untitledDocumentData;
}

extension type CustomEditorProvider<T extends JSAny?>(JSObject _self) implements CustomReadonlyEditorProvider<T>, JSObject {
  external factory CustomEditorProvider.lit$({JSFunction? backupCustomDocument, JSObject? onDidChangeCustomDocument, JSFunction? revertCustomDocument, JSFunction? saveCustomDocument, JSFunction? saveCustomDocumentAs});
  external JSPromise<CustomDocumentBackup> backupCustomDocument(T document, CustomDocumentBackupContext context, CancellationToken cancellation);
  external JSObject get onDidChangeCustomDocument;
  external JSPromise<JSAny?> revertCustomDocument(T document, CancellationToken cancellation);
  external JSPromise<JSAny?> saveCustomDocument(T document, CancellationToken cancellation);
  external JSPromise<JSAny?> saveCustomDocumentAs(T document, Uri destination, CancellationToken cancellation);
}

extension type CustomReadonlyEditorProvider<T extends JSAny?>(JSObject _self) implements JSObject {
  external factory CustomReadonlyEditorProvider.lit$({JSFunction? openCustomDocument, JSFunction? resolveCustomEditor});
  external JSAny openCustomDocument(Uri uri, CustomDocumentOpenContext openContext, CancellationToken token);
  external JSAny resolveCustomEditor(T document, WebviewPanel webviewPanel, CancellationToken token);
}

extension type CustomTextEditorProvider(JSObject _self) implements JSObject {
  external factory CustomTextEditorProvider.lit$({JSFunction? resolveCustomTextEditor});
  external JSAny resolveCustomTextEditor(TextDocument document, WebviewPanel webviewPanel, CancellationToken token);
}

extension type DataTransferFile(JSObject _self) implements JSObject {
  external factory DataTransferFile.lit$({JSFunction? data, JSString? name, Uri? uri});
  external JSPromise<JSUint8Array> data();
  external String get name;
  external Uri? get uri;
}

extension type DebugAdapter(JSObject _self) implements Disposable, JSObject {
  external factory DebugAdapter.lit$({JSFunction? handleMessage, Event<DebugProtocolMessage>? onDidSendMessage});
  external void handleMessage(DebugProtocolMessage message);
  external Event<DebugProtocolMessage> get onDidSendMessage;
}

extension type DebugAdapterDescriptorFactory(JSObject _self) implements JSObject {
  external factory DebugAdapterDescriptorFactory.lit$({JSFunction? createDebugAdapterDescriptor});
  external JSAny? createDebugAdapterDescriptor(DebugSession session, DebugAdapterExecutable? executable);
}

extension type DebugAdapterExecutableOptions(JSObject _self) implements JSObject {
  external factory DebugAdapterExecutableOptions.lit$({JSString? cwd, JSAnon_c77c8585355a? env});
  external String? get cwd;
  external set cwd(String? value);
  external JSAnon_c77c8585355a? get env;
  external set env(JSAnon_c77c8585355a? value);
}

extension type DebugAdapterTracker(JSObject _self) implements JSObject {
  external factory DebugAdapterTracker.lit$({JSFunction? onDidSendMessage, JSFunction? onError, JSFunction? onExit, JSFunction? onWillReceiveMessage, JSFunction? onWillStartSession, JSFunction? onWillStopSession});
  external void onDidSendMessage(JSAny? message);
  external void onError(JSObject error);
  external void onExit(num? code, String? signal);
  external void onWillReceiveMessage(JSAny? message);
  external void onWillStartSession();
  external void onWillStopSession();
}

extension type DebugAdapterTrackerFactory(JSObject _self) implements JSObject {
  external factory DebugAdapterTrackerFactory.lit$({JSFunction? createDebugAdapterTracker});
  external JSAny? createDebugAdapterTracker(DebugSession session);
}

extension type DebugConfiguration(JSObject _self) implements JSObject {
  external factory DebugConfiguration.lit$({JSString? name, JSString? request, JSString? type});
  external JSAny? operator [](String key);
  external void operator []=(String key, JSAny? value);
  external String get name;
  external set name(String value);
  external String get request;
  external set request(String value);
  external String get type;
  external set type(String value);
}

extension type DebugConfigurationProvider(JSObject _self) implements JSObject {
  external factory DebugConfigurationProvider.lit$({JSFunction? provideDebugConfigurations, JSFunction? resolveDebugConfiguration, JSFunction? resolveDebugConfigurationWithSubstitutedVariables});
  external JSAny? provideDebugConfigurations(WorkspaceFolder? folder, [CancellationToken? token]);
  external JSAny? resolveDebugConfiguration(WorkspaceFolder? folder, DebugConfiguration debugConfiguration, [CancellationToken? token]);
  external JSAny? resolveDebugConfigurationWithSubstitutedVariables(WorkspaceFolder? folder, DebugConfiguration debugConfiguration, [CancellationToken? token]);
}

extension type DebugConsole(JSObject _self) implements JSObject {
  external factory DebugConsole.lit$({JSFunction? append, JSFunction? appendLine});
  external void append(String value);
  external void appendLine(String value);
}

extension type DebugProtocolBreakpoint(JSObject _self) implements JSObject {
}

extension type DebugProtocolMessage(JSObject _self) implements JSObject {
}

extension type DebugProtocolSource(JSObject _self) implements JSObject {
}

extension type DebugSession(JSObject _self) implements JSObject {
  external factory DebugSession.lit$({DebugConfiguration? configuration, JSFunction? customRequest, JSFunction? getDebugProtocolBreakpoint, JSString? id, JSString? name, DebugSession? parentSession, JSString? type, WorkspaceFolder? workspaceFolder});
  external DebugConfiguration get configuration;
  external JSPromise<JSAny?> customRequest(String command, [JSAny? args]);
  external JSPromise<DebugProtocolBreakpoint?> getDebugProtocolBreakpoint(Breakpoint breakpoint);
  external String get id;
  external String get name;
  external set name(String value);
  external DebugSession? get parentSession;
  external String get type;
  external WorkspaceFolder? get workspaceFolder;
}

extension type DebugSessionCustomEvent(JSObject _self) implements JSObject {
  external factory DebugSessionCustomEvent.lit$({JSAny? body, JSString? event, DebugSession? session});
  external JSAny? get body;
  external String get event;
  external DebugSession get session;
}

extension type DebugSessionOptions(JSObject _self) implements JSObject {
  external factory DebugSessionOptions.lit$({JSBoolean? compact, JSNumber? consoleMode, JSBoolean? lifecycleManagedByParent, JSBoolean? noDebug, DebugSession? parentSession, JSBoolean? suppressDebugStatusbar, JSBoolean? suppressDebugToolbar, JSBoolean? suppressDebugView, JSBoolean? suppressSaveBeforeStart, TestRun? testRun});
  external bool? get compact;
  external set compact(bool? value);
  external int? get consoleMode;
  external set consoleMode(int? value);
  external bool? get lifecycleManagedByParent;
  external set lifecycleManagedByParent(bool? value);
  external bool? get noDebug;
  external set noDebug(bool? value);
  external DebugSession? get parentSession;
  external set parentSession(DebugSession? value);
  external bool? get suppressDebugStatusbar;
  external set suppressDebugStatusbar(bool? value);
  external bool? get suppressDebugToolbar;
  external set suppressDebugToolbar(bool? value);
  external bool? get suppressDebugView;
  external set suppressDebugView(bool? value);
  external bool? get suppressSaveBeforeStart;
  external set suppressSaveBeforeStart(bool? value);
  external TestRun? get testRun;
  external set testRun(TestRun? value);
}

extension type DeclarationProvider(JSObject _self) implements JSObject {
  external factory DeclarationProvider.lit$({JSFunction? provideDeclaration});
  external JSAny? provideDeclaration(TextDocument document, Position position, CancellationToken token);
}

extension type DecorationInstanceRenderOptions(JSObject _self) implements ThemableDecorationInstanceRenderOptions, JSObject {
  external factory DecorationInstanceRenderOptions.lit$({ThemableDecorationInstanceRenderOptions? dark, ThemableDecorationInstanceRenderOptions? light});
  external ThemableDecorationInstanceRenderOptions? get dark;
  external set dark(ThemableDecorationInstanceRenderOptions? value);
  external ThemableDecorationInstanceRenderOptions? get light;
  external set light(ThemableDecorationInstanceRenderOptions? value);
}

extension type DecorationOptions(JSObject _self) implements JSObject {
  external factory DecorationOptions.lit$({JSAny? hoverMessage, Range? range, DecorationInstanceRenderOptions? renderOptions});
  external JSAny? get hoverMessage;
  external set hoverMessage(JSAny? value);
  external Range get range;
  external set range(Range value);
  external DecorationInstanceRenderOptions? get renderOptions;
  external set renderOptions(DecorationInstanceRenderOptions? value);
}

extension type DecorationRenderOptions(JSObject _self) implements ThemableDecorationRenderOptions, JSObject {
  external factory DecorationRenderOptions.lit$({ThemableDecorationRenderOptions? dark, JSBoolean? isWholeLine, ThemableDecorationRenderOptions? light, JSNumber? overviewRulerLane, JSNumber? rangeBehavior});
  external ThemableDecorationRenderOptions? get dark;
  external set dark(ThemableDecorationRenderOptions? value);
  external bool? get isWholeLine;
  external set isWholeLine(bool? value);
  external ThemableDecorationRenderOptions? get light;
  external set light(ThemableDecorationRenderOptions? value);
  external int? get overviewRulerLane;
  external set overviewRulerLane(int? value);
  external int? get rangeBehavior;
  external set rangeBehavior(int? value);
}

extension type DefinitionProvider(JSObject _self) implements JSObject {
  external factory DefinitionProvider.lit$({JSFunction? provideDefinition});
  external JSAny? provideDefinition(TextDocument document, Position position, CancellationToken token);
}

extension type DiagnosticChangeEvent(JSObject _self) implements JSObject {
  external factory DiagnosticChangeEvent.lit$({JSArray<Uri>? uris});
  external JSArray<Uri> get uris;
}

extension type DiagnosticCollection(JSObject _self) implements JSObject {
  external factory DiagnosticCollection.lit$({JSFunction? clear, JSFunction? delete, JSFunction? dispose, JSFunction? forEach, JSFunction? get, JSFunction? has, JSString? name, JSFunction? set});
  external void clear();
  external void delete(Uri uri);
  external void dispose();
  external void forEach(JSFunction callback, [JSAny? thisArg]);
  external JSArray<Diagnostic>? get(Uri uri);
  external bool has(Uri uri);
  external String get name;
  external void set(Uri uri, JSArray<Diagnostic>? diagnostics);
  @JS('set')
  external void set$2(JSArray<JSTuple_25eb84db6d3d> entries);
}

extension type DocumentColorProvider(JSObject _self) implements JSObject {
  external factory DocumentColorProvider.lit$({JSFunction? provideColorPresentations, JSFunction? provideDocumentColors});
  external JSAny? provideColorPresentations(Color color, JSAnon_e0c29a989921 context, CancellationToken token);
  external JSAny? provideDocumentColors(TextDocument document, CancellationToken token);
}

extension type DocumentDropEditProvider<T extends JSAny?>(JSObject _self) implements JSObject {
  external factory DocumentDropEditProvider.lit$({JSFunction? provideDocumentDropEdits, JSFunction? resolveDocumentDropEdit});
  external JSAny? provideDocumentDropEdits(TextDocument document, Position position, DataTransfer dataTransfer, CancellationToken token);
  external JSAny? resolveDocumentDropEdit(T edit, CancellationToken token);
}

extension type DocumentDropEditProviderMetadata(JSObject _self) implements JSObject {
  external factory DocumentDropEditProviderMetadata.lit$({JSArray<JSString>? dropMimeTypes, JSArray<DocumentDropOrPasteEditKind>? providedDropEditKinds});
  external JSArray<JSString> get dropMimeTypes;
  external JSArray<DocumentDropOrPasteEditKind>? get providedDropEditKinds;
}

extension type DocumentFilter(JSObject _self) implements JSObject {
  external factory DocumentFilter.lit$({JSString? language, JSString? notebookType, JSAny? pattern, JSString? scheme});
  external String? get language;
  external String? get notebookType;
  external JSAny? get pattern;
  external String? get scheme;
}

extension type DocumentFormattingEditProvider(JSObject _self) implements JSObject {
  external factory DocumentFormattingEditProvider.lit$({JSFunction? provideDocumentFormattingEdits});
  external JSAny? provideDocumentFormattingEdits(TextDocument document, FormattingOptions options, CancellationToken token);
}

extension type DocumentHighlightProvider(JSObject _self) implements JSObject {
  external factory DocumentHighlightProvider.lit$({JSFunction? provideDocumentHighlights});
  external JSAny? provideDocumentHighlights(TextDocument document, Position position, CancellationToken token);
}

extension type DocumentLinkProvider<T extends JSAny?>(JSObject _self) implements JSObject {
  external factory DocumentLinkProvider.lit$({JSFunction? provideDocumentLinks, JSFunction? resolveDocumentLink});
  external JSAny? provideDocumentLinks(TextDocument document, CancellationToken token);
  external JSAny? resolveDocumentLink(T link, CancellationToken token);
}

extension type DocumentPasteEditContext(JSObject _self) implements JSObject {
  external factory DocumentPasteEditContext.lit$({DocumentDropOrPasteEditKind? only, JSNumber? triggerKind});
  external DocumentDropOrPasteEditKind? get only;
  external int get triggerKind;
}

extension type DocumentPasteEditProvider<T extends JSAny?>(JSObject _self) implements JSObject {
  external factory DocumentPasteEditProvider.lit$({JSFunction? prepareDocumentPaste, JSFunction? provideDocumentPasteEdits, JSFunction? resolveDocumentPasteEdit});
  external JSAny prepareDocumentPaste(TextDocument document, JSArray<Range> ranges, DataTransfer dataTransfer, CancellationToken token);
  external JSAny? provideDocumentPasteEdits(TextDocument document, JSArray<Range> ranges, DataTransfer dataTransfer, DocumentPasteEditContext context, CancellationToken token);
  external JSAny? resolveDocumentPasteEdit(T pasteEdit, CancellationToken token);
}

extension type DocumentPasteProviderMetadata(JSObject _self) implements JSObject {
  external factory DocumentPasteProviderMetadata.lit$({JSArray<JSString>? copyMimeTypes, JSArray<JSString>? pasteMimeTypes, JSArray<DocumentDropOrPasteEditKind>? providedPasteEditKinds});
  external JSArray<JSString>? get copyMimeTypes;
  external JSArray<JSString>? get pasteMimeTypes;
  external JSArray<DocumentDropOrPasteEditKind> get providedPasteEditKinds;
}

extension type DocumentRangeFormattingEditProvider(JSObject _self) implements JSObject {
  external factory DocumentRangeFormattingEditProvider.lit$({JSFunction? provideDocumentRangeFormattingEdits, JSFunction? provideDocumentRangesFormattingEdits});
  external JSAny? provideDocumentRangeFormattingEdits(TextDocument document, Range range, FormattingOptions options, CancellationToken token);
  external JSAny? provideDocumentRangesFormattingEdits(TextDocument document, JSArray<Range> ranges, FormattingOptions options, CancellationToken token);
}

extension type DocumentRangeSemanticTokensProvider(JSObject _self) implements JSObject {
  external factory DocumentRangeSemanticTokensProvider.lit$({Event<JSAny?>? onDidChangeSemanticTokens, JSFunction? provideDocumentRangeSemanticTokens});
  external Event<JSAny?>? get onDidChangeSemanticTokens;
  external set onDidChangeSemanticTokens(Event<JSAny?>? value);
  external JSAny? provideDocumentRangeSemanticTokens(TextDocument document, Range range, CancellationToken token);
}

extension type DocumentSemanticTokensProvider(JSObject _self) implements JSObject {
  external factory DocumentSemanticTokensProvider.lit$({Event<JSAny?>? onDidChangeSemanticTokens, JSFunction? provideDocumentSemanticTokens, JSFunction? provideDocumentSemanticTokensEdits});
  external Event<JSAny?>? get onDidChangeSemanticTokens;
  external set onDidChangeSemanticTokens(Event<JSAny?>? value);
  external JSAny? provideDocumentSemanticTokens(TextDocument document, CancellationToken token);
  external JSAny? provideDocumentSemanticTokensEdits(TextDocument document, String previousResultId, CancellationToken token);
}

extension type DocumentSymbolProvider(JSObject _self) implements JSObject {
  external factory DocumentSymbolProvider.lit$({JSFunction? provideDocumentSymbols});
  external JSAny? provideDocumentSymbols(TextDocument document, CancellationToken token);
}

extension type DocumentSymbolProviderMetadata(JSObject _self) implements JSObject {
  external factory DocumentSymbolProviderMetadata.lit$({JSString? label});
  external String? get label;
  external set label(String? value);
}

extension type EnterAction(JSObject _self) implements JSObject {
  external factory EnterAction.lit$({JSString? appendText, JSNumber? indentAction, JSNumber? removeText});
  external String? get appendText;
  external set appendText(String? value);
  external int get indentAction;
  external set indentAction(int value);
  external num? get removeText;
  external set removeText(num? value);
}

extension type EnvironmentVariableCollection(JSObject _self) implements JSObject {
  external factory EnvironmentVariableCollection.lit$({JSFunction? append, JSFunction? clear, JSFunction? delete, JSAny? description, JSFunction? forEach, JSFunction? get, JSBoolean? persistent, JSFunction? prepend, JSFunction? replace});
  external void append(String variable, String value, [EnvironmentVariableMutatorOptions? options]);
  external void clear();
  external void delete(String variable);
  external JSAny? get description;
  external set description(JSAny? value);
  external void forEach(JSFunction callback, [JSAny? thisArg]);
  external EnvironmentVariableMutator? get(String variable);
  external bool get persistent;
  external set persistent(bool value);
  external void prepend(String variable, String value, [EnvironmentVariableMutatorOptions? options]);
  external void replace(String variable, String value, [EnvironmentVariableMutatorOptions? options]);
}

extension type EnvironmentVariableMutator(JSObject _self) implements JSObject {
  external factory EnvironmentVariableMutator.lit$({EnvironmentVariableMutatorOptions? options, JSNumber? type, JSString? value});
  external EnvironmentVariableMutatorOptions get options;
  external int get type;
  external String get value;
}

extension type EnvironmentVariableMutatorOptions(JSObject _self) implements JSObject {
  external factory EnvironmentVariableMutatorOptions.lit$({JSBoolean? applyAtProcessCreation, JSBoolean? applyAtShellIntegration});
  external bool? get applyAtProcessCreation;
  external set applyAtProcessCreation(bool? value);
  external bool? get applyAtShellIntegration;
  external set applyAtShellIntegration(bool? value);
}

extension type EnvironmentVariableScope(JSObject _self) implements JSObject {
  external factory EnvironmentVariableScope.lit$({WorkspaceFolder? workspaceFolder});
  external WorkspaceFolder? get workspaceFolder;
  external set workspaceFolder(WorkspaceFolder? value);
}

extension type EvaluatableExpressionProvider(JSObject _self) implements JSObject {
  external factory EvaluatableExpressionProvider.lit$({JSFunction? provideEvaluatableExpression});
  external JSAny? provideEvaluatableExpression(TextDocument document, Position position, CancellationToken token);
}

extension type Event<T extends JSAny?>(JSFunction _self) implements JSObject {
  Disposable call(JSFunction listener, [JSAny? thisArgs, JSArray<Disposable>? disposables]) {
    final args$ = <JSAny?>[listener, thisArgs, disposables];
    final args$Count = _trimTrailingNulls(args$, 1);
    return _self.callAsFunction(null, args$Count > 0 ? args$[0] : null, args$Count > 1 ? args$[1] : null, args$Count > 2 ? args$[2] : null) as Disposable;
  }
}

extension type Extension<T extends JSAny?>(JSObject _self) implements JSObject {
  external factory Extension.lit$({JSFunction? activate, T? exports, JSNumber? extensionKind, JSString? extensionPath, Uri? extensionUri, JSString? id, JSBoolean? isActive, JSAny? packageJSON});
  external JSPromise<T> activate();
  external T get exports;
  external int get extensionKind;
  external set extensionKind(int value);
  external String get extensionPath;
  external Uri get extensionUri;
  external String get id;
  external bool get isActive;
  external JSAny? get packageJSON;
}

extension type ExtensionContext(JSObject _self) implements JSObject {
  external factory ExtensionContext.lit$({JSFunction? asAbsolutePath, GlobalEnvironmentVariableCollection? environmentVariableCollection, Extension<JSAny?>? extension, JSNumber? extensionMode, JSString? extensionPath, Uri? extensionUri, JSIntersection_c8c004dd0b99? globalState, JSString? globalStoragePath, Uri? globalStorageUri, LanguageModelAccessInformation? languageModelAccessInformation, JSString? logPath, Uri? logUri, SecretStorage? secrets, JSString? storagePath, Uri? storageUri, JSArray<JSAnon_ffa2e03c40a2>? subscriptions, Memento? workspaceState});
  external String asAbsolutePath(String relativePath);
  external GlobalEnvironmentVariableCollection get environmentVariableCollection;
  external Extension<JSAny?> get extension;
  external int get extensionMode;
  external String get extensionPath;
  external Uri get extensionUri;
  external JSIntersection_c8c004dd0b99 get globalState;
  external String get globalStoragePath;
  external Uri get globalStorageUri;
  external LanguageModelAccessInformation get languageModelAccessInformation;
  external String get logPath;
  external Uri get logUri;
  external SecretStorage get secrets;
  external String? get storagePath;
  external Uri? get storageUri;
  external JSArray<JSAnon_ffa2e03c40a2> get subscriptions;
  external Memento get workspaceState;
}

extension type ExtensionTerminalOptions(JSObject _self) implements JSObject {
  external factory ExtensionTerminalOptions.lit$({ThemeColor? color, JSObject? iconPath, JSBoolean? isTransient, JSAny? location, JSString? name, Pseudoterminal? pty, JSString? shellIntegrationNonce});
  external ThemeColor? get color;
  external set color(ThemeColor? value);
  external JSObject? get iconPath;
  external set iconPath(JSObject? value);
  external bool? get isTransient;
  external set isTransient(bool? value);
  external JSAny? get location;
  external set location(JSAny? value);
  external String get name;
  external set name(String value);
  external Pseudoterminal get pty;
  external set pty(Pseudoterminal value);
  external String? get shellIntegrationNonce;
  external set shellIntegrationNonce(String? value);
}

extension type FileChangeEvent(JSObject _self) implements JSObject {
  external factory FileChangeEvent.lit$({JSNumber? type, Uri? uri});
  external int get type;
  external Uri get uri;
}

extension type FileCreateEvent(JSObject _self) implements JSObject {
  external factory FileCreateEvent.lit$({JSArray<Uri>? files});
  external JSArray<Uri> get files;
}

extension type FileDecorationProvider(JSObject _self) implements JSObject {
  external factory FileDecorationProvider.lit$({Event<JSObject?>? onDidChangeFileDecorations, JSFunction? provideFileDecoration});
  external Event<JSObject?>? get onDidChangeFileDecorations;
  external set onDidChangeFileDecorations(Event<JSObject?>? value);
  external JSAny? provideFileDecoration(Uri uri, CancellationToken token);
}

extension type FileDeleteEvent(JSObject _self) implements JSObject {
  external factory FileDeleteEvent.lit$({JSArray<Uri>? files});
  external JSArray<Uri> get files;
}

extension type FileRenameEvent(JSObject _self) implements JSObject {
  external factory FileRenameEvent.lit$({JSArray<JSAnon_7c30c4713d83>? files});
  external JSArray<JSAnon_7c30c4713d83> get files;
}

extension type FileStat(JSObject _self) implements JSObject {
  external factory FileStat.lit$({JSNumber? ctime, JSNumber? mtime, JSNumber? permissions, JSNumber? size, JSNumber? type});
  external num get ctime;
  external set ctime(num value);
  external num get mtime;
  external set mtime(num value);
  external int? get permissions;
  external set permissions(int? value);
  external num get size;
  external set size(num value);
  external int get type;
  external set type(int value);
}

extension type FileSystem(JSObject _self) implements JSObject {
  external factory FileSystem.lit$({JSFunction? copy, JSFunction? createDirectory, JSFunction? delete, JSFunction? isWritableFileSystem, JSFunction? readDirectory, JSFunction? readFile, JSFunction? rename, JSFunction? stat, JSFunction? writeFile});
  external JSPromise<JSAny?> copy(Uri source, Uri target, [JSAnon_b2623fd46fde? options]);
  external JSPromise<JSAny?> createDirectory(Uri uri);
  external JSPromise<JSAny?> delete(Uri uri, [JSAnon_576b1a88ebc3? options]);
  external bool? isWritableFileSystem(String scheme);
  external JSPromise<JSArray<JSTuple_171b5687ecdc>> readDirectory(Uri uri);
  external JSPromise<JSUint8Array> readFile(Uri uri);
  external JSPromise<JSAny?> rename(Uri source, Uri target, [JSAnon_b2623fd46fde? options]);
  external JSPromise<FileStat> stat(Uri uri);
  external JSPromise<JSAny?> writeFile(Uri uri, JSUint8Array content);
}

extension type FileSystemProvider(JSObject _self) implements JSObject {
  external factory FileSystemProvider.lit$({JSFunction? copy, JSFunction? createDirectory, JSFunction? delete, Event<JSArray<FileChangeEvent>>? onDidChangeFile, JSFunction? readDirectory, JSFunction? readFile, JSFunction? rename, JSFunction? stat, JSFunction? watch, JSFunction? writeFile});
  external JSAny copy(Uri source, Uri destination, JSAnon_f4ceea3f5f6f options);
  external JSAny createDirectory(Uri uri);
  external JSAny delete(Uri uri, JSAnon_4ae6d0aa1bdf options);
  external Event<JSArray<FileChangeEvent>> get onDidChangeFile;
  external JSObject readDirectory(Uri uri);
  external JSObject readFile(Uri uri);
  external JSAny rename(Uri oldUri, Uri newUri, JSAnon_f4ceea3f5f6f options);
  external JSObject stat(Uri uri);
  external Disposable watch(Uri uri, JSAnon_ce282821cb2a options);
  external JSAny writeFile(Uri uri, JSUint8Array content, JSAnon_95947812f514 options);
}

extension type FileSystemWatcher(JSObject _self) implements Disposable, JSObject {
  external factory FileSystemWatcher.lit$({JSBoolean? ignoreChangeEvents, JSBoolean? ignoreCreateEvents, JSBoolean? ignoreDeleteEvents, Event<Uri>? onDidChange, Event<Uri>? onDidCreate, Event<Uri>? onDidDelete});
  external bool get ignoreChangeEvents;
  external bool get ignoreCreateEvents;
  external bool get ignoreDeleteEvents;
  external Event<Uri> get onDidChange;
  external Event<Uri> get onDidCreate;
  external Event<Uri> get onDidDelete;
}

extension type FileWillCreateEvent(JSObject _self) implements JSObject {
  external factory FileWillCreateEvent.lit$({JSArray<Uri>? files, CancellationToken? token, JSFunction? waitUntil});
  external JSArray<Uri> get files;
  external CancellationToken get token;
  external void waitUntil(JSPromise<WorkspaceEdit> thenable);
  @JS('waitUntil')
  external void waitUntil$2(JSPromise<JSAny?> thenable);
}

extension type FileWillDeleteEvent(JSObject _self) implements JSObject {
  external factory FileWillDeleteEvent.lit$({JSArray<Uri>? files, CancellationToken? token, JSFunction? waitUntil});
  external JSArray<Uri> get files;
  external CancellationToken get token;
  external void waitUntil(JSPromise<WorkspaceEdit> thenable);
  @JS('waitUntil')
  external void waitUntil$2(JSPromise<JSAny?> thenable);
}

extension type FileWillRenameEvent(JSObject _self) implements JSObject {
  external factory FileWillRenameEvent.lit$({JSArray<JSAnon_7c30c4713d83>? files, CancellationToken? token, JSFunction? waitUntil});
  external JSArray<JSAnon_7c30c4713d83> get files;
  external CancellationToken get token;
  external void waitUntil(JSPromise<WorkspaceEdit> thenable);
  @JS('waitUntil')
  external void waitUntil$2(JSPromise<JSAny?> thenable);
}

extension type FoldingContext(JSObject _self) implements JSObject {
}

extension type FoldingRangeProvider(JSObject _self) implements JSObject {
  external factory FoldingRangeProvider.lit$({Event<JSAny?>? onDidChangeFoldingRanges, JSFunction? provideFoldingRanges});
  external Event<JSAny?>? get onDidChangeFoldingRanges;
  external set onDidChangeFoldingRanges(Event<JSAny?>? value);
  external JSAny? provideFoldingRanges(TextDocument document, FoldingContext context, CancellationToken token);
}

extension type FormattingOptions(JSObject _self) implements JSObject {
  external factory FormattingOptions.lit$({JSBoolean? insertSpaces, JSNumber? tabSize});
  external JSAny? operator [](String key);
  external void operator []=(String key, JSAny? value);
  external bool get insertSpaces;
  external set insertSpaces(bool value);
  external num get tabSize;
  external set tabSize(num value);
}

extension type GlobalEnvironmentVariableCollection(JSObject _self) implements EnvironmentVariableCollection, JSObject {
  external factory GlobalEnvironmentVariableCollection.lit$({JSFunction? getScoped});
  external EnvironmentVariableCollection getScoped(EnvironmentVariableScope scope);
}

extension type HoverProvider(JSObject _self) implements JSObject {
  external factory HoverProvider.lit$({JSFunction? provideHover});
  external JSAny? provideHover(TextDocument document, Position position, CancellationToken token);
}

extension type ImplementationProvider(JSObject _self) implements JSObject {
  external factory ImplementationProvider.lit$({JSFunction? provideImplementation});
  external JSAny? provideImplementation(TextDocument document, Position position, CancellationToken token);
}

extension type IndentationRule(JSObject _self) implements JSObject {
  external factory IndentationRule.lit$({JSObject? decreaseIndentPattern, JSObject? increaseIndentPattern, JSObject? indentNextLinePattern, JSObject? unIndentedLinePattern});
  external JSObject get decreaseIndentPattern;
  external set decreaseIndentPattern(JSObject value);
  external JSObject get increaseIndentPattern;
  external set increaseIndentPattern(JSObject value);
  external JSObject? get indentNextLinePattern;
  external set indentNextLinePattern(JSObject? value);
  external JSObject? get unIndentedLinePattern;
  external set unIndentedLinePattern(JSObject? value);
}

extension type InlayHintsProvider<T extends JSAny?>(JSObject _self) implements JSObject {
  external factory InlayHintsProvider.lit$({Event<JSAny?>? onDidChangeInlayHints, JSFunction? provideInlayHints, JSFunction? resolveInlayHint});
  external Event<JSAny?>? get onDidChangeInlayHints;
  external set onDidChangeInlayHints(Event<JSAny?>? value);
  external JSAny? provideInlayHints(TextDocument document, Range range, CancellationToken token);
  external JSAny? resolveInlayHint(T hint, CancellationToken token);
}

extension type InlineCompletionContext(JSObject _self) implements JSObject {
  external factory InlineCompletionContext.lit$({SelectedCompletionInfo? selectedCompletionInfo, JSNumber? triggerKind});
  external SelectedCompletionInfo? get selectedCompletionInfo;
  external int get triggerKind;
}

extension type InlineCompletionItemProvider(JSObject _self) implements JSObject {
  external factory InlineCompletionItemProvider.lit$({JSFunction? provideInlineCompletionItems});
  external JSAny? provideInlineCompletionItems(TextDocument document, Position position, InlineCompletionContext context, CancellationToken token);
}

extension type InlineValueContext(JSObject _self) implements JSObject {
  external factory InlineValueContext.lit$({JSNumber? frameId, Range? stoppedLocation});
  external num get frameId;
  external Range get stoppedLocation;
}

extension type InlineValuesProvider(JSObject _self) implements JSObject {
  external factory InlineValuesProvider.lit$({Event<JSAny?>? onDidChangeInlineValues, JSFunction? provideInlineValues});
  external Event<JSAny?>? get onDidChangeInlineValues;
  external set onDidChangeInlineValues(Event<JSAny?>? value);
  external JSAny? provideInlineValues(TextDocument document, Range viewPort, InlineValueContext context, CancellationToken token);
}

extension type InputBox(JSObject _self) implements QuickInput, JSObject {
  external factory InputBox.lit$({JSArray<QuickInputButton>? buttons, Event<JSAny?>? onDidAccept, Event<JSString>? onDidChangeValue, Event<QuickInputButton>? onDidTriggerButton, JSBoolean? password, JSString? placeholder, JSString? prompt, JSAny? validationMessage, JSString? value, JSTuple_9b5999d5c048? valueSelection});
  external JSArray<QuickInputButton> get buttons;
  external set buttons(JSArray<QuickInputButton> value);
  external Event<JSAny?> get onDidAccept;
  external Event<JSString> get onDidChangeValue;
  external Event<QuickInputButton> get onDidTriggerButton;
  external bool get password;
  external set password(bool value);
  external String? get placeholder;
  external set placeholder(String? value);
  external String? get prompt;
  external set prompt(String? value);
  external JSAny? get validationMessage;
  external set validationMessage(JSAny? value);
  external String get value;
  external set value(String value);
  external JSTuple_9b5999d5c048? get valueSelection;
  external set valueSelection(JSTuple_9b5999d5c048? value);
}

extension type InputBoxOptions(JSObject _self) implements JSObject {
  external factory InputBoxOptions.lit$({JSBoolean? ignoreFocusOut, JSBoolean? password, JSString? placeHolder, JSString? prompt, JSString? title, JSFunction? validateInput, JSString? value, JSTuple_9b5999d5c048? valueSelection});
  external bool? get ignoreFocusOut;
  external set ignoreFocusOut(bool? value);
  external bool? get password;
  external set password(bool? value);
  external String? get placeHolder;
  external set placeHolder(String? value);
  external String? get prompt;
  external set prompt(String? value);
  external String? get title;
  external set title(String? value);
  external JSAny? validateInput(String value);
  external String? get value;
  external set value(String? value);
  external JSTuple_9b5999d5c048? get valueSelection;
  external set valueSelection(JSTuple_9b5999d5c048? value);
}

extension type InputBoxValidationMessage(JSObject _self) implements JSObject {
  external factory InputBoxValidationMessage.lit$({JSString? message, JSNumber? severity});
  external String get message;
  external int get severity;
}

extension type LanguageConfiguration(JSObject _self) implements JSObject {
  external factory LanguageConfiguration.lit$({JSArray<AutoClosingPair>? autoClosingPairs, JSArray<JSTuple_58c6c79a4e36>? brackets, CommentRule? comments, IndentationRule? indentationRules, JSArray<OnEnterRule>? onEnterRules, JSObject? wordPattern});
  @JS('__characterPairSupport')
  external JSAnon_3800d8dfe13a? get $__characterPairSupport;
  @JS('__characterPairSupport')
  external set $__characterPairSupport(JSAnon_3800d8dfe13a? value);
  @JS('__electricCharacterSupport')
  external JSAnon_7e699a4ba0b6? get $__electricCharacterSupport;
  @JS('__electricCharacterSupport')
  external set $__electricCharacterSupport(JSAnon_7e699a4ba0b6? value);
  external JSArray<AutoClosingPair>? get autoClosingPairs;
  external set autoClosingPairs(JSArray<AutoClosingPair>? value);
  external JSArray<JSTuple_58c6c79a4e36>? get brackets;
  external set brackets(JSArray<JSTuple_58c6c79a4e36>? value);
  external CommentRule? get comments;
  external set comments(CommentRule? value);
  external IndentationRule? get indentationRules;
  external set indentationRules(IndentationRule? value);
  external JSArray<OnEnterRule>? get onEnterRules;
  external set onEnterRules(JSArray<OnEnterRule>? value);
  external JSObject? get wordPattern;
  external set wordPattern(JSObject? value);
}

extension type LanguageModelAccessInformation(JSObject _self) implements JSObject {
  external factory LanguageModelAccessInformation.lit$({JSFunction? canSendRequest, Event<JSAny?>? onDidChange});
  external bool? canSendRequest(LanguageModelChat chat);
  external Event<JSAny?> get onDidChange;
}

extension type LanguageModelChat(JSObject _self) implements JSObject {
  external factory LanguageModelChat.lit$({JSFunction? countTokens, JSString? family, JSString? id, JSNumber? maxInputTokens, JSString? name, JSFunction? sendRequest, JSString? vendor, JSString? version});
  external JSPromise<JSNumber> countTokens(JSAny text, [CancellationToken? token]);
  external String get family;
  external String get id;
  external num get maxInputTokens;
  external String get name;
  external JSPromise<LanguageModelChatResponse> sendRequest(JSArray<LanguageModelChatMessage> messages, [LanguageModelChatRequestOptions? options, CancellationToken? token]);
  external String get vendor;
  external String get version;
}

extension type LanguageModelChatCapabilities(JSObject _self) implements JSObject {
  external factory LanguageModelChatCapabilities.lit$({JSBoolean? imageInput, JSAny? toolCalling});
  external bool? get imageInput;
  external JSAny? get toolCalling;
}

extension type LanguageModelChatInformation(JSObject _self) implements JSObject {
  external factory LanguageModelChatInformation.lit$({LanguageModelChatCapabilities? capabilities, JSString? detail, JSString? family, JSString? id, JSNumber? maxInputTokens, JSNumber? maxOutputTokens, JSString? name, JSString? tooltip, JSString? version});
  external LanguageModelChatCapabilities get capabilities;
  external String? get detail;
  external String get family;
  external String get id;
  external num get maxInputTokens;
  external num get maxOutputTokens;
  external String get name;
  external String? get tooltip;
  external String get version;
}

extension type LanguageModelChatProvider<T extends JSAny?>(JSObject _self) implements JSObject {
  external factory LanguageModelChatProvider.lit$({Event<JSAny?>? onDidChangeLanguageModelChatInformation, JSFunction? provideLanguageModelChatInformation, JSFunction? provideLanguageModelChatResponse, JSFunction? provideTokenCount});
  external Event<JSAny?>? get onDidChangeLanguageModelChatInformation;
  external JSAny? provideLanguageModelChatInformation(PrepareLanguageModelChatModelOptions options, CancellationToken token);
  external JSPromise<JSAny?> provideLanguageModelChatResponse(T model, JSArray<LanguageModelChatRequestMessage> messages, ProvideLanguageModelChatResponseOptions options, Progress<JSObject> progress, CancellationToken token);
  external JSPromise<JSNumber> provideTokenCount(T model, JSAny text, CancellationToken token);
}

extension type LanguageModelChatRequestMessage(JSObject _self) implements JSObject {
  external factory LanguageModelChatRequestMessage.lit$({JSArray<JSAny>? content, JSString? name, JSNumber? role});
  external JSArray<JSAny> get content;
  external String? get name;
  external int get role;
}

extension type LanguageModelChatRequestOptions(JSObject _self) implements JSObject {
  external factory LanguageModelChatRequestOptions.lit$({JSString? justification, JSAnon_90b1eaa702e4? modelOptions, JSNumber? toolMode, JSArray<LanguageModelChatTool>? tools});
  external String? get justification;
  external set justification(String? value);
  external JSAnon_90b1eaa702e4? get modelOptions;
  external set modelOptions(JSAnon_90b1eaa702e4? value);
  external int? get toolMode;
  external set toolMode(int? value);
  external JSArray<LanguageModelChatTool>? get tools;
  external set tools(JSArray<LanguageModelChatTool>? value);
}

extension type LanguageModelChatResponse(JSObject _self) implements JSObject {
  external factory LanguageModelChatResponse.lit$({JSObject? stream, JSObject? text});
  external JSObject get stream;
  external set stream(JSObject value);
  external JSObject get text;
  external set text(JSObject value);
}

extension type LanguageModelChatSelector(JSObject _self) implements JSObject {
  external factory LanguageModelChatSelector.lit$({JSString? family, JSString? id, JSString? vendor, JSString? version});
  external String? get family;
  external set family(String? value);
  external String? get id;
  external set id(String? value);
  external String? get vendor;
  external set vendor(String? value);
  external String? get version;
  external set version(String? value);
}

extension type LanguageModelChatTool(JSObject _self) implements JSObject {
  external factory LanguageModelChatTool.lit$({JSString? description, JSObject? inputSchema, JSString? name});
  external String get description;
  external set description(String value);
  external JSObject? get inputSchema;
  external set inputSchema(JSObject? value);
  external String get name;
  external set name(String value);
}

extension type LanguageModelTool<T extends JSAny?>(JSObject _self) implements JSObject {
  external factory LanguageModelTool.lit$({JSFunction? invoke, JSFunction? prepareInvocation});
  external JSAny? invoke(LanguageModelToolInvocationOptions<T> options, CancellationToken token);
  external JSAny? prepareInvocation(LanguageModelToolInvocationPrepareOptions<T> options, CancellationToken token);
}

extension type LanguageModelToolConfirmationMessages(JSObject _self) implements JSObject {
  external factory LanguageModelToolConfirmationMessages.lit$({JSAny? message, JSString? title});
  external JSAny get message;
  external set message(JSAny value);
  external String get title;
  external set title(String value);
}

extension type LanguageModelToolInformation(JSObject _self) implements JSObject {
  external factory LanguageModelToolInformation.lit$({JSString? description, JSObject? inputSchema, JSString? name, JSArray<JSString>? tags});
  external String get description;
  external JSObject? get inputSchema;
  external String get name;
  external JSArray<JSString> get tags;
}

extension type LanguageModelToolInvocationOptions<T extends JSAny?>(JSObject _self) implements JSObject {
  external factory LanguageModelToolInvocationOptions.lit$({T? input, LanguageModelToolTokenizationOptions? tokenizationOptions, JSAny? toolInvocationToken});
  external T get input;
  external set input(T value);
  external LanguageModelToolTokenizationOptions? get tokenizationOptions;
  external set tokenizationOptions(LanguageModelToolTokenizationOptions? value);
  external JSAny? get toolInvocationToken;
  external set toolInvocationToken(JSAny? value);
}

extension type LanguageModelToolInvocationPrepareOptions<T extends JSAny?>(JSObject _self) implements JSObject {
  external factory LanguageModelToolInvocationPrepareOptions.lit$({T? input});
  external T get input;
  external set input(T value);
}

extension type LanguageModelToolTokenizationOptions(JSObject _self) implements JSObject {
  external factory LanguageModelToolTokenizationOptions.lit$({JSFunction? countTokens, JSNumber? tokenBudget});
  external JSPromise<JSNumber> countTokens(String text, [CancellationToken? token]);
  external num get tokenBudget;
  external set tokenBudget(num value);
}

extension type LanguageStatusItem(JSObject _self) implements JSObject {
  external factory LanguageStatusItem.lit$({AccessibilityInformation? accessibilityInformation, JSBoolean? busy, Command? command, JSString? detail, JSFunction? dispose, JSString? id, JSString? name, JSAny? selector, JSNumber? severity, JSString? text});
  external AccessibilityInformation? get accessibilityInformation;
  external set accessibilityInformation(AccessibilityInformation? value);
  external bool get busy;
  external set busy(bool value);
  external Command? get command;
  external set command(Command? value);
  external String? get detail;
  external set detail(String? value);
  external void dispose();
  external String get id;
  external String? get name;
  external set name(String? value);
  external JSAny get selector;
  external set selector(JSAny value);
  external int get severity;
  external set severity(int value);
  external String get text;
  external set text(String value);
}

extension type LineCommentRule(JSObject _self) implements JSObject {
  external factory LineCommentRule.lit$({JSString? comment, JSBoolean? noIndent});
  external String get comment;
  external set comment(String value);
  external bool? get noIndent;
  external set noIndent(bool? value);
}

extension type LinkedEditingRangeProvider(JSObject _self) implements JSObject {
  external factory LinkedEditingRangeProvider.lit$({JSFunction? provideLinkedEditingRanges});
  external JSAny? provideLinkedEditingRanges(TextDocument document, Position position, CancellationToken token);
}

extension type LocationLink(JSObject _self) implements JSObject {
  external factory LocationLink.lit$({Range? originSelectionRange, Range? targetRange, Range? targetSelectionRange, Uri? targetUri});
  external Range? get originSelectionRange;
  external set originSelectionRange(Range? value);
  external Range get targetRange;
  external set targetRange(Range value);
  external Range? get targetSelectionRange;
  external set targetSelectionRange(Range? value);
  external Uri get targetUri;
  external set targetUri(Uri value);
}

extension type LogOutputChannel(JSObject _self) implements OutputChannel, JSObject {
  external factory LogOutputChannel.lit$({JSFunction? debug, JSFunction? error, JSFunction? info, JSNumber? logLevel, Event<JSNumber>? onDidChangeLogLevel, JSFunction? trace, JSFunction? warn});
  JSAny? debug(JSString message, [List<JSAny?> args = const []]) {
    final args$ = <JSAny?>[message, ...args];
    return _self.callMethodVarArgs<JSAny?>('debug'.toJS, args$.sublist(0, args$.length));
  }
  JSAny? error(JSAny error, [List<JSAny?> args = const []]) {
    final args$ = <JSAny?>[error, ...args];
    return _self.callMethodVarArgs<JSAny?>('error'.toJS, args$.sublist(0, args$.length));
  }
  JSAny? info(JSString message, [List<JSAny?> args = const []]) {
    final args$ = <JSAny?>[message, ...args];
    return _self.callMethodVarArgs<JSAny?>('info'.toJS, args$.sublist(0, args$.length));
  }
  external int get logLevel;
  external Event<JSNumber> get onDidChangeLogLevel;
  JSAny? trace(JSString message, [List<JSAny?> args = const []]) {
    final args$ = <JSAny?>[message, ...args];
    return _self.callMethodVarArgs<JSAny?>('trace'.toJS, args$.sublist(0, args$.length));
  }
  JSAny? warn(JSString message, [List<JSAny?> args = const []]) {
    final args$ = <JSAny?>[message, ...args];
    return _self.callMethodVarArgs<JSAny?>('warn'.toJS, args$.sublist(0, args$.length));
  }
}

extension type McpServerDefinitionProvider<T extends JSAny?>(JSObject _self) implements JSObject {
  external factory McpServerDefinitionProvider.lit$({Event<JSAny?>? onDidChangeMcpServerDefinitions, JSFunction? provideMcpServerDefinitions, JSFunction? resolveMcpServerDefinition});
  external Event<JSAny?>? get onDidChangeMcpServerDefinitions;
  external JSAny? provideMcpServerDefinitions(CancellationToken token);
  external JSAny? resolveMcpServerDefinition(T server, CancellationToken token);
}

extension type Memento(JSObject _self) implements JSObject {
  external factory Memento.lit$({JSFunction? get, JSFunction? keys, JSFunction? update});
  external T? get<T extends JSAny?>(String key);
  @JS('get')
  external T get$2<T extends JSAny?>(String key, T defaultValue);
  external JSArray<JSString> keys();
  external JSPromise<JSAny?> update(String key, JSAny? value);
}

extension type MessageItem(JSObject _self) implements JSObject {
  external factory MessageItem.lit$({JSBoolean? isCloseAffordance, JSString? title});
  external bool? get isCloseAffordance;
  external set isCloseAffordance(bool? value);
  external String get title;
  external set title(String value);
}

extension type MessageOptions(JSObject _self) implements JSObject {
  external factory MessageOptions.lit$({JSString? detail, JSBoolean? modal});
  external String? get detail;
  external set detail(String? value);
  external bool? get modal;
  external set modal(bool? value);
}

extension type NotebookCell(JSObject _self) implements JSObject {
  external factory NotebookCell.lit$({TextDocument? document, NotebookCellExecutionSummary? executionSummary, JSNumber? index, JSNumber? kind, JSAnon_cd1da709a211? metadata, NotebookDocument? notebook, JSArray<NotebookCellOutput>? outputs});
  external TextDocument get document;
  external NotebookCellExecutionSummary? get executionSummary;
  external num get index;
  external int get kind;
  external JSAnon_cd1da709a211 get metadata;
  external NotebookDocument get notebook;
  external JSArray<NotebookCellOutput> get outputs;
}

extension type NotebookCellExecution(JSObject _self) implements JSObject {
  external factory NotebookCellExecution.lit$({JSFunction? appendOutput, JSFunction? appendOutputItems, NotebookCell? cell, JSFunction? clearOutput, JSFunction? end, JSNumber? executionOrder, JSFunction? replaceOutput, JSFunction? replaceOutputItems, JSFunction? start, CancellationToken? token});
  external JSPromise<JSAny?> appendOutput(JSObject out, [NotebookCell? cell]);
  external JSPromise<JSAny?> appendOutputItems(JSObject items, NotebookCellOutput output);
  external NotebookCell get cell;
  external JSPromise<JSAny?> clearOutput([NotebookCell? cell]);
  external void end(bool? success, [num? endTime]);
  external num? get executionOrder;
  external set executionOrder(num? value);
  external JSPromise<JSAny?> replaceOutput(JSObject out, [NotebookCell? cell]);
  external JSPromise<JSAny?> replaceOutputItems(JSObject items, NotebookCellOutput output);
  external void start([num? startTime]);
  external CancellationToken get token;
}

extension type NotebookCellExecutionSummary(JSObject _self) implements JSObject {
  external factory NotebookCellExecutionSummary.lit$({JSNumber? executionOrder, JSBoolean? success, JSAnon_2ef6a897fc39? timing});
  external num? get executionOrder;
  external bool? get success;
  external JSAnon_2ef6a897fc39? get timing;
}

extension type NotebookCellStatusBarItemProvider(JSObject _self) implements JSObject {
  external factory NotebookCellStatusBarItemProvider.lit$({Event<JSAny?>? onDidChangeCellStatusBarItems, JSFunction? provideCellStatusBarItems});
  external Event<JSAny?>? get onDidChangeCellStatusBarItems;
  external set onDidChangeCellStatusBarItems(Event<JSAny?>? value);
  external JSAny? provideCellStatusBarItems(NotebookCell cell, CancellationToken token);
}

extension type NotebookController(JSObject _self) implements JSObject {
  external factory NotebookController.lit$({JSFunction? createNotebookCellExecution, JSString? description, JSString? detail, JSFunction? dispose, JSFunction? executeHandler, JSString? id, JSFunction? interruptHandler, JSString? label, JSString? notebookType, Event<JSAnon_a6a068851ba0>? onDidChangeSelectedNotebooks, JSArray<JSString>? supportedLanguages, JSBoolean? supportsExecutionOrder, JSFunction? updateNotebookAffinity});
  external NotebookCellExecution createNotebookCellExecution(NotebookCell cell);
  external String? get description;
  external set description(String? value);
  external String? get detail;
  external set detail(String? value);
  external void dispose();
  external JSFunction get executeHandler;
  external set executeHandler(JSFunction value);
  external String get id;
  external JSFunction? get interruptHandler;
  external set interruptHandler(JSFunction? value);
  external String get label;
  external set label(String value);
  external String get notebookType;
  external Event<JSAnon_a6a068851ba0> get onDidChangeSelectedNotebooks;
  external JSArray<JSString>? get supportedLanguages;
  external set supportedLanguages(JSArray<JSString>? value);
  external bool? get supportsExecutionOrder;
  external set supportsExecutionOrder(bool? value);
  external void updateNotebookAffinity(NotebookDocument notebook, int affinity);
}

extension type NotebookDocument(JSObject _self) implements JSObject {
  external factory NotebookDocument.lit$({JSFunction? cellAt, JSNumber? cellCount, JSFunction? getCells, JSBoolean? isClosed, JSBoolean? isDirty, JSBoolean? isUntitled, JSAnon_90b1eaa702e4? metadata, JSString? notebookType, JSFunction? save, Uri? uri, JSNumber? version});
  external NotebookCell cellAt(num index);
  external num get cellCount;
  external JSArray<NotebookCell> getCells([NotebookRange? range]);
  external bool get isClosed;
  external bool get isDirty;
  external bool get isUntitled;
  external JSAnon_90b1eaa702e4 get metadata;
  external String get notebookType;
  external JSPromise<JSBoolean> save();
  external Uri get uri;
  external num get version;
}

extension type NotebookDocumentCellChange(JSObject _self) implements JSObject {
  external factory NotebookDocumentCellChange.lit$({NotebookCell? cell, TextDocument? document, NotebookCellExecutionSummary? executionSummary, JSAnon_90b1eaa702e4? metadata, JSArray<NotebookCellOutput>? outputs});
  external NotebookCell get cell;
  external TextDocument? get document;
  external NotebookCellExecutionSummary? get executionSummary;
  external JSAnon_90b1eaa702e4? get metadata;
  external JSArray<NotebookCellOutput>? get outputs;
}

extension type NotebookDocumentChangeEvent(JSObject _self) implements JSObject {
  external factory NotebookDocumentChangeEvent.lit$({JSArray<NotebookDocumentCellChange>? cellChanges, JSArray<NotebookDocumentContentChange>? contentChanges, JSAnon_90b1eaa702e4? metadata, NotebookDocument? notebook});
  external JSArray<NotebookDocumentCellChange> get cellChanges;
  external JSArray<NotebookDocumentContentChange> get contentChanges;
  external JSAnon_90b1eaa702e4? get metadata;
  external NotebookDocument get notebook;
}

extension type NotebookDocumentContentChange(JSObject _self) implements JSObject {
  external factory NotebookDocumentContentChange.lit$({JSArray<NotebookCell>? addedCells, NotebookRange? range, JSArray<NotebookCell>? removedCells});
  external JSArray<NotebookCell> get addedCells;
  external NotebookRange get range;
  external JSArray<NotebookCell> get removedCells;
}

extension type NotebookDocumentContentOptions(JSObject _self) implements JSObject {
  external factory NotebookDocumentContentOptions.lit$({JSAnon_8493e550322c? transientCellMetadata, JSAnon_8493e550322c? transientDocumentMetadata, JSBoolean? transientOutputs});
  external JSAnon_8493e550322c? get transientCellMetadata;
  external set transientCellMetadata(JSAnon_8493e550322c? value);
  external JSAnon_8493e550322c? get transientDocumentMetadata;
  external set transientDocumentMetadata(JSAnon_8493e550322c? value);
  external bool? get transientOutputs;
  external set transientOutputs(bool? value);
}

extension type NotebookDocumentShowOptions(JSObject _self) implements JSObject {
  external factory NotebookDocumentShowOptions.lit$({JSBoolean? preserveFocus, JSBoolean? preview, JSArray<NotebookRange>? selections, JSNumber? viewColumn});
  external bool? get preserveFocus;
  external bool? get preview;
  external JSArray<NotebookRange>? get selections;
  external int? get viewColumn;
}

extension type NotebookDocumentWillSaveEvent(JSObject _self) implements JSObject {
  external factory NotebookDocumentWillSaveEvent.lit$({NotebookDocument? notebook, JSNumber? reason, CancellationToken? token, JSFunction? waitUntil});
  external NotebookDocument get notebook;
  external int get reason;
  external CancellationToken get token;
  external void waitUntil(JSPromise<WorkspaceEdit> thenable);
  @JS('waitUntil')
  external void waitUntil$2(JSPromise<JSAny?> thenable);
}

extension type NotebookEditor(JSObject _self) implements JSObject {
  external factory NotebookEditor.lit$({NotebookDocument? notebook, JSFunction? revealRange, NotebookRange? selection, JSArray<NotebookRange>? selections, JSNumber? viewColumn, JSArray<NotebookRange>? visibleRanges});
  external NotebookDocument get notebook;
  external void revealRange(NotebookRange range, [int? revealType]);
  external NotebookRange get selection;
  external set selection(NotebookRange value);
  external JSArray<NotebookRange> get selections;
  external set selections(JSArray<NotebookRange> value);
  external int? get viewColumn;
  external JSArray<NotebookRange> get visibleRanges;
}

extension type NotebookEditorSelectionChangeEvent(JSObject _self) implements JSObject {
  external factory NotebookEditorSelectionChangeEvent.lit$({NotebookEditor? notebookEditor, JSArray<NotebookRange>? selections});
  external NotebookEditor get notebookEditor;
  external JSArray<NotebookRange> get selections;
}

extension type NotebookEditorVisibleRangesChangeEvent(JSObject _self) implements JSObject {
  external factory NotebookEditorVisibleRangesChangeEvent.lit$({NotebookEditor? notebookEditor, JSArray<NotebookRange>? visibleRanges});
  external NotebookEditor get notebookEditor;
  external JSArray<NotebookRange> get visibleRanges;
}

extension type NotebookRendererMessaging(JSObject _self) implements JSObject {
  external factory NotebookRendererMessaging.lit$({Event<JSAnon_68b4d8c85bba>? onDidReceiveMessage, JSFunction? postMessage});
  external Event<JSAnon_68b4d8c85bba> get onDidReceiveMessage;
  external JSPromise<JSBoolean> postMessage(JSAny? message, [NotebookEditor? editor]);
}

extension type NotebookSerializer(JSObject _self) implements JSObject {
  external factory NotebookSerializer.lit$({JSFunction? deserializeNotebook, JSFunction? serializeNotebook});
  external JSObject deserializeNotebook(JSUint8Array content, CancellationToken token);
  external JSObject serializeNotebook(NotebookData data, CancellationToken token);
}

extension type OnEnterRule(JSObject _self) implements JSObject {
  external factory OnEnterRule.lit$({EnterAction? action, JSObject? afterText, JSObject? beforeText, JSObject? previousLineText});
  external EnterAction get action;
  external set action(EnterAction value);
  external JSObject? get afterText;
  external set afterText(JSObject? value);
  external JSObject get beforeText;
  external set beforeText(JSObject value);
  external JSObject? get previousLineText;
  external set previousLineText(JSObject? value);
}

extension type OnTypeFormattingEditProvider(JSObject _self) implements JSObject {
  external factory OnTypeFormattingEditProvider.lit$({JSFunction? provideOnTypeFormattingEdits});
  external JSAny? provideOnTypeFormattingEdits(TextDocument document, Position position, String ch, FormattingOptions options, CancellationToken token);
}

extension type OpenDialogOptions(JSObject _self) implements JSObject {
  external factory OpenDialogOptions.lit$({JSBoolean? canSelectFiles, JSBoolean? canSelectFolders, JSBoolean? canSelectMany, Uri? defaultUri, JSAnon_04cd047eb59c? filters, JSString? openLabel, JSString? title});
  external bool? get canSelectFiles;
  external set canSelectFiles(bool? value);
  external bool? get canSelectFolders;
  external set canSelectFolders(bool? value);
  external bool? get canSelectMany;
  external set canSelectMany(bool? value);
  external Uri? get defaultUri;
  external set defaultUri(Uri? value);
  external JSAnon_04cd047eb59c? get filters;
  external set filters(JSAnon_04cd047eb59c? value);
  external String? get openLabel;
  external set openLabel(String? value);
  external String? get title;
  external set title(String? value);
}

extension type OutputChannel(JSObject _self) implements JSObject {
  external factory OutputChannel.lit$({JSFunction? append, JSFunction? appendLine, JSFunction? clear, JSFunction? dispose, JSFunction? hide, JSString? name, JSFunction? replace, JSFunction? show});
  external void append(String value);
  external void appendLine(String value);
  external void clear();
  external void dispose();
  external void hide();
  external String get name;
  external void replace(String value);
  external void show([bool? preserveFocus]);
  @JS('show')
  external void show$2([int? column, bool? preserveFocus]);
}

extension type PrepareLanguageModelChatModelOptions(JSObject _self) implements JSObject {
  external factory PrepareLanguageModelChatModelOptions.lit$({JSBoolean? silent});
  external bool get silent;
}

extension type PreparedToolInvocation(JSObject _self) implements JSObject {
  external factory PreparedToolInvocation.lit$({LanguageModelToolConfirmationMessages? confirmationMessages, JSAny? invocationMessage});
  external LanguageModelToolConfirmationMessages? get confirmationMessages;
  external set confirmationMessages(LanguageModelToolConfirmationMessages? value);
  external JSAny? get invocationMessage;
  external set invocationMessage(JSAny? value);
}

extension type ProcessExecutionOptions(JSObject _self) implements JSObject {
  external factory ProcessExecutionOptions.lit$({JSString? cwd, JSAnon_c77c8585355a? env});
  external String? get cwd;
  external set cwd(String? value);
  external JSAnon_c77c8585355a? get env;
  external set env(JSAnon_c77c8585355a? value);
}

extension type Progress<T extends JSAny?>(JSObject _self) implements JSObject {
  external factory Progress.lit$({JSFunction? report});
  external void report(T value);
}

extension type ProgressOptions(JSObject _self) implements JSObject {
  external factory ProgressOptions.lit$({JSBoolean? cancellable, JSAny? location, JSString? title});
  external bool? get cancellable;
  external set cancellable(bool? value);
  external JSAny get location;
  external set location(JSAny value);
  external String? get title;
  external set title(String? value);
}

extension type ProvideLanguageModelChatResponseOptions(JSObject _self) implements JSObject {
  external factory ProvideLanguageModelChatResponseOptions.lit$({JSAnon_cd1da709a211? modelOptions, JSNumber? toolMode, JSArray<LanguageModelChatTool>? tools});
  external JSAnon_cd1da709a211? get modelOptions;
  external int get toolMode;
  external JSArray<LanguageModelChatTool>? get tools;
}

extension type Pseudoterminal(JSObject _self) implements JSObject {
  external factory Pseudoterminal.lit$({JSFunction? close, JSFunction? handleInput, Event<JSString>? onDidChangeName, Event<JSAny>? onDidClose, Event<TerminalDimensions?>? onDidOverrideDimensions, Event<JSString>? onDidWrite, JSFunction? open, JSFunction? setDimensions});
  external void close();
  external void handleInput(String data);
  external Event<JSString>? get onDidChangeName;
  external set onDidChangeName(Event<JSString>? value);
  external Event<JSAny>? get onDidClose;
  external set onDidClose(Event<JSAny>? value);
  external Event<TerminalDimensions?>? get onDidOverrideDimensions;
  external set onDidOverrideDimensions(Event<TerminalDimensions?>? value);
  external Event<JSString> get onDidWrite;
  external set onDidWrite(Event<JSString> value);
  external void open(TerminalDimensions? initialDimensions);
  external void setDimensions(TerminalDimensions dimensions);
}

extension type QuickDiffProvider(JSObject _self) implements JSObject {
  external factory QuickDiffProvider.lit$({JSFunction? provideOriginalResource});
  external JSAny? provideOriginalResource(Uri uri, CancellationToken token);
}

extension type QuickInput(JSObject _self) implements JSObject {
  external factory QuickInput.lit$({JSBoolean? busy, JSFunction? dispose, JSBoolean? enabled, JSFunction? hide, JSBoolean? ignoreFocusOut, Event<JSAny?>? onDidHide, JSFunction? show, JSNumber? step, JSString? title, JSNumber? totalSteps});
  external bool get busy;
  external set busy(bool value);
  external void dispose();
  external bool get enabled;
  external set enabled(bool value);
  external void hide();
  external bool get ignoreFocusOut;
  external set ignoreFocusOut(bool value);
  external Event<JSAny?> get onDidHide;
  external void show();
  external num? get step;
  external set step(num? value);
  external String? get title;
  external set title(String? value);
  external num? get totalSteps;
  external set totalSteps(num? value);
}

extension type QuickInputButton(JSObject _self) implements JSObject {
  external factory QuickInputButton.lit$({JSObject? iconPath, JSNumber? location, JSAnon_dc1f16364c4a? toggle, JSString? tooltip});
  external JSObject get iconPath;
  external int? get location;
  external set location(int? value);
  external JSAnon_dc1f16364c4a? get toggle;
  external String? get tooltip;
}

extension type QuickPick<T extends JSAny?>(JSObject _self) implements QuickInput, JSObject {
  external factory QuickPick.lit$({JSArray<T>? activeItems, JSArray<QuickInputButton>? buttons, JSBoolean? canSelectMany, JSArray<T>? items, JSBoolean? keepScrollPosition, JSBoolean? matchOnDescription, JSBoolean? matchOnDetail, Event<JSAny?>? onDidAccept, Event<JSArray<T>>? onDidChangeActive, Event<JSArray<T>>? onDidChangeSelection, Event<JSString>? onDidChangeValue, Event<QuickInputButton>? onDidTriggerButton, Event<QuickPickItemButtonEvent<T>>? onDidTriggerItemButton, JSString? placeholder, JSString? prompt, JSArray<T>? selectedItems, JSString? value});
  external JSArray<T> get activeItems;
  external set activeItems(JSArray<T> value);
  external JSArray<QuickInputButton> get buttons;
  external set buttons(JSArray<QuickInputButton> value);
  external bool get canSelectMany;
  external set canSelectMany(bool value);
  external JSArray<T> get items;
  external set items(JSArray<T> value);
  external bool? get keepScrollPosition;
  external set keepScrollPosition(bool? value);
  external bool get matchOnDescription;
  external set matchOnDescription(bool value);
  external bool get matchOnDetail;
  external set matchOnDetail(bool value);
  external Event<JSAny?> get onDidAccept;
  external Event<JSArray<T>> get onDidChangeActive;
  external Event<JSArray<T>> get onDidChangeSelection;
  external Event<JSString> get onDidChangeValue;
  external Event<QuickInputButton> get onDidTriggerButton;
  external Event<QuickPickItemButtonEvent<T>> get onDidTriggerItemButton;
  external String? get placeholder;
  external set placeholder(String? value);
  external String? get prompt;
  external set prompt(String? value);
  external JSArray<T> get selectedItems;
  external set selectedItems(JSArray<T> value);
  external String get value;
  external set value(String value);
}

extension type QuickPickItem(JSObject _self) implements JSObject {
  external factory QuickPickItem.lit$({JSBoolean? alwaysShow, JSArray<QuickInputButton>? buttons, JSString? description, JSString? detail, JSObject? iconPath, JSNumber? kind, JSString? label, JSBoolean? picked, Uri? resourceUri});
  external bool? get alwaysShow;
  external set alwaysShow(bool? value);
  external JSArray<QuickInputButton>? get buttons;
  external set buttons(JSArray<QuickInputButton>? value);
  external String? get description;
  external set description(String? value);
  external String? get detail;
  external set detail(String? value);
  external JSObject? get iconPath;
  external set iconPath(JSObject? value);
  external int? get kind;
  external set kind(int? value);
  external String get label;
  external set label(String value);
  external bool? get picked;
  external set picked(bool? value);
  external Uri? get resourceUri;
  external set resourceUri(Uri? value);
}

extension type QuickPickItemButtonEvent<T extends JSAny?>(JSObject _self) implements JSObject {
  external factory QuickPickItemButtonEvent.lit$({QuickInputButton? button, T? item});
  external QuickInputButton get button;
  external T get item;
}

extension type QuickPickOptions(JSObject _self) implements JSObject {
  external factory QuickPickOptions.lit$({JSBoolean? canPickMany, JSBoolean? ignoreFocusOut, JSBoolean? matchOnDescription, JSBoolean? matchOnDetail, JSFunction? onDidSelectItem, JSString? placeHolder, JSString? prompt, JSString? title});
  external bool? get canPickMany;
  external set canPickMany(bool? value);
  external bool? get ignoreFocusOut;
  external set ignoreFocusOut(bool? value);
  external bool? get matchOnDescription;
  external set matchOnDescription(bool? value);
  external bool? get matchOnDetail;
  external set matchOnDetail(bool? value);
  external JSAny? onDidSelectItem(JSAny item);
  external String? get placeHolder;
  external set placeHolder(String? value);
  external String? get prompt;
  external set prompt(String? value);
  external String? get title;
  external set title(String? value);
}

extension type ReferenceContext(JSObject _self) implements JSObject {
  external factory ReferenceContext.lit$({JSBoolean? includeDeclaration});
  external bool get includeDeclaration;
}

extension type ReferenceProvider(JSObject _self) implements JSObject {
  external factory ReferenceProvider.lit$({JSFunction? provideReferences});
  external JSAny? provideReferences(TextDocument document, Position position, ReferenceContext context, CancellationToken token);
}

extension type RenameProvider(JSObject _self) implements JSObject {
  external factory RenameProvider.lit$({JSFunction? prepareRename, JSFunction? provideRenameEdits});
  external JSAny? prepareRename(TextDocument document, Position position, CancellationToken token);
  external JSAny? provideRenameEdits(TextDocument document, Position position, String newName, CancellationToken token);
}

extension type RunOptions(JSObject _self) implements JSObject {
  external factory RunOptions.lit$({JSBoolean? reevaluateOnRerun});
  external bool? get reevaluateOnRerun;
  external set reevaluateOnRerun(bool? value);
}

extension type SaveDialogOptions(JSObject _self) implements JSObject {
  external factory SaveDialogOptions.lit$({Uri? defaultUri, JSAnon_04cd047eb59c? filters, JSString? saveLabel, JSString? title});
  external Uri? get defaultUri;
  external set defaultUri(Uri? value);
  external JSAnon_04cd047eb59c? get filters;
  external set filters(JSAnon_04cd047eb59c? value);
  external String? get saveLabel;
  external set saveLabel(String? value);
  external String? get title;
  external set title(String? value);
}

extension type SecretStorage(JSObject _self) implements JSObject {
  external factory SecretStorage.lit$({JSFunction? delete, JSFunction? get, JSFunction? keys, Event<SecretStorageChangeEvent>? onDidChange, JSFunction? store});
  external JSPromise<JSAny?> delete(String key);
  external JSPromise<JSString?> get(String key);
  external JSPromise<JSArray<JSString>> keys();
  external Event<SecretStorageChangeEvent> get onDidChange;
  external JSPromise<JSAny?> store(String key, String value);
}

extension type SecretStorageChangeEvent(JSObject _self) implements JSObject {
  external factory SecretStorageChangeEvent.lit$({JSString? key});
  external String get key;
}

extension type SelectedCompletionInfo(JSObject _self) implements JSObject {
  external factory SelectedCompletionInfo.lit$({Range? range, JSString? text});
  external Range get range;
  external String get text;
}

extension type SelectionRangeProvider(JSObject _self) implements JSObject {
  external factory SelectionRangeProvider.lit$({JSFunction? provideSelectionRanges});
  external JSAny? provideSelectionRanges(TextDocument document, JSArray<Position> positions, CancellationToken token);
}

extension type ShellExecutionOptions(JSObject _self) implements JSObject {
  external factory ShellExecutionOptions.lit$({JSString? cwd, JSAnon_c77c8585355a? env, JSString? executable, JSArray<JSString>? shellArgs, ShellQuotingOptions? shellQuoting});
  external String? get cwd;
  external set cwd(String? value);
  external JSAnon_c77c8585355a? get env;
  external set env(JSAnon_c77c8585355a? value);
  external String? get executable;
  external set executable(String? value);
  external JSArray<JSString>? get shellArgs;
  external set shellArgs(JSArray<JSString>? value);
  external ShellQuotingOptions? get shellQuoting;
  external set shellQuoting(ShellQuotingOptions? value);
}

extension type ShellQuotedString(JSObject _self) implements JSObject {
  external factory ShellQuotedString.lit$({JSNumber? quoting, JSString? value});
  external int get quoting;
  external set quoting(int value);
  external String get value;
  external set value(String value);
}

extension type ShellQuotingOptions(JSObject _self) implements JSObject {
  external factory ShellQuotingOptions.lit$({JSAny? escape, JSString? strong, JSString? weak});
  external JSAny? get escape;
  external set escape(JSAny? value);
  external String? get strong;
  external set strong(String? value);
  external String? get weak;
  external set weak(String? value);
}

extension type SignatureHelpContext(JSObject _self) implements JSObject {
  external factory SignatureHelpContext.lit$({SignatureHelp? activeSignatureHelp, JSBoolean? isRetrigger, JSString? triggerCharacter, JSNumber? triggerKind});
  external SignatureHelp? get activeSignatureHelp;
  external bool get isRetrigger;
  external String? get triggerCharacter;
  external int get triggerKind;
}

extension type SignatureHelpProvider(JSObject _self) implements JSObject {
  external factory SignatureHelpProvider.lit$({JSFunction? provideSignatureHelp});
  external JSAny? provideSignatureHelp(TextDocument document, Position position, CancellationToken token, SignatureHelpContext context);
}

extension type SignatureHelpProviderMetadata(JSObject _self) implements JSObject {
  external factory SignatureHelpProviderMetadata.lit$({JSArray<JSString>? retriggerCharacters, JSArray<JSString>? triggerCharacters});
  external JSArray<JSString> get retriggerCharacters;
  external JSArray<JSString> get triggerCharacters;
}

extension type SourceControl(JSObject _self) implements JSObject {
  external factory SourceControl.lit$({Command? acceptInputCommand, JSString? commitTemplate, JSNumber? count, JSFunction? createResourceGroup, JSFunction? dispose, JSString? id, SourceControlInputBox? inputBox, JSString? label, QuickDiffProvider? quickDiffProvider, Uri? rootUri, JSArray<Command>? statusBarCommands});
  external Command? get acceptInputCommand;
  external set acceptInputCommand(Command? value);
  external String? get commitTemplate;
  external set commitTemplate(String? value);
  external num? get count;
  external set count(num? value);
  external SourceControlResourceGroup createResourceGroup(String id, String label);
  external void dispose();
  external String get id;
  external SourceControlInputBox get inputBox;
  external String get label;
  external QuickDiffProvider? get quickDiffProvider;
  external set quickDiffProvider(QuickDiffProvider? value);
  external Uri? get rootUri;
  external JSArray<Command>? get statusBarCommands;
  external set statusBarCommands(JSArray<Command>? value);
}

extension type SourceControlInputBox(JSObject _self) implements JSObject {
  external factory SourceControlInputBox.lit$({JSBoolean? enabled, JSString? placeholder, JSString? value, JSBoolean? visible});
  external bool get enabled;
  external set enabled(bool value);
  external String get placeholder;
  external set placeholder(String value);
  external String get value;
  external set value(String value);
  external bool get visible;
  external set visible(bool value);
}

extension type SourceControlResourceDecorations(JSObject _self) implements SourceControlResourceThemableDecorations, JSObject {
  external factory SourceControlResourceDecorations.lit$({SourceControlResourceThemableDecorations? dark, JSBoolean? faded, SourceControlResourceThemableDecorations? light, JSBoolean? strikeThrough, JSString? tooltip});
  external SourceControlResourceThemableDecorations? get dark;
  external bool? get faded;
  external SourceControlResourceThemableDecorations? get light;
  external bool? get strikeThrough;
  external String? get tooltip;
}

extension type SourceControlResourceGroup(JSObject _self) implements JSObject {
  external factory SourceControlResourceGroup.lit$({JSString? contextValue, JSFunction? dispose, JSBoolean? hideWhenEmpty, JSString? id, JSString? label, JSArray<SourceControlResourceState>? resourceStates});
  external String? get contextValue;
  external set contextValue(String? value);
  external void dispose();
  external bool? get hideWhenEmpty;
  external set hideWhenEmpty(bool? value);
  external String get id;
  external String get label;
  external set label(String value);
  external JSArray<SourceControlResourceState> get resourceStates;
  external set resourceStates(JSArray<SourceControlResourceState> value);
}

extension type SourceControlResourceState(JSObject _self) implements JSObject {
  external factory SourceControlResourceState.lit$({Command? command, JSString? contextValue, SourceControlResourceDecorations? decorations, Uri? resourceUri});
  external Command? get command;
  external String? get contextValue;
  external SourceControlResourceDecorations? get decorations;
  external Uri get resourceUri;
}

extension type SourceControlResourceThemableDecorations(JSObject _self) implements JSObject {
  external factory SourceControlResourceThemableDecorations.lit$({JSAny? iconPath});
  external JSAny? get iconPath;
}

extension type StatusBarItem(JSObject _self) implements JSObject {
  external factory StatusBarItem.lit$({AccessibilityInformation? accessibilityInformation, JSNumber? alignment, ThemeColor? backgroundColor, JSAny? color, JSAny? command, JSFunction? dispose, JSFunction? hide, JSString? id, JSString? name, JSNumber? priority, JSFunction? show, JSString? text, JSAny? tooltip});
  external AccessibilityInformation? get accessibilityInformation;
  external set accessibilityInformation(AccessibilityInformation? value);
  external int get alignment;
  external ThemeColor? get backgroundColor;
  external set backgroundColor(ThemeColor? value);
  external JSAny? get color;
  external set color(JSAny? value);
  external JSAny? get command;
  external set command(JSAny? value);
  external void dispose();
  external void hide();
  external String get id;
  external String? get name;
  external set name(String? value);
  external num? get priority;
  external void show();
  external String get text;
  external set text(String value);
  external JSAny? get tooltip;
  external set tooltip(JSAny? value);
}

extension type Tab(JSObject _self) implements JSObject {
  external factory Tab.lit$({TabGroup? group, JSAny? input, JSBoolean? isActive, JSBoolean? isDirty, JSBoolean? isPinned, JSBoolean? isPreview, JSString? label});
  external TabGroup get group;
  external JSAny get input;
  external bool get isActive;
  external bool get isDirty;
  external bool get isPinned;
  external bool get isPreview;
  external String get label;
}

extension type TabChangeEvent(JSObject _self) implements JSObject {
  external factory TabChangeEvent.lit$({JSArray<Tab>? changed, JSArray<Tab>? closed, JSArray<Tab>? opened});
  external JSArray<Tab> get changed;
  external JSArray<Tab> get closed;
  external JSArray<Tab> get opened;
}

extension type TabGroup(JSObject _self) implements JSObject {
  external factory TabGroup.lit$({Tab? activeTab, JSBoolean? isActive, JSArray<Tab>? tabs, JSNumber? viewColumn});
  external Tab? get activeTab;
  external bool get isActive;
  external JSArray<Tab> get tabs;
  external int get viewColumn;
}

extension type TabGroupChangeEvent(JSObject _self) implements JSObject {
  external factory TabGroupChangeEvent.lit$({JSArray<TabGroup>? changed, JSArray<TabGroup>? closed, JSArray<TabGroup>? opened});
  external JSArray<TabGroup> get changed;
  external JSArray<TabGroup> get closed;
  external JSArray<TabGroup> get opened;
}

extension type TabGroups(JSObject _self) implements JSObject {
  external factory TabGroups.lit$({TabGroup? activeTabGroup, JSArray<TabGroup>? all, JSFunction? close, Event<TabGroupChangeEvent>? onDidChangeTabGroups, Event<TabChangeEvent>? onDidChangeTabs});
  external TabGroup get activeTabGroup;
  external JSArray<TabGroup> get all;
  external JSPromise<JSBoolean> close(JSObject tab, [bool? preserveFocus]);
  @JS('close')
  external JSPromise<JSBoolean> close$2(JSObject tabGroup, [bool? preserveFocus]);
  external Event<TabGroupChangeEvent> get onDidChangeTabGroups;
  external Event<TabChangeEvent> get onDidChangeTabs;
}

extension type TaskDefinition(JSObject _self) implements JSObject {
  external factory TaskDefinition.lit$({JSString? type});
  external JSAny? operator [](String key);
  external void operator []=(String key, JSAny? value);
  external String get type;
}

extension type TaskEndEvent(JSObject _self) implements JSObject {
  external factory TaskEndEvent.lit$({TaskExecution? execution});
  external TaskExecution get execution;
}

extension type TaskExecution(JSObject _self) implements JSObject {
  external factory TaskExecution.lit$({Task? task, JSFunction? terminate});
  external Task get task;
  external set task(Task value);
  external void terminate();
}

extension type TaskFilter(JSObject _self) implements JSObject {
  external factory TaskFilter.lit$({JSString? type, JSString? version});
  external String? get type;
  external set type(String? value);
  external String? get version;
  external set version(String? value);
}

extension type TaskPresentationOptions(JSObject _self) implements JSObject {
  external factory TaskPresentationOptions.lit$({JSBoolean? clear, JSBoolean? close, JSBoolean? echo, JSBoolean? focus, JSNumber? panel, JSNumber? reveal, JSBoolean? showReuseMessage});
  external bool? get clear;
  external set clear(bool? value);
  external bool? get close;
  external set close(bool? value);
  external bool? get echo;
  external set echo(bool? value);
  external bool? get focus;
  external set focus(bool? value);
  external int? get panel;
  external set panel(int? value);
  external int? get reveal;
  external set reveal(int? value);
  external bool? get showReuseMessage;
  external set showReuseMessage(bool? value);
}

extension type TaskProcessEndEvent(JSObject _self) implements JSObject {
  external factory TaskProcessEndEvent.lit$({TaskExecution? execution, JSNumber? exitCode});
  external TaskExecution get execution;
  external num? get exitCode;
}

extension type TaskProcessStartEvent(JSObject _self) implements JSObject {
  external factory TaskProcessStartEvent.lit$({TaskExecution? execution, JSNumber? processId});
  external TaskExecution get execution;
  external num get processId;
}

extension type TaskProvider<T extends JSAny?>(JSObject _self) implements JSObject {
  external factory TaskProvider.lit$({JSFunction? provideTasks, JSFunction? resolveTask});
  external JSAny? provideTasks(CancellationToken token);
  external JSAny? resolveTask(T task, CancellationToken token);
}

extension type TaskStartEvent(JSObject _self) implements JSObject {
  external factory TaskStartEvent.lit$({TaskExecution? execution});
  external TaskExecution get execution;
}

extension type TelemetryLogger(JSObject _self) implements JSObject {
  external factory TelemetryLogger.lit$({JSFunction? dispose, JSBoolean? isErrorsEnabled, JSBoolean? isUsageEnabled, JSFunction? logError, JSFunction? logUsage, Event<TelemetryLogger>? onDidChangeEnableStates});
  external void dispose();
  external bool get isErrorsEnabled;
  external bool get isUsageEnabled;
  external void logError(String eventName, [JSObject? data]);
  @JS('logError')
  external void logError$2(JSObject error, [JSObject? data]);
  external void logUsage(String eventName, [JSObject? data]);
  external Event<TelemetryLogger> get onDidChangeEnableStates;
}

extension type TelemetryLoggerOptions(JSObject _self) implements JSObject {
  external factory TelemetryLoggerOptions.lit$({JSObject? additionalCommonProperties, JSBoolean? ignoreBuiltInCommonProperties, JSBoolean? ignoreUnhandledErrors});
  external JSObject? get additionalCommonProperties;
  external bool? get ignoreBuiltInCommonProperties;
  external bool? get ignoreUnhandledErrors;
}

extension type TelemetrySender(JSObject _self) implements JSObject {
  external factory TelemetrySender.lit$({JSFunction? flush, JSFunction? sendErrorData, JSFunction? sendEventData});
  external JSAny flush();
  external void sendErrorData(JSObject error, [JSObject? data]);
  external void sendEventData(String eventName, [JSObject? data]);
}

extension type Terminal(JSObject _self) implements JSObject {
  external factory Terminal.lit$({JSObject? creationOptions, JSFunction? dispose, TerminalExitStatus? exitStatus, JSFunction? hide, JSString? name, JSPromise<JSNumber?>? processId, JSFunction? sendText, TerminalShellIntegration? shellIntegration, JSFunction? show, TerminalState? state});
  external JSObject get creationOptions;
  external void dispose();
  external TerminalExitStatus? get exitStatus;
  external void hide();
  external String get name;
  external JSPromise<JSNumber?> get processId;
  external void sendText(String text, [bool? shouldExecute]);
  external TerminalShellIntegration? get shellIntegration;
  external void show([bool? preserveFocus]);
  external TerminalState get state;
}

extension type TerminalDimensions(JSObject _self) implements JSObject {
  external factory TerminalDimensions.lit$({JSNumber? columns, JSNumber? rows});
  external num get columns;
  external num get rows;
}

extension type TerminalEditorLocationOptions(JSObject _self) implements JSObject {
  external factory TerminalEditorLocationOptions.lit$({JSBoolean? preserveFocus, JSNumber? viewColumn});
  external bool? get preserveFocus;
  external set preserveFocus(bool? value);
  external int get viewColumn;
  external set viewColumn(int value);
}

extension type TerminalExitStatus(JSObject _self) implements JSObject {
  external factory TerminalExitStatus.lit$({JSNumber? code, JSNumber? reason});
  external num? get code;
  external int get reason;
}

extension type TerminalLinkContext(JSObject _self) implements JSObject {
  external factory TerminalLinkContext.lit$({JSString? line, Terminal? terminal});
  external String get line;
  external set line(String value);
  external Terminal get terminal;
  external set terminal(Terminal value);
}

extension type TerminalLinkProvider<T extends JSAny?>(JSObject _self) implements JSObject {
  external factory TerminalLinkProvider.lit$({JSFunction? handleTerminalLink, JSFunction? provideTerminalLinks});
  external JSAny? handleTerminalLink(T link);
  external JSAny? provideTerminalLinks(TerminalLinkContext context, CancellationToken token);
}

extension type TerminalOptions(JSObject _self) implements JSObject {
  external factory TerminalOptions.lit$({ThemeColor? color, JSAny? cwd, JSAnon_5cec6a3f14bb? env, JSBoolean? hideFromUser, JSObject? iconPath, JSBoolean? isTransient, JSAny? location, JSString? message, JSString? name, JSAny? shellArgs, JSString? shellIntegrationNonce, JSString? shellPath, JSBoolean? strictEnv});
  external ThemeColor? get color;
  external set color(ThemeColor? value);
  external JSAny? get cwd;
  external set cwd(JSAny? value);
  external JSAnon_5cec6a3f14bb? get env;
  external set env(JSAnon_5cec6a3f14bb? value);
  external bool? get hideFromUser;
  external set hideFromUser(bool? value);
  external JSObject? get iconPath;
  external set iconPath(JSObject? value);
  external bool? get isTransient;
  external set isTransient(bool? value);
  external JSAny? get location;
  external set location(JSAny? value);
  external String? get message;
  external set message(String? value);
  external String? get name;
  external set name(String? value);
  external JSAny? get shellArgs;
  external set shellArgs(JSAny? value);
  external String? get shellIntegrationNonce;
  external set shellIntegrationNonce(String? value);
  external String? get shellPath;
  external set shellPath(String? value);
  external bool? get strictEnv;
  external set strictEnv(bool? value);
}

extension type TerminalProfileProvider(JSObject _self) implements JSObject {
  external factory TerminalProfileProvider.lit$({JSFunction? provideTerminalProfile});
  external JSAny? provideTerminalProfile(CancellationToken token);
}

extension type TerminalShellExecution(JSObject _self) implements JSObject {
  external factory TerminalShellExecution.lit$({TerminalShellExecutionCommandLine? commandLine, Uri? cwd, JSFunction? read});
  external TerminalShellExecutionCommandLine get commandLine;
  external Uri? get cwd;
  external JSObject read();
}

extension type TerminalShellExecutionCommandLine(JSObject _self) implements JSObject {
  external factory TerminalShellExecutionCommandLine.lit$({JSNumber? confidence, JSBoolean? isTrusted, JSString? value});
  external int get confidence;
  external bool get isTrusted;
  external String get value;
}

extension type TerminalShellExecutionEndEvent(JSObject _self) implements JSObject {
  external factory TerminalShellExecutionEndEvent.lit$({TerminalShellExecution? execution, JSNumber? exitCode, TerminalShellIntegration? shellIntegration, Terminal? terminal});
  external TerminalShellExecution get execution;
  external num? get exitCode;
  external TerminalShellIntegration get shellIntegration;
  external Terminal get terminal;
}

extension type TerminalShellExecutionStartEvent(JSObject _self) implements JSObject {
  external factory TerminalShellExecutionStartEvent.lit$({TerminalShellExecution? execution, TerminalShellIntegration? shellIntegration, Terminal? terminal});
  external TerminalShellExecution get execution;
  external TerminalShellIntegration get shellIntegration;
  external Terminal get terminal;
}

extension type TerminalShellIntegration(JSObject _self) implements JSObject {
  external factory TerminalShellIntegration.lit$({Uri? cwd, JSFunction? executeCommand});
  external Uri? get cwd;
  external TerminalShellExecution executeCommand(String commandLine);
  @JS('executeCommand')
  external TerminalShellExecution executeCommand$2(String executable, JSArray<JSString> args);
}

extension type TerminalShellIntegrationChangeEvent(JSObject _self) implements JSObject {
  external factory TerminalShellIntegrationChangeEvent.lit$({TerminalShellIntegration? shellIntegration, Terminal? terminal});
  external TerminalShellIntegration get shellIntegration;
  external Terminal get terminal;
}

extension type TerminalSplitLocationOptions(JSObject _self) implements JSObject {
  external factory TerminalSplitLocationOptions.lit$({Terminal? parentTerminal});
  external Terminal get parentTerminal;
  external set parentTerminal(Terminal value);
}

extension type TerminalState(JSObject _self) implements JSObject {
  external factory TerminalState.lit$({JSBoolean? isInteractedWith, JSString? shell});
  external bool get isInteractedWith;
  external String? get shell;
}

extension type TestController(JSObject _self) implements JSObject {
  external factory TestController.lit$({JSFunction? createRunProfile, JSFunction? createTestItem, JSFunction? createTestRun, JSFunction? dispose, JSString? id, JSFunction? invalidateTestResults, TestItemCollection? items, JSString? label, JSFunction? refreshHandler, JSFunction? resolveHandler});
  external TestRunProfile createRunProfile(String label, int kind, JSFunction runHandler, [bool? isDefault, TestTag? tag, bool? supportsContinuousRun]);
  external TestItem createTestItem(String id, String label, [Uri? uri]);
  external TestRun createTestRun(TestRunRequest request, [String? name, bool? persist]);
  external void dispose();
  external String get id;
  external void invalidateTestResults([JSObject? items]);
  external TestItemCollection get items;
  external String get label;
  external set label(String value);
  external JSFunction? get refreshHandler;
  external set refreshHandler(JSFunction? value);
  external JSFunction? get resolveHandler;
  external set resolveHandler(JSFunction? value);
}

extension type TestItem(JSObject _self) implements JSObject {
  external factory TestItem.lit$({JSBoolean? busy, JSBoolean? canResolveChildren, TestItemCollection? children, JSString? description, JSAny? error, JSString? id, JSString? label, TestItem? parent, Range? range, JSString? sortText, JSArray<TestTag>? tags, Uri? uri});
  external bool get busy;
  external set busy(bool value);
  external bool get canResolveChildren;
  external set canResolveChildren(bool value);
  external TestItemCollection get children;
  external String? get description;
  external set description(String? value);
  external JSAny? get error;
  external set error(JSAny? value);
  external String get id;
  external String get label;
  external set label(String value);
  external TestItem? get parent;
  external Range? get range;
  external set range(Range? value);
  external String? get sortText;
  external set sortText(String? value);
  external JSArray<TestTag> get tags;
  external set tags(JSArray<TestTag> value);
  external Uri? get uri;
}

extension type TestItemCollection(JSObject _self) implements JSObject {
  external factory TestItemCollection.lit$({JSFunction? add, JSFunction? delete, JSFunction? forEach, JSFunction? get, JSFunction? replace, JSNumber? size});
  external void add(TestItem item);
  external void delete(String itemId);
  external void forEach(JSFunction callback, [JSAny? thisArg]);
  external TestItem? get(String itemId);
  external void replace(JSArray<TestItem> items);
  external num get size;
}

extension type TestRun(JSObject _self) implements JSObject {
  external factory TestRun.lit$({JSFunction? addCoverage, JSFunction? appendOutput, JSFunction? end, JSFunction? enqueued, JSFunction? errored, JSFunction? failed, JSBoolean? isPersisted, JSString? name, Event<JSAny?>? onDidDispose, JSFunction? passed, JSFunction? skipped, JSFunction? started, CancellationToken? token});
  external void addCoverage(FileCoverage fileCoverage);
  external void appendOutput(String output, [Location? location, TestItem? test]);
  external void end();
  external void enqueued(TestItem test);
  external void errored(TestItem test, JSObject message, [num? duration]);
  external void failed(TestItem test, JSObject message, [num? duration]);
  external bool get isPersisted;
  external String? get name;
  external Event<JSAny?> get onDidDispose;
  external void passed(TestItem test, [num? duration]);
  external void skipped(TestItem test);
  external void started(TestItem test);
  external CancellationToken get token;
}

extension type TestRunProfile(JSObject _self) implements JSObject {
  external factory TestRunProfile.lit$({JSFunction? configureHandler, JSFunction? dispose, JSBoolean? isDefault, JSNumber? kind, JSString? label, JSFunction? loadDetailedCoverage, JSFunction? loadDetailedCoverageForTest, Event<JSBoolean>? onDidChangeDefault, JSFunction? runHandler, JSBoolean? supportsContinuousRun, TestTag? tag});
  external JSFunction? get configureHandler;
  external set configureHandler(JSFunction? value);
  external void dispose();
  external bool get isDefault;
  external set isDefault(bool value);
  external int get kind;
  external String get label;
  external set label(String value);
  external JSFunction? get loadDetailedCoverage;
  external set loadDetailedCoverage(JSFunction? value);
  external JSFunction? get loadDetailedCoverageForTest;
  external set loadDetailedCoverageForTest(JSFunction? value);
  external Event<JSBoolean> get onDidChangeDefault;
  external JSFunction get runHandler;
  external set runHandler(JSFunction value);
  external bool get supportsContinuousRun;
  external set supportsContinuousRun(bool value);
  external TestTag? get tag;
  external set tag(TestTag? value);
}

extension type TextDocument(JSObject _self) implements JSObject {
  external factory TextDocument.lit$({JSString? encoding, JSNumber? eol, JSString? fileName, JSFunction? getText, JSFunction? getWordRangeAtPosition, JSBoolean? isClosed, JSBoolean? isDirty, JSBoolean? isUntitled, JSString? languageId, JSFunction? lineAt, JSNumber? lineCount, JSFunction? offsetAt, JSFunction? positionAt, JSFunction? save, Uri? uri, JSFunction? validatePosition, JSFunction? validateRange, JSNumber? version});
  external String get encoding;
  external int get eol;
  external String get fileName;
  external String getText([Range? range]);
  external Range? getWordRangeAtPosition(Position position, [JSObject? regex]);
  external bool get isClosed;
  external bool get isDirty;
  external bool get isUntitled;
  external String get languageId;
  external TextLine lineAt(num line);
  @JS('lineAt')
  external TextLine lineAt$2(Position position);
  external num get lineCount;
  external num offsetAt(Position position);
  external Position positionAt(num offset);
  external JSPromise<JSBoolean> save();
  external Uri get uri;
  external Position validatePosition(Position position);
  external Range validateRange(Range range);
  external num get version;
}

extension type TextDocumentChangeEvent(JSObject _self) implements JSObject {
  external factory TextDocumentChangeEvent.lit$({JSArray<TextDocumentContentChangeEvent>? contentChanges, TextDocument? document, JSNumber? reason});
  external JSArray<TextDocumentContentChangeEvent> get contentChanges;
  external TextDocument get document;
  external int? get reason;
}

extension type TextDocumentContentChangeEvent(JSObject _self) implements JSObject {
  external factory TextDocumentContentChangeEvent.lit$({Range? range, JSNumber? rangeLength, JSNumber? rangeOffset, JSString? text});
  external Range get range;
  external num get rangeLength;
  external num get rangeOffset;
  external String get text;
}

extension type TextDocumentContentProvider(JSObject _self) implements JSObject {
  external factory TextDocumentContentProvider.lit$({Event<Uri>? onDidChange, JSFunction? provideTextDocumentContent});
  external Event<Uri>? get onDidChange;
  external set onDidChange(Event<Uri>? value);
  external JSAny? provideTextDocumentContent(Uri uri, CancellationToken token);
}

extension type TextDocumentShowOptions(JSObject _self) implements JSObject {
  external factory TextDocumentShowOptions.lit$({JSBoolean? preserveFocus, JSBoolean? preview, Range? selection, JSNumber? viewColumn});
  external bool? get preserveFocus;
  external set preserveFocus(bool? value);
  external bool? get preview;
  external set preview(bool? value);
  external Range? get selection;
  external set selection(Range? value);
  external int? get viewColumn;
  external set viewColumn(int? value);
}

extension type TextDocumentWillSaveEvent(JSObject _self) implements JSObject {
  external factory TextDocumentWillSaveEvent.lit$({TextDocument? document, JSNumber? reason, JSFunction? waitUntil});
  external TextDocument get document;
  external int get reason;
  external void waitUntil(JSPromise<JSArray<TextEdit>> thenable);
  @JS('waitUntil')
  external void waitUntil$2(JSPromise<JSAny?> thenable);
}

extension type TextEditor(JSObject _self) implements JSObject {
  external factory TextEditor.lit$({TextDocument? document, JSFunction? edit, JSFunction? hide, JSFunction? insertSnippet, TextEditorOptions? options, JSFunction? revealRange, Selection? selection, JSArray<Selection>? selections, JSFunction? setDecorations, JSFunction? show, JSNumber? viewColumn, JSArray<Range>? visibleRanges});
  external TextDocument get document;
  external JSPromise<JSBoolean> edit(JSFunction callback, [JSAnon_c32f2c0618c1? options]);
  external void hide();
  external JSPromise<JSBoolean> insertSnippet(SnippetString snippet, [JSObject? location, JSAnon_d6158a9f7600? options]);
  external TextEditorOptions get options;
  external set options(TextEditorOptions value);
  external void revealRange(Range range, [int? revealType]);
  external Selection get selection;
  external set selection(Selection value);
  external JSArray<Selection> get selections;
  external set selections(JSArray<Selection> value);
  external void setDecorations(TextEditorDecorationType decorationType, JSObject rangesOrOptions);
  external void show([int? column]);
  external int? get viewColumn;
  external JSArray<Range> get visibleRanges;
}

extension type TextEditorDecorationType(JSObject _self) implements JSObject {
  external factory TextEditorDecorationType.lit$({JSFunction? dispose, JSString? key});
  external void dispose();
  external String get key;
}

extension type TextEditorEdit(JSObject _self) implements JSObject {
  external factory TextEditorEdit.lit$({JSFunction? delete, JSFunction? insert, JSFunction? replace, JSFunction? setEndOfLine});
  external void delete(JSObject location);
  external void insert(Position location, String value);
  external void replace(JSObject location, String value);
  external void setEndOfLine(int endOfLine);
}

extension type TextEditorOptions(JSObject _self) implements JSObject {
  external factory TextEditorOptions.lit$({JSNumber? cursorStyle, JSAny? indentSize, JSAny? insertSpaces, JSNumber? lineNumbers, JSAny? tabSize});
  external int? get cursorStyle;
  external set cursorStyle(int? value);
  external JSAny? get indentSize;
  external set indentSize(JSAny? value);
  external JSAny? get insertSpaces;
  external set insertSpaces(JSAny? value);
  external int? get lineNumbers;
  external set lineNumbers(int? value);
  external JSAny? get tabSize;
  external set tabSize(JSAny? value);
}

extension type TextEditorOptionsChangeEvent(JSObject _self) implements JSObject {
  external factory TextEditorOptionsChangeEvent.lit$({TextEditorOptions? options, TextEditor? textEditor});
  external TextEditorOptions get options;
  external TextEditor get textEditor;
}

extension type TextEditorSelectionChangeEvent(JSObject _self) implements JSObject {
  external factory TextEditorSelectionChangeEvent.lit$({JSNumber? kind, JSArray<Selection>? selections, TextEditor? textEditor});
  external int? get kind;
  external JSArray<Selection> get selections;
  external TextEditor get textEditor;
}

extension type TextEditorViewColumnChangeEvent(JSObject _self) implements JSObject {
  external factory TextEditorViewColumnChangeEvent.lit$({TextEditor? textEditor, JSNumber? viewColumn});
  external TextEditor get textEditor;
  external int get viewColumn;
}

extension type TextEditorVisibleRangesChangeEvent(JSObject _self) implements JSObject {
  external factory TextEditorVisibleRangesChangeEvent.lit$({TextEditor? textEditor, JSArray<Range>? visibleRanges});
  external TextEditor get textEditor;
  external JSArray<Range> get visibleRanges;
}

extension type TextLine(JSObject _self) implements JSObject {
  external factory TextLine.lit$({JSNumber? firstNonWhitespaceCharacterIndex, JSBoolean? isEmptyOrWhitespace, JSNumber? lineNumber, Range? range, Range? rangeIncludingLineBreak, JSString? text});
  external num get firstNonWhitespaceCharacterIndex;
  external bool get isEmptyOrWhitespace;
  external num get lineNumber;
  external Range get range;
  external Range get rangeIncludingLineBreak;
  external String get text;
}

extension type ThemableDecorationAttachmentRenderOptions(JSObject _self) implements JSObject {
  external factory ThemableDecorationAttachmentRenderOptions.lit$({JSAny? backgroundColor, JSString? border, JSAny? borderColor, JSAny? color, JSAny? contentIconPath, JSString? contentText, JSString? fontStyle, JSString? fontWeight, JSString? height, JSString? margin, JSString? textDecoration, JSString? width});
  external JSAny? get backgroundColor;
  external set backgroundColor(JSAny? value);
  external String? get border;
  external set border(String? value);
  external JSAny? get borderColor;
  external set borderColor(JSAny? value);
  external JSAny? get color;
  external set color(JSAny? value);
  external JSAny? get contentIconPath;
  external set contentIconPath(JSAny? value);
  external String? get contentText;
  external set contentText(String? value);
  external String? get fontStyle;
  external set fontStyle(String? value);
  external String? get fontWeight;
  external set fontWeight(String? value);
  external String? get height;
  external set height(String? value);
  external String? get margin;
  external set margin(String? value);
  external String? get textDecoration;
  external set textDecoration(String? value);
  external String? get width;
  external set width(String? value);
}

extension type ThemableDecorationInstanceRenderOptions(JSObject _self) implements JSObject {
  external factory ThemableDecorationInstanceRenderOptions.lit$({ThemableDecorationAttachmentRenderOptions? after, ThemableDecorationAttachmentRenderOptions? before});
  external ThemableDecorationAttachmentRenderOptions? get after;
  external set after(ThemableDecorationAttachmentRenderOptions? value);
  external ThemableDecorationAttachmentRenderOptions? get before;
  external set before(ThemableDecorationAttachmentRenderOptions? value);
}

extension type ThemableDecorationRenderOptions(JSObject _self) implements JSObject {
  external factory ThemableDecorationRenderOptions.lit$({ThemableDecorationAttachmentRenderOptions? after, JSAny? backgroundColor, ThemableDecorationAttachmentRenderOptions? before, JSString? border, JSAny? borderColor, JSString? borderRadius, JSString? borderSpacing, JSString? borderStyle, JSString? borderWidth, JSAny? color, JSString? cursor, JSString? fontStyle, JSString? fontWeight, JSAny? gutterIconPath, JSString? gutterIconSize, JSString? letterSpacing, JSString? opacity, JSString? outline, JSAny? outlineColor, JSString? outlineStyle, JSString? outlineWidth, JSAny? overviewRulerColor, JSString? textDecoration});
  external ThemableDecorationAttachmentRenderOptions? get after;
  external set after(ThemableDecorationAttachmentRenderOptions? value);
  external JSAny? get backgroundColor;
  external set backgroundColor(JSAny? value);
  external ThemableDecorationAttachmentRenderOptions? get before;
  external set before(ThemableDecorationAttachmentRenderOptions? value);
  external String? get border;
  external set border(String? value);
  external JSAny? get borderColor;
  external set borderColor(JSAny? value);
  external String? get borderRadius;
  external set borderRadius(String? value);
  external String? get borderSpacing;
  external set borderSpacing(String? value);
  external String? get borderStyle;
  external set borderStyle(String? value);
  external String? get borderWidth;
  external set borderWidth(String? value);
  external JSAny? get color;
  external set color(JSAny? value);
  external String? get cursor;
  external set cursor(String? value);
  external String? get fontStyle;
  external set fontStyle(String? value);
  external String? get fontWeight;
  external set fontWeight(String? value);
  external JSAny? get gutterIconPath;
  external set gutterIconPath(JSAny? value);
  external String? get gutterIconSize;
  external set gutterIconSize(String? value);
  external String? get letterSpacing;
  external set letterSpacing(String? value);
  external String? get opacity;
  external set opacity(String? value);
  external String? get outline;
  external set outline(String? value);
  external JSAny? get outlineColor;
  external set outlineColor(JSAny? value);
  external String? get outlineStyle;
  external set outlineStyle(String? value);
  external String? get outlineWidth;
  external set outlineWidth(String? value);
  external JSAny? get overviewRulerColor;
  external set overviewRulerColor(JSAny? value);
  external String? get textDecoration;
  external set textDecoration(String? value);
}

extension type TreeCheckboxChangeEvent<T extends JSAny?>(JSObject _self) implements JSObject {
  external factory TreeCheckboxChangeEvent.lit$({JSArray<JSTuple_87f74e97d0da>? items});
  external JSArray<JSTuple_87f74e97d0da> get items;
}

extension type TreeDataProvider<T extends JSAny?>(JSObject _self) implements JSObject {
  external factory TreeDataProvider.lit$({JSFunction? getChildren, JSFunction? getParent, JSFunction? getTreeItem, Event<JSAny?>? onDidChangeTreeData, JSFunction? resolveTreeItem});
  external JSAny? getChildren([T? element]);
  external JSAny? getParent(T element);
  external JSObject getTreeItem(T element);
  external Event<JSAny?>? get onDidChangeTreeData;
  external set onDidChangeTreeData(Event<JSAny?>? value);
  external JSAny? resolveTreeItem(TreeItem item, T element, CancellationToken token);
}

extension type TreeDragAndDropController<T extends JSAny?>(JSObject _self) implements JSObject {
  external factory TreeDragAndDropController.lit$({JSArray<JSString>? dragMimeTypes, JSArray<JSString>? dropMimeTypes, JSFunction? handleDrag, JSFunction? handleDrop});
  external JSArray<JSString> get dragMimeTypes;
  external JSArray<JSString> get dropMimeTypes;
  external JSAny handleDrag(JSArray<T> source, DataTransfer dataTransfer, CancellationToken token);
  external JSAny handleDrop(T? target, DataTransfer dataTransfer, CancellationToken token);
}

extension type TreeItemLabel(JSObject _self) implements JSObject {
  external factory TreeItemLabel.lit$({JSArray<JSTuple_9b5999d5c048>? highlights, JSString? label});
  external JSArray<JSTuple_9b5999d5c048>? get highlights;
  external set highlights(JSArray<JSTuple_9b5999d5c048>? value);
  external String get label;
  external set label(String value);
}

extension type TreeView<T extends JSAny?>(JSObject _self) implements Disposable, JSObject {
  external factory TreeView.lit$({ViewBadge? badge, JSString? description, JSString? message, Event<TreeCheckboxChangeEvent<T>>? onDidChangeCheckboxState, Event<TreeViewSelectionChangeEvent<T>>? onDidChangeSelection, Event<TreeViewVisibilityChangeEvent>? onDidChangeVisibility, Event<TreeViewExpansionEvent<T>>? onDidCollapseElement, Event<TreeViewExpansionEvent<T>>? onDidExpandElement, JSFunction? reveal, JSArray<T>? selection, JSString? title, JSBoolean? visible});
  external ViewBadge? get badge;
  external set badge(ViewBadge? value);
  external String? get description;
  external set description(String? value);
  external String? get message;
  external set message(String? value);
  external Event<TreeCheckboxChangeEvent<T>> get onDidChangeCheckboxState;
  external Event<TreeViewSelectionChangeEvent<T>> get onDidChangeSelection;
  external Event<TreeViewVisibilityChangeEvent> get onDidChangeVisibility;
  external Event<TreeViewExpansionEvent<T>> get onDidCollapseElement;
  external Event<TreeViewExpansionEvent<T>> get onDidExpandElement;
  external JSPromise<JSAny?> reveal(T element, [JSAnon_49025246bc6f? options]);
  external JSArray<T> get selection;
  external String? get title;
  external set title(String? value);
  external bool get visible;
}

extension type TreeViewExpansionEvent<T extends JSAny?>(JSObject _self) implements JSObject {
  external factory TreeViewExpansionEvent.lit$({T? element});
  external T get element;
}

extension type TreeViewOptions<T extends JSAny?>(JSObject _self) implements JSObject {
  external factory TreeViewOptions.lit$({JSBoolean? canSelectMany, TreeDragAndDropController<T>? dragAndDropController, JSBoolean? manageCheckboxStateManually, JSBoolean? showCollapseAll, TreeDataProvider<T>? treeDataProvider});
  external bool? get canSelectMany;
  external set canSelectMany(bool? value);
  external TreeDragAndDropController<T>? get dragAndDropController;
  external set dragAndDropController(TreeDragAndDropController<T>? value);
  external bool? get manageCheckboxStateManually;
  external set manageCheckboxStateManually(bool? value);
  external bool? get showCollapseAll;
  external set showCollapseAll(bool? value);
  external TreeDataProvider<T> get treeDataProvider;
  external set treeDataProvider(TreeDataProvider<T> value);
}

extension type TreeViewSelectionChangeEvent<T extends JSAny?>(JSObject _self) implements JSObject {
  external factory TreeViewSelectionChangeEvent.lit$({JSArray<T>? selection});
  external JSArray<T> get selection;
}

extension type TreeViewVisibilityChangeEvent(JSObject _self) implements JSObject {
  external factory TreeViewVisibilityChangeEvent.lit$({JSBoolean? visible});
  external bool get visible;
}

extension type TypeDefinitionProvider(JSObject _self) implements JSObject {
  external factory TypeDefinitionProvider.lit$({JSFunction? provideTypeDefinition});
  external JSAny? provideTypeDefinition(TextDocument document, Position position, CancellationToken token);
}

extension type TypeHierarchyProvider(JSObject _self) implements JSObject {
  external factory TypeHierarchyProvider.lit$({JSFunction? prepareTypeHierarchy, JSFunction? provideTypeHierarchySubtypes, JSFunction? provideTypeHierarchySupertypes});
  external JSAny? prepareTypeHierarchy(TextDocument document, Position position, CancellationToken token);
  external JSAny? provideTypeHierarchySubtypes(TypeHierarchyItem item, CancellationToken token);
  external JSAny? provideTypeHierarchySupertypes(TypeHierarchyItem item, CancellationToken token);
}

extension type UriHandler(JSObject _self) implements JSObject {
  external factory UriHandler.lit$({JSFunction? handleUri});
  external JSAny? handleUri(Uri uri);
}

extension type ViewBadge(JSObject _self) implements JSObject {
  external factory ViewBadge.lit$({JSString? tooltip, JSNumber? value});
  external String get tooltip;
  external num get value;
}

extension type Webview(JSObject _self) implements JSObject {
  external factory Webview.lit$({JSFunction? asWebviewUri, JSString? cspSource, JSString? html, Event<JSAny?>? onDidReceiveMessage, WebviewOptions? options, JSFunction? postMessage});
  external Uri asWebviewUri(Uri localResource);
  external String get cspSource;
  external String get html;
  external set html(String value);
  external Event<JSAny?> get onDidReceiveMessage;
  external WebviewOptions get options;
  external set options(WebviewOptions value);
  external JSPromise<JSBoolean> postMessage(JSAny? message);
}

extension type WebviewOptions(JSObject _self) implements JSObject {
  external factory WebviewOptions.lit$({JSAny? enableCommandUris, JSBoolean? enableForms, JSBoolean? enableScripts, JSArray<Uri>? localResourceRoots, JSArray<WebviewPortMapping>? portMapping});
  external JSAny? get enableCommandUris;
  external bool? get enableForms;
  external bool? get enableScripts;
  external JSArray<Uri>? get localResourceRoots;
  external JSArray<WebviewPortMapping>? get portMapping;
}

extension type WebviewPanel(JSObject _self) implements JSObject {
  external factory WebviewPanel.lit$({JSBoolean? active, JSFunction? dispose, JSObject? iconPath, Event<WebviewPanelOnDidChangeViewStateEvent>? onDidChangeViewState, Event<JSAny?>? onDidDispose, WebviewPanelOptions? options, JSFunction? reveal, JSString? title, JSNumber? viewColumn, JSString? viewType, JSBoolean? visible, Webview? webview});
  external bool get active;
  external JSAny? dispose();
  external JSObject? get iconPath;
  external set iconPath(JSObject? value);
  external Event<WebviewPanelOnDidChangeViewStateEvent> get onDidChangeViewState;
  external Event<JSAny?> get onDidDispose;
  external WebviewPanelOptions get options;
  external void reveal([int? viewColumn, bool? preserveFocus]);
  external String get title;
  external set title(String value);
  external int? get viewColumn;
  external String get viewType;
  external bool get visible;
  external Webview get webview;
}

extension type WebviewPanelOnDidChangeViewStateEvent(JSObject _self) implements JSObject {
  external factory WebviewPanelOnDidChangeViewStateEvent.lit$({WebviewPanel? webviewPanel});
  external WebviewPanel get webviewPanel;
}

extension type WebviewPanelOptions(JSObject _self) implements JSObject {
  external factory WebviewPanelOptions.lit$({JSBoolean? enableFindWidget, JSBoolean? retainContextWhenHidden});
  external bool? get enableFindWidget;
  external bool? get retainContextWhenHidden;
}

extension type WebviewPanelSerializer<T extends JSAny?>(JSObject _self) implements JSObject {
  external factory WebviewPanelSerializer.lit$({JSFunction? deserializeWebviewPanel});
  external JSPromise<JSAny?> deserializeWebviewPanel(WebviewPanel webviewPanel, T state);
}

extension type WebviewPortMapping(JSObject _self) implements JSObject {
  external factory WebviewPortMapping.lit$({JSNumber? extensionHostPort, JSNumber? webviewPort});
  external num get extensionHostPort;
  external num get webviewPort;
}

extension type WebviewView(JSObject _self) implements JSObject {
  external factory WebviewView.lit$({ViewBadge? badge, JSString? description, Event<JSAny?>? onDidChangeVisibility, Event<JSAny?>? onDidDispose, JSFunction? show, JSString? title, JSString? viewType, JSBoolean? visible, Webview? webview});
  external ViewBadge? get badge;
  external set badge(ViewBadge? value);
  external String? get description;
  external set description(String? value);
  external Event<JSAny?> get onDidChangeVisibility;
  external Event<JSAny?> get onDidDispose;
  external void show([bool? preserveFocus]);
  external String? get title;
  external set title(String? value);
  external String get viewType;
  external bool get visible;
  external Webview get webview;
}

extension type WebviewViewProvider(JSObject _self) implements JSObject {
  external factory WebviewViewProvider.lit$({JSFunction? resolveWebviewView});
  external JSAny resolveWebviewView(WebviewView webviewView, WebviewViewResolveContext<JSAny?> context, CancellationToken token);
}

extension type WebviewViewResolveContext<T extends JSAny?>(JSObject _self) implements JSObject {
  external factory WebviewViewResolveContext.lit$({T? state});
  external T? get state;
}

extension type WindowState(JSObject _self) implements JSObject {
  external factory WindowState.lit$({JSBoolean? active, JSBoolean? focused});
  external bool get active;
  external bool get focused;
}

extension type WorkspaceConfiguration(JSObject _self) implements JSObject {
  external factory WorkspaceConfiguration.lit$({JSFunction? get, JSFunction? has, JSFunction? inspect, JSFunction? update});
  external JSAny? operator [](String key);
  external T? get<T extends JSAny?>(String section);
  @JS('get')
  external T get$2<T extends JSAny?>(String section, T defaultValue);
  external bool has(String section);
  external JSAnon_406956b7ed59? inspect<T extends JSAny?>(String section);
  external JSPromise<JSAny?> update(String section, JSAny? value, [JSAny? configurationTarget, bool? overrideInLanguage]);
}

extension type WorkspaceEditEntryMetadata(JSObject _self) implements JSObject {
  external factory WorkspaceEditEntryMetadata.lit$({JSString? description, JSObject? iconPath, JSString? label, JSBoolean? needsConfirmation});
  external String? get description;
  external set description(String? value);
  external JSObject? get iconPath;
  external set iconPath(JSObject? value);
  external String get label;
  external set label(String value);
  external bool get needsConfirmation;
  external set needsConfirmation(bool value);
}

extension type WorkspaceEditMetadata(JSObject _self) implements JSObject {
  external factory WorkspaceEditMetadata.lit$({JSBoolean? isRefactoring});
  external bool? get isRefactoring;
  external set isRefactoring(bool? value);
}

extension type WorkspaceFolder(JSObject _self) implements JSObject {
  external factory WorkspaceFolder.lit$({JSNumber? index, JSString? name, Uri? uri});
  external num get index;
  external String get name;
  external Uri get uri;
}

extension type WorkspaceFolderPickOptions(JSObject _self) implements JSObject {
  external factory WorkspaceFolderPickOptions.lit$({JSBoolean? ignoreFocusOut, JSString? placeHolder});
  external bool? get ignoreFocusOut;
  external set ignoreFocusOut(bool? value);
  external String? get placeHolder;
  external set placeHolder(String? value);
}

extension type WorkspaceFoldersChangeEvent(JSObject _self) implements JSObject {
  external factory WorkspaceFoldersChangeEvent.lit$({JSArray<WorkspaceFolder>? added, JSArray<WorkspaceFolder>? removed});
  external JSArray<WorkspaceFolder> get added;
  external JSArray<WorkspaceFolder> get removed;
}

extension type WorkspaceSymbolProvider<T extends JSAny?>(JSObject _self) implements JSObject {
  external factory WorkspaceSymbolProvider.lit$({JSFunction? provideWorkspaceSymbols, JSFunction? resolveWorkspaceSymbol});
  external JSAny? provideWorkspaceSymbols(String query, CancellationToken token);
  external JSAny? resolveWorkspaceSymbol(T symbol, CancellationToken token);
}

extension type BranchCoverage(JSObject _self) implements JSObject {
  external JSAny get executed;
  external set executed(JSAny value);
  external String? get label;
  external set label(String? value);
  external JSObject? get location;
  external set location(JSObject? value);
}

extension type BranchCoverageCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  BranchCoverage cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of BranchCoverage');
    }
    return BranchCoverage(value! as JSObject);
  }
  BranchCoverage new$(JSAny executed, [JSObject? location, JSString? label]) {
    final args$ = <JSAny?>[executed, location, label];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as BranchCoverage;
  }
}

extension type Breakpoint(JSObject _self) implements JSObject {
  external String? get condition;
  external bool get enabled;
  external String? get hitCondition;
  external String get id;
  external String? get logMessage;
}

extension type BreakpointCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  Breakpoint cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of Breakpoint');
    }
    return Breakpoint(value! as JSObject);
  }
  Breakpoint new$() =>
      _self.callAsConstructorVarArgs<JSObject>(const [])
          as Breakpoint;
}

extension type CallHierarchyIncomingCall(JSObject _self) implements JSObject {
  external CallHierarchyItem get from;
  external set from(CallHierarchyItem value);
  external JSArray<Range> get fromRanges;
  external set fromRanges(JSArray<Range> value);
}

extension type CallHierarchyIncomingCallCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  CallHierarchyIncomingCall cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of CallHierarchyIncomingCall');
    }
    return CallHierarchyIncomingCall(value! as JSObject);
  }
  CallHierarchyIncomingCall new$(CallHierarchyItem item, JSArray<Range> fromRanges) {
    final args$ = <JSAny?>[item, fromRanges];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as CallHierarchyIncomingCall;
  }
}

extension type CallHierarchyItem(JSObject _self) implements JSObject {
  external String? get detail;
  external set detail(String? value);
  external int get kind;
  external set kind(int value);
  external String get name;
  external set name(String value);
  external Range get range;
  external set range(Range value);
  external Range get selectionRange;
  external set selectionRange(Range value);
  external JSArray<JSNumber>? get tags;
  external set tags(JSArray<JSNumber>? value);
  external Uri get uri;
  external set uri(Uri value);
}

extension type CallHierarchyItemCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  CallHierarchyItem cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of CallHierarchyItem');
    }
    return CallHierarchyItem(value! as JSObject);
  }
  CallHierarchyItem new$(JSNumber kind, JSString name, JSString detail, Uri uri, Range range, Range selectionRange) {
    final args$ = <JSAny?>[kind, name, detail, uri, range, selectionRange];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 6))) as CallHierarchyItem;
  }
}

extension type CallHierarchyOutgoingCall(JSObject _self) implements JSObject {
  external JSArray<Range> get fromRanges;
  external set fromRanges(JSArray<Range> value);
  external CallHierarchyItem get to;
  external set to(CallHierarchyItem value);
}

extension type CallHierarchyOutgoingCallCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  CallHierarchyOutgoingCall cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of CallHierarchyOutgoingCall');
    }
    return CallHierarchyOutgoingCall(value! as JSObject);
  }
  CallHierarchyOutgoingCall new$(CallHierarchyItem item, JSArray<Range> fromRanges) {
    final args$ = <JSAny?>[item, fromRanges];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as CallHierarchyOutgoingCall;
  }
}

extension type CancellationError(JSObject _self) implements JSObject {
}

extension type CancellationErrorCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  CancellationError cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of CancellationError');
    }
    return CancellationError(value! as JSObject);
  }
  CancellationError new$() {
    final args$ = <JSAny?>[];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 0))) as CancellationError;
  }
}

extension type CancellationTokenSource(JSObject _self) implements JSObject {
  external void cancel();
  external void dispose();
  external CancellationToken get token;
  external set token(CancellationToken value);
}

extension type CancellationTokenSourceCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  CancellationTokenSource cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of CancellationTokenSource');
    }
    return CancellationTokenSource(value! as JSObject);
  }
  CancellationTokenSource new$() =>
      _self.callAsConstructorVarArgs<JSObject>(const [])
          as CancellationTokenSource;
}

extension type ChatRequestTurn(JSObject _self) implements JSObject {
  external String? get command;
  external String get participant;
  external String get prompt;
  external JSArray<ChatPromptReference> get references;
  external JSArray<ChatLanguageModelToolReference> get toolReferences;
}

extension type ChatRequestTurnCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  ChatRequestTurn cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of ChatRequestTurn');
    }
    return ChatRequestTurn(value! as JSObject);
  }
  ChatRequestTurn new$() =>
      _self.callAsConstructorVarArgs<JSObject>(const [])
          as ChatRequestTurn;
}

extension type ChatResponseAnchorPart(JSObject _self) implements JSObject {
  external String? get title;
  external set title(String? value);
  external JSObject get value;
  external set value(JSObject value);
}

extension type ChatResponseAnchorPartCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  ChatResponseAnchorPart cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of ChatResponseAnchorPart');
    }
    return ChatResponseAnchorPart(value! as JSObject);
  }
  ChatResponseAnchorPart new$(JSObject value, [JSString? title]) {
    final args$ = <JSAny?>[value, title];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as ChatResponseAnchorPart;
  }
}

extension type ChatResponseCommandButtonPart(JSObject _self) implements JSObject {
  external Command get value;
  external set value(Command value);
}

extension type ChatResponseCommandButtonPartCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  ChatResponseCommandButtonPart cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of ChatResponseCommandButtonPart');
    }
    return ChatResponseCommandButtonPart(value! as JSObject);
  }
  ChatResponseCommandButtonPart new$(Command value) {
    final args$ = <JSAny?>[value];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as ChatResponseCommandButtonPart;
  }
}

extension type ChatResponseFileTreePart(JSObject _self) implements JSObject {
  external Uri get baseUri;
  external set baseUri(Uri value);
  external JSArray<ChatResponseFileTree> get value;
  external set value(JSArray<ChatResponseFileTree> value);
}

extension type ChatResponseFileTreePartCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  ChatResponseFileTreePart cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of ChatResponseFileTreePart');
    }
    return ChatResponseFileTreePart(value! as JSObject);
  }
  ChatResponseFileTreePart new$(JSArray<ChatResponseFileTree> value, Uri baseUri) {
    final args$ = <JSAny?>[value, baseUri];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as ChatResponseFileTreePart;
  }
}

extension type ChatResponseMarkdownPart(JSObject _self) implements JSObject {
  external MarkdownString get value;
  external set value(MarkdownString value);
}

extension type ChatResponseMarkdownPartCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  ChatResponseMarkdownPart cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of ChatResponseMarkdownPart');
    }
    return ChatResponseMarkdownPart(value! as JSObject);
  }
  ChatResponseMarkdownPart new$(JSAny value) {
    final args$ = <JSAny?>[value];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as ChatResponseMarkdownPart;
  }
}

extension type ChatResponseProgressPart(JSObject _self) implements JSObject {
  external String get value;
  external set value(String value);
}

extension type ChatResponseProgressPartCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  ChatResponseProgressPart cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of ChatResponseProgressPart');
    }
    return ChatResponseProgressPart(value! as JSObject);
  }
  ChatResponseProgressPart new$(JSString value) {
    final args$ = <JSAny?>[value];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as ChatResponseProgressPart;
  }
}

extension type ChatResponseReferencePart(JSObject _self) implements JSObject {
  external JSObject? get iconPath;
  external set iconPath(JSObject? value);
  external JSObject get value;
  external set value(JSObject value);
}

extension type ChatResponseReferencePartCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  ChatResponseReferencePart cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of ChatResponseReferencePart');
    }
    return ChatResponseReferencePart(value! as JSObject);
  }
  ChatResponseReferencePart new$(JSObject value, [JSObject? iconPath]) {
    final args$ = <JSAny?>[value, iconPath];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as ChatResponseReferencePart;
  }
}

extension type ChatResponseTurn(JSObject _self) implements JSObject {
  external String? get command;
  external String get participant;
  external JSArray<JSObject> get response;
  external ChatResult get result;
}

extension type ChatResponseTurnCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  ChatResponseTurn cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of ChatResponseTurn');
    }
    return ChatResponseTurn(value! as JSObject);
  }
  ChatResponseTurn new$() =>
      _self.callAsConstructorVarArgs<JSObject>(const [])
          as ChatResponseTurn;
}

extension type CodeAction(JSObject _self) implements JSObject {
  external Command? get command;
  external set command(Command? value);
  external JSArray<Diagnostic>? get diagnostics;
  external set diagnostics(JSArray<Diagnostic>? value);
  external JSAnon_4caec6211e15? get disabled;
  external set disabled(JSAnon_4caec6211e15? value);
  external WorkspaceEdit? get edit;
  external set edit(WorkspaceEdit? value);
  external bool? get isPreferred;
  external set isPreferred(bool? value);
  external CodeActionKind? get kind;
  external set kind(CodeActionKind? value);
  external String get title;
  external set title(String value);
}

extension type CodeActionCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  CodeAction cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of CodeAction');
    }
    return CodeAction(value! as JSObject);
  }
  CodeAction new$(JSString title, [CodeActionKind? kind]) {
    final args$ = <JSAny?>[title, kind];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as CodeAction;
  }
}

extension type CodeActionKind(JSObject _self) implements JSObject {
  external CodeActionKind append(String parts);
  external bool contains(CodeActionKind other);
  external bool intersects(CodeActionKind other);
  external String get value;
}

extension type CodeActionKindCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  CodeActionKind cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of CodeActionKind');
    }
    return CodeActionKind(value! as JSObject);
  }
  CodeActionKind new$() =>
      _self.callAsConstructorVarArgs<JSObject>(const [])
          as CodeActionKind;
  external CodeActionKind get Empty;
  external CodeActionKind get Notebook;
  external CodeActionKind get QuickFix;
  external CodeActionKind get Refactor;
  external CodeActionKind get RefactorExtract;
  external CodeActionKind get RefactorInline;
  external CodeActionKind get RefactorMove;
  external CodeActionKind get RefactorRewrite;
  external CodeActionKind get Source;
  external CodeActionKind get SourceFixAll;
  external CodeActionKind get SourceOrganizeImports;
}

extension type CodeLens(JSObject _self) implements JSObject {
  external Command? get command;
  external set command(Command? value);
  external bool get isResolved;
  external Range get range;
  external set range(Range value);
}

extension type CodeLensCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  CodeLens cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of CodeLens');
    }
    return CodeLens(value! as JSObject);
  }
  CodeLens new$(Range range, [Command? command]) {
    final args$ = <JSAny?>[range, command];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as CodeLens;
  }
}

extension type Color(JSObject _self) implements JSObject {
  external num get alpha;
  external num get blue;
  external num get green;
  external num get red;
}

extension type ColorCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  Color cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of Color');
    }
    return Color(value! as JSObject);
  }
  Color new$(JSNumber red, JSNumber green, JSNumber blue, JSNumber alpha) {
    final args$ = <JSAny?>[red, green, blue, alpha];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 4))) as Color;
  }
}

extension type ColorInformation(JSObject _self) implements JSObject {
  external Color get color;
  external set color(Color value);
  external Range get range;
  external set range(Range value);
}

extension type ColorInformationCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  ColorInformation cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of ColorInformation');
    }
    return ColorInformation(value! as JSObject);
  }
  ColorInformation new$(Range range, Color color) {
    final args$ = <JSAny?>[range, color];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as ColorInformation;
  }
}

extension type ColorPresentation(JSObject _self) implements JSObject {
  external JSArray<TextEdit>? get additionalTextEdits;
  external set additionalTextEdits(JSArray<TextEdit>? value);
  external String get label;
  external set label(String value);
  external TextEdit? get textEdit;
  external set textEdit(TextEdit? value);
}

extension type ColorPresentationCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  ColorPresentation cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of ColorPresentation');
    }
    return ColorPresentation(value! as JSObject);
  }
  ColorPresentation new$(JSString label) {
    final args$ = <JSAny?>[label];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as ColorPresentation;
  }
}

extension type CompletionItem(JSObject _self) implements JSObject {
  external JSArray<TextEdit>? get additionalTextEdits;
  external set additionalTextEdits(JSArray<TextEdit>? value);
  external Command? get command;
  external set command(Command? value);
  external JSArray<JSString>? get commitCharacters;
  external set commitCharacters(JSArray<JSString>? value);
  external String? get detail;
  external set detail(String? value);
  external JSAny? get documentation;
  external set documentation(JSAny? value);
  external String? get filterText;
  external set filterText(String? value);
  external JSAny? get insertText;
  external set insertText(JSAny? value);
  external bool? get keepWhitespace;
  external set keepWhitespace(bool? value);
  external int? get kind;
  external set kind(int? value);
  external JSAny get label;
  external set label(JSAny value);
  external bool? get preselect;
  external set preselect(bool? value);
  external JSObject? get range;
  external set range(JSObject? value);
  external String? get sortText;
  external set sortText(String? value);
  external JSArray<JSNumber>? get tags;
  external set tags(JSArray<JSNumber>? value);
  external TextEdit? get textEdit;
  external set textEdit(TextEdit? value);
}

extension type CompletionItemCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  CompletionItem cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of CompletionItem');
    }
    return CompletionItem(value! as JSObject);
  }
  CompletionItem new$(JSAny label, [JSNumber? kind]) {
    final args$ = <JSAny?>[label, kind];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as CompletionItem;
  }
}

extension type CompletionList<T extends JSAny?>(JSObject _self) implements JSObject {
  external bool? get isIncomplete;
  external set isIncomplete(bool? value);
  external JSArray<T> get items;
  external set items(JSArray<T> value);
}

extension type CompletionListCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  CompletionList<T> cast<T extends JSAny?>(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of CompletionList');
    }
    return CompletionList<T>(value! as JSObject);
  }
  CompletionList<T> new$<T extends JSAny?>([JSArray<T>? items, JSBoolean? isIncomplete]) {
    final args$ = <JSAny?>[items, isIncomplete];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 0))) as CompletionList<T>;
  }
}

extension type CustomExecution(JSObject _self) implements JSObject {
}

extension type CustomExecutionCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  CustomExecution cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of CustomExecution');
    }
    return CustomExecution(value! as JSObject);
  }
  CustomExecution new$(JSFunction callback) {
    final args$ = <JSAny?>[callback];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as CustomExecution;
  }
}

extension type DataTransfer(JSObject _self) implements JSObject {
  external void forEach(JSFunction callbackfn, [JSAny? thisArg]);
  external DataTransferItem? get(String mimeType);
  external void set(String mimeType, DataTransferItem value);
}

extension type DataTransferCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  DataTransfer cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of DataTransfer');
    }
    return DataTransfer(value! as JSObject);
  }
  DataTransfer new$() =>
      _self.callAsConstructorVarArgs<JSObject>(const [])
          as DataTransfer;
}

extension type DataTransferItem(JSObject _self) implements JSObject {
  external DataTransferFile? asFile();
  external JSPromise<JSString> asString();
  external JSAny? get value;
}

extension type DataTransferItemCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  DataTransferItem cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of DataTransferItem');
    }
    return DataTransferItem(value! as JSObject);
  }
  DataTransferItem new$(JSAny? value) {
    final args$ = <JSAny?>[value];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as DataTransferItem;
  }
}

extension type DebugAdapterExecutable(JSObject _self) implements JSObject {
  external JSArray<JSString> get args;
  external String get command;
  external DebugAdapterExecutableOptions? get options;
}

extension type DebugAdapterExecutableCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  DebugAdapterExecutable cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of DebugAdapterExecutable');
    }
    return DebugAdapterExecutable(value! as JSObject);
  }
  DebugAdapterExecutable new$(JSString command, [JSArray<JSString>? args, DebugAdapterExecutableOptions? options]) {
    final args$ = <JSAny?>[command, args, options];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as DebugAdapterExecutable;
  }
}

extension type DebugAdapterInlineImplementation(JSObject _self) implements JSObject {
}

extension type DebugAdapterInlineImplementationCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  DebugAdapterInlineImplementation cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of DebugAdapterInlineImplementation');
    }
    return DebugAdapterInlineImplementation(value! as JSObject);
  }
  DebugAdapterInlineImplementation new$(DebugAdapter implementation) {
    final args$ = <JSAny?>[implementation];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as DebugAdapterInlineImplementation;
  }
}

extension type DebugAdapterNamedPipeServer(JSObject _self) implements JSObject {
  external String get path;
}

extension type DebugAdapterNamedPipeServerCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  DebugAdapterNamedPipeServer cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of DebugAdapterNamedPipeServer');
    }
    return DebugAdapterNamedPipeServer(value! as JSObject);
  }
  DebugAdapterNamedPipeServer new$(JSString path) {
    final args$ = <JSAny?>[path];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as DebugAdapterNamedPipeServer;
  }
}

extension type DebugAdapterServer(JSObject _self) implements JSObject {
  external String? get host;
  external num get port;
}

extension type DebugAdapterServerCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  DebugAdapterServer cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of DebugAdapterServer');
    }
    return DebugAdapterServer(value! as JSObject);
  }
  DebugAdapterServer new$(JSNumber port, [JSString? host]) {
    final args$ = <JSAny?>[port, host];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as DebugAdapterServer;
  }
}

extension type DebugStackFrame(JSObject _self) implements JSObject {
  external num get frameId;
  external DebugSession get session;
  external num get threadId;
}

extension type DebugStackFrameCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  DebugStackFrame cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of DebugStackFrame');
    }
    return DebugStackFrame(value! as JSObject);
  }
  DebugStackFrame new$() =>
      _self.callAsConstructorVarArgs<JSObject>(const [])
          as DebugStackFrame;
}

extension type DebugThread(JSObject _self) implements JSObject {
  external DebugSession get session;
  external num get threadId;
}

extension type DebugThreadCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  DebugThread cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of DebugThread');
    }
    return DebugThread(value! as JSObject);
  }
  DebugThread new$() =>
      _self.callAsConstructorVarArgs<JSObject>(const [])
          as DebugThread;
}

extension type DeclarationCoverage(JSObject _self) implements JSObject {
  external JSAny get executed;
  external set executed(JSAny value);
  external JSObject get location;
  external set location(JSObject value);
  external String get name;
  external set name(String value);
}

extension type DeclarationCoverageCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  DeclarationCoverage cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of DeclarationCoverage');
    }
    return DeclarationCoverage(value! as JSObject);
  }
  DeclarationCoverage new$(JSString name, JSAny executed, JSObject location) {
    final args$ = <JSAny?>[name, executed, location];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 3))) as DeclarationCoverage;
  }
}

extension type Diagnostic(JSObject _self) implements JSObject {
  external JSAny? get code;
  external set code(JSAny? value);
  external String get message;
  external set message(String value);
  external Range get range;
  external set range(Range value);
  external JSArray<DiagnosticRelatedInformation>? get relatedInformation;
  external set relatedInformation(JSArray<DiagnosticRelatedInformation>? value);
  external int get severity;
  external set severity(int value);
  external String? get source;
  external set source(String? value);
  external JSArray<JSNumber>? get tags;
  external set tags(JSArray<JSNumber>? value);
}

extension type DiagnosticCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  Diagnostic cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of Diagnostic');
    }
    return Diagnostic(value! as JSObject);
  }
  Diagnostic new$(Range range, JSString message, [JSNumber? severity]) {
    final args$ = <JSAny?>[range, message, severity];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as Diagnostic;
  }
}

extension type DiagnosticRelatedInformation(JSObject _self) implements JSObject {
  external Location get location;
  external set location(Location value);
  external String get message;
  external set message(String value);
}

extension type DiagnosticRelatedInformationCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  DiagnosticRelatedInformation cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of DiagnosticRelatedInformation');
    }
    return DiagnosticRelatedInformation(value! as JSObject);
  }
  DiagnosticRelatedInformation new$(Location location, JSString message) {
    final args$ = <JSAny?>[location, message];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as DiagnosticRelatedInformation;
  }
}

extension type Disposable(JSObject _self) implements JSObject {
  external JSAny? dispose();
}

extension type DisposableCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  Disposable cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of Disposable');
    }
    return Disposable(value! as JSObject);
  }
  Disposable new$(JSFunction callOnDispose) {
    final args$ = <JSAny?>[callOnDispose];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as Disposable;
  }
  Disposable from([List<JSAny?> disposableLikes = const []]) {
    final args$ = <JSAny?>[...disposableLikes];
    return _self.callMethodVarArgs<Disposable>('from'.toJS, args$.sublist(0, args$.length));
  }
}

extension type DocumentDropEdit(JSObject _self) implements JSObject {
  external WorkspaceEdit? get additionalEdit;
  external set additionalEdit(WorkspaceEdit? value);
  external JSAny get insertText;
  external set insertText(JSAny value);
  external DocumentDropOrPasteEditKind? get kind;
  external set kind(DocumentDropOrPasteEditKind? value);
  external String? get title;
  external set title(String? value);
  external JSArray<DocumentDropOrPasteEditKind>? get yieldTo;
  external set yieldTo(JSArray<DocumentDropOrPasteEditKind>? value);
}

extension type DocumentDropEditCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  DocumentDropEdit cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of DocumentDropEdit');
    }
    return DocumentDropEdit(value! as JSObject);
  }
  DocumentDropEdit new$(JSAny insertText, [JSString? title, DocumentDropOrPasteEditKind? kind]) {
    final args$ = <JSAny?>[insertText, title, kind];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as DocumentDropEdit;
  }
}

extension type DocumentDropOrPasteEditKind(JSObject _self) implements JSObject {
  DocumentDropOrPasteEditKind append([List<JSAny?> parts = const []]) {
    final args$ = <JSAny?>[...parts];
    return _self.callMethodVarArgs<DocumentDropOrPasteEditKind>('append'.toJS, args$.sublist(0, args$.length));
  }
  external bool contains(DocumentDropOrPasteEditKind other);
  external bool intersects(DocumentDropOrPasteEditKind other);
  external String get value;
}

extension type DocumentDropOrPasteEditKindCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  DocumentDropOrPasteEditKind cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of DocumentDropOrPasteEditKind');
    }
    return DocumentDropOrPasteEditKind(value! as JSObject);
  }
  DocumentDropOrPasteEditKind new$() =>
      _self.callAsConstructorVarArgs<JSObject>(const [])
          as DocumentDropOrPasteEditKind;
  external DocumentDropOrPasteEditKind get Empty;
  external DocumentDropOrPasteEditKind get Text;
  external DocumentDropOrPasteEditKind get TextUpdateImports;
}

extension type DocumentHighlight(JSObject _self) implements JSObject {
  external int? get kind;
  external set kind(int? value);
  external Range get range;
  external set range(Range value);
}

extension type DocumentHighlightCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  DocumentHighlight cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of DocumentHighlight');
    }
    return DocumentHighlight(value! as JSObject);
  }
  DocumentHighlight new$(Range range, [JSNumber? kind]) {
    final args$ = <JSAny?>[range, kind];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as DocumentHighlight;
  }
}

extension type DocumentLink(JSObject _self) implements JSObject {
  external Range get range;
  external set range(Range value);
  external Uri? get target;
  external set target(Uri? value);
  external String? get tooltip;
  external set tooltip(String? value);
}

extension type DocumentLinkCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  DocumentLink cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of DocumentLink');
    }
    return DocumentLink(value! as JSObject);
  }
  DocumentLink new$(Range range, [Uri? target]) {
    final args$ = <JSAny?>[range, target];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as DocumentLink;
  }
}

extension type DocumentPasteEdit(JSObject _self) implements JSObject {
  external WorkspaceEdit? get additionalEdit;
  external set additionalEdit(WorkspaceEdit? value);
  external JSAny get insertText;
  external set insertText(JSAny value);
  external DocumentDropOrPasteEditKind get kind;
  external set kind(DocumentDropOrPasteEditKind value);
  external String get title;
  external set title(String value);
  external JSArray<DocumentDropOrPasteEditKind>? get yieldTo;
  external set yieldTo(JSArray<DocumentDropOrPasteEditKind>? value);
}

extension type DocumentPasteEditCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  DocumentPasteEdit cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of DocumentPasteEdit');
    }
    return DocumentPasteEdit(value! as JSObject);
  }
  DocumentPasteEdit new$(JSAny insertText, JSString title, DocumentDropOrPasteEditKind kind) {
    final args$ = <JSAny?>[insertText, title, kind];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 3))) as DocumentPasteEdit;
  }
}

extension type DocumentSymbol(JSObject _self) implements JSObject {
  external JSArray<DocumentSymbol> get children;
  external set children(JSArray<DocumentSymbol> value);
  external String get detail;
  external set detail(String value);
  external int get kind;
  external set kind(int value);
  external String get name;
  external set name(String value);
  external Range get range;
  external set range(Range value);
  external Range get selectionRange;
  external set selectionRange(Range value);
  external JSArray<JSNumber>? get tags;
  external set tags(JSArray<JSNumber>? value);
}

extension type DocumentSymbolCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  DocumentSymbol cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of DocumentSymbol');
    }
    return DocumentSymbol(value! as JSObject);
  }
  DocumentSymbol new$(JSString name, JSString detail, JSNumber kind, Range range, Range selectionRange) {
    final args$ = <JSAny?>[name, detail, kind, range, selectionRange];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 5))) as DocumentSymbol;
  }
}

extension type EvaluatableExpression(JSObject _self) implements JSObject {
  external String? get expression;
  external Range get range;
}

extension type EvaluatableExpressionCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  EvaluatableExpression cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of EvaluatableExpression');
    }
    return EvaluatableExpression(value! as JSObject);
  }
  EvaluatableExpression new$(Range range, [JSString? expression]) {
    final args$ = <JSAny?>[range, expression];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as EvaluatableExpression;
  }
}

extension type EventEmitter<T extends JSAny?>(JSObject _self) implements JSObject {
  external void dispose();
  external Event<T> get event;
  external set event(Event<T> value);
  external void fire(T data);
}

extension type EventEmitterCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  EventEmitter<T> cast<T extends JSAny?>(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of EventEmitter');
    }
    return EventEmitter<T>(value! as JSObject);
  }
  EventEmitter<T> new$<T extends JSAny?>() =>
      _self.callAsConstructorVarArgs<JSObject>(const [])
          as EventEmitter<T>;
}

extension type FileCoverage(JSObject _self) implements JSObject {
  external TestCoverageCount? get branchCoverage;
  external set branchCoverage(TestCoverageCount? value);
  external TestCoverageCount? get declarationCoverage;
  external set declarationCoverage(TestCoverageCount? value);
  external JSArray<TestItem>? get includesTests;
  external set includesTests(JSArray<TestItem>? value);
  external TestCoverageCount get statementCoverage;
  external set statementCoverage(TestCoverageCount value);
  external Uri get uri;
}

extension type FileCoverageCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  FileCoverage cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of FileCoverage');
    }
    return FileCoverage(value! as JSObject);
  }
  FileCoverage new$(Uri uri, TestCoverageCount statementCoverage, [TestCoverageCount? branchCoverage, TestCoverageCount? declarationCoverage, JSArray<TestItem>? includesTests]) {
    final args$ = <JSAny?>[uri, statementCoverage, branchCoverage, declarationCoverage, includesTests];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as FileCoverage;
  }
  external FileCoverage fromDetails(Uri uri, JSArray<JSObject> details);
}

extension type FileDecoration(JSObject _self) implements JSObject {
  external String? get badge;
  external set badge(String? value);
  external ThemeColor? get color;
  external set color(ThemeColor? value);
  external bool? get propagate;
  external set propagate(bool? value);
  external String? get tooltip;
  external set tooltip(String? value);
}

extension type FileDecorationCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  FileDecoration cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of FileDecoration');
    }
    return FileDecoration(value! as JSObject);
  }
  FileDecoration new$([JSString? badge, JSString? tooltip, ThemeColor? color]) {
    final args$ = <JSAny?>[badge, tooltip, color];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 0))) as FileDecoration;
  }
}

extension type FileSystemError(JSObject _self) implements JSObject {
  external String get code;
}

extension type FileSystemErrorCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  FileSystemError cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of FileSystemError');
    }
    return FileSystemError(value! as JSObject);
  }
  external FileSystemError FileExists([JSAny? messageOrUri]);
  external FileSystemError FileIsADirectory([JSAny? messageOrUri]);
  external FileSystemError FileNotADirectory([JSAny? messageOrUri]);
  external FileSystemError FileNotFound([JSAny? messageOrUri]);
  external FileSystemError NoPermissions([JSAny? messageOrUri]);
  external FileSystemError Unavailable([JSAny? messageOrUri]);
  FileSystemError new$([JSAny? messageOrUri]) {
    final args$ = <JSAny?>[messageOrUri];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 0))) as FileSystemError;
  }
}

extension type FoldingRange(JSObject _self) implements JSObject {
  external num get end;
  external set end(num value);
  external int? get kind;
  external set kind(int? value);
  external num get start;
  external set start(num value);
}

extension type FoldingRangeCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  FoldingRange cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of FoldingRange');
    }
    return FoldingRange(value! as JSObject);
  }
  FoldingRange new$(JSNumber start, JSNumber end, [JSNumber? kind]) {
    final args$ = <JSAny?>[start, end, kind];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as FoldingRange;
  }
}

extension type FunctionBreakpoint(JSObject _self) implements Breakpoint, JSObject {
  external String get functionName;
}

extension type FunctionBreakpointCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  FunctionBreakpoint cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of FunctionBreakpoint');
    }
    return FunctionBreakpoint(value! as JSObject);
  }
  FunctionBreakpoint new$(JSString functionName, [JSBoolean? enabled, JSString? condition, JSString? hitCondition, JSString? logMessage]) {
    final args$ = <JSAny?>[functionName, enabled, condition, hitCondition, logMessage];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as FunctionBreakpoint;
  }
}

extension type Hover(JSObject _self) implements JSObject {
  external JSArray<JSAny> get contents;
  external set contents(JSArray<JSAny> value);
  external Range? get range;
  external set range(Range? value);
}

extension type HoverCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  Hover cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of Hover');
    }
    return Hover(value! as JSObject);
  }
  Hover new$(JSAny contents, [Range? range]) {
    final args$ = <JSAny?>[contents, range];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as Hover;
  }
}

extension type InlayHint(JSObject _self) implements JSObject {
  external int? get kind;
  external set kind(int? value);
  external JSAny get label;
  external set label(JSAny value);
  external bool? get paddingLeft;
  external set paddingLeft(bool? value);
  external bool? get paddingRight;
  external set paddingRight(bool? value);
  external Position get position;
  external set position(Position value);
  external JSArray<TextEdit>? get textEdits;
  external set textEdits(JSArray<TextEdit>? value);
  external JSAny? get tooltip;
  external set tooltip(JSAny? value);
}

extension type InlayHintCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  InlayHint cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of InlayHint');
    }
    return InlayHint(value! as JSObject);
  }
  InlayHint new$(Position position, JSAny label, [JSNumber? kind]) {
    final args$ = <JSAny?>[position, label, kind];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as InlayHint;
  }
}

extension type InlayHintLabelPart(JSObject _self) implements JSObject {
  external Command? get command;
  external set command(Command? value);
  external Location? get location;
  external set location(Location? value);
  external JSAny? get tooltip;
  external set tooltip(JSAny? value);
  external String get value;
  external set value(String value);
}

extension type InlayHintLabelPartCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  InlayHintLabelPart cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of InlayHintLabelPart');
    }
    return InlayHintLabelPart(value! as JSObject);
  }
  InlayHintLabelPart new$(JSString value) {
    final args$ = <JSAny?>[value];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as InlayHintLabelPart;
  }
}

extension type InlineCompletionItem(JSObject _self) implements JSObject {
  external Command? get command;
  external set command(Command? value);
  external String? get filterText;
  external set filterText(String? value);
  external JSAny get insertText;
  external set insertText(JSAny value);
  external Range? get range;
  external set range(Range? value);
}

extension type InlineCompletionItemCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  InlineCompletionItem cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of InlineCompletionItem');
    }
    return InlineCompletionItem(value! as JSObject);
  }
  InlineCompletionItem new$(JSAny insertText, [Range? range, Command? command]) {
    final args$ = <JSAny?>[insertText, range, command];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as InlineCompletionItem;
  }
}

extension type InlineCompletionList(JSObject _self) implements JSObject {
  external JSArray<InlineCompletionItem> get items;
  external set items(JSArray<InlineCompletionItem> value);
}

extension type InlineCompletionListCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  InlineCompletionList cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of InlineCompletionList');
    }
    return InlineCompletionList(value! as JSObject);
  }
  InlineCompletionList new$(JSArray<InlineCompletionItem> items) {
    final args$ = <JSAny?>[items];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as InlineCompletionList;
  }
}

extension type InlineValueEvaluatableExpression(JSObject _self) implements JSObject {
  external String? get expression;
  external Range get range;
}

extension type InlineValueEvaluatableExpressionCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  InlineValueEvaluatableExpression cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of InlineValueEvaluatableExpression');
    }
    return InlineValueEvaluatableExpression(value! as JSObject);
  }
  InlineValueEvaluatableExpression new$(Range range, [JSString? expression]) {
    final args$ = <JSAny?>[range, expression];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as InlineValueEvaluatableExpression;
  }
}

extension type InlineValueText(JSObject _self) implements JSObject {
  external Range get range;
  external String get text;
}

extension type InlineValueTextCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  InlineValueText cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of InlineValueText');
    }
    return InlineValueText(value! as JSObject);
  }
  InlineValueText new$(Range range, JSString text) {
    final args$ = <JSAny?>[range, text];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as InlineValueText;
  }
}

extension type InlineValueVariableLookup(JSObject _self) implements JSObject {
  external bool get caseSensitiveLookup;
  external Range get range;
  external String? get variableName;
}

extension type InlineValueVariableLookupCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  InlineValueVariableLookup cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of InlineValueVariableLookup');
    }
    return InlineValueVariableLookup(value! as JSObject);
  }
  InlineValueVariableLookup new$(Range range, [JSString? variableName, JSBoolean? caseSensitiveLookup]) {
    final args$ = <JSAny?>[range, variableName, caseSensitiveLookup];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as InlineValueVariableLookup;
  }
}

extension type LanguageModelChatMessage(JSObject _self) implements JSObject {
  external JSArray<JSObject> get content;
  external set content(JSArray<JSObject> value);
  external String? get name;
  external set name(String? value);
  external int get role;
  external set role(int value);
}

extension type LanguageModelChatMessageCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  LanguageModelChatMessage cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of LanguageModelChatMessage');
    }
    return LanguageModelChatMessage(value! as JSObject);
  }
  external LanguageModelChatMessage Assistant(JSAny content, [String? name]);
  external LanguageModelChatMessage User(JSAny content, [String? name]);
  LanguageModelChatMessage new$(JSNumber role, JSAny content, [JSString? name]) {
    final args$ = <JSAny?>[role, content, name];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as LanguageModelChatMessage;
  }
}

extension type LanguageModelDataPart(JSObject _self) implements JSObject {
  external JSUint8Array get data;
  external set data(JSUint8Array value);
  external String get mimeType;
  external set mimeType(String value);
}

extension type LanguageModelDataPartCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  LanguageModelDataPart cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of LanguageModelDataPart');
    }
    return LanguageModelDataPart(value! as JSObject);
  }
  LanguageModelDataPart new$(JSUint8Array data, JSString mimeType) {
    final args$ = <JSAny?>[data, mimeType];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as LanguageModelDataPart;
  }
  external LanguageModelDataPart image(JSUint8Array data, String mime);
  external LanguageModelDataPart json(JSAny? value, [String? mime]);
  external LanguageModelDataPart text(String value, [String? mime]);
}

extension type LanguageModelError(JSObject _self) implements JSObject {
  external String get code;
}

extension type LanguageModelErrorCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  LanguageModelError cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of LanguageModelError');
    }
    return LanguageModelError(value! as JSObject);
  }
  LanguageModelError new$() =>
      _self.callAsConstructorVarArgs<JSObject>(const [])
          as LanguageModelError;
  external LanguageModelError Blocked([String? message]);
  external LanguageModelError NoPermissions([String? message]);
  external LanguageModelError NotFound([String? message]);
}

extension type LanguageModelPromptTsxPart(JSObject _self) implements JSObject {
  external JSAny? get value;
  external set value(JSAny? value);
}

extension type LanguageModelPromptTsxPartCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  LanguageModelPromptTsxPart cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of LanguageModelPromptTsxPart');
    }
    return LanguageModelPromptTsxPart(value! as JSObject);
  }
  LanguageModelPromptTsxPart new$(JSAny? value) {
    final args$ = <JSAny?>[value];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as LanguageModelPromptTsxPart;
  }
}

extension type LanguageModelTextPart(JSObject _self) implements JSObject {
  external String get value;
  external set value(String value);
}

extension type LanguageModelTextPartCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  LanguageModelTextPart cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of LanguageModelTextPart');
    }
    return LanguageModelTextPart(value! as JSObject);
  }
  LanguageModelTextPart new$(JSString value) {
    final args$ = <JSAny?>[value];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as LanguageModelTextPart;
  }
}

extension type LanguageModelToolCallPart(JSObject _self) implements JSObject {
  external String get callId;
  external set callId(String value);
  external JSObject get input;
  external set input(JSObject value);
  external String get name;
  external set name(String value);
}

extension type LanguageModelToolCallPartCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  LanguageModelToolCallPart cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of LanguageModelToolCallPart');
    }
    return LanguageModelToolCallPart(value! as JSObject);
  }
  LanguageModelToolCallPart new$(JSString callId, JSString name, JSObject input) {
    final args$ = <JSAny?>[callId, name, input];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 3))) as LanguageModelToolCallPart;
  }
}

extension type LanguageModelToolResult(JSObject _self) implements JSObject {
  external JSArray<JSAny> get content;
  external set content(JSArray<JSAny> value);
}

extension type LanguageModelToolResultCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  LanguageModelToolResult cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of LanguageModelToolResult');
    }
    return LanguageModelToolResult(value! as JSObject);
  }
  LanguageModelToolResult new$(JSArray<JSAny> content) {
    final args$ = <JSAny?>[content];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as LanguageModelToolResult;
  }
}

extension type LanguageModelToolResultPart(JSObject _self) implements JSObject {
  external String get callId;
  external set callId(String value);
  external JSArray<JSAny> get content;
  external set content(JSArray<JSAny> value);
}

extension type LanguageModelToolResultPartCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  LanguageModelToolResultPart cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of LanguageModelToolResultPart');
    }
    return LanguageModelToolResultPart(value! as JSObject);
  }
  LanguageModelToolResultPart new$(JSString callId, JSArray<JSAny> content) {
    final args$ = <JSAny?>[callId, content];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as LanguageModelToolResultPart;
  }
}

extension type LinkedEditingRanges(JSObject _self) implements JSObject {
  external JSArray<Range> get ranges;
  external JSObject? get wordPattern;
}

extension type LinkedEditingRangesCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  LinkedEditingRanges cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of LinkedEditingRanges');
    }
    return LinkedEditingRanges(value! as JSObject);
  }
  LinkedEditingRanges new$(JSArray<Range> ranges, [JSObject? wordPattern]) {
    final args$ = <JSAny?>[ranges, wordPattern];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as LinkedEditingRanges;
  }
}

extension type Location(JSObject _self) implements JSObject {
  external Range get range;
  external set range(Range value);
  external Uri get uri;
  external set uri(Uri value);
}

extension type LocationCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  Location cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of Location');
    }
    return Location(value! as JSObject);
  }
  Location new$(Uri uri, JSObject rangeOrPosition) {
    final args$ = <JSAny?>[uri, rangeOrPosition];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as Location;
  }
}

extension type MarkdownString(JSObject _self) implements JSObject {
  external MarkdownString appendCodeblock(String value, [String? language]);
  external MarkdownString appendMarkdown(String value);
  external MarkdownString appendText(String value);
  external Uri? get baseUri;
  external set baseUri(Uri? value);
  external JSAny? get isTrusted;
  external set isTrusted(JSAny? value);
  external bool? get supportHtml;
  external set supportHtml(bool? value);
  external bool? get supportThemeIcons;
  external set supportThemeIcons(bool? value);
  external String get value;
  external set value(String value);
}

extension type MarkdownStringCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  MarkdownString cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of MarkdownString');
    }
    return MarkdownString(value! as JSObject);
  }
  MarkdownString new$([JSString? value, JSBoolean? supportThemeIcons]) {
    final args$ = <JSAny?>[value, supportThemeIcons];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 0))) as MarkdownString;
  }
}

extension type McpHttpServerDefinition(JSObject _self) implements JSObject {
  external JSObject get headers;
  external set headers(JSObject value);
  external String get label;
  external Uri get uri;
  external set uri(Uri value);
  external String? get version;
  external set version(String? value);
}

extension type McpHttpServerDefinitionCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  McpHttpServerDefinition cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of McpHttpServerDefinition');
    }
    return McpHttpServerDefinition(value! as JSObject);
  }
  McpHttpServerDefinition new$(JSString label, Uri uri, [JSObject? headers, JSString? version]) {
    final args$ = <JSAny?>[label, uri, headers, version];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as McpHttpServerDefinition;
  }
}

extension type McpStdioServerDefinition(JSObject _self) implements JSObject {
  external JSArray<JSString> get args;
  external set args(JSArray<JSString> value);
  external String get command;
  external set command(String value);
  external Uri? get cwd;
  external set cwd(Uri? value);
  external JSObject get env;
  external set env(JSObject value);
  external String get label;
  external String? get version;
  external set version(String? value);
}

extension type McpStdioServerDefinitionCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  McpStdioServerDefinition cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of McpStdioServerDefinition');
    }
    return McpStdioServerDefinition(value! as JSObject);
  }
  McpStdioServerDefinition new$(JSString label, JSString command, [JSArray<JSString>? args, JSObject? env, JSString? version]) {
    final args$ = <JSAny?>[label, command, args, env, version];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as McpStdioServerDefinition;
  }
}

extension type NotebookCellData(JSObject _self) implements JSObject {
  external NotebookCellExecutionSummary? get executionSummary;
  external set executionSummary(NotebookCellExecutionSummary? value);
  external int get kind;
  external set kind(int value);
  external String get languageId;
  external set languageId(String value);
  external JSAnon_90b1eaa702e4? get metadata;
  external set metadata(JSAnon_90b1eaa702e4? value);
  external JSArray<NotebookCellOutput>? get outputs;
  external set outputs(JSArray<NotebookCellOutput>? value);
  external String get value;
  external set value(String value);
}

extension type NotebookCellDataCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  NotebookCellData cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of NotebookCellData');
    }
    return NotebookCellData(value! as JSObject);
  }
  NotebookCellData new$(JSNumber kind, JSString value, JSString languageId) {
    final args$ = <JSAny?>[kind, value, languageId];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 3))) as NotebookCellData;
  }
}

extension type NotebookCellOutput(JSObject _self) implements JSObject {
  external JSArray<NotebookCellOutputItem> get items;
  external set items(JSArray<NotebookCellOutputItem> value);
  external JSAnon_90b1eaa702e4? get metadata;
  external set metadata(JSAnon_90b1eaa702e4? value);
}

extension type NotebookCellOutputCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  NotebookCellOutput cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of NotebookCellOutput');
    }
    return NotebookCellOutput(value! as JSObject);
  }
  NotebookCellOutput new$(JSArray<NotebookCellOutputItem> items, [JSAnon_90b1eaa702e4? metadata]) {
    final args$ = <JSAny?>[items, metadata];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as NotebookCellOutput;
  }
}

extension type NotebookCellOutputItem(JSObject _self) implements JSObject {
  external JSUint8Array get data;
  external set data(JSUint8Array value);
  external String get mime;
  external set mime(String value);
}

extension type NotebookCellOutputItemCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  NotebookCellOutputItem cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of NotebookCellOutputItem');
    }
    return NotebookCellOutputItem(value! as JSObject);
  }
  NotebookCellOutputItem new$(JSUint8Array data, JSString mime) {
    final args$ = <JSAny?>[data, mime];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as NotebookCellOutputItem;
  }
  external NotebookCellOutputItem error(JSObject value);
  external NotebookCellOutputItem json(JSAny? value, [String? mime]);
  external NotebookCellOutputItem stderr(String value);
  external NotebookCellOutputItem stdout(String value);
  external NotebookCellOutputItem text(String value, [String? mime]);
}

extension type NotebookCellStatusBarItem(JSObject _self) implements JSObject {
  external AccessibilityInformation? get accessibilityInformation;
  external set accessibilityInformation(AccessibilityInformation? value);
  external int get alignment;
  external set alignment(int value);
  external JSAny? get command;
  external set command(JSAny? value);
  external num? get priority;
  external set priority(num? value);
  external String get text;
  external set text(String value);
  external String? get tooltip;
  external set tooltip(String? value);
}

extension type NotebookCellStatusBarItemCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  NotebookCellStatusBarItem cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of NotebookCellStatusBarItem');
    }
    return NotebookCellStatusBarItem(value! as JSObject);
  }
  NotebookCellStatusBarItem new$(JSString text, JSNumber alignment) {
    final args$ = <JSAny?>[text, alignment];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as NotebookCellStatusBarItem;
  }
}

extension type NotebookData(JSObject _self) implements JSObject {
  external JSArray<NotebookCellData> get cells;
  external set cells(JSArray<NotebookCellData> value);
  external JSAnon_90b1eaa702e4? get metadata;
  external set metadata(JSAnon_90b1eaa702e4? value);
}

extension type NotebookDataCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  NotebookData cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of NotebookData');
    }
    return NotebookData(value! as JSObject);
  }
  NotebookData new$(JSArray<NotebookCellData> cells) {
    final args$ = <JSAny?>[cells];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as NotebookData;
  }
}

extension type NotebookEdit(JSObject _self) implements JSObject {
  external JSAnon_90b1eaa702e4? get newCellMetadata;
  external set newCellMetadata(JSAnon_90b1eaa702e4? value);
  external JSArray<NotebookCellData> get newCells;
  external set newCells(JSArray<NotebookCellData> value);
  external JSAnon_90b1eaa702e4? get newNotebookMetadata;
  external set newNotebookMetadata(JSAnon_90b1eaa702e4? value);
  external NotebookRange get range;
  external set range(NotebookRange value);
}

extension type NotebookEditCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  NotebookEdit cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of NotebookEdit');
    }
    return NotebookEdit(value! as JSObject);
  }
  NotebookEdit new$(NotebookRange range, JSArray<NotebookCellData> newCells) {
    final args$ = <JSAny?>[range, newCells];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as NotebookEdit;
  }
  external NotebookEdit deleteCells(NotebookRange range);
  external NotebookEdit insertCells(num index, JSArray<NotebookCellData> newCells);
  external NotebookEdit replaceCells(NotebookRange range, JSArray<NotebookCellData> newCells);
  external NotebookEdit updateCellMetadata(num index, JSAnon_90b1eaa702e4 newCellMetadata);
  external NotebookEdit updateNotebookMetadata(JSAnon_90b1eaa702e4 newNotebookMetadata);
}

extension type NotebookRange(JSObject _self) implements JSObject {
  external num get end;
  external bool get isEmpty;
  external num get start;
  @JS('with')
  external NotebookRange with$(JSAnon_d702e8e12ae8 change);
}

extension type NotebookRangeCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  NotebookRange cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of NotebookRange');
    }
    return NotebookRange(value! as JSObject);
  }
  NotebookRange new$(JSNumber start, JSNumber end) {
    final args$ = <JSAny?>[start, end];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as NotebookRange;
  }
}

extension type ParameterInformation(JSObject _self) implements JSObject {
  external JSAny? get documentation;
  external set documentation(JSAny? value);
  external JSAny get label;
  external set label(JSAny value);
}

extension type ParameterInformationCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  ParameterInformation cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of ParameterInformation');
    }
    return ParameterInformation(value! as JSObject);
  }
  ParameterInformation new$(JSAny label, [JSAny? documentation]) {
    final args$ = <JSAny?>[label, documentation];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as ParameterInformation;
  }
}

extension type Position(JSObject _self) implements JSObject {
  external num get character;
  external num compareTo(Position other);
  external bool isAfter(Position other);
  external bool isAfterOrEqual(Position other);
  external bool isBefore(Position other);
  external bool isBeforeOrEqual(Position other);
  external bool isEqual(Position other);
  external num get line;
  external Position translate([num? lineDelta, num? characterDelta]);
  @JS('translate')
  external Position translate$2(JSAnon_5687bad38499 change);
  @JS('with')
  external Position with$([num? line, num? character]);
  @JS('with')
  external Position with$$2(JSAnon_91ec0d04130c change);
}

extension type PositionCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  Position cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of Position');
    }
    return Position(value! as JSObject);
  }
  Position new$(JSNumber line, JSNumber character) {
    final args$ = <JSAny?>[line, character];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as Position;
  }
}

extension type ProcessExecution(JSObject _self) implements JSObject {
  external JSArray<JSString> get args;
  external set args(JSArray<JSString> value);
  external ProcessExecutionOptions? get options;
  external set options(ProcessExecutionOptions? value);
  external String get process;
  external set process(String value);
}

extension type ProcessExecutionCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  ProcessExecution cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of ProcessExecution');
    }
    return ProcessExecution(value! as JSObject);
  }
  ProcessExecution new$(JSString process, [ProcessExecutionOptions? options]) {
    final args$ = <JSAny?>[process, options];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as ProcessExecution;
  }
  ProcessExecution new$$2(JSString process, JSArray<JSString> args, [ProcessExecutionOptions? options]) {
    final args$ = <JSAny?>[process, args, options];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as ProcessExecution;
  }
}

extension type QuickInputButtons(JSObject _self) implements JSObject {
}

extension type QuickInputButtonsCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  QuickInputButtons cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of QuickInputButtons');
    }
    return QuickInputButtons(value! as JSObject);
  }
  QuickInputButtons new$() =>
      _self.callAsConstructorVarArgs<JSObject>(const [])
          as QuickInputButtons;
  external QuickInputButton get Back;
}

extension type Range(JSObject _self) implements JSObject {
  external bool contains(JSObject positionOrRange);
  external Position get end;
  external Range? intersection(Range range);
  external bool get isEmpty;
  external set isEmpty(bool value);
  external bool isEqual(Range other);
  external bool get isSingleLine;
  external set isSingleLine(bool value);
  external Position get start;
  external Range union(Range other);
  @JS('with')
  external Range with$([Position? start, Position? end]);
  @JS('with')
  external Range with$$2(JSAnon_471b06108965 change);
}

extension type RangeCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  Range cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of Range');
    }
    return Range(value! as JSObject);
  }
  Range new$(Position start, Position end) {
    final args$ = <JSAny?>[start, end];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as Range;
  }
  Range new$$2(JSNumber startLine, JSNumber startCharacter, JSNumber endLine, JSNumber endCharacter) {
    final args$ = <JSAny?>[startLine, startCharacter, endLine, endCharacter];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 4))) as Range;
  }
}

extension type RelativePattern(JSObject _self) implements JSObject {
  external String get base;
  external set base(String value);
  external Uri get baseUri;
  external set baseUri(Uri value);
  external String get pattern;
  external set pattern(String value);
}

extension type RelativePatternCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  RelativePattern cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of RelativePattern');
    }
    return RelativePattern(value! as JSObject);
  }
  RelativePattern new$(JSAny base, JSString pattern) {
    final args$ = <JSAny?>[base, pattern];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as RelativePattern;
  }
}

extension type Selection(JSObject _self) implements Range, JSObject {
  external Position get active;
  external Position get anchor;
  external bool get isReversed;
}

extension type SelectionCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  Selection cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of Selection');
    }
    return Selection(value! as JSObject);
  }
  Selection new$(Position anchor, Position active) {
    final args$ = <JSAny?>[anchor, active];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as Selection;
  }
  Selection new$$2(JSNumber anchorLine, JSNumber anchorCharacter, JSNumber activeLine, JSNumber activeCharacter) {
    final args$ = <JSAny?>[anchorLine, anchorCharacter, activeLine, activeCharacter];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 4))) as Selection;
  }
}

extension type SelectionRange(JSObject _self) implements JSObject {
  external SelectionRange? get parent;
  external set parent(SelectionRange? value);
  external Range get range;
  external set range(Range value);
}

extension type SelectionRangeCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  SelectionRange cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of SelectionRange');
    }
    return SelectionRange(value! as JSObject);
  }
  SelectionRange new$(Range range, [SelectionRange? parent]) {
    final args$ = <JSAny?>[range, parent];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as SelectionRange;
  }
}

extension type SemanticTokens(JSObject _self) implements JSObject {
  external JSUint32Array get data;
  external String? get resultId;
}

extension type SemanticTokensCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  SemanticTokens cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of SemanticTokens');
    }
    return SemanticTokens(value! as JSObject);
  }
  SemanticTokens new$(JSUint32Array data, [JSString? resultId]) {
    final args$ = <JSAny?>[data, resultId];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as SemanticTokens;
  }
}

extension type SemanticTokensBuilder(JSObject _self) implements JSObject {
  external SemanticTokens build([String? resultId]);
  external void push(num line, num char, num length, num tokenType, [num? tokenModifiers]);
  @JS('push')
  external void push$2(Range range, String tokenType, [JSArray<JSString>? tokenModifiers]);
}

extension type SemanticTokensBuilderCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  SemanticTokensBuilder cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of SemanticTokensBuilder');
    }
    return SemanticTokensBuilder(value! as JSObject);
  }
  SemanticTokensBuilder new$([SemanticTokensLegend? legend]) {
    final args$ = <JSAny?>[legend];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 0))) as SemanticTokensBuilder;
  }
}

extension type SemanticTokensEdit(JSObject _self) implements JSObject {
  external JSUint32Array? get data;
  external num get deleteCount;
  external num get start;
}

extension type SemanticTokensEditCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  SemanticTokensEdit cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of SemanticTokensEdit');
    }
    return SemanticTokensEdit(value! as JSObject);
  }
  SemanticTokensEdit new$(JSNumber start, JSNumber deleteCount, [JSUint32Array? data]) {
    final args$ = <JSAny?>[start, deleteCount, data];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as SemanticTokensEdit;
  }
}

extension type SemanticTokensEdits(JSObject _self) implements JSObject {
  external JSArray<SemanticTokensEdit> get edits;
  external String? get resultId;
}

extension type SemanticTokensEditsCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  SemanticTokensEdits cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of SemanticTokensEdits');
    }
    return SemanticTokensEdits(value! as JSObject);
  }
  SemanticTokensEdits new$(JSArray<SemanticTokensEdit> edits, [JSString? resultId]) {
    final args$ = <JSAny?>[edits, resultId];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as SemanticTokensEdits;
  }
}

extension type SemanticTokensLegend(JSObject _self) implements JSObject {
  external JSArray<JSString> get tokenModifiers;
  external JSArray<JSString> get tokenTypes;
}

extension type SemanticTokensLegendCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  SemanticTokensLegend cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of SemanticTokensLegend');
    }
    return SemanticTokensLegend(value! as JSObject);
  }
  SemanticTokensLegend new$(JSArray<JSString> tokenTypes, [JSArray<JSString>? tokenModifiers]) {
    final args$ = <JSAny?>[tokenTypes, tokenModifiers];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as SemanticTokensLegend;
  }
}

extension type ShellExecution(JSObject _self) implements JSObject {
  external JSArray<JSAny>? get args;
  external set args(JSArray<JSAny>? value);
  external JSAny? get command;
  external set command(JSAny? value);
  external String? get commandLine;
  external set commandLine(String? value);
  external ShellExecutionOptions? get options;
  external set options(ShellExecutionOptions? value);
}

extension type ShellExecutionCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  ShellExecution cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of ShellExecution');
    }
    return ShellExecution(value! as JSObject);
  }
  ShellExecution new$(JSString commandLine, [ShellExecutionOptions? options]) {
    final args$ = <JSAny?>[commandLine, options];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as ShellExecution;
  }
  ShellExecution new$$2(JSAny command, JSArray<JSAny> args, [ShellExecutionOptions? options]) {
    final args$ = <JSAny?>[command, args, options];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as ShellExecution;
  }
}

extension type SignatureHelp(JSObject _self) implements JSObject {
  external num get activeParameter;
  external set activeParameter(num value);
  external num get activeSignature;
  external set activeSignature(num value);
  external JSArray<SignatureInformation> get signatures;
  external set signatures(JSArray<SignatureInformation> value);
}

extension type SignatureHelpCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  SignatureHelp cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of SignatureHelp');
    }
    return SignatureHelp(value! as JSObject);
  }
  SignatureHelp new$() =>
      _self.callAsConstructorVarArgs<JSObject>(const [])
          as SignatureHelp;
}

extension type SignatureInformation(JSObject _self) implements JSObject {
  external num? get activeParameter;
  external set activeParameter(num? value);
  external JSAny? get documentation;
  external set documentation(JSAny? value);
  external String get label;
  external set label(String value);
  external JSArray<ParameterInformation> get parameters;
  external set parameters(JSArray<ParameterInformation> value);
}

extension type SignatureInformationCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  SignatureInformation cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of SignatureInformation');
    }
    return SignatureInformation(value! as JSObject);
  }
  SignatureInformation new$(JSString label, [JSAny? documentation]) {
    final args$ = <JSAny?>[label, documentation];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as SignatureInformation;
  }
}

extension type SnippetString(JSObject _self) implements JSObject {
  external SnippetString appendChoice(JSArray<JSString> values, [num? number]);
  external SnippetString appendPlaceholder(JSAny value, [num? number]);
  external SnippetString appendTabstop([num? number]);
  external SnippetString appendText(String string);
  external SnippetString appendVariable(String name, JSAny defaultValue);
  external String get value;
  external set value(String value);
}

extension type SnippetStringCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  SnippetString cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of SnippetString');
    }
    return SnippetString(value! as JSObject);
  }
  SnippetString new$([JSString? value]) {
    final args$ = <JSAny?>[value];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 0))) as SnippetString;
  }
}

extension type SnippetTextEdit(JSObject _self) implements JSObject {
  external bool? get keepWhitespace;
  external set keepWhitespace(bool? value);
  external Range get range;
  external set range(Range value);
  external SnippetString get snippet;
  external set snippet(SnippetString value);
}

extension type SnippetTextEditCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  SnippetTextEdit cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of SnippetTextEdit');
    }
    return SnippetTextEdit(value! as JSObject);
  }
  SnippetTextEdit new$(Range range, SnippetString snippet) {
    final args$ = <JSAny?>[range, snippet];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as SnippetTextEdit;
  }
  external SnippetTextEdit insert(Position position, SnippetString snippet);
  external SnippetTextEdit replace(Range range, SnippetString snippet);
}

extension type SourceBreakpoint(JSObject _self) implements Breakpoint, JSObject {
  external Location get location;
}

extension type SourceBreakpointCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  SourceBreakpoint cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of SourceBreakpoint');
    }
    return SourceBreakpoint(value! as JSObject);
  }
  SourceBreakpoint new$(Location location, [JSBoolean? enabled, JSString? condition, JSString? hitCondition, JSString? logMessage]) {
    final args$ = <JSAny?>[location, enabled, condition, hitCondition, logMessage];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as SourceBreakpoint;
  }
}

extension type StatementCoverage(JSObject _self) implements JSObject {
  external JSArray<BranchCoverage> get branches;
  external set branches(JSArray<BranchCoverage> value);
  external JSAny get executed;
  external set executed(JSAny value);
  external JSObject get location;
  external set location(JSObject value);
}

extension type StatementCoverageCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  StatementCoverage cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of StatementCoverage');
    }
    return StatementCoverage(value! as JSObject);
  }
  StatementCoverage new$(JSAny executed, JSObject location, [JSArray<BranchCoverage>? branches]) {
    final args$ = <JSAny?>[executed, location, branches];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as StatementCoverage;
  }
}

extension type SymbolInformation(JSObject _self) implements JSObject {
  external String get containerName;
  external set containerName(String value);
  external int get kind;
  external set kind(int value);
  external Location get location;
  external set location(Location value);
  external String get name;
  external set name(String value);
  external JSArray<JSNumber>? get tags;
  external set tags(JSArray<JSNumber>? value);
}

extension type SymbolInformationCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  SymbolInformation cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of SymbolInformation');
    }
    return SymbolInformation(value! as JSObject);
  }
  SymbolInformation new$(JSString name, JSNumber kind, JSString containerName, Location location) {
    final args$ = <JSAny?>[name, kind, containerName, location];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 4))) as SymbolInformation;
  }
  SymbolInformation new$$2(JSString name, JSNumber kind, Range range, [Uri? uri, JSString? containerName]) {
    final args$ = <JSAny?>[name, kind, range, uri, containerName];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 3))) as SymbolInformation;
  }
}

extension type TabInputCustom(JSObject _self) implements JSObject {
  external Uri get uri;
  external String get viewType;
}

extension type TabInputCustomCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  TabInputCustom cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of TabInputCustom');
    }
    return TabInputCustom(value! as JSObject);
  }
  TabInputCustom new$(Uri uri, JSString viewType) {
    final args$ = <JSAny?>[uri, viewType];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as TabInputCustom;
  }
}

extension type TabInputNotebook(JSObject _self) implements JSObject {
  external String get notebookType;
  external Uri get uri;
}

extension type TabInputNotebookCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  TabInputNotebook cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of TabInputNotebook');
    }
    return TabInputNotebook(value! as JSObject);
  }
  TabInputNotebook new$(Uri uri, JSString notebookType) {
    final args$ = <JSAny?>[uri, notebookType];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as TabInputNotebook;
  }
}

extension type TabInputNotebookDiff(JSObject _self) implements JSObject {
  external Uri get modified;
  external String get notebookType;
  external Uri get original;
}

extension type TabInputNotebookDiffCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  TabInputNotebookDiff cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of TabInputNotebookDiff');
    }
    return TabInputNotebookDiff(value! as JSObject);
  }
  TabInputNotebookDiff new$(Uri original, Uri modified, JSString notebookType) {
    final args$ = <JSAny?>[original, modified, notebookType];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 3))) as TabInputNotebookDiff;
  }
}

extension type TabInputTerminal(JSObject _self) implements JSObject {
}

extension type TabInputTerminalCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  TabInputTerminal cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of TabInputTerminal');
    }
    return TabInputTerminal(value! as JSObject);
  }
  TabInputTerminal new$() {
    final args$ = <JSAny?>[];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 0))) as TabInputTerminal;
  }
}

extension type TabInputText(JSObject _self) implements JSObject {
  external Uri get uri;
}

extension type TabInputTextCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  TabInputText cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of TabInputText');
    }
    return TabInputText(value! as JSObject);
  }
  TabInputText new$(Uri uri) {
    final args$ = <JSAny?>[uri];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as TabInputText;
  }
}

extension type TabInputTextDiff(JSObject _self) implements JSObject {
  external Uri get modified;
  external Uri get original;
}

extension type TabInputTextDiffCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  TabInputTextDiff cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of TabInputTextDiff');
    }
    return TabInputTextDiff(value! as JSObject);
  }
  TabInputTextDiff new$(Uri original, Uri modified) {
    final args$ = <JSAny?>[original, modified];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as TabInputTextDiff;
  }
}

extension type TabInputWebview(JSObject _self) implements JSObject {
  external String get viewType;
}

extension type TabInputWebviewCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  TabInputWebview cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of TabInputWebview');
    }
    return TabInputWebview(value! as JSObject);
  }
  TabInputWebview new$(JSString viewType) {
    final args$ = <JSAny?>[viewType];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as TabInputWebview;
  }
}

extension type Task(JSObject _self) implements JSObject {
  external TaskDefinition get definition;
  external set definition(TaskDefinition value);
  external String? get detail;
  external set detail(String? value);
  external JSObject? get execution;
  external set execution(JSObject? value);
  external TaskGroup? get group;
  external set group(TaskGroup? value);
  external bool get isBackground;
  external set isBackground(bool value);
  external String get name;
  external set name(String value);
  external TaskPresentationOptions get presentationOptions;
  external set presentationOptions(TaskPresentationOptions value);
  external JSArray<JSString> get problemMatchers;
  external set problemMatchers(JSArray<JSString> value);
  external RunOptions get runOptions;
  external set runOptions(RunOptions value);
  external JSAny? get scope;
  external String get source;
  external set source(String value);
}

extension type TaskCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  Task cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of Task');
    }
    return Task(value! as JSObject);
  }
  Task new$(TaskDefinition taskDefinition, JSAny scope, JSString name, JSString source, [JSObject? execution, JSAny? problemMatchers]) {
    final args$ = <JSAny?>[taskDefinition, scope, name, source, execution, problemMatchers];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 4))) as Task;
  }
  Task new$$2(TaskDefinition taskDefinition, JSString name, JSString source, [JSObject? execution, JSAny? problemMatchers]) {
    final args$ = <JSAny?>[taskDefinition, name, source, execution, problemMatchers];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 3))) as Task;
  }
}

extension type TaskGroup(JSObject _self) implements JSObject {
  external String get id;
  external bool? get isDefault;
}

extension type TaskGroupCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  TaskGroup cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of TaskGroup');
    }
    return TaskGroup(value! as JSObject);
  }
  TaskGroup new$() =>
      _self.callAsConstructorVarArgs<JSObject>(const [])
          as TaskGroup;
  external TaskGroup get Build;
  external set Build(TaskGroup value);
  external TaskGroup get Clean;
  external set Clean(TaskGroup value);
  external TaskGroup get Rebuild;
  external set Rebuild(TaskGroup value);
  external TaskGroup get Test;
  external set Test(TaskGroup value);
}

extension type TelemetryTrustedValue<T extends JSAny?>(JSObject _self) implements JSObject {
  external T get value;
}

extension type TelemetryTrustedValueCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  TelemetryTrustedValue<T> cast<T extends JSAny?>(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of TelemetryTrustedValue');
    }
    return TelemetryTrustedValue<T>(value! as JSObject);
  }
  TelemetryTrustedValue<T> new$<T extends JSAny?>(T value) {
    final args$ = <JSAny?>[value];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as TelemetryTrustedValue<T>;
  }
}

extension type TerminalLink(JSObject _self) implements JSObject {
  external num get length;
  external set length(num value);
  external num get startIndex;
  external set startIndex(num value);
  external String? get tooltip;
  external set tooltip(String? value);
}

extension type TerminalLinkCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  TerminalLink cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of TerminalLink');
    }
    return TerminalLink(value! as JSObject);
  }
  TerminalLink new$(JSNumber startIndex, JSNumber length, [JSString? tooltip]) {
    final args$ = <JSAny?>[startIndex, length, tooltip];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as TerminalLink;
  }
}

extension type TerminalProfile(JSObject _self) implements JSObject {
  external JSObject get options;
  external set options(JSObject value);
}

extension type TerminalProfileCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  TerminalProfile cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of TerminalProfile');
    }
    return TerminalProfile(value! as JSObject);
  }
  TerminalProfile new$(JSObject options) {
    final args$ = <JSAny?>[options];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as TerminalProfile;
  }
}

extension type TestCoverageCount(JSObject _self) implements JSObject {
  external num get covered;
  external set covered(num value);
  external num get total;
  external set total(num value);
}

extension type TestCoverageCountCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  TestCoverageCount cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of TestCoverageCount');
    }
    return TestCoverageCount(value! as JSObject);
  }
  TestCoverageCount new$(JSNumber covered, JSNumber total) {
    final args$ = <JSAny?>[covered, total];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as TestCoverageCount;
  }
}

extension type TestMessage(JSObject _self) implements JSObject {
  external String? get actualOutput;
  external set actualOutput(String? value);
  external String? get contextValue;
  external set contextValue(String? value);
  external String? get expectedOutput;
  external set expectedOutput(String? value);
  external Location? get location;
  external set location(Location? value);
  external JSAny get message;
  external set message(JSAny value);
  external JSArray<TestMessageStackFrame>? get stackTrace;
  external set stackTrace(JSArray<TestMessageStackFrame>? value);
}

extension type TestMessageCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  TestMessage cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of TestMessage');
    }
    return TestMessage(value! as JSObject);
  }
  TestMessage new$(JSAny message) {
    final args$ = <JSAny?>[message];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as TestMessage;
  }
  external TestMessage diff(JSAny message, String expected, String actual);
}

extension type TestMessageStackFrame(JSObject _self) implements JSObject {
  external String get label;
  external set label(String value);
  external Position? get position;
  external set position(Position? value);
  external Uri? get uri;
  external set uri(Uri? value);
}

extension type TestMessageStackFrameCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  TestMessageStackFrame cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of TestMessageStackFrame');
    }
    return TestMessageStackFrame(value! as JSObject);
  }
  TestMessageStackFrame new$(JSString label, [Uri? uri, Position? position]) {
    final args$ = <JSAny?>[label, uri, position];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as TestMessageStackFrame;
  }
}

extension type TestRunRequest(JSObject _self) implements JSObject {
  external bool? get continuous;
  external JSArray<TestItem>? get exclude;
  external JSArray<TestItem>? get include;
  external bool get preserveFocus;
  external TestRunProfile? get profile;
}

extension type TestRunRequestCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  TestRunRequest cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of TestRunRequest');
    }
    return TestRunRequest(value! as JSObject);
  }
  TestRunRequest new$([JSArray<TestItem>? include, JSArray<TestItem>? exclude, TestRunProfile? profile, JSBoolean? continuous, JSBoolean? preserveFocus]) {
    final args$ = <JSAny?>[include, exclude, profile, continuous, preserveFocus];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 0))) as TestRunRequest;
  }
}

extension type TestTag(JSObject _self) implements JSObject {
  external String get id;
}

extension type TestTagCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  TestTag cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of TestTag');
    }
    return TestTag(value! as JSObject);
  }
  TestTag new$(JSString id) {
    final args$ = <JSAny?>[id];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as TestTag;
  }
}

extension type TextEdit(JSObject _self) implements JSObject {
  external int? get newEol;
  external set newEol(int? value);
  external String get newText;
  external set newText(String value);
  external Range get range;
  external set range(Range value);
}

extension type TextEditCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  TextEdit cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of TextEdit');
    }
    return TextEdit(value! as JSObject);
  }
  TextEdit new$(Range range, JSString newText) {
    final args$ = <JSAny?>[range, newText];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 2))) as TextEdit;
  }
  external TextEdit delete(Range range);
  external TextEdit insert(Position position, String newText);
  external TextEdit replace(Range range, String newText);
  external TextEdit setEndOfLine(int eol);
}

extension type ThemeColor(JSObject _self) implements JSObject {
  external String get id;
}

extension type ThemeColorCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  ThemeColor cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of ThemeColor');
    }
    return ThemeColor(value! as JSObject);
  }
  ThemeColor new$(JSString id) {
    final args$ = <JSAny?>[id];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as ThemeColor;
  }
}

extension type ThemeIcon(JSObject _self) implements JSObject {
  external ThemeColor? get color;
  external String get id;
}

extension type ThemeIconCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  ThemeIcon cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of ThemeIcon');
    }
    return ThemeIcon(value! as JSObject);
  }
  external ThemeIcon get File;
  external ThemeIcon get Folder;
  ThemeIcon new$(JSString id, [ThemeColor? color]) {
    final args$ = <JSAny?>[id, color];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as ThemeIcon;
  }
}

extension type TreeItem(JSObject _self) implements JSObject {
  external AccessibilityInformation? get accessibilityInformation;
  external set accessibilityInformation(AccessibilityInformation? value);
  external JSAny? get checkboxState;
  external set checkboxState(JSAny? value);
  external int? get collapsibleState;
  external set collapsibleState(int? value);
  external Command? get command;
  external set command(Command? value);
  external String? get contextValue;
  external set contextValue(String? value);
  external JSAny? get description;
  external set description(JSAny? value);
  external JSAny? get iconPath;
  external set iconPath(JSAny? value);
  external String? get id;
  external set id(String? value);
  external JSAny? get label;
  external set label(JSAny? value);
  external Uri? get resourceUri;
  external set resourceUri(Uri? value);
  external JSAny? get tooltip;
  external set tooltip(JSAny? value);
}

extension type TreeItemCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  TreeItem cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of TreeItem');
    }
    return TreeItem(value! as JSObject);
  }
  TreeItem new$(JSAny label, [JSNumber? collapsibleState]) {
    final args$ = <JSAny?>[label, collapsibleState];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as TreeItem;
  }
  TreeItem new$$2(Uri resourceUri, [JSNumber? collapsibleState]) {
    final args$ = <JSAny?>[resourceUri, collapsibleState];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 1))) as TreeItem;
  }
}

extension type TypeHierarchyItem(JSObject _self) implements JSObject {
  external String? get detail;
  external set detail(String? value);
  external int get kind;
  external set kind(int value);
  external String get name;
  external set name(String value);
  external Range get range;
  external set range(Range value);
  external Range get selectionRange;
  external set selectionRange(Range value);
  external JSArray<JSNumber>? get tags;
  external set tags(JSArray<JSNumber>? value);
  external Uri get uri;
  external set uri(Uri value);
}

extension type TypeHierarchyItemCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  TypeHierarchyItem cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of TypeHierarchyItem');
    }
    return TypeHierarchyItem(value! as JSObject);
  }
  TypeHierarchyItem new$(JSNumber kind, JSString name, JSString detail, Uri uri, Range range, Range selectionRange) {
    final args$ = <JSAny?>[kind, name, detail, uri, range, selectionRange];
    return _self.callAsConstructorVarArgs<JSObject>(args$.sublist(0, _trimTrailingNulls(args$, 6))) as TypeHierarchyItem;
  }
}

extension type Uri(JSObject _self) implements JSObject {
  external String get authority;
  external String get fragment;
  external String get fsPath;
  external String get path;
  external String get query;
  external String get scheme;
  external JSAny? toJSON();
  @JS('toString')
  external String toString$([bool? skipEncoding]);
  @JS('with')
  external Uri with$(JSAnon_67772e4ecc2b change);
}

extension type UriCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  Uri cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of Uri');
    }
    return Uri(value! as JSObject);
  }
  Uri new$() =>
      _self.callAsConstructorVarArgs<JSObject>(const [])
          as Uri;
  external Uri file(String path);
  external Uri from(JSAnon_5503263f5517 components);
  Uri joinPath(Uri base, [List<JSAny?> pathSegments = const []]) {
    final args$ = <JSAny?>[base, ...pathSegments];
    return _self.callMethodVarArgs<Uri>('joinPath'.toJS, args$.sublist(0, args$.length));
  }
  external Uri parse(String value, [bool? strict]);
}

extension type WorkspaceEdit(JSObject _self) implements JSObject {
  external void createFile(Uri uri, [JSAnon_05617a7b4547? options, WorkspaceEditEntryMetadata? metadata]);
  external void delete(Uri uri, Range range, [WorkspaceEditEntryMetadata? metadata]);
  external void deleteFile(Uri uri, [JSAnon_6f600fe6d695? options, WorkspaceEditEntryMetadata? metadata]);
  external JSArray<JSTuple_581eb76c2fe4> entries();
  external JSArray<TextEdit> get(Uri uri);
  external bool has(Uri uri);
  external void insert(Uri uri, Position position, String newText, [WorkspaceEditEntryMetadata? metadata]);
  external void renameFile(Uri oldUri, Uri newUri, [JSAnon_ed2698223f98? options, WorkspaceEditEntryMetadata? metadata]);
  external void replace(Uri uri, Range range, String newText, [WorkspaceEditEntryMetadata? metadata]);
  external void set(Uri uri, JSArray<JSObject> edits);
  @JS('set')
  external void set$2(Uri uri, JSArray<JSTuple_de3a98144066> edits);
  @JS('set')
  external void set$3(Uri uri, JSArray<NotebookEdit> edits);
  @JS('set')
  external void set$4(Uri uri, JSArray<JSTuple_ce311b95ee43> edits);
  external num get size;
}

extension type WorkspaceEditCtor(JSFunction _self) implements JSObject {
  bool isInstance(JSAny? value) {
    if (value == null) return false;
    final prototype = _self.getProperty('prototype'.toJS);
    if (prototype is! JSObject) return false;
    return (prototype.callMethod(
      'isPrototypeOf'.toJS,
      value,
    )! as JSBoolean).toDart;
  }
  WorkspaceEdit cast(JSAny? value) {
    if (!isInstance(value)) {
      throw ArgumentError('value is not an instance of WorkspaceEdit');
    }
    return WorkspaceEdit(value! as JSObject);
  }
  WorkspaceEdit new$() =>
      _self.callAsConstructorVarArgs<JSObject>(const [])
          as WorkspaceEdit;
}

/// The VS Code API module object, as passed to activation.
///
/// The module wrapper is the only root of this layer: no
/// generated code resolves names through JS scope.
extension type VscodeApi(JSObject _self) implements JSObject {
  external BranchCoverageCtor get BranchCoverage;
  external BreakpointCtor get Breakpoint;
  external CallHierarchyIncomingCallCtor get CallHierarchyIncomingCall;
  external CallHierarchyItemCtor get CallHierarchyItem;
  external CallHierarchyOutgoingCallCtor get CallHierarchyOutgoingCall;
  external CancellationErrorCtor get CancellationError;
  external CancellationTokenSourceCtor get CancellationTokenSource;
  external ChatRequestTurnCtor get ChatRequestTurn;
  external ChatResponseAnchorPartCtor get ChatResponseAnchorPart;
  external ChatResponseCommandButtonPartCtor get ChatResponseCommandButtonPart;
  external ChatResponseFileTreePartCtor get ChatResponseFileTreePart;
  external ChatResponseMarkdownPartCtor get ChatResponseMarkdownPart;
  external ChatResponseProgressPartCtor get ChatResponseProgressPart;
  external ChatResponseReferencePartCtor get ChatResponseReferencePart;
  external ChatResponseTurnCtor get ChatResponseTurn;
  external ChatResultFeedbackKindValues get ChatResultFeedbackKind;
  external CodeActionCtor get CodeAction;
  external CodeActionKindCtor get CodeActionKind;
  external CodeActionTriggerKindValues get CodeActionTriggerKind;
  external CodeLensCtor get CodeLens;
  external ColorCtor get Color;
  external ColorInformationCtor get ColorInformation;
  external ColorPresentationCtor get ColorPresentation;
  external ColorThemeKindValues get ColorThemeKind;
  external CommentModeValues get CommentMode;
  external CommentThreadCollapsibleStateValues get CommentThreadCollapsibleState;
  external CommentThreadStateValues get CommentThreadState;
  external CompletionItemCtor get CompletionItem;
  external CompletionItemKindValues get CompletionItemKind;
  external CompletionItemTagValues get CompletionItemTag;
  external CompletionListCtor get CompletionList;
  external CompletionTriggerKindValues get CompletionTriggerKind;
  external ConfigurationTargetValues get ConfigurationTarget;
  external CustomExecutionCtor get CustomExecution;
  external DataTransferCtor get DataTransfer;
  external DataTransferItemCtor get DataTransferItem;
  external DebugAdapterExecutableCtor get DebugAdapterExecutable;
  external DebugAdapterInlineImplementationCtor get DebugAdapterInlineImplementation;
  external DebugAdapterNamedPipeServerCtor get DebugAdapterNamedPipeServer;
  external DebugAdapterServerCtor get DebugAdapterServer;
  external DebugConfigurationProviderTriggerKindValues get DebugConfigurationProviderTriggerKind;
  external DebugConsoleModeValues get DebugConsoleMode;
  external DebugStackFrameCtor get DebugStackFrame;
  external DebugThreadCtor get DebugThread;
  external DeclarationCoverageCtor get DeclarationCoverage;
  external DecorationRangeBehaviorValues get DecorationRangeBehavior;
  external DiagnosticCtor get Diagnostic;
  external DiagnosticRelatedInformationCtor get DiagnosticRelatedInformation;
  external DiagnosticSeverityValues get DiagnosticSeverity;
  external DiagnosticTagValues get DiagnosticTag;
  external DisposableCtor get Disposable;
  external DocumentDropEditCtor get DocumentDropEdit;
  external DocumentDropOrPasteEditKindCtor get DocumentDropOrPasteEditKind;
  external DocumentHighlightCtor get DocumentHighlight;
  external DocumentHighlightKindValues get DocumentHighlightKind;
  external DocumentLinkCtor get DocumentLink;
  external DocumentPasteEditCtor get DocumentPasteEdit;
  external DocumentPasteTriggerKindValues get DocumentPasteTriggerKind;
  external DocumentSymbolCtor get DocumentSymbol;
  external EndOfLineValues get EndOfLine;
  external EnvironmentVariableMutatorTypeValues get EnvironmentVariableMutatorType;
  external EvaluatableExpressionCtor get EvaluatableExpression;
  external EventEmitterCtor get EventEmitter;
  external ExtensionKindValues get ExtensionKind;
  external ExtensionModeValues get ExtensionMode;
  external FileChangeTypeValues get FileChangeType;
  external FileCoverageCtor get FileCoverage;
  external FileDecorationCtor get FileDecoration;
  external FilePermissionValues get FilePermission;
  external FileSystemErrorCtor get FileSystemError;
  external FileTypeValues get FileType;
  external FoldingRangeCtor get FoldingRange;
  external FoldingRangeKindValues get FoldingRangeKind;
  external FunctionBreakpointCtor get FunctionBreakpoint;
  external HoverCtor get Hover;
  external IndentActionValues get IndentAction;
  external InlayHintCtor get InlayHint;
  external InlayHintKindValues get InlayHintKind;
  external InlayHintLabelPartCtor get InlayHintLabelPart;
  external InlineCompletionItemCtor get InlineCompletionItem;
  external InlineCompletionListCtor get InlineCompletionList;
  external InlineCompletionTriggerKindValues get InlineCompletionTriggerKind;
  external InlineValueEvaluatableExpressionCtor get InlineValueEvaluatableExpression;
  external InlineValueTextCtor get InlineValueText;
  external InlineValueVariableLookupCtor get InlineValueVariableLookup;
  external InputBoxValidationSeverityValues get InputBoxValidationSeverity;
  external LanguageModelChatMessageCtor get LanguageModelChatMessage;
  external LanguageModelChatMessageRoleValues get LanguageModelChatMessageRole;
  external LanguageModelChatToolModeValues get LanguageModelChatToolMode;
  external LanguageModelDataPartCtor get LanguageModelDataPart;
  external LanguageModelErrorCtor get LanguageModelError;
  external LanguageModelPromptTsxPartCtor get LanguageModelPromptTsxPart;
  external LanguageModelTextPartCtor get LanguageModelTextPart;
  external LanguageModelToolCallPartCtor get LanguageModelToolCallPart;
  external LanguageModelToolResultCtor get LanguageModelToolResult;
  external LanguageModelToolResultPartCtor get LanguageModelToolResultPart;
  external LanguageStatusSeverityValues get LanguageStatusSeverity;
  external LinkedEditingRangesCtor get LinkedEditingRanges;
  external LocationCtor get Location;
  external LogLevelValues get LogLevel;
  external MarkdownStringCtor get MarkdownString;
  external McpHttpServerDefinitionCtor get McpHttpServerDefinition;
  external McpStdioServerDefinitionCtor get McpStdioServerDefinition;
  external NotebookCellDataCtor get NotebookCellData;
  external NotebookCellKindValues get NotebookCellKind;
  external NotebookCellOutputCtor get NotebookCellOutput;
  external NotebookCellOutputItemCtor get NotebookCellOutputItem;
  external NotebookCellStatusBarAlignmentValues get NotebookCellStatusBarAlignment;
  external NotebookCellStatusBarItemCtor get NotebookCellStatusBarItem;
  external NotebookControllerAffinityValues get NotebookControllerAffinity;
  external NotebookDataCtor get NotebookData;
  external NotebookEditCtor get NotebookEdit;
  external NotebookEditorRevealTypeValues get NotebookEditorRevealType;
  external NotebookRangeCtor get NotebookRange;
  external OverviewRulerLaneValues get OverviewRulerLane;
  external ParameterInformationCtor get ParameterInformation;
  external PositionCtor get Position;
  external ProcessExecutionCtor get ProcessExecution;
  external ProgressLocationValues get ProgressLocation;
  external QuickInputButtonLocationValues get QuickInputButtonLocation;
  external QuickInputButtonsCtor get QuickInputButtons;
  external QuickPickItemKindValues get QuickPickItemKind;
  external RangeCtor get Range;
  external RelativePatternCtor get RelativePattern;
  external SelectionCtor get Selection;
  external SelectionRangeCtor get SelectionRange;
  external SemanticTokensCtor get SemanticTokens;
  external SemanticTokensBuilderCtor get SemanticTokensBuilder;
  external SemanticTokensEditCtor get SemanticTokensEdit;
  external SemanticTokensEditsCtor get SemanticTokensEdits;
  external SemanticTokensLegendCtor get SemanticTokensLegend;
  external ShellExecutionCtor get ShellExecution;
  external ShellQuotingValues get ShellQuoting;
  external SignatureHelpCtor get SignatureHelp;
  external SignatureHelpTriggerKindValues get SignatureHelpTriggerKind;
  external SignatureInformationCtor get SignatureInformation;
  external SnippetStringCtor get SnippetString;
  external SnippetTextEditCtor get SnippetTextEdit;
  external SourceBreakpointCtor get SourceBreakpoint;
  external StatementCoverageCtor get StatementCoverage;
  external StatusBarAlignmentValues get StatusBarAlignment;
  external SymbolInformationCtor get SymbolInformation;
  external SymbolKindValues get SymbolKind;
  external SymbolTagValues get SymbolTag;
  external SyntaxTokenTypeValues get SyntaxTokenType;
  external TabInputCustomCtor get TabInputCustom;
  external TabInputNotebookCtor get TabInputNotebook;
  external TabInputNotebookDiffCtor get TabInputNotebookDiff;
  external TabInputTerminalCtor get TabInputTerminal;
  external TabInputTextCtor get TabInputText;
  external TabInputTextDiffCtor get TabInputTextDiff;
  external TabInputWebviewCtor get TabInputWebview;
  external TaskCtor get Task;
  external TaskGroupCtor get TaskGroup;
  external TaskPanelKindValues get TaskPanelKind;
  external TaskRevealKindValues get TaskRevealKind;
  external TaskScopeValues get TaskScope;
  external TelemetryTrustedValueCtor get TelemetryTrustedValue;
  external TerminalExitReasonValues get TerminalExitReason;
  external TerminalLinkCtor get TerminalLink;
  external TerminalLocationValues get TerminalLocation;
  external TerminalProfileCtor get TerminalProfile;
  external TerminalShellExecutionCommandLineConfidenceValues get TerminalShellExecutionCommandLineConfidence;
  external TestCoverageCountCtor get TestCoverageCount;
  external TestMessageCtor get TestMessage;
  external TestMessageStackFrameCtor get TestMessageStackFrame;
  external TestRunProfileKindValues get TestRunProfileKind;
  external TestRunRequestCtor get TestRunRequest;
  external TestTagCtor get TestTag;
  external TextDocumentChangeReasonValues get TextDocumentChangeReason;
  external TextDocumentSaveReasonValues get TextDocumentSaveReason;
  external TextEditCtor get TextEdit;
  external TextEditorCursorStyleValues get TextEditorCursorStyle;
  external TextEditorLineNumbersStyleValues get TextEditorLineNumbersStyle;
  external TextEditorRevealTypeValues get TextEditorRevealType;
  external TextEditorSelectionChangeKindValues get TextEditorSelectionChangeKind;
  external ThemeColorCtor get ThemeColor;
  external ThemeIconCtor get ThemeIcon;
  external TreeItemCtor get TreeItem;
  external TreeItemCheckboxStateValues get TreeItemCheckboxState;
  external TreeItemCollapsibleStateValues get TreeItemCollapsibleState;
  external TypeHierarchyItemCtor get TypeHierarchyItem;
  external UIKindValues get UIKind;
  external UriCtor get Uri;
  external ViewColumnValues get ViewColumn;
  external WorkspaceEditCtor get WorkspaceEdit;
  external AuthenticationNs get authentication;
  external ChatNs get chat;
  external CommandsNs get commands;
  external CommentsNs get comments;
  external DebugNs get debug;
  external EnvNs get env;
  external ExtensionsNs get extensions;
  external L10nNs get l10n;
  external LanguagesNs get languages;
  external LmNs get lm;
  external NotebooksNs get notebooks;
  external ScmNs get scm;
  external TasksNs get tasks;
  external TestsNs get tests;
  external String get version;
  external WindowNs get window;
  external WorkspaceNs get workspace;
}

int _trimTrailingNulls(List<JSAny?> args, int floor) {
  var length = args.length;
  while (length > floor && args[length - 1] == null) {
    length -= 1;
  }
  return length;
}
