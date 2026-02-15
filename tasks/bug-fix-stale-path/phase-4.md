# Phase 4 — Validator Closeout and Revalidate Handoff

## Objective
Finalize lifecycle artifacts and validator outputs to reach revalidate-ready status.

## Code areas impacted
- `tasks/bug-fix-stale-path/final-phase.md`
- `tasks/bug-fix-stale-path/revalidate.md`
- `tasks/bug-fix-stale-path/revalidate-code-review.md`

## Work items
- [x] Run Stage 3 validator and resolve any blockers.
- [x] Complete Stage 4 final-phase verification ledger.
- [x] Run implement and revalidate validators.

## Deliverables
- Validator-backed lifecycle artifacts with terminal revalidate verdict.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] Validators emit expected verdicts without unresolved blockers.

## Verification steps
List exact commands and expected results.
- [x] Command: `./codex/scripts/prepare-phased-impl-validate.sh bug-fix-stale-path`
  - Expected: `READY FOR IMPLEMENTATION`.
  - Result: PASS (`READY FOR IMPLEMENTATION`).
- [x] Command: `./codex/scripts/implement-validate.sh bug-fix-stale-path`
  - Expected: `READY FOR REVERIFICATION`.
  - Result: PASS (`READY FOR REVERIFICATION`).
- [x] Command: `./codex/scripts/revalidate-code-review.sh bug-fix-stale-path`
  - Expected: `READY`.
  - Result: PASS (`READY`).
- [x] Command: `./codex/scripts/revalidate-validate.sh bug-fix-stale-path`
  - Expected: `READY TO LAND`.
  - Result: PASS (`READY TO LAND`).

## Risks and mitigations
- Risk: Incomplete artifact details can fail validators.
- Mitigation: update artifacts immediately with exact command results and keep checklist evaluation explicit.
