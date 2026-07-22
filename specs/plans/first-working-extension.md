# First Working Extension Plan

Status: Reopened — fresh-audit hardening in progress
Date: 2026-07-21

## Fresh Reopening Audit

A second completion audit re-ran the real Extension Host, installed-VSIX,
analysis, publication, and full-suite gates. The walking skeleton is genuine,
but green tests were still proving less than several checked claims. This plan
is reopened until every item below has its own observed red and focused green.

### Binding Pipeline and Evidence

- [x] Baseline comparison treats removed public declarations as explicit API
  deltas instead of silently accepting them.
- [x] Baseline validation covers the seed and rejects stale targets, entries,
  unused Host Contracts, malformed evidence hashes, and evidence hashes that
  do not match candidate IR. A later baseline cannot retain misleading
  classification or evidence metadata.
- [x] Pin validation requires every official VS Code input to match the declared
  product version and commit, not merely carry a valid checksum in isolation.
- [x] The walking-slice emitter derives selected declarations from canonical IR
  and Semantic Override strategies without a second exact-ID/name/count profile
  embedded in generator source. Unsupported semantics must still fail closed.
- [x] Coverage language distinguishes mechanically attributed binding IDs from
  independent behavioral contracts. Runtime probes are recorded only through
  generated operations whose surrounding real-host behavior succeeds.
- [x] Node and Dart validators apply the same ECMAScript whitespace predicate
  to reviewed exclusions and removals, including U+0085 and U+FEFF.
- [x] The importer preserves generic scope, declaration-name equivalence,
  effective visibility, and every supported declaration shape; syntax the IR
  cannot express is rejected instead of erased.
- [x] The pin manifest has one exact producer schema, including input
  cardinality, keys, contribution schemas, product/parser metadata, and source
  provenance.
- [ ] The Dart consumer accepts only IR the Node producer could emit. It must
  recompute identities and hashes, preserve parent/scope/type-literal graph
  relationships, correlate raw and canonical fields, and reject impossible
  coverage, modifier, ordinal, receipt, and numeric combinations.

### Installed Author Workflow

- [x] The installed user flow starts with an inactive extension, shows a
  supported document, waits for VS Code's documented `onLanguage` activation,
  and asserts the first and only hover query. A speculative query and later
  retry may not stand in for that result.

### View Protocol Lifecycle

- [x] Public session IDs, bootstrap nonces, operation names, error messages, and
  error details are validated before a frame can be emitted; invalid inputs
  fail promptly with a stable `ViewProtocolException` instead of hanging or
  tearing down the peer with a self-invalid frame.
- [x] A shutdown requested after peer close returns the peer's stored measured
  report (or the prior terminal error), never a synthesized zero report.
- [x] Receive-stream completion and errors drive terminal cleanup so `ready`,
  `connect`, `rendered`, `shutdown`, `closed`, and pending calls cannot remain
  stranded after transport loss.
- [x] Concurrent and repeated close calls join the same cleanup future; no
  caller can observe `close()` complete before listener and transport cleanup.
- [x] Render-report delivery failure terminates the View session consistently
  with call/result/error delivery failure.
- [x] Every transport send returns an awaitable result and the protocol awaits
  the strongest delivery guarantee its native API exposes. Host-to-View sends
  await VS Code's asynchronous acceptance result; the void Flutter View API
  can report only synchronous handoff. Any rejection a transport does expose
  enters the same terminal cleanup path.
- [x] The Host installs a newly generated active nonce before advertising it,
  including on reload, so a synchronous peer cannot lose its first valid frame.
- [x] Reload/close evidence says exactly what the runtime guarantees: stale
  responses are abandoned and handler futures remain honestly counted until
  application settlement while general handler cancellation remains deferred.
- [x] Pre-handshake phase checks reject work frames without blocking terminal
  `shutdown` or `closing` frames needed to settle a failed handshake.

### Enforcement and Durable Evidence

- [x] CI runs analysis, the full gate, Pub's actual archive dry run, and a final
  generated-file/worktree cleanliness check.
- [x] A focused repository test rejects a stale checked-in generated View
  protocol before fixture build can rewrite it.
- [x] Lock-enforced Host builds require a root `pubspec.lock` that is present
  and trackable from a fresh checkout.
- [ ] New red/green evidence below records the exact command and observed result
  for each reopened item. The plan may return to `Implemented and verified`
  only after two consecutive unchanged full gates pass.

The monolithic CLI orchestration module and the public naming-rule exception for
upstream parity types are maintainability/documentation follow-ups. They do not
invalidate this pinned first-extension exit gate, but the repository guidance
must describe the naming exception honestly.

## Pre-Hardening Evidence

The original implementation cleared its broad gates, but a fresh audit found
that several assertions were weaker than the requirements they purported to
prove. The evidence below is retained as a baseline, not as a completion claim.

