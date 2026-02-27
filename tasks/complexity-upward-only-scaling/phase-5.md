# Phase 5 — Update Complexity Scaling Documentation

## Objective
Align complexity-scaling skill guidance with upward-only enforcement and score-band-only level mapping.

## Code areas impacted
- `codex/skills/complexity-scaling/SKILL.md`

## Work items
- [x] Remove forced-L1 hard-classifier guidance.
- [x] Document guardrails as informational.
- [x] Add explicit upward-only enforcement section.
- [x] Update Stage 1 integration note for goals validation behavior.

## Deliverables
- Complexity-scaling skill text reflects implemented policy.

## Gate (must pass before proceeding)
No contradictory forced-L1 or goal-range-blocking guidance remains.
- [x] Verified by repository search.

## Verification steps
- [x] Command: `rg -n "Forced L1|level-specific goal ranges" codex/skills/complexity-scaling/SKILL.md`
  - Expected: no matches.

## Risks and mitigations
- Risk: downstream users may rely on previous policy text.
- Mitigation: keep deterministic scoring/ranges and clarify changed enforcement semantics.
