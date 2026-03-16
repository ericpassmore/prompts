# Phase 5 — Validation And Closeout Artifacts

## Objective
Run the bounded validation suite for the implemented fixes and update Stage 4 closeout artifacts so the repo has traceable evidence for each resolved issue.

## Code areas impacted
- `tasks/fix-open-prompts-issues/final-phase.md`
- `tasks/fix-open-prompts-issues/phase-5.md`
- `tasks/fix-open-prompts-issues/spec.md`

## Work items
- [x] Record the exact validation commands and outcomes used for the issue fixes.
- [x] Update `final-phase.md` with Stage 4 evaluation status and verification evidence.
- [x] Run `implement-validate.sh` once the implementation is complete.

## Deliverables
- Updated `final-phase.md` with truthful evaluation and verification entries.
- Stage 4 validator output for `fix-open-prompts-issues`.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] The validation evidence covers each implemented fix, and `implement-validate.sh` emits `READY TO LAND`.

## Verification steps
List exact commands and expected results.
- [x] Command: `./codex/scripts/prepare-phased-impl-validate.sh fix-open-prompts-issues`
  - Expected: prints `READY FOR IMPLEMENTATION`.
- [x] Command: `./codex/scripts/implement-validate.sh fix-open-prompts-issues`
  - Expected: prints `READY TO LAND` after Stage 4 artifacts are complete.

## Risks and mitigations
- Risk: validation notes could drift from the actual commands run.
- Mitigation: record the exact commands and outputs immediately after execution.