- Checkpoint 1 passes in VS Code 1.129.1 with Dart-owned activation, command,
  hover provider, event unsubscribe, native identity, promise/error bridging,
  activation-failure cleanup, and repeated teardown.
- Checkpoint 2 deterministically imports pinned official sources and transitive
  validators into canonical IR. The ledger records 2,979 discovered entries:
  53 emitted, 7 reviewed exclusions, 10 visibility exclusions, and 2,909
  pending. It makes no full-parity claim.
- Checkpoint 3 creates, builds, packages, installs, auto-activates, and exercises
  a host-only extension without author-managed Node or npm.
- Checkpoint 4 packages a real Flutter View with a typed, allowlisted v1
  protocol; the Host and View report zero live requests/subscriptions at close.
- Final gates: `scripts/test_all.sh` passes 112 Dart/Flutter tests, 33 importer
  tests, deterministic generation/build checks, real Extension Host tests, and
  two clean installed-VSIX tests. `flutter analyze` reports no issues.

## Audit Gaps and Hardening Acceptance

Every item below requires a newly observed failing test followed by the minimum
implementation that makes that test pass. Existing broad green gates do not
substitute for the specific evidence.

### Checkpoint 1: Host Lifecycle and Diagnostics

- [x] Real Extension Host error assertions require a mapped
  `host/lib/extension.dart:<line>:<column>` frame and explicitly reject
  `.dart.js` as a false positive.
- [x] A rejected activation rolls back every registration made during the
  attempt; commands and providers from the partial activation are no longer
  callable.
- [x] Activation failure is injected by the test harness, not by a shipped
  production environment-variable branch, and the public lifecycle remains
  `activate(context, vscode)`.

### Checkpoint 2: Deterministic Evidence

- [x] Coverage distinguishes the 7 semantically reviewed exclusions from the
  10 mechanically excluded non-public symbols instead of calling all 17
  reviewed.
- [x] Each emitted ledger entry cites the executable host contract that verifies
  it, and real-host evidence is recorded mechanically when generated binding
  behavior executes. Handwritten aggregate flags or observed-ID lists are not
  accepted as proof.
- [x] Pinned schema and validator inputs are either mechanically projected into
  validation behavior or described honestly as integrity-pinned inputs.
- [x] Baseline-update checks fail closed for newly added or ambiguous public
  symbols until a general rule or reviewed override classifies them. Existing
  visible `pending` inventory remains an explicit non-parity state.
- [x] The importer baseline gate and Dart generator accept the same durable
  Host Contract shape: `{boundary, artifact, artifactSha256}` with one
  canonical JSON artifact under `tool/bindings/contracts/`. Obsolete or looser
  path-based shapes fail closed in both validators.
- [x] TDD evidence records the exact red and green command/result for every
  hardening item; chronology is not inferred from the final diff.

### Checkpoint 3: Author Workflow and Packaging

- [x] Hover works through lazy activation in a freshly installed VSIX; the
  installed test starts inactive, opens a supported document, waits for
  `onLanguage`, and asserts its only hover query before any extension command.
- [x] Malformed Host Dart exits cleanly with the filename and an actionable
  parse diagnostic, without an internal stack trace or exit code 255.
- [x] A freshly created project analyzes successfully before its first build;
  generated facade availability and quickstart ordering agree.
- [x] `extension.vsixmanifest` and `[Content_Types].xml` are parsed as XML during
  packaging, include a valid declaration, and reject XML 1.0-forbidden control
  characters before a VSIX is emitted.
- [x] A build receipt identifies the framework, generator, and pinned API inputs
  so `package` refuses stale artifacts after any of those sources change. This
  milestone does not claim SDK or resolved-dependency fingerprinting.
- [x] Current quickstart and API links lead to the generated Dart host API, not
  the legacy TypeScript/manual-`package.json` path.
- [x] Local development instructions use path activation. Publication
  readiness is checked with `dart pub publish --dry-run`, but publishing itself
  remains explicitly out of scope.
- [x] Installed-package E2E activates the CLI from a `.pubignore`-filtered copy,
  keeps repository-only fixtures outside that copy, and binds the external
  fixture back to the exact staged package.

### Checkpoint 4: View Boundary

- [x] Close reports live request/subscription counts measured after awaited
  cancellation and transport shutdown, not constant zeros reported beforehand.
- [x] A real webview test rejects invalid version, nonce, schema, and operation
  messages and proves structured-error behavior at the actual boundary.
- [x] Reload with an outstanding request is exercised in a real webview. Stale
  protocol work is abandoned, Host handler futures remain counted until their
  application futures settle, and final transport resources return to zero.
- [x] Render success is observed independently by the Extension Host test rather
  than trusted solely from the view's self-report.

Completion requires all four focused checkpoint suites, `flutter analyze`, and
two consecutive clean runs of `scripts/test_all.sh` to pass. Only then may this
plan return to `Implemented and verified`.

