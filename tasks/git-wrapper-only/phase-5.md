# Phase 5 — Verification And Readiness Evidence

## Objective
Run the pinned command classes and targeted checks, record evidence, and prepare the task for landing without using the Codex MCP GitHub service.

## Code areas impacted
- `tasks/git-wrapper-only/spec.md`
- `tasks/git-wrapper-only/final-phase.md`
- In-scope verification records

## Work items
- [x] Run lint/build/test command classes as pinned in `spec.md`.
- [x] Run targeted shell syntax, spelling, raw git guidance, and Codex MCP GitHub service searches.
- [x] Run lifecycle validators required for Stage 3 and Stage 4.
- [x] Update final-phase evidence with explicit pass/blocker notes.

## Deliverables
- Verification evidence mapped to G1-G6 and a Stage 4 `READY TO LAND` handoff if all gates pass.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] Lint/build/test command classes are recorded as pass or explicit `not-configured` outcomes.
- [x] Targeted checks pass or blockers are documented.
- [x] Implementation validation emits `READY TO LAND`.

## Verification steps
List exact commands and expected results.
- [x] Command: `bash -n codex/scripts/git-track-safe-untracked.sh`
  - Expected: exits 0.
  - Evidence: PASS, expanded syntax check also covered new helper scripts.
- [x] Command: `./codex/scripts/prepare-phased-impl-validate.sh git-wrapper-only`
  - Expected: `READY FOR IMPLEMENTATION`.
  - Evidence: PASS before implementation; final rerun pending.
- [x] Command: `./codex/scripts/implement-validate.sh git-wrapper-only`
  - Expected: `READY TO LAND`.
  - Evidence: PASS, validator emitted `READY TO LAND`.

## Risks and mitigations
- Risk: Repository-wide lint/build/test commands are not configured.
- Mitigation: Record explicit `not-configured` outcomes from canonical command records and rely on targeted checks plus lifecycle validators.
