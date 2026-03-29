# Phase 3 — Verify Wrapper Behavior and Landing Readiness

## Objective
Run targeted wrapper/config checks, validate lifecycle readiness, and prepare the task for landing without expanding scope.

## Code areas impacted
- `tasks/gh-wrapper-auth-routing/*`
- changed files from Phases 1 and 2

## Work items
- [x] Run targeted wrapper behavior probes for default auth fallback and configured-but-unset mapping failure.
- [x] Update `final-phase.md` with full verification and checklist evaluation.
- [x] Run Stage 3 and Stage 4 validators to reach `READY TO LAND`.

## Deliverables
- Completed task artifacts with verification evidence.
- `READY TO LAND` stage outcome.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] Targeted wrapper checks pass with expected outcomes.
- [x] `prepare-phased-impl-validate.sh` and `implement-validate.sh` pass for this task.
- [x] No unresolved actionable issues remain before landing.

## Verification steps
List exact commands and expected results.
- [x] Command: `./codex/scripts/prepare-phased-impl-validate.sh gh-wrapper-auth-routing`
  - Expected: `READY FOR IMPLEMENTATION`. Result: PASS.
- [x] Command: `./codex/scripts/implement-validate.sh gh-wrapper-auth-routing`
  - Expected: `READY TO LAND`. Result: PASS.

## Risks and mitigations
- Risk: wrapper verification could rely on live GitHub state and become flaky.
- Mitigation: keep Stage 4 checks focused on deterministic local wrapper behavior and syntax, and leave live auth mutation to the manual diagnostic wrapper.