## Hardening TDD Ledger

These entries record failures observed while introducing each assertion and
the focused command that subsequently passed. They are evidence of chronology,
not deductions from the finished diff.

### Checkpoint 1

1. **Mapped Dart errors.** Red — `./scripts/test_host_extension.sh` failed the
   new stack assertions because errors exposed only `extension.dart.js` frames.
   Green — the same real-host gate exits 0 and requires
   `host/lib/extension.dart:<line>:<column>` while rejecting `.dart.js`.
2. **Activation rollback.** Red —
   `node --test tool/extension_host_test/bootstrap_lifecycle.test.cjs` found
   zero of five partial registrations disposed and found them retained in the
   context. Green — the same command passes 1/1 with reverse-order, once-only
   rollback while a pre-existing subscription remains untouched.
3. **Harness-only failure injection.** Red — the same Node test found the
   production bootstrap's environment branch and third lifecycle argument.
   Green — the same command passes 1/1 with `activate(context, vscode)`; only
   fixture Host Dart reads the test environment flag.

### Checkpoint 2

1. **Exclusion accounting.** Red — `flutter test
   test/binding_generator_test.dart` found one aggregate group of 17 exclusions
   and no visibility split. Green — the same command passes with 7 reviewed
   semantic exclusions and 10 mechanical non-public exclusions.
2. **Executable binding evidence.** Red — Node comparator tests first found a
   missing module and then accepted extra, duplicate, and mismatched claims.
   After those fixes, removing the handwritten ID side channel made
   `./scripts/test_host_extension.sh` pass every real-host behavior assertion
   and then exit 1 with `ENOENT` for `observed.json`. Green — the same command
   exits 0 and observes the exact mechanically attributed 53-ID set. `flutter
   test
   test/binding_generator_test.dart test/binding_generator_cli_test.dart
   test/binding_evidence_test.dart test/repository_gate_test.dart -r expanded`
   passes 39/39, and `node --test
   tool/extension_host_test/bootstrap_lifecycle.test.cjs
   tool/extension_host_test/host_contract.test.cjs` passes 6/6. Generated
   calls, getters, and callback wrappers emit observations directly. Bindings
   erased from JavaScript at runtime are attributed mechanically to their
   generated consuming operation. Host test and author Dart contain no binding
   IDs or observation calls. The canonical 6,956-byte artifact SHA-256 is
   `af68dd17c1e9f621fa01c09e5a383ad79b20eacae624894ac572a127eceec5f9`.
3. **Validator projection.** Red — `(cd tool/binding_importer && npm test)`
   found no projected manifest rules or validator-body integrity pin, and an
   added unprojected condition went unnoticed. Green — the same command
   projects the walking-slice predicates, pins the remaining validator body,
   and labels `semver.valid` as external rather than claiming equivalence.
4. **Fail-closed baseline series.** Red — `(cd tool/binding_importer && npm
   test)` accepted empty and stale classifications and had no adjacent-version
   series command. Green — the same command passes 49/49 plus the
   semver-ordered baseline-series check; new and shape-changed public entries
   require a matching declaration fingerprint and reviewed classification.
5. **One Host Contract schema.** Red — baseline tests first rejected the
   repository's durable artifact shape, then accepted a noncanonical filename;
   after that fix, the Dart generator still accepted
   `docs/test-extension-host.json`. The fresh-audit command `(cd
   tool/binding_importer && node --test test/baseline.test.cjs)` then failed
   8/9 because an unused obsolete contract was accepted beside the valid cited
   contract. Green — that exact command passes 9/9, full `npm test` passes
   49/49 plus the baseline series, and the generator's Host Contract tests pass
   3/3 with the same exact key, path, and lowercase SHA-256 rules; every
   declared contract is validated, whether or not a changed symbol cites it. A
   later differential audit found one remaining mismatch: Node accepted a
   valid contract named `BadContract`, while Dart rejected the same declaration
   because IDs must be lower camel case. Red — `(cd tool/binding_importer &&
   node --test test/baseline.test.cjs)` failed 9/10 with `Missing expected
   exception`. Green — the exact command passes 10/10 after Node adopted
   Dart's ID rule; full `npm test` passed 50/50 plus the baseline series. The
   same audit then found Node accepted missing and empty contract maps that Dart
   rejects. Red — the focused baseline command failed 10/11 with `Missing
   expected exception: missing`. Green — the exact command passes 11/11 after
   Node requires a nonempty contract object; full `npm test` passes 51/51 plus
   the baseline series.
6. **Ledger presence.** Red — `git show
   HEAD:specs/plans/first-working-extension.md | rg -n '^## Hardening TDD
   Ledger'` exits 1 with no match. Green — `rg -n '^## Hardening TDD Ledger'
   specs/plans/first-working-extension.md` exits 0 at this section; final
   full-gate evidence is recorded below only after it runs.

