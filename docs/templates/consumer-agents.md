# Extension Agent Guidelines

This is a `flutter_vscode` Extension Project. Activation and VS Code callbacks
run in pure Host Dart; Flutter views are optional, separate runtimes.

## Source of truth

- Edit `extension.dart` for metadata, `apiTarget`, and contributions.
- Edit `host/lib/**` for commands, providers, events, and VS Code object use.
- Edit `shared/lib/**` only for runtime-neutral Dart.
- Edit `views/**` for optional Flutter UI.
- Never edit `package.json`, `coverage.json`, `host/lib/generated/**`,
  `host/bootstrap.cjs`, `.vscode/launch.json`, `out/**`, or a VSIX.

## Mandatory rules

1. Run host behavior without assuming a Flutter view exists.
2. Use only symbols present in generated bindings and marked implemented in
   `coverage.json`. Never guess or handwrite a replacement binding.
3. Keep `apiTarget` explicit. Do not raise it as a side effect of another edit.
4. Put Flutter/browser imports only in `views/`; keep `host/` and `shared/`
   within their enforced dependency boundaries.
5. Send only validated value snapshots across the versioned view protocol.
   Keep native VS Code objects in Host Dart.
6. Expose view operations through a specific allowlist; do not add a generic
   dispatcher.
7. Register disposables with the extension context or clean up Dart-owned
   resources idempotently.
8. Regenerate with `flutter_vscode build`; package with
   `flutter_vscode package`.

## Decision guide

```text
VS Code activation, command, provider, event, or native object -> host/lib/
Extension contribution                                      -> extension.dart
Runtime-neutral model                                       -> shared/lib/
Rich optional UI                                            -> views/<name>/
Host value needed by a view                                 -> allowlisted v1 call
Missing generated VS Code symbol                            -> report API gap
```

## Validation

```sh
flutter_vscode build
flutter_vscode package
```

After a view change, also verify that host commands and providers work both
without opening it and after closing it, and that protocol pending-request and
subscription counts return to zero.

Use the project-local skills under `agent-skills/` for focused workflows.
