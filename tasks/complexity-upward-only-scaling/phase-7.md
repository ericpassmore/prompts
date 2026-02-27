# Phase 7 — Targeted Behavior Regression Checks

## Objective
Produce deterministic evidence for success criteria scenarios.

## Code areas impacted
- `codex/scripts/complexity-score.sh`
- `codex/scripts/goals-validate.sh`
- `codex/scripts/prepare-phased-impl-validate.sh`

## Work items
- [x] Verify scorer behavior with all guardrails true and high score.
- [x] Verify goals validation with low-range signals does not block goal count.
- [x] Verify Stage 3 min-phase failure and above-max phase pass behavior.

## Deliverables
- Command outputs recorded in session evidence and reflected in final verification summary.

## Gate (must pass before proceeding)
All three policy scenarios behave as required.
- [x] Scorer: level remains score-band derived.
- [x] Goals: no complexity-range block.
- [x] Phases: minimum enforced, above-max allowed.

## Verification steps
- [x] Command: `./codex/scripts/complexity-score.sh /tmp/<all-guardrails-high-score>.json --format json`
  - Expected: `level` matches score band, not forced L1.
- [x] Command: `./codex/scripts/goals-validate.sh complexity-upward-only-scaling v0 /tmp/<low-range-signals>.json`
  - Expected: `GOALS LOCKED`.
- [x] Command: `./codex/scripts/prepare-phased-impl-validate.sh complexity-upward-only-scaling`
  - Expected: result depends on phase count minimum condition.

## Risks and mitigations
- Risk: temporary `/tmp` fixtures are not retained in repo.
- Mitigation: checks are command-deterministic and rerunnable.
