# Phase 2 — Fast Path And Evidence Contract

## Objective
Define the obvious-bug fast path and the minimum evidence bundle for each required incident class so issue capture stays low-friction but reproducible.

## Code areas impacted
- `codex/prompts/self-improve-skills.md`
- `tasks/self-improve-skills/spec.md`
- `tasks/self-improve-skills/phase-2.md`

## Work items
- [x] Specify immediate issue-filing behavior for obvious bugs and confirmed defects, including continue-if-safe handling.
- [x] Specify required issue triggers for repeated bash runs, repeated permission escalations, lack-of-access blocks without actionable resolution, and poor-fit skill invocation.
- [x] Define the minimum evidence bundle: source repository, skill or stage, incident type, short repro or observation, and relevant task artifacts.

## Deliverables
- Concrete incident taxonomy and fast-path bug workflow in `codex/prompts/self-improve-skills.md`.
- Minimum evidence contract for all required incident classes in `codex/prompts/self-improve-skills.md`.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] The process definition covers every required incident class and keeps the reporter-side burden intentionally small.

## Verification steps
List exact commands and expected results.
- [x] Command: `sed -n '1,260p' project-ideas/self-improve-skills/01-surface-map.md`
  - Expected: confirms the planned intake and fast-path flow match the refined idea scenarios.
- [x] Result: PASS. The implemented incident classes and fast-path behavior match the refined executing-agent scenarios.
- [x] Command: `sed -n '1,240p' goals/self-improve-skills/goals.v1.md`
  - Expected: confirms the incident classes and evidence contract satisfy locked goals G2 and G3.
- [x] Result: PASS. The prompt covers all locked incident classes and the minimum evidence bundle required by G2 and G3.

## Risks and mitigations
- Risk: over-specifying evidence fields discourages issue filing.
- Mitigation: keep the minimum bundle short and move enrichment to triage rather than intake.
