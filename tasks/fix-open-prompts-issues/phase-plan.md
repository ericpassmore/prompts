# Phase Plan
- Task name: fix-open-prompts-issues
- Complexity: scored:L3 (multi-surface)
- Phase count: 6
- Active phases: 1..6
- Verdict: READY TO LAND

## Constraints
- no code/config changes are allowed except phase-plan document updates under ./tasks/*
- no new scope is allowed; scope drift is BLOCKED

## Complexity scoring details
- score=12; recommended-goals=6; guardrails-all-true=false; signals=/Users/eric/.codex/worktrees/d105/prompts/tasks/fix-open-prompts-issues/complexity-signals.json
- Ranges: goals=5-8; phases=4-6

## Phase sequence
1. Fix explicit `CODEX_ROOT` handling in `resolve-codex-root.sh` and validate the fast path for valid non-default roots.
2. Fix establish-goals extraction/validation parsing so scaffold-compatible section headers preserve populated content and validate correctly.
3. Correct `acac` goal-approval ordering and add explicit self-improvement routing guidance for shared-surface incidents.
4. Fix `land-the-plan` fallback guidance so an existing PR is reused or updated instead of relying on create-only fallback behavior.
5. Run the bounded validation suite, update Stage 4 closeout artifacts, and confirm the implementation satisfies the locked goals.
6. Update the related GitHub issues with the validated results, closing the fixed issues and preserving cross-links for the parent/child cluster.

## Goal-to-phase traceability
- G1: Phase 1
- G2: Phase 2
- G3,G4: Phase 3
- G5: Phase 4
- G6: Phases 5-6
