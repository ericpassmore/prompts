# Phase 3 — Triage, Clustering, And Parent Escalation

## Objective
Define the triage-agent workflow that classifies child issues, preserves provenance, and escalates repeated signatures into parent issues only after threshold evidence exists.

## Code areas impacted
- `codex/prompts/self-improve-skills-triage.md`
- `codex/prompts/self-improve-skills.md`
- `tasks/self-improve-skills/phase-3.md`

## Work items
- [x] Define child-issue classification categories and provenance requirements.
- [x] Define the clustering signature model and the threshold for parent-issue creation or update.
- [x] Define how parent issues retain links to child incidents across repositories without replacing them.

## Deliverables
- Triage/clustering flow with explicit metadata expectations in `codex/prompts/self-improve-skills-triage.md`.
- Threshold-based parent-issue policy aligned to the refined default in `codex/prompts/self-improve-skills-triage.md`.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] Triage and clustering rules are explicit enough to implement without reinterpreting the locked goals.

## Verification steps
List exact commands and expected results.
- [x] Command: `sed -n '1,240p' project-ideas/self-improve-skills/04a-capability-inventory.md`
  - Expected: confirms triage, clustering, and parent escalation capabilities remain aligned with the refined capability inventory.
- [x] Result: PASS. The triage prompt covers capability cards C4 and C5, including provenance and parent escalation.
- [x] Command: `sed -n '1,260p' project-ideas/self-improve-skills/04b-objective-mapping.md`
  - Expected: confirms the triage plan preserves provenance and threshold-based escalation required by locked goal G4.
- [x] Result: PASS. The implemented threshold and clustering flow preserve provenance and align to locked goal G4.

## Risks and mitigations
- Risk: threshold rules that are too loose create noisy parent issues.
- Mitigation: keep the initial threshold deterministic and defer tuning to later evidence rather than widening scope now.
