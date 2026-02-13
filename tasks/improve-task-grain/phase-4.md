# Phase 4 — Reverify and Capture Evidence

## Objective
Run targeted validations and record evidence in task artifacts for handoff to Stage 4/5.

## Code areas impacted
- `tasks/improve-task-grain/spec.md`
- `tasks/improve-task-grain/final-phase.md`
- `goals/task-manifest.csv`

## Work items
- [x] Execute script syntax checks and Stage 3/4/5 validators.
- [x] Update task artifacts with verification outcomes and stage evidence.
- [x] Confirm no scope drift from locked snapshot.

## Deliverables
- Updated lifecycle artifacts with readiness and verification proof.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] Validators pass with no unresolved blockers.

## Verification steps
List exact commands and expected results.
- [x] Command: `bash -n codex/scripts/goals-scaffold.sh codex/scripts/prepare-phased-impl-validate.sh codex/scripts/complexity-score.sh`
  - Expected: no syntax errors.
- [x] Command: `./codex/scripts/prepare-phased-impl-validate.sh improve-task-grain`
  - Expected: `READY FOR IMPLEMENTATION`.

## Risks and mitigations
- Risk: validator evidence may be incomplete for Stage 4 if not captured in final-phase ledger.
- Mitigation: write explicit command outcomes in `final-phase.md` during implementation.
