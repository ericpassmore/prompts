# Phase 1 — Audit Surfaces and Verification Fixtures

## Objective

Establish exact implementation surfaces and reproducible local fixture strategy for each locked issue before changing behavior.

## Code areas impacted
- `codex/scripts/*`
- `codex/skills/*/SKILL.md`
- `codex/tasks/_templates/*`
- `codex/prompts/*`
- `tasks/may-self-improvements/*`

## Work items
- [ ] Map each locked goal to the specific script, skill, template, or prompt that owns the current behavior.
- [ ] Identify the smallest fixture or shell scenario needed to reproduce or validate each issue.
- [ ] Record any issue that cannot be reproduced locally with an explicit verification substitute.
- [ ] Confirm no implementation surface outside the locked `IN SCOPE` section is needed.

## Deliverables
- Surface map for G1-G7.
- Fixture plan covering complexity signals, ACAC continuation, dirty worktree, untracked staging, upstream handling, env samples, and review diff selection.
- Drift check confirming no scope expansion.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [ ] Every goal has an identified owner surface and verification approach.
- [ ] No new scope is required.
- [ ] Risks discovered during audit are recorded before behavior changes.

## Verification steps
List exact commands and expected results.
- [ ] Command: `rg -n "complexity-signals|interfaces=|git-track-safe-untracked|upstream|developement.env|revalidate-code-review|prepare-takeoff|READY FOR PLANNING" codex`
  - Expected: relevant owner surfaces are found for all locked goals.
- [ ] Command: `git status --short`
  - Expected: only task-owned Stage 1-3 artifacts and intentional implementation changes are present.

## Risks and mitigations
- Risk: external-repo incidents cannot be reproduced exactly in this repo.
- Mitigation: use local fixtures that exercise the same script contracts and document any substitute evidence.
