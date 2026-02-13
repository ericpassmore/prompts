# Goals Extract
- Task name: fix-task-manifest-attributes
- Iteration: v0
- State: locked

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

