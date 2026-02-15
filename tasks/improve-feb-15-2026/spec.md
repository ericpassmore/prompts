# Improve Codex/AGENTS Consistency, Speed, and Trim

## Stage status
- establish-goals verdict: `GOALS LOCKED` (`goals/improve-feb-15-2026/goals.v0.md`)
- prepare-takeoff verdict: `READY FOR PLANNING`
- prepare-phased-impl verdict: `READY FOR IMPLEMENTATION`
- implement verdict: `READY FOR REVERIFICATION`
- revalidate verdict: `READY TO LAND`
- Stage 2 evidence:
  - Bootstrap config refreshed: `codex/codex-config.yaml`
  - Task scaffold created: `tasks/improve-feb-15-2026/`
  - Safety prep executed: `./codex/scripts/prepare-takeoff-worktree.sh improve-feb-15-2026`

## Overview
Review `./codex` governance assets against `codex/principles.md`, correct consistency gaps, improve agent workflow efficiency where safe, and trim redundant instructions while preserving lifecycle behavior and stage contracts.

## Goals
1. Produce a principle-to-contract traceability review with explicit gap findings.
2. Align `codex/AGENTS.md` and only necessary `./codex` assets with principles.
3. Preserve existing stage order and verdict vocabulary.
4. Improve workflow speed by reducing redundant checks/text where this does not change behavior.
5. Consolidate unnecessary instruction duplication while keeping hard gates explicit.
6. Clarify repository-specific `./codex`-first behavior while maintaining fallback compatibility (`./.codex`, `$HOME/.codex`).
7. Complete lifecycle validation evidence including lint/build/test command classes.

## Non-goals
- Adding/removing/renaming lifecycle stages or verdict tokens.
- Broad refactors outside governance and enforcement artifacts under `./codex`.
- Functional behavior changes unrelated to principles alignment and instruction hygiene.

## Use cases / user stories
- As a coding agent, I can follow one coherent contract that matches principles and stage skills.
- As a maintainer, I can update governance documents/scripts with less duplication and lower drift risk.
- As a reviewer, I can verify that behavior is unchanged while instruction quality improves.

## Current behavior
- Notes:
  - `codex/principles.md` defines six principles.
  - `codex/AGENTS.md` defines stage contracts and hard gates.
  - Stage skills contain repeated guidance and path-resolution details with mixed emphasis on `./.codex` vs `./codex`.
- Key files:
  - `codex/principles.md`
  - `codex/AGENTS.md`
  - `codex/skills/*/SKILL.md`
  - `codex/scripts/*.sh`

## Proposed behavior
- Behavior changes:
  - Improve textual consistency and traceability across principles/contract/skills/scripts.
  - Trim redundant instructions that do not add new constraints.
  - Tighten/clarify repo-specific codex-root guidance to reflect `./codex` layout here without breaking fallback support.
  - Apply targeted script-level speedups only when semantically neutral.
- Edge cases:
  - Any proposed simplification that weakens a hard gate is rejected.
  - Any change affecting stage verdict semantics is out of scope and blocked.

## Technical design
### Architecture / modules impacted
- `codex/AGENTS.md`
- `codex/skills/*/SKILL.md` (only where required for consistency/duplication reduction)
- `codex/scripts/*` (only narrow, semantics-preserving speedups or path-resolution clarity)

### Stage 2 governing context
- Rules:
  - `codex/rules/expand-task-spec.rules`
  - `codex/rules/git-safe.rules`
- Skills:
  - `codex/skills/prepare-takeoff/SKILL.md`
  - `codex/skills/prepare-phased-impl/SKILL.md`
  - `codex/skills/implement/SKILL.md`
  - `codex/skills/revalidate/SKILL.md`
  - `codex/skills/land-the-plan/SKILL.md`
- Sandbox constraints:
  - Workspace-write filesystem sandbox
  - Network restricted

### API changes (if any)
- None.

### UI/UX changes (if any)
- None.

### Data model / schema changes (PostgreSQL)
- Migrations: none
- Backward compatibility: full
- Rollback: revert modified governance/script files

## Security & privacy
- No new secrets, credentials, or external integrations.
- All changes remain local to governance and script behavior.

## Observability (logs/metrics)
- Validators and stage scripts provide deterministic verdict output.
- Task artifacts provide traceability from goals to phase execution and reverification.

## Verification Commands
> Pin the exact commands discovered for this repo (also update `./codex/project-structure.md` and `./codex/codex-config.yaml` if canon changes).

- Lint:
  - `not-configured`
- Build:
  - `not-configured`
- Test:
  - `not-configured`
- Stage verification helpers:
  - `./codex/scripts/prepare-phased-impl-scope-lock.sh improve-feb-15-2026`
  - `./codex/scripts/prepare-phased-impl-scaffold.sh improve-feb-15-2026 @tasks/improve-feb-15-2026/complexity-signals.json`
  - `./codex/scripts/prepare-phased-impl-validate.sh improve-feb-15-2026`
  - `./codex/scripts/implement-validate.sh improve-feb-15-2026`
  - `./codex/scripts/revalidate-validate.sh improve-feb-15-2026`

## Test strategy
- Unit:
  - Script-level checks for touched helpers using targeted command runs.
- Integration:
  - Execute Stage 3/4/5 validators against task artifacts.
- E2E / UI (if applicable):
  - n/a

## Acceptance criteria checklist
- [ ] Principles-to-contract consistency gaps are documented and resolved in-scope.
- [ ] Lifecycle stage order and verdict tokens remain unchanged.
- [ ] At least one workflow efficiency improvement is delivered without semantic drift.
- [ ] Redundant instructions are trimmed while hard gates remain explicit.
- [ ] Codex root guidance clearly reflects this repo’s `./codex` layout and fallback compatibility.

## Ambiguity check
- Result: no unresolved blocking ambiguity for Stage 2.

## IN SCOPE
- Consistency and clarity updates in `codex/AGENTS.md` and related `./codex` governance artifacts.
- Semantics-preserving script and instruction cleanups that improve execution speed/maintainability.
- Task lifecycle artifacts for `improve-feb-15-2026`.

## OUT OF SCOPE
- New lifecycle stages or verdict vocabulary changes.
- Unrelated product/application code changes outside `./codex`.
- Behavior-altering refactors not required for principles alignment.

## Execution posture lock
- Simplicity bias: required.
- Surgical-change discipline: required.
- Fail-fast error handling: required.

## Change control
- Locked goals/constraints/success criteria from `goals/improve-feb-15-2026/goals.v0.md` are immutable unless relocked through establish-goals.
- Scope expansion or verification weakening requires revalidate routing before continuing.

## Implementation phase strategy
- Complexity: 4
- Complexity scoring details: score=12; recommended-goals=6; forced-l1=false; signals=/Users/eric/.codex/worktrees/2994/prompts/tasks/improve-feb-15-2026/complexity-signals.json
- Active phases: 1..4
- No new scope introduced: required
