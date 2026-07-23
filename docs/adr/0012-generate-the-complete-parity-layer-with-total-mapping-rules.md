---
status: accepted
---

# Generate the Complete Parity Layer with Total Mapping Rules

The Parity Layer will cover the entire API Parity Baseline in one mechanical
generation pass, produced exclusively by Total Mapping Rules: judgment-free,
deterministic rules that map each class of TypeScript construct to
`dart:js_interop` code for every occurrence. The strategy is erasure at the
`external` boundary (the `package:web` precedent: unions erase to their least
upper bound in the JS type hierarchy) combined with generated Precision
Helpers (the ScalablyTyped precedent adapted to extension types: typed union
narrowing via `isA<T>`, per-overload `@JS`-renamed members, typed
string-literal wrappers, typed tuple access). A construct with no Total
Mapping Rule fails generation with an actionable error; nothing is
approximated, guessed, or resolved by review. Semantic Overrides no longer
participate in the Parity Layer and apply only to the Idiomatic Facade.

This supersedes the walking-slice model in which every emitted symbol
required a reviewed Semantic Override and real-host evidence before emission.
Per-symbol review does not scale to 2,972 declarations and — as five
hardening rounds demonstrated — reviewed judgment is precisely the ingredient
that resists mechanical verification. Research across ecosystems
(`specs/research/js-to-dart-mapping.md`) established that total rules exist
for every construct in the pinned baseline: the two flagged gaps are the
platform-wide `undefined`/`null` conflation (mapped to `T?` and documented —
no ecosystem can distinguish them) and intersection types (six occurrences in
the baseline, covered by a deterministic implements-both encoding; any future
shape it cannot express fails generation).

ADR 0008's release gate evolves accordingly: a release is blocked when a new
baseline introduces a construct with no Total Mapping Rule, and the block is
lifted only by adding a rule — never a per-symbol judgment. Behavioral
verification (real Extension Host evidence) and Idiomatic Facade coverage
move from emission gates to measured burn-downs. The trade-off is accepted
deliberately: the erased boundary is less precise than hand-reviewed
signatures, but it is total, immediately available for every capability,
recovers precision through generated helpers, and keeps the pipeline free of
the judgment calls that undermined verifiability.
