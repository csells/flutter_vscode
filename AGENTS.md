# AGENTS Index

This file is the root index for AI and contributor documentation.

## Canonical File Naming

- Use `AGENTS.md` (uppercase) as the only canonical root agent-instruction file.

## Shared Agent Layout

- `CLAUDE.md` and `GEMINI.md` import the shared rules from `AGENTS.md`.
- Keep project skills in `.claude/skills/`; `.agents/skills` points there.

## Quick Navigation

- [Project Vision](specs/vision/vision.md)
- [Architecture (living)](specs/architecture/index.md)
- [Architecture Deepening Plan (active)](specs/plans/architecture-deepening.md)
- [Futures (deferred-work inbox)](specs/plans/futures.md)
- [Futures](specs/plans/futures.md)
- [Archived Plans](specs/plans/archive/)
- [Domain Language](CONTEXT.md)
- [Architecture Decisions](docs/adr/)
- [Documentation Root](docs/index.md)
- [Agent Guidelines](docs/agent-guidelines/index.md)
- [Architecture](docs/architecture/index.md)
- [Guides](docs/guides/index.md)
- [Reference](docs/reference/index.md)
- [Roadmap](docs/reference/roadmap.md)
- [Contributing](docs/contributing/index.md)

## Root Project Documents

- [README](README.md)
- [PRD](PRD.md)
- [CHANGELOG](CHANGELOG.md)

## Mandatory Baseline Rules

- Project type is a Flutter package that provides code generation and runtime utilities.
- Keep generator code, runtime utilities, and platform-specific bridge implementations separated.
- Use `very_good_analysis` and follow Effective Dart conventions.
- Prefer `package:web` and `dart:js_interop`; do not add `dart:js_util`.
- For generation errors, provide actionable user-facing failures.
- Keep documentation and examples aligned with API behavior.

## Consumer Agent Toolkit

Extension authors (not package contributors) use:

- [Agent-Assisted Development](docs/guides/agent-assisted-development.md)
- [Generated Host API](docs/reference/generated-host-api.md)
- [Legacy VS Code API Mapping](docs/reference/vscode-api-mapping.md)
- [Consumer AGENTS.md template](docs/templates/consumer-agents.md)
- Skills in [`skills/`](skills/) — copy into an extension project as `agent-skills/`
  when they are not already present

For full detail, follow the linked topic pages under `docs/agent-guidelines/`.
