# Goals Extract
- Task name: remove-complexity-scoring
- Iteration: v0
- State: locked

## Goals (1-20, verifiable)

1. Add exactly `Use your judgment to scale the number of goals and implementation phases to the task’s complexity.` to the active `prepare-phased-impl` skill.
2. Remove the active `complexity-scaling` skill and deterministic scorer executable/template machinery.
3. Remove complexity-score and complexity-signals dependencies from all other active skills, prompts, rules, scripts, and active documentation.
4. Preserve existing historical records under `goals/` and `tasks/` unchanged, except for the new artifacts created for this task.
5. Verify active surfaces contain no references to the removed scoring machinery and relevant script validation passes.


## Non-goals (explicit exclusions)

- Rewriting or deleting historical records for completed or existing tasks.
- Removing `establish-goals` or changing its core goal-lock workflow beyond eliminating its complexity-scoring dependency.
- Replacing complexity scoring with a new deterministic rubric or scorer.


## Success criteria (objective checks)

> Tie each criterion to a goal number when possible.

- [G1] The exact sentence appears in `.codex/skills/prepare-phased-impl/SKILL.md`.
- [G2] The complexity-scaling skill, scorer script, and complexity-signals template no longer exist in active repository surfaces.
- [G3] A repository search excluding `goals/` and `tasks/` finds no active dependency on `complexity-score`, `complexity-signals`, or the `complexity-scaling` skill.
- [G4] Pre-existing historical files under `goals/` and `tasks/` are not rewritten or deleted.
- [G5] Modified shell scripts pass syntax checks and relevant repository validations/tests pass.

