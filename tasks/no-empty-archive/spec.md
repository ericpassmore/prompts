# Prevent Archive On Template-Only Phase Files

## Stage status
- establish-goals verdict: `GOALS LOCKED` (`goals/no-empty-archive/goals.v1.md`)
- prepare-takeoff verdict: `READY FOR PLANNING`
- prepare-phased-impl verdict: `READY FOR IMPLEMENTATION`
- implement verdict: `READY FOR REVERIFICATION`
- revalidate verdict: `READY TO LAND`
- Stage 2 evidence:
  - Bootstrap config updated: `codex/codex-config.yaml`
  - Task scaffold created: `tasks/no-empty-archive/`
  - Safety prep executed: `./codex/scripts/prepare-takeoff-worktree.sh no-empty-archive`

## Overview
Prevent premature Stage 3 archival when `phase-1.md` and `phase-2.md` are still untouched generated templates. Archive should run only when there is meaningful planning content or other archive-worthy artifacts.

## Goals
1. Update archive detection so template-only `phase-1.md` and `phase-2.md` do not trigger archive.
2. Use deterministic file-content comparison against expected template-rendered content.
3. Preserve existing archive behavior when phase files diverge from template content or when `phase-plan.md` exists.
4. Add verification evidence that covers both skip and archive paths.

## Non-goals
- Introducing mutable INIT/update tags in phase files.
- Changing lifecycle stage verdict names/order.
- Refactoring unrelated Stage 3 scripts or task artifacts.

## Use cases / user stories
- As a planner starting Stage 3, I do not want archive/noise created when phase files are untouched templates.
- As a maintainer, I want deterministic logic that does not depend on manual tags.
- As a reviewer, I can verify skip/archive behavior from explicit command evidence.

## Current behavior
- Notes:
  - `prepare-phased-impl-archive.sh` archives whenever any `phase-*.md` exists.
  - Newly scaffolded tasks always include phase files, so archive can run before any real planning content exists.
- Key files:
  - `codex/scripts/prepare-phased-impl-archive.sh`
  - `codex/tasks/_templates/phase.template.md`
  - `codex/scripts/prepare-phased-impl-scaffold.sh`

## Proposed behavior
- Behavior changes:
  - `prepare-phased-impl-archive.sh` checks whether `phase-1.md` and `phase-2.md` exactly match the rendered template baselines.
  - When both files are template-only and no `phase-plan.md` exists, script exits no-op and reports no Stage 3 artifacts to archive.
  - Existing archive behavior remains unchanged for any substantive phase-file edits or `phase-plan.md` presence.
- Edge cases:
  - Missing template file is fail-fast.
  - Non-existent `phase-1.md`/`phase-2.md` keeps current archive logic for other artifacts.
  - Any whitespace/content drift from template counts as substantive and permits archive.

## Technical design
### Architecture / modules impacted
- `codex/scripts/prepare-phased-impl-archive.sh`

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
  - No network required for implementation and local validation

### API changes (if any)
- None.

### UI/UX changes (if any)
- None.

### Data model / schema changes (PostgreSQL)
- Migrations: none
- Backward compatibility: full; archive semantics only narrow premature archival
- Rollback: revert `codex/scripts/prepare-phased-impl-archive.sh`

## Security & privacy
- No new secrets, auth, or external inputs.
- Deterministic comparisons reduce ambiguous operator-driven state.

## Observability (logs/metrics)
- Archive script emits explicit reason when skipping template-only files.
- Verification commands capture no-op and archive paths.

## Verification Commands
> Pin the exact commands discovered for this repo (also update canonical config docs when needed).

- Lint:
  - `not-configured`
- Build:
  - `not-configured`
- Test:
  - `not-configured`
- Targeted checks:
  - `./codex/scripts/prepare-phased-impl-archive.sh no-empty-archive`
  - `./codex/scripts/prepare-phased-impl-scaffold.sh no-empty-archive surgical`
  - `./codex/scripts/prepare-phased-impl-validate.sh no-empty-archive`
  - `./codex/scripts/implement-validate.sh no-empty-archive`
  - `./codex/scripts/revalidate-validate.sh no-empty-archive`

## Test strategy
- Unit:
  - Validate template-comparison helper path by running archive script against untouched template files.
- Integration:
  - Run Stage 3/4/5 validators to ensure lifecycle compatibility.
- E2E / UI (if applicable):
  - n/a

## Acceptance criteria checklist
- [x] Archive script does not archive when both `phase-1.md` and `phase-2.md` are template-only.
- [x] Deterministic template comparison is used instead of mutable state markers.
- [x] Archive still runs when at least one phase file has substantive edits.
- [x] Verification evidence recorded in task artifacts.

## IN SCOPE
- Implementing archive guard logic in `codex/scripts/prepare-phased-impl-archive.sh`.
- Updating this task's lifecycle docs and verification evidence.

## OUT OF SCOPE
- Changes to Stage 3/4/5 verdict contracts.
- Adding a dedicated shell test harness for this repository.

## Execution posture lock
- Simplicity bias: required.
- Surgical-change discipline: required.
- Fail-fast error handling: required.

## Change control
- Locked goals/constraints/success criteria from `goals/no-empty-archive/goals.v1.md` cannot change without relock.
- Any scope expansion requires revalidate routing before implementation continues.

## Implementation phase strategy
- Complexity: surgical
- Active phases: 1..2
- No new scope introduced: required
