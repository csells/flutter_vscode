# Architecture

How `flutter_vscode` works and how its claims stay true. These documents
are the living authority extracted from the archived
[first-working-extension plan](../plans/archive/first-working-extension.md)
when it closed; each rule below names the code or gate that enforces it,
because this project's history shows that unenforced prose rots.

- [Host Execution](host-execution.md) — how Dart runs inside VS Code's
  Extension Host.
- [Binding Pipeline](binding-pipeline.md) — pinned inputs to generated
  API, and every regeneration command.
- [Evidence Chain](evidence-chain.md) — receipts, gates, the exit-bar
  methodology, and what "verified" is allowed to mean.
- [View Protocol](view-protocol.md) — the versioned Host/Flutter View
  boundary.
- [Author Workflow](author-workflow.md) — create, build, package, and how
  the installed result is proven.

Status rule inherited from the plan: a completion claim is valid only
while `scripts/check_round5_exit.sh` exits 0 at HEAD. Forward work is
tracked in [futures](../plans/futures.md); API coverage is measured
in the generated [parity report](../../docs/reference/parity.md).
