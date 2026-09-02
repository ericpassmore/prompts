# Phase 3 — Verify Active-Surface Cleanup

## Objective

Prove that active surfaces no longer reference deterministic complexity scoring and that lifecycle scripts still work.

## Code areas impacted

- Active repository surfaces excluding historical `goals/` and `tasks/`
- Task verification artifacts for `remove-complexity-scoring`

## Work items

- [x] Search active surfaces for removed identifiers and concepts.
- [x] Run syntax checks and representative lifecycle fixtures.
- [x] Review the diff for historical-record preservation and unrelated-change safety.

## Deliverables

- Verification evidence mapped to every locked goal.

## Gate (must pass before proceeding)

- [x] Search, syntax, behavior, and diff-scope checks pass.

## Verification steps

- [x] Command: `rg` active surfaces for `complexity-score`, `complexity-signals`, and `complexity-scaling`.
  - Expected: no matches.
- [x] Command: representative lifecycle script tests in a temporary fixture.
  - Expected: goal, task, and phase workflows pass without scoring assets.

## Risks and mitigations

- Risk: generic historical wording is mistaken for an active dependency.
- Mitigation: exclude historical `goals/` and `tasks/` records exactly as locked.