### Checkpoint 3

1. **Hover-first installed activation.** Red —
   `./scripts/test_packaged_extension.sh` first activated by command; after
   reordering, an invisible document did not activate immediately and a
   concurrent hover query returned zero providers. A proposed
   `onCommand:vscode.executeHoverProvider` event and synchronous Dart
   registration still failed `0 !== 1`. The pinned VS Code source explains
   why: API-command activation is drive-by and explicitly not awaited before
   `_executeHoverProvider` snapshots the provider registry. Green — the same
   command starts inactive, shows the JSON document, waits for supported
   `onLanguage` activation, and asserts the first and only hover query before
   invoking the extension command. Generated activation also registers the
   provider synchronously rather than deferring setup to another Future turn.
2. **Malformed Host Dart.** Red — `flutter test test/cli_build_test.dart`
   observed the compiler's internal failure path instead of a stable source
   diagnostic. Green — the same command passes with exit 1,
   filename/line/column, remediation, and no internal stack or exit 255.
3. **Analyze before build.** Red — `flutter test test/cli_create_test.dart`
   found that a created project imported a facade that did not exist until
   `build`. Green — the same command passes; `create` writes the facade
   immediately and the test completes `dart pub get && dart analyze` before the
   first build.
4. **Valid VSIX XML.** Red — `flutter test test/cli_package_test.dart` found
   missing XML declarations and accepted an XML 1.0-forbidden control
   character. Green — the same command parses both required parts with
   `package:xml`, verifies the declaration, and rejects the character before
   writing a VSIX.
5. **Build-source receipt.** Red — `flutter test test/build_receipt_test.dart
   test/cli_package_test.dart` found that changing a transitive generator helper
   did not change tool identity. Green — the same command passes and `package`
   rejects changed framework, generator, or pinned-input digests.
6. **Current author docs.** Red — `git show
   HEAD:docs/guides/quickstart.md | rg -n 'Generated Host API'` and the matching
   path-activation check for `agent-assisted-development.md` both exited 1.
   Green — `rg -n 'global activate --source path|Generated Host API' README.md
   docs/guides docs/reference` finds local path activation and the current
   generated API; legacy links are explicitly labeled.
7. **Publication contents.** Red — `flutter test
   test/repository_gate_test.dart` found no `.pubignore` filter while the
   packaged E2E copied the whole repository. Green — the same command passes
   3/3 and `dart pub publish --dry-run` contains the generator, pins, and compact
   Host Contract while excluding repository-only hardening sources.
8. **Pub-filtered E2E topology.** Red —
   `./scripts/test_packaged_extension.sh` first broke the external fixture's
   relative dependency, then exposed asynchronous activation and a zero-result
   racing hover. Green — the same command uses a temporary dependency override
   to the pristine staged package and exits 0 for both installed VSIX fixtures.

### Checkpoint 4

1. **Measured close reports.** Red — `flutter test
   test/view_protocol_test.dart` observed a `closing` frame before delayed
   listener cancellation and then found native receiving counts of one. Green —
   the same command passes 37/37, with both sessions awaiting Dart and native
   receive shutdown before measuring and sending the final outbound frame.
2. **Adversarial real boundary.** Red — `./scripts/test_host_extension.sh` had
   no version, nonce, exact-schema, disallowed-operation, or structured-error
   probe to satisfy the new assertions. Its first green was disproven by a
   fresh audit: the Host observer mutated frames only after VS Code had
   delivered them, so malformed input had not crossed the real boundary. After
   making that observer read-only and delivering native input to the parser
   first, the same command exited 1 with `0 !== 2` for the injected-frame
   counters. Green — fixture-only page code now corrupts each frame before
   calling VS Code's native `postMessage`; the same command exits 0 with two
   native-delivered frames per malformed class, zero protected-handler
   invocations, and the disallowed-operation and structured-operation-error
   assertions passing.
3. **Reload with live work.** Red — `./scripts/test_host_extension.sh` could not
   observe two ready handshakes or a request outstanding across reload. Its
   first green was also disproven: `pendingRequestCount` tracked response IDs,
   which reload cleared even though both Host Dart handler futures remained
   live. Red — `flutter test test/view_protocol_test.dart -r expanded` failed
   two new lifecycle assertions with expected 1, actual 0 after close and
   reload. Green — that command passes 37/37 with handler-future accounting;
   the real-host and installed-VSIX gates prove the transition from one live
   handler before reload, to two before shutdown and at close, to zero after
   both handlers settle. Two ready frames, one reload, and zero final resources
   are independently asserted.
4. **Independent exact render.** Red — `./scripts/test_host_extension.sh`
   reported `hostObservedRenderedContent` as undefined; a generic Flutter
   semantics selector also failed. Green — the same command proves Host-owned
   page code observes exact visible Flutter-owned DOM text with non-zero bounds,
   and both normal and reloaded views return the expected content before
   self-report acceptance.

