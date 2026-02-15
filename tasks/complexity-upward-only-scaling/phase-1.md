# Phase 1 — Remove Forced-L1 Classification

## Objective
Stop forced-L1 from overriding score-band level selection while keeping guardrail evidence validation intact.

## Code areas impacted
- `codex/scripts/complexity-score.sh`

## Work items
- [x] Keep guardrail booleans/evidence required.
- [x] Remove forced-L1 conflict rejection path.
- [x] Select level strictly from total score bands.

## Deliverables
- Updated scorer logic where level is score-derived only.
- Backward-compatible scorer output with informational guardrail flag.

## Gate (must pass before proceeding)
Scorer no longer collapses a high score task to L1 solely due guardrails.
- [x] Verified with all guardrails true and high score signals.

## Verification steps
- [x] Command: `./codex/scripts/complexity-score.sh tasks/complexity-upward-only-scaling/complexity-signals.json --format json`
  - Expected: `level` aligns with score bands.

## Risks and mitigations
- Risk: downstream consumers rely on `force_l1` field semantics.
- Mitigation: keep `force_l1` field for compatibility, but make it informational.
