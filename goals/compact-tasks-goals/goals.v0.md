# Goals Extract
- Task name: compact-tasks-goals
- Iteration: v0
- State: locked

## Goals (1-20, verifiable)

1. Implement Stage 6 (`land-the-plan`) artifact compaction logic that runs after completion gates and before final handoff is emitted.
2. Preserve exactly one goal file for the landed task and keep the retained goal file content unmodified.
3. Preserve exactly one spec file for the landed task (`tasks/<task>/spec.md`) and remove redundant task artifact files that are not required by retention policy.
4. Create or update a task audit log that records lifecycle execution completeness and, for incomplete runs, the completed portion and explicit blocker/reason.
5. Store compacted reconstruction metadata under task artifacts sufficient to recreate the landed change from retained goals/spec plus compact data (including diffs where applicable).
6. Ensure compaction behavior is deterministic, fail-fast on missing prerequisites, and does not modify files outside the target task's `goals/` and `tasks/` surfaces.
7. Update `land-the-plan` stage documentation to include the compaction behavior and outputs so stage contract and scripts stay aligned.


## Non-goals (explicit exclusions)

- Retrospective compaction for all existing historical tasks in one migration.
- Any change to stage order, verdict vocabulary, or upstream stage validators unrelated to this retention feature.


## Success criteria (objective checks)

> Tie each criterion to a goal number when possible.

- [G1] Stage 6 flow includes a scripted compaction step and the implementation is invoked from land-stage automation.
- [G2] For the active task, only one `goals.vN.md` remains under `goals/<task>/` and its content hash is unchanged pre/post compaction.
- [G3] For the active task, `tasks/<task>/spec.md` remains and redundant task files are removed or compacted according to policy.
- [G4] `tasks/<task>/audit-log.md` exists and includes completion status plus blocker/progress format for incomplete runs.
- [G5] A compact reconstruction artifact (diff or equivalent) is produced and references enough information to recreate the landed patch from retained files.
- [G6] Script exits non-zero with explicit errors when required files are missing or unsafe conditions are detected.
- [G7] `codex/skills/land-the-plan/SKILL.md` reflects the new compaction step and required outputs.

