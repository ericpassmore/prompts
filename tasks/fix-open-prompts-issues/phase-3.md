# Phase 3 — ACAC Contract Guidance

## Objective
Correct the ACAC stage ordering around goal approval and make self-improvement routing explicit when shared workflow defects or repeated friction are observed.

## Code areas impacted
- `codex/skills/acac/SKILL.md`
- `codex/prompts/self-improve-skills.md`
- `tasks/fix-open-prompts-issues/phase-3.md`

## Work items
- [x] Reorder the `acac` establish-goals handoff so user approval is a prerequisite to `GOALS LOCKED`.
- [x] Add an explicit self-improvement routing checkpoint for centralized workflow defects and recurring friction.
- [x] Record phase verification evidence after implementation.

## Deliverables
- Updated ACAC workflow ordering.
- Explicit self-improvement routing guidance in the active workflow surface.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] `acac` no longer implies `GOALS LOCKED` can precede user approval, and centralized workflow incidents are explicitly routed to `self-improve-skills`.

## Verification steps
List exact commands and expected results.
- [x] Command: `rg -n "GOALS LOCKED|approve|self-improve-skills" codex/skills/acac/SKILL.md codex/prompts/self-improve-skills.md`
  - Expected: shows user approval before lock handoff in `acac` and explicit routing language for `self-improve-skills`.

## Risks and mitigations
- Risk: wording-only changes could still leave ambiguous ordering.
- Mitigation: make the sequence explicit in numbered steps and prerequisite language.
