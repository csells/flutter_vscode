# Troubleshooting

## Command calls do nothing

- Confirm your controller class is annotated with `@VSCodeController`.
- Confirm command methods are annotated with `@VSCodeCommand`.
- Regenerate: `dart run build_runner build --delete-conflicting-outputs`.
- Rebuild extension artifacts: `npm run compile`.

## Generated files are stale

- Delete conflicting outputs if needed and rerun build_runner.
- Ensure `part '...vscode.g.part';` is present in controller library.

## Webview fails to load Flutter app

- Run `npm run compile` and verify `build/web/index.html` exists.
- Ensure extension host webview `localResourceRoots` includes `build/web`.

## CSP or remote resource errors

- Keep default compile flags that disable remote web resources.
- Keep generated bootstrap configuration that uses local CanvasKit assets.

## Runtime response hangs

- Verify the TypeScript handler posts `requestId` with either `result` or `error`.
- Check command ids match between generated Dart and TypeScript.
- Inspect payload format in `docs/reference/message-contract.md`.
