# Architecture

System-level structure for generation, runtime messaging, and extension hosting.

## Components

- **Annotations**
  - `@VSCodeController` and `@VSCodeCommand` define command surface in Dart.
- **Generators**
  - Dart generator emits `*.vscode.g.part`.
  - TypeScript generator emits `*.handlers.ts`.
- **Runtime bridge**
  - `VSCodeControllerBase` posts commands and tracks pending responses.
  - `VSCodeWebViewHelper` receives host messages and routes to runtime.
- **Extension host**
  - `src/extension.ts` registers webview and forwards incoming messages to generated handlers.

## Data Flow

```mermaid
flowchart LR
  flutterSrc[FlutterAndControllerDart] --> codegen[BuildRunnerGeneration]
  codegen --> dartPart[GeneratedDartPart]
  codegen --> tsHandlers[GeneratedTsHandlers]
  tsHandlers --> extensionHost[VsCodeExtensionHost]
  extensionHost --> webview[VsCodeWebview]
  webview --> flutterRuntime[FlutterWebRuntime]
  flutterRuntime -->|"command params requestId"| extensionHost
  extensionHost -->|"result or error requestId"| flutterRuntime
```

## Key Contracts

- [Dart to VS Code Message Contract](../reference/message-contract.md)
- [PRD Traceability and MVP Acceptance](../reference/prd-traceability.md)

## Related

- [Documentation Index](../index.md)
- [Agent Guidelines](../agent-guidelines/index.md)
