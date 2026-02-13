# Fix Task Manifest Attributes

## Stage status
- establish-goals verdict: `GOALS LOCKED` (`goals/fix-task-manifest-attributes/goals.v0.md`)
- prepare-takeoff verdict: `READY FOR PLANNING`
- Stage 2 evidence:
  - Bootstrap config updated: `codex/codex-config.yaml`
  - Task scaffold created: `tasks/fix-task-manifest-attributes/`
  - Safety prep executed: `./codex/scripts/prepare-takeoff-worktree.sh fix-task-manifest-attributes`

## Overview
Add a landing-stage helper script that stamps manifest metadata for the current task after safe commit and before PR creation, then commits/pushes the manifest update.

## Goals
1. Add a script that updates `goals/task-manifest.csv` for the current task with current UTC `HHMMSS` and current `HEAD` commit hash.
2. Ensure the script creates a manifest commit and pushes it to remote when changes were written.
3. Wire this script into `land-the-plan` flow after `git-commit` and before PR creation.
4. Add command allow-rules so the script can execute in sandboxed workflows.

## Non-goals
- Refactoring unrelated stages/scripts.
- Changing PR content contract semantics beyond step sequencing.

## Use cases / user stories
- As a landing operator, I can automatically persist per-task manifest time/hash metadata right after code commit.
- As a maintainer, the landing flow remains deterministic and executable under sandbox command rules.

## Current behavior
- Notes:
  - `goals/task-manifest.csv` stores placeholder `first_create_hhmmss` and `first_create_git_hash` values for new tasks.
  - `land-the-plan` has no dedicated step/script to stamp finalized manifest metadata after commit.
- Key files:
  - `codex/skills/land-the-plan/SKILL.md`
  - `codex/rules/git-safe.rules`
  - `goals/task-manifest.csv`

## Proposed behavior
- Behavior changes:
  - Add a new trusted helper script in `codex/scripts/` to update manifest row metadata for one task and commit/push that manifest update.
  - Require running that script in landing flow immediately after `git-commit` and before PR create/update.
  - Add allow-rules for home/canonical/repo-local script paths in `git-safe.rules`.
- Edge cases:
  - Missing task row in manifest is a hard failure.
  - Detached `HEAD` is blocked for this script to prevent ambiguous push target.

## Technical design
### Architecture / modules impacted
- `codex/scripts/task-manifest-land-update.sh`
- `codex/skills/land-the-plan/SKILL.md`
- `codex/rules/git-safe.rules`

### Stage 2 governing context
- Rules:
  - `codex/rules/expand-task-spec.rules`
  - `codex/rules/git-safe.rules`
- Skills:
  - `codex/skills/acac/SKILL.md`
  - `codex/skills/land-the-plan/SKILL.md`
- Sandbox constraints:
  - workspace-write filesystem
  - no network PR automation through `gh`

### API changes (if any)
- None.

### UI/UX changes (if any)
- None.

### Data model / schema changes (PostgreSQL)
- Migrations: none
- Backward compatibility: n/a
- Rollback: revert touched skill/rule/script files

## Security & privacy
- No secrets workflow changes.
- Manifest script only mutates tracked metadata fields for the named task row.

## Observability (logs/metrics)
- Script outputs explicit status for manifest update, commit, and push actions.

## Verification Commands
> Pin the exact commands discovered for this repo (also update canonical config docs when needed).

- Lint:
  - `not-configured`
- Build:
  - `not-configured`
- Test:
  - `not-configured`
- Targeted checks:
  - `bash -n codex/scripts/task-manifest-land-update.sh`
  - `rg -n "task-manifest-land-update|Step 3 — Update task manifest metadata|Step 4 — Resolve base branch" codex/skills/land-the-plan/SKILL.md`
  - `rg -n "task-manifest-land-update.sh" codex/rules/git-safe.rules`
  - `./codex/scripts/prepare-phased-impl-validate.sh fix-task-manifest-attributes`
  - `./codex/scripts/implement-validate.sh fix-task-manifest-attributes`
  - `./codex/scripts/revalidate-validate.sh fix-task-manifest-attributes`

## Test strategy
- Unit:
  - shell syntax validation for new script
- Integration:
  - lifecycle validator execution for Stage 3/4/5 on this task
- E2E / UI (if applicable):
  - n/a

## Acceptance criteria checklist
- [ ] New script updates only the target task row with runtime `HHMMSS` and pre-update `HEAD` hash.
- [ ] Script creates and pushes manifest commit when updates occur.
- [ ] `land-the-plan` step ordering places manifest script between `git-commit` and PR creation.
- [ ] `git-safe.rules` has trusted allow entries for new script path variants.

## IN SCOPE
- Requested edits in:
  - `codex/scripts/task-manifest-land-update.sh`
  - `codex/skills/land-the-plan/SKILL.md`
  - `codex/rules/git-safe.rules`
- Required lifecycle artifacts under:
  - `goals/fix-task-manifest-attributes/`
  - `tasks/fix-task-manifest-attributes/`

## OUT OF SCOPE
- Changes to unrelated lifecycle stages/scripts.
- Any PR automation rewrite beyond existing GitHub MCP handoff model.

## Execution posture lock
- Simplicity bias: required.
- Surgical-change discipline: required.
- Fail-fast error handling: required.

## Change control
- Locked goals/constraints/success criteria from `goals/fix-task-manifest-attributes/goals.v0.md` cannot change without relock.
- Scope expansion requires routing through `revalidate`.

## Implementation phase strategy
- Complexity: surgical
- Active phases: 1..2
- No new scope introduced: required
