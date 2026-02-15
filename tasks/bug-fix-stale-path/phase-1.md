# Phase 1 — Reproduce and Bound the Bug

## Objective
Capture a concrete stale `CODEX_SCRIPTS_DIR` reproduction and define expected post-fix behavior boundaries.

## Code areas impacted
- `tasks/bug-fix-stale-path/spec.md`
- `tasks/bug-fix-stale-path/phase-1.md`

## Work items
- [x] Simulate stale env vars from a mismatched scripts directory.
- [x] Capture observed current behavior from `read-codex-paths.sh`.
- [x] Define exact acceptance criteria for corrected early-return behavior.

## Deliverables
- Reproduction evidence and expected-result notes in this phase file.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] Repro command and expected corrected behavior are explicitly documented.

## Verification steps
List exact commands and expected results.
- [x] Command: `CODEX_ROOT="$(pwd)/codex" CODEX_SCRIPTS_DIR="/Users/eric/.codex/scripts" bash -lc 'source codex/scripts/read-codex-paths.sh >/dev/null; printf "%s\n%s\n" "$CODEX_ROOT" "$CODEX_SCRIPTS_DIR"'`
  - Expected: stale scripts path is not accepted for current repo/bootstrap context.
  - Result: PASS (`CODEX_SCRIPTS_DIR` resolved to `/Users/eric/.codex/worktrees/2994/prompts/codex/scripts`).

## Risks and mitigations
- Risk: Reproduction path may vary if stale directory is missing.
- Mitigation: use an existing alternate scripts directory path that contains resolver helpers.

## Baseline risk documentation
- Prior fast-path accepted env values if env root/scripts existed and scripts dir contained `resolve-codex-root.sh`, allowing stale cross-session scripts dirs to persist before bootstrap-consistent resolution was consulted.
