# Phase 3 — Reverification, Consistency, And Lifecycle Closeout Prep

## Objective
Verify script/skill changes are internally consistent and stage validators can proceed without worktree lifecycle requirements.

## Code areas impacted
- `tasks/remove-worktree/spec.md`
- `tasks/remove-worktree/phase-plan.md`
- `tasks/remove-worktree/final-phase.md`
- `tasks/remove-worktree/revalidate.md`
- `tasks/remove-worktree/revalidate-code-review.md`

## Work items
- [x] Update task artifacts to record implementation and verification evidence.
- [x] Run mandatory stage validators (`prepare-phased-impl`, `implement`, `revalidate`) for this task.
- [x] Record code-review findings status and final revalidation verdict.

## Deliverables
- Stage artifacts updated with concrete evidence and terminal stage verdicts.
- Validator outputs showing implementation and reverification readiness.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] `prepare-phased-impl-validate.sh` returns `READY FOR IMPLEMENTATION`.
- [x] Task artifacts stay in locked scope and include explicit verification records.

## Verification steps
List exact commands and expected results.
- [x] Command: `./codex/scripts/prepare-phased-impl-validate.sh remove-worktree`
  - Expected: `READY FOR IMPLEMENTATION`.
  - Result: PASS
- [x] Command: `git diff --name-only`
  - Expected: changed-file set remains within approved scope for this task.
  - Result: PASS (active tracked diff is in codex scripts/skills/rules and stage artifacts)

## Risks and mitigations
- Risk: validator expectations may fail if task artifacts are missing required markers.
- Mitigation: update each lifecycle artifact immediately after each stage action and rerun validators.
