# Objective Mapping

## Objective Cards

### O1: Reduce Rework

- objective_id: `O1`
- Desired outcome: incidents in shared skills are captured and resolved early enough to reduce downstream retries and post-lock changes.
- Success measurements:
- lower rate of goals modified after implementation begins
- lower rate of goal drift after lock
- lower count of repeat tasks with materially similar goals
- Axis vector:
- Workflow Explicitness: `+2`
- Economic Posture: `+1`
- Technology Complexity: `0`
- Cultural Specificity: `0`
- Force: `5`
- Non-negotiable flag: `yes`

### O2: Preserve Low-Friction Reporting

- objective_id: `O2`
- Desired outcome: agents can file improvement issues without significant overhead or tooling setup.
- Success measurements:
- high share of incident issues with complete minimum fields
- low median time from incident observation to issue creation
- low rate of skipped issue filing for obvious bugs
- Axis vector:
- Workflow Explicitness: `+1`
- Economic Posture: `-1`
- Technology Complexity: `-1`
- Cultural Specificity: `0`
- Force: `4`
- Non-negotiable flag: `yes`

### O3: Make Prioritization Evidence-Based

- objective_id: `O3`
- Desired outcome: repeated issues are clustered and prioritized from observed evidence instead of intuition.
- Success measurements:
- percent of repeated issue signatures linked to a parent issue
- lower duplicate-analysis effort across maintainers
- clear priority ordering across parent issues
- Axis vector:
- Workflow Explicitness: `+2`
- Economic Posture: `+1`
- Technology Complexity: `+1`
- Cultural Specificity: `0`
- Force: `4`
- Non-negotiable flag: `no`

### O4: Close The Loop To Rollout

- objective_id: `O4`
- Desired outcome: every actionable issue can move into a validated change and rollout path.
- Success measurements:
- issue-to-change conversion rate for confirmed defects and actionable parent issues
- time from parent issue creation to first proposed change
- validation coverage on landed skill improvements
- Axis vector:
- Workflow Explicitness: `+2`
- Economic Posture: `+1`
- Technology Complexity: `0`
- Cultural Specificity: `0`
- Force: `4`
- Non-negotiable flag: `yes`

## Capability Mapping

| Capability | Objective Links | Axis Effect Vector | support_score | Weighted Contribution |
| --- | --- | --- | --- | --- |
| C1 Incident Intake | supports O1, O2, O4 | `(+2, 0, 0, 0)` | O1 `+2`, O2 `+2`, O4 `+1` | O1 `10`, O2 `8`, O4 `4` |
| C2 Fast-Path Obvious Bug Filing | supports O1, O2 | `(+2, -1, 0, 0)` | O1 `+2`, O2 `+2` | O1 `10`, O2 `8` |
| C3 Evidence Normalization | supports O1, O3, O4; mild conflict O2 | `(+1, 0, +1, 0)` | O1 `+1`, O2 `-1`, O3 `+2`, O4 `+1` | O1 `5`, O2 `-4`, O3 `8`, O4 `4` |
| C4 Automated Triage | supports O1, O3, O4; mild conflict O2 | `(+2, +1, +1, 0)` | O1 `+1`, O2 `-1`, O3 `+2`, O4 `+1` | O1 `5`, O2 `-4`, O3 `8`, O4 `4` |
| C5 Cluster Detection And Parent Escalation | supports O1, O3, O4 | `(+2, +1, +1, 0)` | O1 `+1`, O3 `+2`, O4 `+1` | O1 `5`, O3 `8`, O4 `4` |
| C6 Improvement Proposal Routing | supports O1, O4 | `(+1, 0, 0, 0)` | O1 `+1`, O4 `+2` | O1 `5`, O4 `8` |
| C7 Validation And Rollout | supports O1, O4; neutral O2 | `(+1, +1, 0, 0)` | O1 `+2`, O4 `+2` | O1 `10`, O4 `8` |

## Ranked Conflict List

1. `C3` and `C4` mildly conflict with `O2` because evidence normalization and triage can increase reporting overhead if the minimum required issue payload is too large.
2. `C5` can create noise against `O2` if parent-issue thresholds are too low, though this is currently bounded by triage automation rather than issue intake burden.

## Proposed Structural Splits

- Default flow: minimal issue intake for all incidents, especially obvious bugs and confirmed defects.
- Analysis flow: richer clustering and parent issue work handled by the triage agent after intake, not by the reporting agent.
- Change flow: confirmed defect or actionable parent issue moves into skill change proposal, validation, and rollout.

## Decision Candidates

- Keep low-friction child issue template separate from richer triage metadata to preserve intake speed.
- Keep parent issue creation threshold-based and automated rather than reporter-driven.
- Redesign if evidence quality remains too weak after rollout; only then consider targeted telemetry additions.
