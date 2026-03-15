# Phase 6 — Verification And Implementation Handoff

## Objective
Reconcile the planned assets, phases, and verification expectations into an implementation-ready handoff with no scope drift and clear closeout criteria.

## Code areas impacted
- `tasks/self-improve-skills/phase-plan.md`
- `tasks/self-improve-skills/final-phase.md`
- `tasks/self-improve-skills/spec.md`
- `tasks/self-improve-skills/phase-6.md`

## Work items
- [x] Add phase-sequence and goal-traceability detail to `phase-plan.md`.
- [x] Update `final-phase.md` with task-specific closeout expectations for docs, verification, rollout notes, and review.
- [x] Confirm all planning artifacts remain within the locked scope snapshot and are ready for Stage 4 execution.

## Deliverables
- Complete phase plan with goal traceability in `tasks/self-improve-skills/phase-plan.md`.
- Task-specific final-phase closeout plan suitable for implementation and landing in `tasks/self-improve-skills/final-phase.md`.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] Planning artifacts are internally consistent, validator-ready, and require no new scope or goal reinterpretation to begin implementation.

## Verification steps
List exact commands and expected results.
- [x] Command: `./codex/scripts/prepare-phased-impl-validate.sh self-improve-skills`
  - Expected: emits `READY FOR IMPLEMENTATION` after all active phase docs and scope locks are complete.
- [x] Result: PASS. Stage 3 validator emitted `READY FOR IMPLEMENTATION` before Stage 4 execution.
- [x] Command: `sed -n '1,260p' tasks/self-improve-skills/final-phase.md`
  - Expected: confirms the final-phase closeout plan is specific to this task rather than template-only.
- [x] Result: PASS. `final-phase.md` now contains task-specific verification, review, and rollout expectations.

## Risks and mitigations
- Risk: planning artifacts can remain formally valid but still be too vague for efficient implementation.
- Mitigation: require concrete target files, phase deliverables, and verification expectations in every active phase.
