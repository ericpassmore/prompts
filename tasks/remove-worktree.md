# Remove Worktree Lifecycle Management From ACAC Flow

## Stage status
- establish-goals verdict: `GOALS LOCKED` (`goals/remove-worktree/goals.v0.md`)
- prepare-takeoff verdict: `READY FOR PLANNING`
- prepare-phased-impl verdict: `READY FOR IMPLEMENTATION`
- implement verdict: `READY FOR REVERIFICATION`
- revalidate verdict: `READY TO LAND`
- land-the-plan verdict: `READY TO LAND` (detached `HEAD` is now accepted by landing/commit policy; stage not re-executed in this turn)
- Stage 2 evidence:
  - Bootstrap config updated: `codex/codex-config.yaml`
  - Task scaffold created: `tasks/remove-worktree/`
  - Safety prep executed: `git worktree prune` and `git status --porcelain`

## Overview
Remove stage requirements that create, initialize, switch to, or release git worktrees. The agent must assume it starts in an already-managed existing worktree. Stage 2 keeps safe repository preparation actions only.

## Goals
1. Update lifecycle scripts so no stage requires creating, initializing, or switching to a new git worktree.
2. Update relevant skills and stage gates to remove worktree creation/release requirements and explicitly state existing-worktree execution.
3. Preserve Stage 2 safe prep actions such as prune and repository safety checks.
4. Keep cross-file references consistent so stage automation remains mechanically valid.

## Non-goals
- Re-architecting the ACAC lifecycle stage order or verdict names.
- Refactoring unrelated scripts/skills outside the worktree-management scope.

## Use cases / user stories
- As an agent running inside a managed worktree, I can execute lifecycle stages without creating/switching worktrees.
- As a maintainer, I can run Stage 2 prep with lightweight safety checks only.
- As a reviewer, I can verify no required lifecycle gate depends on worktree creation or release.

## Current behavior
- Notes:
  - Stage 2 skill currently requires creating a git worktree via `prepare-takeoff-worktree.sh`.
  - Bootstrap script currently treats `prepare-takeoff-worktree.sh` as a required script.
  - Landing skill currently references releasing worktree resources.
  - Safety rules contain worktree create/release helper rules.
- Key files:
  - `codex/scripts/prepare-takeoff-worktree.sh`
  - `codex/scripts/prepare-takeoff-bootstrap.sh`
  - `codex/skills/prepare-takeoff/SKILL.md`
  - `codex/skills/land-the-plan/SKILL.md`
  - `codex/rules/git-safe.rules`

## Proposed behavior
- Behavior changes:
  - Stage 2 no longer creates/manages worktrees; it runs safety prep only.
  - `prepare-takeoff-worktree.sh` is converted to a safety-prep helper that performs non-destructive checks/prune.
  - `prepare-takeoff` and `land-the-plan` skills remove worktree creation/release gates and adopt existing-worktree assumptions.
  - `prepare-takeoff-bootstrap.sh` resolves required scripts without requiring worktree-creation script semantics.
  - `git-safe.rules` removes allow-rules tied to worktree creation/release helpers that are no longer used.
- Edge cases:
  - Detached HEAD is accepted; landing resolves a head branch for push/PR operations.
  - Missing git repository remains blocked.
  - `git worktree prune` failures are surfaced explicitly and fail fast.

## Technical design
### Architecture / modules impacted
- `codex/scripts/prepare-takeoff-worktree.sh`
- `codex/scripts/prepare-takeoff-bootstrap.sh`
- `codex/skills/prepare-takeoff/SKILL.md`
- `codex/skills/land-the-plan/SKILL.md`
- `codex/rules/git-safe.rules`

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
  - Workspace-write filesystem sandbox.
  - No network access required for this task.

### API changes (if any)
- None.

### UI/UX changes (if any)
- None.

### Data model / schema changes (PostgreSQL)
- Migrations: none
- Backward compatibility: n/a
- Rollback: revert modified scripts/skills/rules to prior worktree-management behavior

## Security & privacy
- No secrets introduced.
- Safety prep remains non-destructive (status/prune checks only).

## Observability (logs/metrics)
- Scripts emit explicit pass/fail messages for safety prep and blocked conditions.
- Stage docs retain deterministic verdict text for validators.

## Verification Commands
> Pin the exact commands discovered for this repo (also update canonical config docs when needed).

- Lint:
  - `not-configured`
- Build:
  - `not-configured`
- Test:
  - `not-configured`
- Targeted checks:
  - `rg -n "prepare-takeoff-worktree|git worktree add|release task-specific worktree|worktree resources" codex`
  - `./codex/scripts/prepare-takeoff-worktree.sh remove-worktree`
  - `./codex/scripts/prepare-phased-impl-validate.sh remove-worktree`
  - `./codex/scripts/implement-validate.sh remove-worktree`
  - `./codex/scripts/revalidate-validate.sh remove-worktree`

## Test strategy
- Unit:
  - Validate `prepare-takeoff-worktree.sh` exits cleanly with safety checks and never calls `git worktree add/remove`.
- Integration:
  - Validate stage docs/scripts remain aligned by running stage validators.
- E2E / UI (if applicable):
  - n/a

## Acceptance criteria checklist
- [x] Stage scripts no longer require worktree create/switch/release behavior.
- [x] `prepare-takeoff` and `land-the-plan` skills are updated to existing-worktree assumptions.
- [x] Stage 2 retains safety prep actions (prune + safety checks).
- [x] Cross-file references are consistent with updated behavior.

## IN SCOPE
- Updating lifecycle scripts/skills/rules that currently require worktree management.
- Updating this task's lifecycle artifacts for traceability and validation.

## OUT OF SCOPE
- Changing lifecycle stage order, verdict taxonomy, or non-worktree policy areas.
- Adding new external tooling or CI workflows.

## Execution posture lock
- Simplicity bias: required.
- Surgical-change discipline: required.
- Fail-fast error handling: required.

## Change control
- Locked goals/constraints/success criteria from `goals/remove-worktree/goals.v0.md` cannot change without relock.
- Scope expansion requires revalidate routing before implementation continues.

## Implementation phase strategy
- Complexity: medium
- Active phases: 1..3
- No new scope introduced: required
