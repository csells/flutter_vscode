# flutter_vscode

Shared language for the people, projects, and product promises in the
`flutter_vscode` ecosystem.

## People

**Extension Author**:
A developer who builds and maintains a VS Code extension with `flutter_vscode`.
_Avoid_: Consumer, package user, user

**Extension User**:
A person who installs or operates an extension produced with `flutter_vscode`.
_Avoid_: End user, consumer, user

## Product

**Extension Project**:
A Dart codebase that produces an installable VS Code extension and may include
zero or more Flutter Views.
_Avoid_: Flutter app, consumer project

**Flutter View**:
A Flutter web application hosted as one user interface within an Extension
Project.
_Avoid_: Flutter app, webview

**Host-Only Extension**:
An Extension Project that provides VS Code capabilities without a Flutter View.
_Avoid_: Headless extension, non-Flutter extension

**Extension Capability**:
One part of the VS Code extension platform exposed to an Extension Author,
including APIs, contributions, events, providers, and lifecycles.
_Avoid_: Command, API call

**Dart-Only Authoring**:
The product contract that Extension Authors write and maintain only Dart and
Flutter code, even when the resulting extension contains other generated code.
_Avoid_: Dart-only artifact, TypeScript-free artifact

**Author Toolchain**:
The tools an Extension Author installs and invokes directly: Flutter/Dart, VS
Code, and the `flutter_vscode` CLI.
_Avoid_: Build internals, host runtime

**Framework-Managed Artifact**:
Build or configuration output created, validated, and upgraded by
`flutter_vscode`; Extension Authors may inspect it but do not edit it.
_Avoid_: Scaffold file, user file

**API Parity Baseline**:
The pinned stable VS Code release whose public Extension Capabilities must all
have a classified Dart representation.
_Avoid_: Latest API, full API

**Parity Layer**:
The complete, mechanically generated Dart representation of an API Parity
Baseline.
_Avoid_: Raw API, low-level API

**Idiomatic Facade**:
The Dart-first API that Extension Authors normally use, generated over the
Parity Layer with Dart types and conventions.
_Avoid_: Wrapper API, convenience API

**Binding Pipeline**:
The deterministic transformation from pinned VS Code API sources into the
Parity Layer, Idiomatic Facade, host interop, and coverage ledger.
_Avoid_: Translation model, inference step

**Total Mapping Rule**:
A judgment-free, deterministic rule that maps one class of TypeScript
construct to Dart interop code for every occurrence in the API Parity
Baseline; a construct with no Total Mapping Rule fails generation rather
than being approximated.
_Avoid_: Heuristic, best-effort mapping, special case

**Precision Helper**:
A generated Dart member that restores type precision over an erased interop
boundary, such as typed narrowing for unions, typed literal values, or typed
tuple access.
_Avoid_: Convenience wrapper, sugar

**Semantic Override**:
A reviewed, versioned rule that resolves an API mapping not derivable from the
pinned upstream sources while keeping the Binding Pipeline deterministic. The
Parity Layer uses none — it is produced entirely by Total Mapping Rules;
Semantic Overrides apply to the Idiomatic Facade.
_Avoid_: Manual binding, exception, guess

**Host Target**:
An Extension Host environment in which an Extension Project is built and
verified to run, such as a local or remote Node Extension Host or the Web
Extension Host.
_Avoid_: Platform, deployment target

**Stable API Contract**:
The product guarantee that every stable Extension Capability in the API Parity
Baseline has a supported Dart representation.
_Avoid_: Full API including proposals, latest API

**Experimental API Mode**:
An explicit opt-in mode for proposed VS Code APIs, pinned to a compatible
Insiders build and outside normal compatibility and Marketplace guarantees.
_Avoid_: Proposed API support, preview flag

**Project API Target**:
The minimum stable VS Code version selected by an Extension Author; it controls
the available generated API surface and the managed extension compatibility
declaration.
_Avoid_: Latest VS Code, generator version, API Parity Baseline