## Fresh Reopening TDD Ledger

These are the observed reds that reopened the plan and the focused greens that
closed them. Counts are from the repaired tree before the two final unchanged
full gates.

### Binding Pipeline and Evidence

1. **Fail-closed baselines and one schema.** Reds in
   `test/baseline.test.cjs`, `test/baseline_series.test.cjs`, and
   `test/binding_generator_test.dart` showed that removed or privatized API,
   stale targets and fingerprints, malformed matching digests, missing or
   unused Host Contracts, unknown metadata, and divergent whitespace rules
   could pass one side of the Node/Dart boundary. Green — both validators now
   enforce the same exact v1 shapes, lowercase candidate-matching evidence
   digests, lower-camel contract IDs, reviewed removals, and projected
   ECMAScript whitespace semantics, including U+0085 and U+FEFF.
2. **Lossless canonical IR.** Focused importer reds exposed erased overload and
   member order, declaration kinds and modifiers, merge semantics, readonly
   index signatures, numeric enum initializers, computed-name collisions,
   inline overload collisions, and unstable IDs beneath outer generics. A
   deeper AST audit then found generic scope capture, declaration-name
   equivalence, nested missing annotations, erased implementation syntax,
   invalid heritage, context-invalid modifiers, and nested non-public members
   that could be lost or misclassified. Green — generic scopes are
   alpha-normalized, names are checked across identifier/string/numeric forms,
   private and protected visibility propagates recursively, and syntax the IR
   cannot represent fails closed. The regenerated pinned inventory has 2,982
   declarations: 2,972 public, 10 non-public, 53 emitted, 7 reviewed
   exclusions, and 2,912 pending. Its SHA-256 is
   `4f44ac50114df8c455e63d22737fb21ec2dfa6d6c355835b772e335e72e202c5`.
3. **Exact official provenance.** Pin tests first accepted individually valid
   checksums from the wrong product provenance and later accepted noncanonical
   source URLs. A later producer audit also found that duplicate or missing
   input kinds, extra document keys, and impossible product/parser values were
   still accepted. Green — the v1 pin file now requires exactly one of each of
   its six official input kinds, exactly the `commands` contribution schema,
   exact keys, and generator-visible value shapes. Every input must name
   version 1.129.1 and commit
   `8a7abeba6e03ea3af87bfbce9a1b7e48fed567b8`, and its URL must identify that
   exact canonical repository commit and path. The focused pin suite passes
   10/10.
4. **Mechanical emission with exact relationships.** Generator reds retained
   hard-coded names after IR renames and accepted wrong optional/static/rest
   flags, generic arity or linkage, property shape, constructor shape, event
   value, selector support, disposal names, and cross-entry types. Green — the
   walking slice is derived from public IR plus structural Semantic Overrides;
   it fails closed unless `Event<T>`, `Thenable<T>`, `ProviderResult<T>`,
   `executeCommand<T>`, webview, provider, URI, and disposal relationships are
   exact. `flutter test test/binding_generator_test.dart -r compact` passes
   72/72.
5. **Truthful native attribution.** Generated wrappers originally recorded
   bindings before native calls completed, and a false `postMessage` result was
   counted as success. New tests failed until observations moved after native
   success and after the awaited boolean is exactly `true`. The evidence
   remains one aggregate real-host contract with 53 mechanically attributed
   IDs, not 53 independent behavioral contracts.
6. **Receipted executable evidence.** Node reds accepted missing, changed, and
   repository-escaping source receipts and launched VS Code before checking
   them. Dart evidence tests also showed that generator helpers, the CLI,
   lockfiles, project parsing, and the integrity verifier itself were outside
   the receipt closure. Green — the launcher verifies 43 exact regular-file
   receipts before launch and again before accepting evidence. The 12,478-byte
   contract artifact has SHA-256
   `c41b18537d22cc0d2d007a0cf99dd0ffa4fdaab61030f05114872e21f6de52e6`;
   artifact, override, and generated coverage agree.
7. **Fresh runtime and dependency state.** Repository-gate reds found reusable
   VS Code cache markers and an ignored root `.dart_tool/package_config.json`
   trusted by standalone fixture builds. Green — each gate uses a new
   invocation-scoped cache, packaged runs share it only within that invocation,
   and the builder first runs lock-enforced root dependency resolution. The
   contract states the remaining toolchain and runtime trust boundary without
   claiming a predeclared VS Code binary digest.
8. **Dart semantic projection.** Focused counterexamples found `JSAny` types,
   URI rest parameters, generic constraints, non-generic callable aliases,
   interface heritage, and abstract constructors that could be emitted with
   the wrong Dart surface. Green — each construct now has an explicit
   structural rule and a regression test; unsupported variants fail closed.

