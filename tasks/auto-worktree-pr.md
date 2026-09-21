# Land Detached-HEAD Worktree PR Flow

## Stage status
- establish-goals verdict: `GOALS LOCKED` (`goals/auto-worktree-pr/goals.v0.md`)
- prepare-takeoff verdict: `READY FOR PLANNING`
- prepare-phased-impl verdict: `READY FOR IMPLEMENTATION`
- implement verdict: `READY FOR REVERIFICATION`
- revalidate verdict: `READY TO LAND`
- Stage 2 evidence:
  - Bootstrap config updated: `codex/codex-config.yaml`
  - Task scaffold created: `tasks/auto-worktree-pr/`
  - Safety prep executed: `./codex/scripts/prepare-takeoff-worktree.sh auto-worktree-pr`

## Overview
Update landing behavior so Stage 6 can safely land from detached `HEAD` by creating a deterministic landing branch, committing via `git-commit`, pushing, creating a PR, and merging into the configured base branch.

## Goals
1. Add detached-`HEAD` landing branch construction flow: `land-the-plan/<task>/<agent-id>-<timestamp>`.
2. Require landing checks/steps: fetch origin, ensure branch does not exist, create and switch branch, run `git-commit`, push branch, create PR, merge PR to configured base branch.
3. Keep git-safe policy and helper scripts aligned with the new landing flow.
4. Verify against `2c3c9b22755cfcc0e19f76950be63d0c4caedc96..HEAD` that secret/binary protections in `git-commit` are retained.

## Non-goals
- Reworking lifecycle order or verdict taxonomy.
- Broad refactors outside landing and git-safe flow for this task.

## Use cases / user stories
- As an agent in detached `HEAD`, I can land changes without manually creating a branch.
- As a reviewer, I get a predictable landing branch name and a merged PR to configured base.
- As a maintainer, I retain protections against committing secrets and blocked binary artifacts.

## Current behavior
- Notes:
  - `land-the-plan` resolves detached `HEAD` to `codex/<task>` but does not require fetch/non-existence/create/switch flow.
  - `git-commit-preflight.sh` blocks named branches without upstream, which can block first commit on newly created landing branches.
  - Stage 6 docs end at PR creation/update; merge is not required.
- Key files:
  - `codex/skills/land-the-plan/SKILL.md`
  - `codex/skills/git-commit/SKILL.md`
  - `codex/scripts/git-commit-preflight.sh`
  - `codex/scripts/git-push-branch-safe.sh`
  - `codex/rules/git-safe.rules`

## Proposed behavior
- Behavior changes:
  - Stage 6 detached-head flow constructs `land-the-plan/<task>/<agent-id>-<timestamp>` branch.
  - Stage 6 requires `git fetch origin` and branch collision checks before branch creation.
  - New landing branch is created/switched before commit; `git-commit` flow remains mandatory.
  - Stage 6 includes PR merge step targeting `codex-config.yaml` base branch.
- Edge cases:
  - If local or remote landing branch already exists, land stage is `BLOCKED`.
  - If git identity/agent-id cannot be inferred, fallback identifier is used.
  - If PR merge fails, stage remains `BLOCKED`.

## Technical design
### Architecture / modules impacted
- `codex/skills/land-the-plan/SKILL.md`
- `codex/skills/git-commit/SKILL.md`
- `codex/scripts/git-commit-preflight.sh`
- `codex/scripts/git-push-branch-safe.sh`
- `codex/rules/git-safe.rules`

### Stage 2 governing context
- Rules:
  - `codex/rules/expand-task-spec.rules`
  - `codex/rules/git-safe.rules`
- Skills:
  - `codex/skills/land-the-plan/SKILL.md`
  - `codex/skills/git-commit/SKILL.md`
- Sandbox constraints:
  - Workspace-write filesystem
  - Network unavailable in this execution environment

### API changes (if any)
- None.

### UI/UX changes (if any)
- None.

### Data model / schema changes (PostgreSQL)
- Migrations: none
- Backward compatibility: n/a
- Rollback: revert touched scripts/skills/rules

## Security & privacy
- Preserve existing no-secret-commit behavior via env-file and staged-diff checks.
- Preserve binary/media restrictions from tracking and diff helper scripts.

## Observability (logs/metrics)
- Landing scripts and skills emit explicit fail-fast `Abort`/`BLOCKED` paths for branch collisions and merge failures.

## Verification Commands
> Pin the exact commands discovered for this repo (also update canonical config docs when needed).

- Lint:
  - `not-configured`
- Build:
  - `not-configured`
- Test:
  - `not-configured`
- Targeted checks:
  - `git diff 2c3c9b22755cfcc0e19f76950be63d0c4caedc96..HEAD -- codex/skills/git-commit/SKILL.md codex/scripts/git-track-safe-untracked.sh codex/scripts/git-diff-staged-skip-binary.sh codex/scripts/git-commit-preflight.sh`
  - `rg -n "land-the-plan/.+agent-id|git fetch origin|gh pr merge|READY TO LAND|LANDED" codex/skills/land-the-plan/SKILL.md codex/rules/git-safe.rules`
  - `./codex/scripts/prepare-phased-impl-validate.sh auto-worktree-pr`
  - `./codex/scripts/implement-validate.sh auto-worktree-pr`
  - `./codex/scripts/revalidate-validate.sh auto-worktree-pr`

## Test strategy
- Unit:
  - Validate preflight behavior for new-branch/no-upstream flow required by Stage 6 detached-head branch creation.
- Integration:
  - Validate stage docs/scripts/rules stay consistent using stage validators.
- E2E / UI (if applicable):
  - n/a

## Acceptance criteria checklist
- [x] Stage 6 defines detached-head branch naming + creation flow exactly as requested.
- [x] Stage 6 requires push, PR create/update, and PR merge to configured base branch.
- [x] Git-safe/rules and helper behavior support the flow with fail-fast collisions.
- [x] Diff review against `2c3c9b2..HEAD` confirms secret/binary protections remain intact.

## IN SCOPE
- Landing skill, git commit/push helper behavior, and git-safe rules tied to detached-head landing flow.
- Task lifecycle artifacts for `auto-worktree-pr`.

## OUT OF SCOPE
- Unrelated lifecycle stages or unrelated scripts.
- Non-landing git policy changes outside required flow.

## Execution posture lock
- Simplicity bias: required.
- Surgical-change discipline: required.
- Fail-fast error handling: required.

## Change control
- Locked goals/constraints/success criteria from `goals/auto-worktree-pr/goals.v0.md` cannot change without relock.
- Scope expansion requires routing to `revalidate` before continuing.

## Implementation phase strategy
- Complexity: medium
- Active phases: 1..3
- No new scope introduced: required
