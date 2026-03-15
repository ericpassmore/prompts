# Phase Model

## Phase 1: Capture Foundation

- Boundary: define incident categories, minimum issue payload, fast-path obvious bug workflow, and central repository routing.
- Largest risk reduced: silent workarounds and lost defect evidence.
- Verification points:
- issue template or equivalent definition covers required fast-path cases
- sample incidents from multiple repositories can be represented without extra tooling
- Revalidation checkpoints:
- confirm issue filing overhead remains low
- confirm source repository and skill context are preserved

## Phase 2: Automated Triage

- Boundary: normalize labels, severity, signatures, and basic prioritization on child issues.
- Largest risk reduced: inconsistent issue quality and weak prioritization.
- Verification points:
- triage output is consistent across representative incident types
- obvious bug issues are not delayed by triage failures
- Revalidation checkpoints:
- measure classification noise and missed labels
- confirm triage agent does not require reporter-side extra fields

## Phase 3: Cluster And Parent Escalation

- Boundary: detect repeated signatures, create or update parent issues, and track evidence thresholds.
- Largest risk reduced: repeated problems remain fragmented and never cross into actionable improvement work.
- Verification points:
- threshold logic groups related incidents without collapsing unrelated ones
- parent issues preserve links to child incidents and repositories
- Revalidation checkpoints:
- check false-positive and false-negative clustering rates
- tune thresholds if noise is too high

## Phase 4: Improvement Delivery

- Boundary: translate actionable issues into proposed skill changes, validate them, and record rollout evidence.
- Largest risk reduced: issue capture never turns into actual improvement.
- Verification points:
- proposed changes cite child or parent issue evidence
- validation method is defined before rollout
- Revalidation checkpoints:
- track whether targeted issue signatures decline after rollout
- track whether goals-to-PR time improves for affected workflows

## Feasibility Notes

- Phase 1 attacks the largest ambiguity cluster around capture and evidence.
- Each phase is independently verifiable.
- No irreversible architecture commitment is required before proving value.