`(cd tool/binding_importer && npm test)` now passes 119/119 plus the adjacent
baseline-series check. `node --test
tool/extension_host_test/bootstrap_lifecycle.test.cjs
tool/extension_host_test/host_contract.test.cjs` passes 11/11.

### Installed Author Workflow

1. **One real hover query.** `./scripts/test_packaged_extension.sh` failed
   `0 !== 1` when the first query was retained instead of replaced by a retry.
   Green — the installed extension starts inactive, shows a supported JSON
   document, waits for documented `onLanguage` activation, and asserts its
   first and only hover query before invoking any extension command.
2. **Synchronous registration.** The create suite failed because generated
   activation deferred registrations through `Future`. Green — setup now runs
   synchronously before returning a resolved promise, so a newly created
   project analyzes before its first build and activation cannot race provider
   registration.
3. **Executable docs and installed topology.** Repository tests failed on the
   old asynchronous snippet and unfiltered repository copy. Green — docs match
   the scaffold, development uses path activation, and installed E2E runs from
   a `.pubignore`-filtered staged package with an external fixture bound back to
   that exact package.

### View Protocol Lifecycle

Every protocol red below was observed in focused Dart tests; the repaired
`test/view_protocol_test.dart` suite passes 61/61.

1. **Validate and snapshot before send.** Invalid IDs, nonces, operation names,
   messages, and error details either emitted invalid frames or hung. Mutable
   in-memory maps also made tests stronger than a real serialization boundary.
   Green — public inputs validate promptly, details are recursively safe, and
   the in-memory transport JSON-round-trips top-level and nested payloads.
2. **One terminal cleanup path.** Stream completion, stream errors, peer close,
   concurrent close, and render-report failure stranded futures or completed
   before listener and transport cleanup. Green — all terminal paths share one
   idempotent cleanup future and retain the peer's measured report or terminal
   error.
3. **Await the strongest delivery guarantee.** Deferred `readyAck`, `result`,
   `rendered`, and `shutdown` failures were discarded. Green — every transport
   send returns and is awaited as `Future<void>`; Host awaits VS Code's
   asynchronous acceptance while the Flutter View can truthfully promise only
   synchronous handoff.
4. **Nonce and reload truth.** A synchronous ready response could beat nonce
   installation, while reload evidence declared zero although application
   handler futures still ran. Green — nonce installation precedes advertisement,
   stale responses are abandoned, and handler futures remain counted until
   application settlement.
5. **Native adapter ownership.** A failed native dispose removed the adapter's
   registration, preventing retry and leaking ownership. Green — failed
   disposal retains the registration, successful retry removes it, and later
   closes are idempotent. A false native `postMessage` also rejects without
   recording generated binding success.
6. **Pre-ready terminal frames.** A phase guard correctly rejected an early
   `result`, but also rejected terminal `shutdown` and `closing` frames. That
   stranded the peer when asynchronous `readyAck` delivery failed. Green — the
   Flutter side still rejects phase-invalid work frames before the handshake,
   while accepting the two terminal frames needed to settle connection and
   close lifecycle futures.

### Enforcement

1. **Real CI gates.** CI now runs `flutter analyze`, the full repository gate,
   Pub's archive dry run, and a final worktree-cleanliness check.
2. **Generated convergence.** The repository gate compares the canonical and
   generated View protocol before fixture build, and generator CLI tests
   regenerate the complete walking slice byte-for-byte.
3. **Focused convergence.** The combined generator, generator CLI, evidence,
   protocol, native transport, and repository command passes 145/145 with no
   skips. Shell syntax checks and `git diff --check` also pass.
4. **Trackable root resolution.** A repository-gate red showed that the build
   required `--enforce-lockfile` while the root `pubspec.lock` was ignored and
   could not survive a checkout. Green — the root lockfile is explicitly
   unignored, present in Git's candidate file set, and required before the Host
   fixture build starts.

## Final Execution Evidence

The prior completion evidence was invalidated by the root-evidence,
whitespace-parity, documentation, and asynchronous-delivery reds above. The
repaired focused suites, real Extension Host, and both installed-VSIX paths are
green. This section remains intentionally incomplete until analysis,
publication, and two consecutive unchanged full gates are rerun on the final
tree.

## Goal and Stop Rule

Make one VS Code extension work end to end with its host behavior written in
Dart. Prove activation, a command, a provider callback, an event, native VS Code
values, and cleanup in one pinned local Extension Host. Then mechanize that
exact path and package it once.

Do not design a multi-version support policy before the first checkpoint is
green. The first proof targets one stable VS Code API release, one matching VS
Code test build, and one local Node Extension Host. It makes no compatibility
promise beyond that combination.

This plan is the shortest executable path from the current implementation to
the [project vision](../vision/vision.md). Broader API parity, host matrices, and
support guarantees follow the working system rather than precede it.

## Starting Gap (Closed by This Plan)

