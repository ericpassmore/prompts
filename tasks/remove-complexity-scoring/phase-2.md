# Phase 2 — Simplify Lifecycle Integrations

## Objective

Remove scorer-specific branches from active skills, scripts, scaffolding, validators, and documentation; add the exact agent-judgment instruction.

## Code areas impacted

- `.codex/skills/establish-goals/SKILL.md`
- `.codex/skills/prepare-phased-impl/SKILL.md`
- `.codex/scripts/goals-validate.sh`
- `.codex/scripts/task-scaffold.sh`
- `.codex/scripts/prepare-phased-impl-scaffold.sh`
- `.codex/scripts/prepare-phased-impl-validate.sh`
- `.codex/project-structure.md`

## Work items

- [x] Add the exact judgment sentence to `prepare-phased-impl`.
- [x] Remove scoring dependencies and optional scored arguments from other skills.
- [x] Remove signals creation, scoring, locking, and scorer-derived validation from scripts.
- [x] Update active documentation to describe judgment-based sizing.

## Deliverables

- Active lifecycle operates without a scorer or signals file.

## Gate (must pass before proceeding)

- [x] All active integrations are scorer-free and retain their unrelated behavior.

## Verification steps

- [x] Command: `bash -n` on every modified shell script.
  - Expected: all scripts parse successfully.

## Risks and mitigations

- Risk: stale positional-argument or lock assumptions remain after deleting scoring branches.
- Mitigation: inspect complete affected functions and run representative scaffolding/validation flows.
