# Phase 2 — Update Complexity Cardinality Mapping

## Objective
Apply the requested L1-L5 goal/phase mapping and new bounds in the complexity scoring script.

## Code areas impacted
- `codex/scripts/complexity-score.sh`

## Work items
- [x] Replace level mapping ranges with requested values.
- [x] Expand goal upper bounds to 20 and phase upper bounds to 12 in scoring outputs.
- [x] Keep deterministic recommendation calculation valid under new ranges.

## Deliverables
- Updated complexity-score ranges and output metadata aligned to requested policy.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] `complexity-score.sh` emits range values matching requested L1-L5 mapping.

## Verification steps
List exact commands and expected results.
- [x] Command: `./codex/scripts/complexity-score.sh tasks/improve-task-grain/complexity-signals.json --format json`
  - Expected: JSON output with requested ranges and valid recommendations.

## Risks and mitigations
- Risk: bounds mismatch can desynchronize Stage 3 scaffolding/validation behavior.
- Mitigation: align `prepare-phased-impl-validate.sh` checks to scorer ranges in Phase 3.
