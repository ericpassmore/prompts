# Phase Plan
- Task name: bug-fix-stale-path
- Complexity: 4
- Phase count: 4
- Active phases: 1..4
- Verdict: READY FOR REVERIFICATION

## Constraints
- no code/config changes are allowed except phase-plan document updates under ./tasks/*
- no new scope is allowed; scope drift is BLOCKED

## Complexity scoring details
- score=10; recommended-goals=6; forced-l1=false; signals=/Users/eric/.codex/worktrees/2994/prompts/tasks/bug-fix-stale-path/complexity-signals.json
- Ranges: goals=5-8; phases=4-6

## Phase sequence
1. Reproduce stale-path behavior and lock expected corrected behavior.
2. Implement minimal path-resolution fix in resolver scripts.
3. Verify stale-path rejection and bootstrap-consistent resolution behavior.
4. Complete validator-based closeout and revalidate handoff.

## Goal-to-phase traceability
- G1: Phase 1
- G2,G3,G4: Phase 2
- G4,G5: Phase 3
- G6: Phase 4
