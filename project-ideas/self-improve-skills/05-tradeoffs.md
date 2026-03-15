# Tradeoffs

## Conflicting Objectives And Constraints

- Tension between `O1 Reduce Rework` and `O2 Preserve Low-Friction Reporting`: richer evidence improves analysis, but too much intake overhead suppresses filing.
- Tension between `O3 Make Prioritization Evidence-Based` and simplicity bias: clustering and parent escalation add workflow logic that must stay bounded.

## Objective Cards Used For Tension Analysis

### Objective A: Reduce Rework

- Desired outcome: issues reveal recurring skill problems early enough to prevent repeat failed attempts and late goal changes.
- Success measurements: fewer late-arriving goals, less post-lock drift, fewer repeated tasks with similar goals.
- Primary axis: Workflow Explicitness `+2`
- Secondary axes:
- Economic Posture `+1`
- Technology Complexity `0`
- Cultural Specificity `0`
- Force: `5`
- Scope overlap: `1.0`

### Objective B: Preserve Low-Friction Reporting

- Desired outcome: reporters can file incidents quickly without high cognitive or tooling overhead.
- Success measurements: rapid issue creation and high completion of minimum fields.
- Primary axis: Workflow Explicitness `+1`
- Secondary axes:
- Economic Posture `-1`
- Technology Complexity `-1`
- Cultural Specificity `0`
- Force: `4`
- Scope overlap: `1.0`

## Cross-Purpose Assessment

- Primary-axis directions are aligned but differ in intensity. The tension sits mostly on secondary complexity and effort, not on the goal of having a process at all.
- Delta per axis:
- Workflow Explicitness: `1`
- Economic Posture: `2`
- Technology Complexity: `1`
- Cultural Specificity: `0`

## Tension Score

- Axis weights used: Workflow `3`, Economic `2`, Technology `2`, Cultural `1`
- Score: `(3x1 + 2x2 + 2x1 + 1x0) x 1.0 x min(5,4) = 36`
- Interpretation: explicit prioritization is required, but a structural split can resolve it without abandoning either objective.

## Priority Decision

- Prioritize low-friction issue intake at the child-issue stage.
- Push richer analysis, clustering, and parent-issue logic into the triage agent path.

## Justification

- The process fails completely if agents do not file issues when incidents occur.
- Triage enrichment can be automated and performed later, so it should absorb complexity instead of the reporter.

## Risk Impact

- Risk reduced: under-reporting caused by heavy intake.
- Residual risk: issue quality may be inconsistent; this is accepted initially and addressed through triage normalization.
