# Phase 2 — Remove Goal-Range Blocking

## Objective
Ensure goals validation enforces only global goal bounds and locked-state requirements.

## Code areas impacted
- `codex/scripts/goals-validate.sh`

## Work items
- [x] Keep global goal bound checks (`1..20`).
- [x] Remove complexity-based goal min/max blocking.
- [x] Preserve optional signals-file scorer compatibility check.

## Deliverables
- `goals-validate.sh` no longer rejects goals for complexity-range mismatch.

## Gate (must pass before proceeding)
Locked goals validate even when count exceeds low complexity max.
- [x] Validator returns `GOALS LOCKED` with a low-range signals file.

## Verification steps
- [x] Command: `./codex/scripts/goals-validate.sh complexity-upward-only-scaling v0 /tmp/<low-range-signals>.json`
  - Expected: `GOALS LOCKED`.

## Risks and mitigations
- Risk: signals file may become unused.
- Mitigation: keep scorer execution for schema/evidence compatibility validation.
