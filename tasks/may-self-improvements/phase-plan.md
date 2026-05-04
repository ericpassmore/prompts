# Phase Plan
- Task name: may-self-improvements
- Complexity: scored:L4 (cross-system)
- Phase count: 8
- Active phases: 1..8
- Verdict: READY TO LAND

## Constraints
- no code/config changes are allowed except phase-plan document updates under ./tasks/* during Stage 3
- no new scope is allowed; scope drift is BLOCKED
- downstream implementation must map every change to locked goals in `goals/may-self-improvements/goals.v0.md`

## Complexity scoring details
- score=16; recommended-goals=11; guardrails-all-true=false; signals=/Users/eric/side-projects/prompts/tasks/may-self-improvements/complexity-signals.json
- Ranges: goals=8-13; phases=6-9

## Phase sequence

1. Audit lifecycle surfaces and define local fixture strategy for all locked issues.
2. Fix complexity-signal materialization and scorer-compatible template guidance for G1.
3. Fix ACAC continuation and dirty-worktree surfacing for G4 and G5.
4. Fix safe untracked staging scope isolation for G2.
5. Fix no-upstream branch handling before commit preflight for G3.
6. Fix repository-aware env sample policy for G6.
7. Fix code-review revalidation diff selection for G7.
8. Align documentation, run validation, and prepare implementation closeout.

## Goal mapping

- G1: phases 1, 2, 8
- G2: phases 1, 4, 8
- G3: phases 1, 5, 8
- G4: phases 1, 3, 8
- G5: phases 1, 3, 8
- G6: phases 1, 6, 8
- G7: phases 1, 7, 8

## Verification posture

- `not-configured` lint/build/test classes must be reported explicitly.
- Script health and stage validators remain mandatory:
  - `./codex/scripts/prepare-takeoff-bootstrap.sh`
  - `./codex/scripts/prepare-phased-impl-validate.sh may-self-improvements`
  - `./codex/scripts/implement-validate.sh may-self-improvements`
- Changed scripts must receive targeted fixture or shell-level checks where practical.
