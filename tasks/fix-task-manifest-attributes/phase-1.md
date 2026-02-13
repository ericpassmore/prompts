# Phase 1 — Add Manifest Landing Script

## Objective
Implement the new landing helper that updates current-task manifest metadata and performs manifest commit/push safely.

## Code areas impacted
- `codex/scripts/task-manifest-land-update.sh`

## Work items
- [x] Create `task-manifest-land-update.sh` with strict input and environment validation.
- [x] Update only the target task row in `goals/task-manifest.csv` (`first_create_hhmmss`, `first_create_git_hash`).
- [x] Commit manifest-only change when updates exist and push to origin branch.

## Deliverables
- New executable script in `codex/scripts/`.

## Gate (must pass before proceeding)
Phase passes when script exists, is executable, and supports fail-fast behavior for invalid/missing prerequisites.
- [x] Script supports happy path and fail-fast path.

## Verification steps
List exact commands and expected results.
- [x] Command: `bash -n codex/scripts/task-manifest-land-update.sh`
  - Expected: syntax check passes.

## Risks and mitigations
- Risk: script might accidentally rewrite non-target manifest rows.
- Mitigation: key updates strictly by task name column and verify row existence before write.