At the start of this plan, consumer Dart ran only inside a Flutter webview.
Editable TypeScript owned activation and command registration, and an
unversioned JSON bridge supported only request/response calls. It could not
preserve live object identity or naturally express host events, provider
callbacks, cancellation, and disposal. Scaffolding also asked Extension
Authors to run npm and copy generated files, while CI never launched the
assembled extension.

The implemented checkpoints keep that v0 path available while adding the new
host path beside it. The webview bridge did not become the host runtime:
provider callbacks and activation work when no view exists.

## Architecture Constraints

- Compile a pure-Dart host entrypoint with `dart compile js` and load it
  in-process in VS Code's Node Extension Host.
- Generate a small CommonJS bootstrap that imports `vscode`, installs any
  required runtime shim, loads the Dart bundle, and forwards `activate` and
  `deactivate`.
- Use `dart:js_interop` directly inside host Dart. VS Code classes such as
  `Uri`, `Position`, `Range`, `MarkdownString`, and `Hover` remain native JS
  objects with their prototypes and identity intact. Dart-friendly builders may
  lower to those objects; they are not JSON copies.
- Keep each optional Flutter View in its own runtime. Only bidirectional
  communication between Host Dart and a Flutter View crosses a versioned
  protocol; view DTOs are snapshots, not host objects.
- Generate public bindings mechanically from pinned official inputs plus
  reviewed Semantic Overrides. No LLM, probabilistic mapping, silent omission,
  or guessed `dynamic` types participate in generation.
- Require no author-managed Node or npm. Maintainer tooling and CI may use
  pinned Node packages without adding them to the Author Toolchain.
- Namespace exported globals by extension ID and enforce that host/shared Dart
  cannot import Flutter, browser-only libraries, or unsupported platform APIs.

The vision now distinguishes direct native Host Dart interop from the versioned
protocol used only for cross-runtime Host/View communication.

## Checkpoint 1: One Local Walking Skeleton

Create `test/fixtures/host_extension/` by hand as an internal fixture. It needs
only:

- `host/lib/extension.dart`;
- a framework-owned bootstrap;
- the smallest framework-owned `package.json` that VS Code can load;
- an isolated private interop kernel for the few APIs under test; and
- an Extension Host test entrypoint.

The private kernel is disposable proof code, not a public API. Checkpoint 2
must replace and delete it. This prevents a handwritten shadow binding layer
from becoming permanent while allowing the execution topology to be tested
before building the generator.

The repository test performs this chain:

```text
compile host Dart -> assemble extension-development folder ->
launch one pinned VS Code build -> activate -> exercise -> shut down
```

Use the real Extension Host boundary and assert:

1. `extensions.getExtension(id).activate()` resolves before any webview opens.
2. `commands.executeCommand` invokes Dart and returns an exact Dart-produced
   value.
3. Opening a real document and invoking `vscode.executeHoverProvider` reaches a
   Dart callback with `TextDocument`, `Position`, and `CancellationToken`, then
   returns the expected native `Hover`, `MarkdownString`, and optional `Range`.
4. A real workspace or window event reaches Dart once; after unsubscribe, a
   second trigger is not delivered.
5. Repeated observations of the same document preserve JS object identity.
6. JS promises become Dart futures, Dart futures become JS thenables, and
   synchronous throws, rejected promises, and activation failure retain useful
   messages and Dart stack frames.
7. Registrations owned by `ExtensionContext.subscriptions` are left to VS Code;
   Dart-owned resources use idempotent cleanup. Bootstrap tests cover partial
   activation and repeated teardown without double disposal.

Write the failing tests first, but land the harness and minimum implementation
together with default CI green. The throwaway Node experiment established that
Dart-compiled JavaScript can call injected JavaScript, export a callback, and
bridge a future; this checkpoint must prove those mechanics inside VS Code.

Exit gate: one local, pinned Extension Host activates Dart, executes the command
and hover provider, delivers and unsubscribes the event, and shuts down cleanly.
No Flutter View, CLI suite, VSIX, remote host, or OS matrix blocks this gate.

## Checkpoint 2: Mechanize the Proven Slice

Pin these upstream inputs with version, source URL, commit, checksum, and
license metadata:

- stable `vscode.d.ts`;
- the extension manifest schema; and
- contribution-point schemas used to validate generated `package.json`.

Build a deterministic pipeline:

1. A maintainer-only importer uses the pinned TypeScript compiler parser to
   normalize `vscode.d.ts` into a language-neutral API IR.
2. The inventory assigns stable IDs to namespaces, members, type members,
   overloads, call signatures, deprecations, and exclusions.
3. Each entry records separate states such as discovered, semantics-reviewed,
   binding-emitted, and host-verified. Unreviewed entries stay visible; they do
   not masquerade as parity.
4. A Dart generator consumes the IR and versioned Semantic Overrides to emit
   the Parity Layer, native JS interop declarations, an initial Idiomatic
   Facade, and the coverage ledger.
