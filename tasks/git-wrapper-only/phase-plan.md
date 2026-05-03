# Phase Plan
- Task name: git-wrapper-only
- Complexity: scored:L3 (multi-surface)
- Phase count: 5
- Active phases: 1..5
- Verdict: READY TO LAND

## Constraints
- no code/config changes are allowed except phase-plan document updates under ./tasks/*
- no new scope is allowed; scope drift is BLOCKED

## Complexity scoring details
- score=12; recommended-goals=6; guardrails-all-true=true; signals=/Users/eric/side-projects/prompts/tasks/git-wrapper-only/complexity-signals.json
- Ranges: goals=5-8; phases=4-6

## Phase sequence
1. Inventory in-scope git guidance and exception references.
2. Align wrapper/helper behavior for the `development.env` exception.
3. Update skill and prompt guidance to wrapper-only git operation language.
4. Align rule/help surfaces and verify no Codex MCP GitHub dependency is introduced.
5. Run final verification, update task evidence, and prepare landing handoff.

## Goal traceability
- G1: Phases 1, 3, 4
- G2: Phases 1, 2, 4
- G3: Phases 1, 2, 5
- G4: Phases 1, 3, 4, 5
- G5: Phase 5
- G6: Phases 3, 4, 5

## Drift guard
- Do not change `## IN SCOPE` or `## OUT OF SCOPE` after `.scope-lock.md`.
- Do not use the Codex MCP GitHub service.
- If helper coverage is insufficient for a raw git instruction, add only a narrow in-scope helper or stop as `BLOCKED`.
