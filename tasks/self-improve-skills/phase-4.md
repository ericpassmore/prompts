# Phase 4 — Change Loop And Metrics

## Objective
Define the transition from issue evidence to proposed skill change, validation, rollout, and measurement so the improvement loop can prove rework reduction.

## Code areas impacted
- `codex/prompts/self-improve-skills.md`
- `codex/prompts/self-improve-skills-triage.md`
- `tasks/self-improve-skills/phase-4.md`

## Work items
- [x] Define the handoff criteria from child issue or parent issue into an actionable change proposal.
- [x] Define the required validation and rollout evidence for a skill improvement.
- [x] Define the primary and secondary metrics: late goal changes, post-lock drift, repeated similar tasks, and goals-to-PR timing.

## Deliverables
- Documented issue-to-change-to-rollout loop in `codex/prompts/self-improve-skills.md` and `codex/prompts/self-improve-skills-triage.md`.
- Bounded metric set that directly maps to locked goals G5 and G6 in `codex/prompts/self-improve-skills.md`.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] The change loop and metric definitions are explicit, objective, and traceable to the locked goals without needing telemetry-heavy infrastructure.

## Verification steps
List exact commands and expected results.
- [x] Command: `sed -n '1,260p' project-ideas/self-improve-skills/06-phase-model.md`
  - Expected: confirms the rollout loop and verification checkpoints match the refined phase model.
- [x] Result: PASS. The implemented change loop and rollout expectations match the refined phase model.
- [x] Command: `sed -n '1,240p' goals/self-improve-skills/goals.v1.md`
  - Expected: confirms the metric set and rollout evidence satisfy locked goals G5 and G6.
- [x] Result: PASS. The process prompt names the locked rework-reduction metrics and the secondary goals-to-PR metric from G5 and G6.

## Risks and mitigations
- Risk: success metrics may be too vague to verify after rollout.
- Mitigation: tie every metric to observable task or GitHub state changes already identified in the refined baseline.
