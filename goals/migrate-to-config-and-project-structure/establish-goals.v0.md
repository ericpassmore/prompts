# establish-goals

## Status

- Iteration: v0
- State: locked
- Task name (proposed, kebab-case): migrate-to-config-and-project-structure

## Request restatement

- Create a task specification for migrating away from `codex/codex-commands.md`.
- Replace it with two canonical files at fixed locations:
  - `codex/project-structure.md` (repository-specific, using the same format family as existing `project-structure/*.md` examples)
  - `codex/codex-config.yaml` (containing the provided Code Review + Notes content)
- The specification must require reviewing every skill and every script that references `codex-commands.md` and replacing those references with either `codex/codex-config.yaml` or `codex/project-structure.md`.
- The specification must include a hard rule: execution aborts if `codex/project-structure.md` is missing.

## Context considered

- Repo/rules/skills consulted:
  - `AGENTS.md` lifecycle contract
  - `codex/skills/establish-goals/SKILL.md`
  - `codex/skills/prepare-takeoff/SKILL.md`
  - `codex/skills/prepare-phased-impl/SKILL.md`
- Relevant files (if any):
  - `codex/codex-commands.md`
  - `project-structure/basic-python.md`
  - `project-structure/mono-repo-typescript.md`
  - `project-structure/ios.md`
  - repo-wide reference scan for `codex-commands.md`
- Constraints (sandbox, commands, policy):
  - Must respect lifecycle gates and stage ordering.
  - Must not implement source migration in this request; deliver specification artifact.
  - User confirmed canonical paths:
    - `codex/project-structure.md`
    - `codex/codex-config.yaml`
  - User confirmed task slug: `migrate-to-config-and-project-structure`.

## Ambiguities

### Blocking (must resolve)

1. None.

### Non-blocking (can proceed with explicit assumptions)

1. Spec may include phased planning and verification command updates even though implementation is out of scope for this turn.

## Questions for user

1. Resolved: task slug confirmed as `migrate-to-config-and-project-structure`.
2. Resolved: canonical file locations confirmed under `./codex/`.
3. Resolved: `codex/project-structure.md` is single canonical repository-specific file.

## Assumptions (explicit; remove when confirmed)

1. The immediate deliverable is planning/specification artifacts, not repository-wide migration implementation.
2. Existing `project-structure/*.md` files remain as examples/reference and are not removed by this task unless explicitly added later.

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

## Risks / tradeoffs

- Ambiguous replacement rules across scripts/skills may cause inconsistent migration unless the spec defines mapping criteria clearly.
- Strict abort-on-missing `codex/project-structure.md` can fail early in partially migrated branches; this is intentional for contract safety.

## Next action

- Ready to lock
