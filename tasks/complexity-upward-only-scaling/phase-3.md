# Phase 3 — Enforce Upward-Only Phase Scaling

## Objective
Apply complexity enforcement only to minimum phase requirements while allowing phase counts above complexity max.

## Code areas impacted
- `codex/scripts/prepare-phased-impl-validate.sh`

## Work items
- [x] Remove complexity goal-range blocking.
- [x] Change phase-range check to minimum-only enforcement.
- [x] Preserve complexity lock drift detection and global phase bounds.

## Deliverables
- Stage 3 validator blocks under-scaled plans and allows above-max phase plans.

## Gate (must pass before proceeding)
Stage 3 validation behavior reflects upward-only policy.
- [x] Phase count below min is blocked.
- [x] Phase count above max passes when other gates pass.

## Verification steps
- [x] Command: `./codex/scripts/prepare-phased-impl-scaffold.sh complexity-upward-only-scaling 2 && ./codex/scripts/prepare-phased-impl-validate.sh complexity-upward-only-scaling`
  - Expected: `BLOCKED` with below-min message.
- [x] Command: `./codex/scripts/prepare-phased-impl-scaffold.sh complexity-upward-only-scaling 8 && ./codex/scripts/prepare-phased-impl-validate.sh complexity-upward-only-scaling`
  - Expected: `READY FOR IMPLEMENTATION`.

## Risks and mitigations
- Risk: over-planned small tasks may add review overhead.
- Mitigation: retain deterministic recommendations and minimum enforcement for complex tasks.
