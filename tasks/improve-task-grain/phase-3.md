# Phase 3 — Enforce Complexity in Stage 3 Validation

## Objective
Require `prepare-phased-impl-validate.sh` to always use complexity scoring and enforce requested goal/phase bounds.

## Code areas impacted
- `codex/scripts/prepare-phased-impl-validate.sh`

## Work items
- [x] Add complexity signals resolution and mandatory complexity-score invocation.
- [x] Validate goal count from locked goals artifact against scorer ranges and hard bounds (`0..20` with zero-goal abort).
- [x] Validate phase count against scorer ranges and hard bounds (`1..12`).

## Deliverables
- Updated Stage 3 validator with complexity-enforced cardinality gates.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] Validator fails when complexity signals or cardinality constraints are violated.

## Verification steps
List exact commands and expected results.
- [x] Command: `./codex/scripts/prepare-phased-impl-validate.sh improve-task-grain`
  - Expected: returns `READY FOR IMPLEMENTATION` only when new complexity/cardinality checks pass.

## Risks and mitigations
- Risk: old tasks without task-local signals may fail unexpectedly.
- Mitigation: provide deterministic fallback to codex complexity-signals template when task-local signals are absent.
