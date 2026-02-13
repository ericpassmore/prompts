# Phase 1 — Expand Task Manifest Schema

## Objective
Add the two requested manifest columns and deterministic default/backfill behavior in the manifest rebuild path.

## Code areas impacted
- `codex/scripts/goals-scaffold.sh`
- `goals/task-manifest.csv`

## Work items
- [x] Add manifest columns `first_create_hhmmss` and `first_create_git_hash`.
- [x] Backfill defaults for existing manifest rows (`000000`, `-------`).
- [x] Keep manifest rebuild deterministic and task-safe.

## Deliverables
- Updated manifest rebuild logic.
- Regenerated `goals/task-manifest.csv` with the new schema.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] Manifest header and row emission include five columns with expected defaults.

## Verification steps
List exact commands and expected results.
- [x] Command: `rg -n "^number,taskname,first_create_date,first_create_hhmmss,first_create_git_hash$" goals/task-manifest.csv`
  - Expected: one match confirming new manifest schema.

## Risks and mitigations
- Risk: schema update may break parsing assumptions for legacy 3-column rows.
- Mitigation: handle both legacy and new-row layouts during manifest rebuild.
