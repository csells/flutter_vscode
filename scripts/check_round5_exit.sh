#!/usr/bin/env bash
set -uo pipefail

# Evaluates the frozen Round-5 exit bar from the plan. This script is the
# only authority allowed to call Round 5 done: the plan status line may
# claim completion only when this script exits 0 at HEAD.
#
# Usage: ./scripts/check_round5_exit.sh [--skip-heavy]
#   --skip-heavy  skip the VS Code-launching packaged gate (R5-6/R5-7 are
#                 then reported from static evidence only, never as PASS).

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

SKIP_HEAVY=0
[[ "${1:-}" == "--skip-heavy" ]] && SKIP_HEAVY=1

FAILURES=0
pass() { echo "PASS  $1"; }
fail() { echo "FAIL  $1 — $2"; FAILURES=$((FAILURES + 1)); }

run_quiet() { "$@" >/dev/null 2>&1; }

# R5-1 / R5-2: prose-truth and self-consistency ratchet
if run_quiet flutter test test/plan_truth_test.dart; then
  pass "R5-1/R5-2 plan truth + consistency (test/plan_truth_test.dart)"
else
  fail "R5-1/R5-2" "flutter test test/plan_truth_test.dart is red or missing"
fi

# R5-3 was removed from the exit bar by owner decision (2026-07-22): a
# fork should not host the project's CI. The first CI execution moves to
# the backlog with the upstream pull request; closure evidence is
# therefore self-attested with this script as the mechanical authority.
HEAD_SHA="$(git rev-parse HEAD)"
echo "INFO  R5-3 removed by owner decision; no CI witness required"

# R5-4: shape member value validation
if run_quiet flutter test test/binding_generator_test.dart \
  --plain-name "rejects registered shape members with malformed values"; then
  pass "R5-4 shape member value validation"
else
  fail "R5-4" "value-validation test missing or red"
fi

# R5-5: lockfile committed in HEAD
if git ls-tree --name-only HEAD -- pubspec.lock | grep -qx "pubspec.lock" \
  && run_quiet flutter test test/repository_gate_test.dart \
    --plain-name "lock-enforced Host builds include a trackable root lockfile"; then
  pass "R5-5 lockfile in HEAD tree + tightened gate"
else
  fail "R5-5" "pubspec.lock not in HEAD or gate test red"
fi

# R5-6 / R5-7: packaged gate with hover-first view fixture and pub-true staging
if grep -q "rsync" scripts/test_packaged_extension.sh; then
  fail "R5-7" "packaged staging still uses rsync approximation"
else
  pass "R5-7 staging consumes pub's own file selection (static)"
fi
if grep -q "hover-first" test/fixtures/packaged_test_driver/test/run.cjs \
  && grep -q "isActive" test/fixtures/packaged_test_driver/test/run.cjs; then
  pass "R5-6 view-fixture hover-first assertions present (static)"
else
  fail "R5-6" "driver lacks view-fixture hover-first assertions"
fi
if [[ "${SKIP_HEAVY}" -eq 1 ]]; then
  fail "R5-6/R5-7 execution" "--skip-heavy given; packaged gate not executed"
else
  if ./scripts/test_packaged_extension.sh >/dev/null 2>&1; then
    pass "R5-6/R5-7 packaged gate executed green"
  else
    fail "R5-6/R5-7 execution" "./scripts/test_packaged_extension.sh failed"
  fi
fi

# R5-8: symlink-resolving pin containment
# Capture first: with pipefail, grep -q's early pipe close would turn a
# passing node run into a SIGPIPE failure.
PINS_OUTPUT="$(cd tool/binding_importer && node --test test/pins.test.cjs 2>&1)"
PINS_EXIT=$?
if [[ "${PINS_EXIT}" -eq 0 ]] && grep -q "symlink" <<<"${PINS_OUTPUT}"; then
  pass "R5-8 pin containment resolves symlinks"
else
  fail "R5-8" "symlink containment test missing or red"
fi

# R5-9: contract writer write path tested
if run_quiet flutter test test/binding_evidence_test.dart \
  --plain-name "writer"; then
  pass "R5-9 contract writer write-path tests"
else
  fail "R5-9" "write-path tests missing or red"
fi

# R5-10: shipped-surface honesty
R510_OK=1
[[ -f bin/init.dart ]] && { fail "R5-10" "dead bin/init.dart still ships"; R510_OK=0; }
head -5 PRD.md | grep -qi "historical" || { fail "R5-10" "PRD.md lacks historical banner"; R510_OK=0; }
run_quiet flutter test test/repository_gate_test.dart \
  --plain-name "legacy" || { fail "R5-10" "legacy-surface gate missing or red"; R510_OK=0; }
[[ "${R510_OK}" -eq 1 ]] && pass "R5-10 shipped-surface honesty"

# R5-11: generated parity report
if [[ -f docs/reference/parity.md ]] \
  && grep -q "parity.md" docs/reference/index.md \
  && grep -qi "defect" docs/reference/parity.md; then
  pass "R5-11 parity report present, linked, defect-rule stated"
else
  fail "R5-11" "parity report missing, unlinked, or missing the defect rule"
fi

# R5-12: CHANGELOG covers the hardening rounds
if grep -qiE "host.bindings?" CHANGELOG.md && grep -qi "evidence" CHANGELOG.md; then
  pass "R5-12 CHANGELOG records host-path and evidence-model changes"
else
  fail "R5-12" "CHANGELOG missing consumer-visible hardening entries"
fi

# R5-13: terminal closure basics (the two consecutive test_all runs are
# procedural evidence executed at closure; this script cannot re-verify
# them and does not claim to)
if run_quiet flutter analyze; then
  pass "R5-13 flutter analyze clean"
else
  fail "R5-13" "flutter analyze reports issues"
fi
STATUS_BEFORE="$(git status --porcelain)"
if ! dart tool/binding_generator/generate.dart --contract . >/dev/null 2>&1; then
  fail "R5-13" "contract regenerator failed to execute"
fi
STATUS_AFTER="$(git status --porcelain)"
if [[ "${STATUS_AFTER}" == "${STATUS_BEFORE}" ]]; then
  pass "R5-13 contract regenerator byte-for-byte no-op"
else
  git checkout -- tool/bindings 2>/dev/null
  fail "R5-13" "regenerator changed tracked files on a converged tree"
fi

echo
if [[ "${FAILURES}" -eq 0 ]]; then
  echo "ROUND 5 EXIT BAR: DONE (all checks green at ${HEAD_SHA:0:9})"
  exit 0
fi
echo "ROUND 5 EXIT BAR: NOT DONE (${FAILURES} failing check(s))"
exit 1
