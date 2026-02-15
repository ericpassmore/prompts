# Phase 2 — Implement Minimal Resolver Fix

## Objective
Update resolver logic so env fast-path only succeeds when scripts dir is valid for current repo/bootstrap context.

## Code areas impacted
- `codex/scripts/read-codex-paths.sh`
- `codex/scripts/resolve-codex-root.sh`

## Work items
- [x] Enforce bootstrap/current-root coherence checks before env fast-path return.
- [x] Reject stale/mismatched `CODEX_SCRIPTS_DIR` and continue normal resolution path.
- [x] Preserve root precedence, fallback behavior, and fail-fast semantics.

## Deliverables
- Script patch implementing stale-path rejection with minimal scope.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] Early return cannot preserve mismatched scripts dir from stale env exports.

## Verification steps
List exact commands and expected results.
- [x] Command: `bash -n codex/scripts/read-codex-paths.sh codex/scripts/resolve-codex-root.sh`
  - Expected: no syntax errors.
  - Result: PASS.
- [x] Command: `./codex/scripts/read-codex-paths.sh`
  - Expected: resolves current repo/worktree codex paths.
  - Result: PASS (`/Users/eric/.codex/worktrees/2994/prompts/codex` + `/Users/eric/.codex/worktrees/2994/prompts/codex/scripts`).

## Risks and mitigations
- Risk: Over-strict checks could reject valid configurations.
- Mitigation: checks are bound to expected root/scripts derived from current resolution flow, with fallback unchanged.
