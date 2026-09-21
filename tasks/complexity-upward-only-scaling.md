# Complexity Upward-Only Scaling

## Stage status
- establish-goals verdict: `GOALS LOCKED` (`goals/complexity-upward-only-scaling/goals.v0.md`)
- prepare-takeoff verdict: `READY FOR PLANNING`
- prepare-phased-impl verdict: `READY FOR IMPLEMENTATION`
- implement verdict: `READY FOR REVERIFICATION`
- revalidate verdict: `READY TO LAND`
- Stage 2 evidence:
  - Bootstrap config refreshed: `codex/codex-config.yaml`
  - Task scaffold created: `tasks/complexity-upward-only-scaling/`
  - Safety prep executed: `./codex/scripts/prepare-takeoff-worktree.sh complexity-upward-only-scaling`

## Overview
Align complexity policy to enforce upward scaling pressure without blocking valid small-task plans that exceed level maximums.

## Goals
1. Preserve lifecycle stage order/verdict contracts and revalidation mechanics.
2. Keep deterministic complexity scoring and lock artifacts.
3. Remove forced-L1 as a hard classifier so levels are score-band derived.
4. Enforce complexity only for under-scaling on phases (minimum required phases must hold).
5. Remove complexity-based goal-count blocking while preserving global `1..20` goals validation.
6. Preserve pressure that high-complexity tasks cannot run with too few phases.
7. Update docs/templates so policy guidance matches implementation.

## Non-goals
- Removing complexity scorer/signals/lock artifacts.
- Changing lifecycle stage names/order/verdict strings.
- Relaxing scope-lock, no-new-scope, or drift hard gates.
- Broad redesigns outside complexity policy enforcement behavior.

## Use cases / user stories
- As a maintainer, I can plan an L1/L2 task with extra phases/goals without being blocked by range maximums.
- As a reviewer, complex work still fails if planned with too few phases.
- As an agent, lifecycle validators and drift gates remain deterministic and unchanged in contract.

## Current behavior
- Notes:
  - Complexity scoring can force L1 based on guardrails even when score is higher.
  - Stage validation blocks both below-min and above-max counts for goals/phases when signals are present.
  - This over-constrains low-complexity work and can block valid planning.
- Key files:
  - `codex/scripts/complexity-score.sh`
  - `codex/scripts/goals-validate.sh`
  - `codex/scripts/prepare-phased-impl-validate.sh`
  - `codex/skills/complexity-scaling/SKILL.md`
  - `codex/skills/establish-goals/SKILL.md`

## Proposed behavior
- Behavior changes:
  - Complexity level derives from score bands only.
  - Goal validation enforces only global bounds (`1..20`) and locked-state checks.
  - Stage 3 validation enforces complexity minimum phase count only; phase count above complexity max no longer blocks.
- Edge cases:
  - Signals continue to be mandatory/validated for Stage 3 scoring and lock-drift detection.
  - Explicit phase count overrides still remain bounded by global `1..12`.

## Technical design
### Architecture / modules impacted
- `codex/scripts/complexity-score.sh`
- `codex/scripts/goals-validate.sh`
- `codex/scripts/prepare-phased-impl-validate.sh`
- `codex/scripts/prepare-phased-impl-scaffold.sh`
- `codex/skills/complexity-scaling/SKILL.md`
- `codex/skills/establish-goals/SKILL.md`
- `codex/skills/prepare-phased-impl/SKILL.md`

### Stage 2 governing context
- Rules:
  - `codex/rules/expand-task-spec.rules`
  - `codex/rules/git-safe.rules`
- Skills:
  - `codex/skills/prepare-takeoff/SKILL.md`
  - `codex/skills/prepare-phased-impl/SKILL.md`
  - `codex/skills/implement/SKILL.md`
  - `codex/skills/revalidate/SKILL.md`
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
- Rollback: revert touched complexity policy script/docs changes

## Security & privacy
- No security boundary changes.
- No secrets or auth flow changes.

## Observability (logs/metrics)
- Script outputs continue to publish deterministic score/range details.
- Validation errors remain explicit and fail-fast with actionable reasons.

## Verification Commands
> Pin exact repo commands and include lifecycle validators.

- Lint:
  - `not-configured`
- Build:
  - `not-configured`
- Test:
  - `not-configured`
- Targeted checks:
  - `./codex/scripts/complexity-score.sh tasks/complexity-upward-only-scaling/complexity-signals.json --format json`
  - `./codex/scripts/goals-validate.sh complexity-upward-only-scaling v0 tasks/complexity-upward-only-scaling/complexity-signals.json`
  - `./codex/scripts/prepare-phased-impl-validate.sh complexity-upward-only-scaling`
  - `./codex/scripts/implement-validate.sh complexity-upward-only-scaling`
  - `./codex/scripts/revalidate-validate.sh complexity-upward-only-scaling`

## Test strategy
- Unit:
  - Script-path checks via deterministic scorer and validators.
- Integration:
  - Stage 3/4/5 validators with task artifacts for this task.
- E2E / UI (if applicable):
  - n/a

## Acceptance criteria checklist
- [x] Small-task extra goals/phases are not blocked by complexity max ranges.
- [x] Complex-task phase plan fails when below complexity minimum and passes when minimum is met.
- [x] Lifecycle stage contracts/verdicts unchanged.
- [x] Docs/templates align to upward-only policy.

## Ambiguity check
- Result: no unresolved blocking ambiguity for Stage 2.

## IN SCOPE
- Complexity score-level selection behavior in `complexity-score.sh`.
- Complexity enforcement checks in `goals-validate.sh` and `prepare-phased-impl-validate.sh`.
- Stage 3 scoring detail text in `prepare-phased-impl-scaffold.sh`.
- Complexity-policy guidance updates in skill docs/templates tied to enforcement behavior.

## OUT OF SCOPE
- Non-complexity lifecycle mechanics.
- Broad script refactoring unrelated to complexity validation policy.
- PR/branch orchestration behavior unrelated to scoring/enforcement policy.

## Execution posture lock
- Simplicity bias: required.
- Surgical-change discipline: required.
- Fail-fast error handling: required.

## Change control
- Locked goals from `goals/complexity-upward-only-scaling/goals.v0.md` are immutable unless relocked.
- Scope changes or verification weakening require revalidate routing first.

## Implementation phase strategy
- Complexity: 8
- Complexity scoring details: score=12; recommended-goals=6; guardrails-all-true=false; signals=/Users/eric/.codex/worktrees/01dc/prompts/tasks/complexity-upward-only-scaling/complexity-signals.json
- Active phases: 1..8
- No new scope introduced: required
