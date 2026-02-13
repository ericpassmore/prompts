# Goals Extract
- Task name: improve-task-grain
- Iteration: v0
- State: locked

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

