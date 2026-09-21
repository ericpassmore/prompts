# Compact Task and Goal Artifacts at Land Time

## Stage status
- establish-goals verdict: `GOALS LOCKED` (`goals/compact-tasks-goals/goals.v0.md`)
- prepare-takeoff verdict: `READY FOR PLANNING`
- Stage 2 evidence:
  - Bootstrap config refreshed: `codex/codex-config.yaml`
  - Task scaffold created: `tasks/compact-tasks-goals/`
  - Safety prep executed: `./codex/scripts/prepare-takeoff-worktree.sh compact-tasks-goals`

## Overview
Reduce lifecycle artifact storage footprint after task completion by compacting retained task/goal records during `land-the-plan`, while preserving enough reconstruction data and audit history.

## Goals
1. Implement land-stage compaction for task/goal artifacts.
2. Preserve one unmodified goal file and one spec file per landed task.
3. Add an audit log with complete/incomplete run outcomes and blocker details.
4. Preserve reconstruction capability via compact metadata and diffs.
5. Keep compaction deterministic and fail-fast.
6. Keep change surface constrained to lifecycle docs/scripts relevant to landing.

## Non-goals
- Running one-time historical cleanup for all existing tasks.
- Changing stage order, verdict tokens, or upstream stage validator behavior beyond required integration.

## Use cases / user stories
- As a maintainer, I can land a task without retaining unnecessary per-stage artifact bloat.
- As a reviewer, I can still reconstruct what changed using retained goals/spec/audit/diff artifacts.
- As an operator, I can see partial progress and blockers for incomplete lifecycle runs.

## Current behavior
- Notes:
  - `task-manifest-land-update.sh` updates manifest metadata only.
  - Land stage does not compact per-task `goals/` and `tasks/` artifacts.
- Key files:
  - `codex/scripts/task-manifest-land-update.sh`
  - `codex/skills/land-the-plan/SKILL.md`

## Proposed behavior
- Behavior changes:
  - Add a land-stage compaction helper to preserve one goal file + one spec file.
  - Create/update `audit-log.md` for completion and blocker-aware progress tracking.
  - Emit compact reconstruction artifacts (manifest-like metadata and change diff text).
  - Invoke compaction from `task-manifest-land-update.sh` so it always occurs in Stage 6.
- Edge cases:
  - Missing goal/spec input files fail fast with explicit error messages.
  - If compaction output is already up-to-date, script remains deterministic and idempotent.

## Technical design
### Architecture / modules impacted
- `codex/scripts/task-manifest-land-update.sh`
- `codex/scripts/task-artifacts-compact.sh` (new)
- `codex/skills/land-the-plan/SKILL.md`

### API changes (if any)
- None.

### UI/UX changes (if any)
- None.

### Data model / schema changes (PostgreSQL)
- Migrations: none
- Backward compatibility: lifecycle flow remains unchanged
- Rollback: revert touched script/skill files

## Security & privacy
- No new credentials, network calls, or external services.
- Compaction operates only on repository-local task/goal artifacts.

## Observability (logs/metrics)
- Compaction script emits retained/removed file summary and blocker reasons.
- Audit log provides per-run completeness/progress context.

## Verification Commands
> Pin exact command classes for this repository and task.

- Lint:
  - `not-configured`
- Build:
  - `not-configured`
- Test:
  - `not-configured`
- Stage verification helpers:
  - `./codex/scripts/prepare-phased-impl-scope-lock.sh compact-tasks-goals`
  - `./codex/scripts/prepare-phased-impl-scaffold.sh compact-tasks-goals @tasks/compact-tasks-goals/complexity-signals.json`
  - `./codex/scripts/prepare-phased-impl-validate.sh compact-tasks-goals`
  - `./codex/scripts/implement-validate.sh compact-tasks-goals`
  - `./codex/scripts/revalidate-validate.sh compact-tasks-goals`

## Test strategy
- Unit:
  - Script-level validations and deterministic file-retention checks.
- Integration:
  - Execute Stage 3/4/5 validators with updated task artifacts.
- E2E / UI (if applicable):
  - n/a

## Acceptance criteria checklist
- [ ] Land-stage helper preserves one goal file and one spec file.
- [ ] Audit log records complete and partial-run formats.
- [ ] Reconstruction artifact is generated from current change set.
- [ ] `task-manifest-land-update.sh` integrates compaction and remains fail-fast.
- [ ] `land-the-plan` skill docs match implemented behavior.

## Ambiguity check
- Result: no unresolved blocking ambiguity for Stage 2.

## IN SCOPE
- Land-stage script changes for compaction and manifest update integration.
- Land-stage skill documentation updates.
- Task artifacts for `compact-tasks-goals` needed to satisfy validators.

## OUT OF SCOPE
- Broad archival/cleanup tooling for all historical tasks.
- Non-lifecycle repository surfaces unrelated to this retention behavior.

## Execution posture lock
- Simplicity bias: required.
- Surgical-change discipline: required.
- Fail-fast error handling: required.

## Change control
- Locked goals/constraints/success criteria from `goals/compact-tasks-goals/goals.v0.md` are immutable unless relocked through establish-goals.
- Scope expansion or verification weakening requires routing to `revalidate` before continuing.

## Readiness verdict
- READY FOR PLANNING

## Implementation phase strategy
- Complexity: scored:L3 (multi-surface)
- Complexity scoring details: score=10; recommended-goals=6; forced-l1=false; signals=/Users/eric/.codex/worktrees/d4c7/prompts/tasks/compact-tasks-goals/complexity-signals.json
- Active phases: 1..6
- No new scope introduced: required
