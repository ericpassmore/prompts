# Phase 3 — Verify Behavior and Drift Safety

## Objective
Verify corrected stale-path behavior and ensure no lifecycle drift was introduced.

## Code areas impacted
- `tasks/bug-fix-stale-path/phase-3.md`
- `tasks/bug-fix-stale-path/final-phase.md`

## Work items
- [x] Re-run stale-env simulation and confirm corrected scripts-dir resolution.
- [x] Re-run normal resolver checks for current repo paths.
- [x] Capture verification evidence in final-phase artifact.

## Deliverables
- Evidence that stale env scripts dir is rejected and replaced by current expected path.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] Post-fix output shows current expected `CODEX_SCRIPTS_DIR` despite stale env input.

## Verification steps
List exact commands and expected results.
- [x] Command: `CODEX_ROOT="$(pwd)/codex" CODEX_SCRIPTS_DIR="/Users/eric/.codex/scripts" bash -lc 'source codex/scripts/read-codex-paths.sh >/dev/null; printf "%s\n%s\n" "$CODEX_ROOT" "$CODEX_SCRIPTS_DIR"'`
  - Expected: outputs current worktree `codex` and `codex/scripts`, not stale scripts path.
  - Result: PASS.
- [x] Command: `CODEX_ROOT="/Users/eric/side-projects/prompts/codex" ./codex/scripts/resolve-codex-root.sh scripts codex-config.yaml project-structure.md`
  - Expected: stale explicit root from another repo/worktree is ignored for this repo context.
  - Result: PASS (`/Users/eric/.codex/worktrees/2994/prompts/codex`).

## Risks and mitigations
- Risk: Absolute-path assertions can be brittle across environments.
- Mitigation: evidence is recorded for this workspace and follows deterministic repo/worktree paths.
