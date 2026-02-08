# Goals Extract
- Task name: migrate-to-config-and-project-structure
- Iteration: v0
- State: locked

## Goals (0–5, verifiable)

> If ambiguity is blocking, it is valid to have 0 goals.

1. Produce a complete task specification at `tasks/migrate-to-config-and-project-structure/spec.md` for replacing `codex/codex-commands.md` with `codex/project-structure.md` and `codex/codex-config.yaml`.
2. Include an explicit migration inventory requirement covering every affected skill and script reference to `codex-commands.md`, with replacement target (`codex/codex-config.yaml` vs `codex/project-structure.md`) defined per usage intent.
3. Include a hard execution gate in the specification: if `codex/project-structure.md` is missing, execution must abort with a clear blocked reason.
4. Include objective acceptance criteria and verification steps that prove reference migration completeness and enforcement of the new required files.


## Non-goals (explicit exclusions)

- Performing the actual repository-wide migration in this stage.
- Changing runtime behavior outside the documented `codex-commands.md` replacement scope.


## Success criteria (objective checks)

> Tie each criterion to a goal number when possible.

- [G1] `tasks/migrate-to-config-and-project-structure/spec.md` exists and defines current behavior, proposed behavior, technical design, verification commands, IN/OUT scope, and acceptance checklist for this migration.
- [G2] The spec explicitly requires full review of all skills and scripts with existing `codex-commands.md` references and defines replacement mapping to `codex/codex-config.yaml` or `codex/project-structure.md`.
- [G3] The spec includes an explicit abort rule when `codex/project-structure.md` is missing.
- [G4] The spec includes verification steps that check no active references to `codex-commands.md` remain (except intentional deprecation context) and validates presence/usage of new canonical files.

