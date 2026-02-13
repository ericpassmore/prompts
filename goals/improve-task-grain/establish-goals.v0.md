# establish-goals

## Status

- Iteration: v0
- State: locked
- Task name (proposed, kebab-case): improve-task-grain

## Request restatement

- Improve task grain metadata and complexity-gated phase validation.
- Add two columns to the task manifest with defaults: `hhmmss` and commit hash.
- Preserve ordering by date/time.
- Update `prepare-phased-impl-validate` to always use complexity scoring with expanded goal/phase ranges and the provided level mapping.

## Context considered

- Repo/rules/skills consulted: `codex/AGENTS.md`, `codex/skills/acac/SKILL.md`, `codex/skills/establish-goals/SKILL.md`
- Relevant files (if any): `goals/task-manifest.csv`, `codex/scripts/prepare-phased-impl-validate.sh`, `codex/scripts/complexity-score.sh`
- Constraints (sandbox, commands, policy): must follow ACAC stage order; no implementation before goals are locked and approved.

## Ambiguities

### Blocking (must resolve)

1. None.

### Non-blocking (can proceed with explicit assumptions)

1. "hour-minute-second as a single 6 digit string" is interpreted as `hhmmss` (zero padded) stored as text.
2. "git commit hash" default `-------` applies when commit hash is unavailable.

## Questions for user

1. None; request is specific enough to lock.

## Assumptions (explicit; remove when confirmed)

1. Existing manifest rows should be backfilled with `000000` and `-------` when new columns are introduced.
2. "Maintain order by date time" means stable ordering by `first_create_date` then `hhmmss`, ascending.

## Goals (1-10, verifiable)

1. Update task-manifest schema to include two new columns: `first_create_hhmmss` (default `000000`) and `first_create_git_hash` (default `-------`).
2. Ensure manifest creation/update logic writes default values for new tasks and backfills defaults for existing rows without data loss.
3. Ensure manifest ordering is maintained by `first_create_date` then `first_create_hhmmss` (ascending).
4. Update `prepare-phased-impl-validate.sh` so complexity-scaling constraints are always enforced using complexity signals.
5. Expand cardinality support to goals `1-20` and phases `1-12`, while preserving hard-fail behavior when goals are zero.
6. Replace level-to-range mapping with the exact requested mapping for L1-L5 goal/phase min/max ranges.

## Non-goals (explicit exclusions)

- No changes to lifecycle stage order or stage verdict vocabulary.
- No changes to unrelated scripts outside manifest and `prepare-phased-impl-validate` path.

## Success criteria (objective checks)

> Tie each criterion to a goal number when possible.

- [G1] `goals/task-manifest.csv` header includes the two new columns with existing records represented using required defaults.
- [G2] Running the manifest update path appends/updates rows using `000000` and `-------` when timestamp/hash are not available.
- [G3] Manifest rows are sorted by date then hhmmss.
- [G4] `prepare-phased-impl-validate.sh` requires complexity-based bounds (not optional) for goals/phases validation.
- [G5] Validator accepts counts in expanded bounds and still aborts on zero goals.
- [G6] Level mapping logic in validation artifacts matches the provided L1-L5 ranges exactly.

## Risks / tradeoffs

- Widening ranges without aligning all call sites could create mismatch if other scripts retain legacy limits.

## Next action

- Handoff: `prepare-takeoff` owns task scaffolding and `spec.md` readiness content.