5. CI regenerates twice and byte-compares generated source and metadata. New or
   ambiguous symbols fail closed until a general rule or reviewed override
   classifies them.

Generate only the transitive API slice exercised by Checkpoint 1, but inventory
the entire pinned file. The implemented closure must be fully reviewed,
non-`dynamic`, and host-verified. Do not claim full API parity while other
entries remain unreviewed.

Replace the fixture's private interop kernel and handwritten manifest fields
with generated output. Re-run every Checkpoint 1 assertion unchanged.

Exit gate: the same local extension works solely through mechanically generated
bindings and manifest data, regeneration is deterministic, and the temporary
kernel is gone.

## Checkpoint 3: Package One Dart-Owned Extension

Add only the CLI surface needed to create the first distributable:

```sh
dart pub global activate flutter_vscode
flutter_vscode create my_extension
flutter_vscode build
flutter_vscode package
```

During repository development, tests activate the package from its local path.
`create` emits an explicit `host/`, `views/`, and `shared/` layout; a Host-Only
Extension simply has no `views/`. Extension metadata and the command/provider
contributions are Dart-owned. The build generates `package.json`, the bootstrap,
launch configuration, host bundle, and source maps as Framework-Managed
Artifacts.

`build` enforces the host dependency boundary and reports errors in Dart terms.
`package` assembles and validates one installable VSIX without requiring an
author to invoke npm. Repository CI may use `@vscode/test-electron`; author-side
testing will later launch the installed `code` binary with a managed test
entrypoint rather than expose Node tooling.

Test the workflow from a clean temporary directory. Assert that consumer-owned
files contain no `.js`, `.ts`, or hand-maintained `package.json`, generated
content matches regeneration, the VSIX installs, and the installed extension
passes the command and hover checks on the one pinned local VS Code build.

Exit gate: a Flutter/Dart developer can create, build, install, and run this one
host-only extension without npm, TypeScript, or manual file copying.

## Checkpoint 4: Add One Optional Flutter View

Only after host-only activation works, add a Flutter View to the fixture. Start
protocol v1 with the minimum real boundary:

- versioned session and nonce handshake;
- calls, results, and structured errors;
- schema validation and operation allowlisting;
- close/reload cleanup for pending calls; and
- CSP, private `acquireVsCodeApi` handling, and webview-safe asset URLs.

The Dart-authored command opens the view. The view reports ready, makes one
typed call to Host Dart, renders the returned value, and closes with instrumented
pending-request and subscription counts at zero. Host commands and providers
must continue working when the view was never opened or has been closed.

Events, cancellation, streams, handles, backpressure, and the full negative
protocol matrix are subsequent hardening work, not prerequisites for the first
round-trip.

Exit gate: one packaged extension proves both execution boundaries without
moving provider logic into the webview.

## From the Proof to the Vision

After the four checkpoints are green, continue in dependency order:

1. **Runtime semantics:** finish events, cancellation, progress, streams,
   callback retention, ownership scopes, structured errors, and session cleanup.
2. **API factory:** emit and verify the entire pinned stable API and contribution
   surface. Add explicit dynamic `call/get/set/construct/subscribe` access over
   the same host interop semantics, then layer the Idiomatic Facade above it.
3. **Capability fixtures:** cover trees/filesystems, terminals/tasks, language
   features, testing, SCM, notebooks, authentication, debugging, and webviews
   with Extension Host tests grouped by semantic pattern.
4. **Product workflow:** add `doctor`, `test`, and `upgrade`; generated-file
   ownership and repair; actionable diagnostics; and migration from the v0
   scaffold after actual downstream usage is known.
5. **Hardening:** test two generated extensions in one host, failure injection,
   protocol abuse, Dart breakpoint/source-map behavior, startup/memory behavior,
   Windows/macOS/Linux, and a concrete remote-host harness.
6. **Platform reach:** add the Web Extension Host before 1.0 without weakening
   the Node-host path.
7. **Documentation:** update examples, README, architecture, quickstart,
   troubleshooting, API mapping, templates, and agent skills from executable
   behavior.
8. **Support policy:** only now define version windows, upgrade guarantees,
   proposed-API experiments, performance budgets, and release support from
   measurements of the working system.

Full parity means the pinned stable baseline has no unimplemented or
unclassified public symbols and every semantic category has an executable host
test. Updating VS Code then becomes a pinned-input update, IR diff, reviewed
Semantic Overrides, deterministic regeneration, and regression tests—not an
inference exercise.

## Deferred Until the Walking Skeleton Works

- past-version support and compatibility windows;
- v0.1 migration guarantees;
- remote, browser, and multi-OS gates;
- a complete CLI and Marketplace publishing automation;
- full API classification and contribution coverage;
- production performance and security budgets.

The accepted [architecture decisions](../../docs/adr/) remain direction, but
none of these deferred policies may delay Checkpoint 1.
