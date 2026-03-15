# Phase 1 — Asset Layout And Intake Contract

## Objective
Choose the concrete repository-local asset layout for the first rollout and define the shared child-issue intake contract without expanding scope beyond process assets and the narrow rules change.

## Code areas impacted
- `tasks/self-improve-skills/spec.md`
- `tasks/self-improve-skills/phase-plan.md`
- `codex/prompts/self-improve-skills.md`
- `codex/prompts/self-improve-skills-triage.md`

## Work items
- [x] Define the first-rollout asset set as repository-local prompts/docs plus the narrow rule change.
- [x] Define where the canonical child-issue intake contract lives and how executing agents consume it.
- [x] Confirm the chosen asset layout is sufficient for downstream implementation and use without introducing telemetry or broad framework changes.

## Deliverables
- Locked target asset list for implementation:
  - `codex/prompts/self-improve-skills.md`
  - `codex/prompts/self-improve-skills-triage.md`
  - `codex/rules/git-safe.rules`
- Documented intake-contract home covering required incident classes and minimum issue fields in `codex/prompts/self-improve-skills.md`.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] Candidate asset paths and the intake-contract home are explicit, in scope, and traceable to locked goals G1, G2, and G7.

## Verification steps
List exact commands and expected results.
- [x] Command: `sed -n '1,260p' tasks/self-improve-skills/spec.md`
  - Expected: confirms the chosen asset layout remains within locked scope and repository-local boundaries.
- [x] Result: PASS. `spec.md` keeps the asset layout within locked scope and names the repository-local implementation surface.
- [x] Command: `find codex/prompts -maxdepth 1 -type f | sort`
  - Expected: confirms the target process-prompt surface is compatible with existing repository layout.
- [x] Result: PASS. The prompt surface now includes `self-improve-skills.md` and `self-improve-skills-triage.md` alongside existing prompt assets.

## Risks and mitigations
- Risk: choosing too many asset surfaces creates avoidable maintenance overhead.
- Mitigation: keep the first rollout to one main process prompt, one triage prompt, and one narrow rule-change surface.
