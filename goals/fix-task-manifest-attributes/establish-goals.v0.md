# establish-goals

## Status

- Iteration: v0
- State: locked
- Task name (proposed, kebab-case): fix-task-manifest-attributes

## Request restatement

- Add a new shell script for the `land-the-plan` workflow that runs after the safe git commit and before PR creation.
- The script must update `goals/task-manifest.csv` for the current task with current `HHMMSS` and the current git commit hash.
- The script must commit `goals/task-manifest.csv` and push the update to remote when needed.
- Add the script to the sandbox rules so it can execute without extra approval.

## Context considered

- Repo/rules/skills consulted:
  - `codex/AGENTS.md`
  - `codex/skills/acac/SKILL.md`
  - `codex/skills/land-the-plan/SKILL.md`
  - `codex/rules/git-safe.rules`
  - `codex/scripts/goals-scaffold.sh`
- Relevant files (if any):
  - `goals/task-manifest.csv`
  - `codex/skills/land-the-plan/SKILL.md`
  - `codex/rules/git-safe.rules`
- Constraints (sandbox, commands, policy):
  - Workspace-write sandbox, no network-dependent PR automation.
  - Stage ordering and gate verdicts from `codex/AGENTS.md` are mandatory.

## Ambiguities

### Blocking (must resolve)

1. None.

### Non-blocking (can proceed with explicit assumptions)

1. “Current git commit” refers to `HEAD` at script start (the commit produced by the preceding safe commit step).
2. “If needed git push” means push only when the script creates a new manifest commit.

## Questions for user

1. None; request is specific enough to execute.

## Assumptions (explicit; remove when confirmed)

1. The manifest row for the current task already exists from Stage 1 task creation; missing-row state should be treated as `BLOCKED`.
2. Timestamp should use UTC `HHMMSS` to stay aligned with existing UTC date handling in manifest logic.

## Goals (1-10, verifiable)

1. Add a new shell script under `codex/scripts/` that updates the current task row in `goals/task-manifest.csv` with `first_create_hhmmss` and `first_create_git_hash` from runtime context.
2. Ensure the script commits `goals/task-manifest.csv` after updating it and pushes the branch update to `origin` when a new commit is created.
3. Update `codex/skills/land-the-plan/SKILL.md` so the new script is required immediately after Stage 6 Step 2 (`git-commit`) and before PR creation.
4. Add sandbox allow rules for the new script path variants in the appropriate rules surface (`codex/rules/git-safe.rules`).
5. Keep changes surgical to requested skill/rule/script surfaces plus required lifecycle artifacts.

## Non-goals (explicit exclusions)

- No refactor of unrelated lifecycle scripts or stages.
- No changes to PR body schema requirements beyond required step renumbering/flow placement.

## Success criteria (objective checks)

> Tie each criterion to a goal number when possible.

- [G1] A new executable script exists in `codex/scripts/` and fails fast on invalid task, missing manifest, or missing task row.
- [G2] Script behavior sets `first_create_hhmmss` and `first_create_git_hash` for the current task, then creates/pushes a manifest-only commit when changes exist.
- [G3] `codex/skills/land-the-plan/SKILL.md` explicitly places the script between `git-commit` and PR creation.
- [G4] `codex/rules/git-safe.rules` includes allow entries for home/canonical/repo-local script paths.
- [G5] Stage validators for planning/implementation/revalidation pass for this task.

## Risks / tradeoffs

- Adding an extra commit during landing changes commit topology (one additional metadata commit before PR creation), but keeps manifest metadata current.

## Next action

- Goals locked; proceed to `prepare-takeoff`.
