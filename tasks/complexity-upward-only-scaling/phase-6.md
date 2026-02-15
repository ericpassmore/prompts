# Phase 6 — Update Stage Guidance for Goal Validation

## Objective
Keep establish-goals and planning-stage skill guidance consistent with new policy.

## Code areas impacted
- `codex/skills/establish-goals/SKILL.md`
- `codex/skills/prepare-phased-impl/SKILL.md`
- `codex/tasks/_templates/complexity-signals.template.json`

## Work items
- [x] Remove statement that signals enforce goal range blocking.
- [x] Document min-phase-only enforcement in Stage 3 guidance.
- [x] Clarify template guardrails text as informational.

## Deliverables
- Skill/template guidance aligned to updated validators.

## Gate (must pass before proceeding)
Guidance across scorer, Stage 1, and Stage 3 is internally consistent.
- [x] Verified by focused keyword scan.

## Verification steps
- [x] Command: `rg -n "goal count must be within the scored level range|Forced L1|outside complexity range" codex/skills codex/tasks/_templates`
  - Expected: no policy-contradicting guidance matches.

## Risks and mitigations
- Risk: broad docs outside skill surfaces may still reference old policy.
- Mitigation: scope limited to lifecycle-owned docs/templates in this task.
