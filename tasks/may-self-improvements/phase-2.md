# Phase 2 — Complexity Signals Reliability

## Objective

Implement G1 by making complexity-signal creation and guidance reliable before Stage 3 scoring/scaffolding requires it.

## Code areas impacted
- `codex/scripts/task-scaffold.sh`
- `codex/scripts/prepare-phased-impl-scaffold.sh`
- `codex/scripts/complexity-score.sh`
- `codex/tasks/_templates/complexity-signals.template.json`
- `codex/skills/prepare-phased-impl/SKILL.md`
- `codex/skills/complexity-scaling/SKILL.md`

## Work items
- [ ] Decide whether Stage 2 task scaffolding, Stage 3 scaffolding, or both should materialize `tasks/<task>/complexity-signals.json`.
- [ ] Ensure generated signals contain required scorer evidence tokens, including `interfaces=` and `checks=`.
- [ ] Improve failure text or guidance when task-local signals are missing or invalid.
- [ ] Add targeted verification for first-pass scorer compatibility.

## Deliverables
- Task-local complexity signals are created or remediated before the Stage 3 scorer hard-requires them.
- Template/guidance remains scorer-compatible.
- G1 verification evidence is recorded in implementation artifacts.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [ ] A newly scaffolded task can reach Stage 3 scoring without manual complexity-signals file creation.
- [ ] The shared complexity-signals template passes `complexity-score.sh`.
- [ ] Error guidance is actionable when signals are malformed.

## Verification steps
List exact commands and expected results.
- [ ] Command: `./codex/scripts/complexity-score.sh codex/tasks/_templates/complexity-signals.template.json --format json`
  - Expected: exits 0 and reports a valid score.
- [ ] Command: `./codex/scripts/prepare-phased-impl-validate.sh may-self-improvements`
  - Expected: remains valid after planning artifacts are updated.

## Risks and mitigations
- Risk: creating a task-local signals file too early could imply planning before goals are locked.
- Mitigation: materialize only as a neutral template artifact and keep scoring/planning gated by Stage 3.
