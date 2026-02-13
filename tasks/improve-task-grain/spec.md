# Improve Task Grain

## Stage status
- establish-goals verdict: `GOALS LOCKED` (`goals/improve-task-grain/goals.v0.md`)
- prepare-takeoff verdict: `READY FOR PLANNING`
- Stage 2 evidence:
  - Bootstrap config updated: `codex/codex-config.yaml`
  - Task scaffold created: `tasks/improve-task-grain/`
  - Safety prep executed: `./codex/scripts/prepare-takeoff-worktree.sh improve-task-grain`

## Overview
Improve task metadata grain and complexity-gated Stage 3 validation by adding timestamp/hash columns to the goals manifest and enforcing complexity-derived goal/phase cardinality in `prepare-phased-impl-validate.sh`.

## Goals
1. Add `first_create_hhmmss` and `first_create_git_hash` columns to `goals/task-manifest.csv` with defaults `000000` and `-------`.
2. Keep manifest ordering stable by first-create date/time.
3. Update Stage 3 validation to always use complexity scoring ranges.
4. Apply requested cardinality model: goals bounded within `0..20` with zero-goal abort, phases bounded within `1..12`.
5. Apply the provided L1-L5 level mapping for goal/phase min/max ranges.

## Non-goals
- Altering lifecycle stage order or verdict vocabulary.
- Expanding changes outside manifest and complexity/Stage 3 validation paths.

## Use cases / user stories
- As an ACAC operator, I can inspect richer task-manifest metadata with deterministic defaults.
- As a planner, Stage 3 validation is consistently gated by complexity signals and deterministic ranges.

## Current behavior
- Notes:
  - `goals/task-manifest.csv` tracks only `number,taskname,first_create_date`.
  - `prepare-phased-impl-validate.sh` validates phase count only against a static `2..20` range and does not enforce complexity scoring.
  - `complexity-score.sh` currently uses legacy L1-L5 ranges capped at goals `1..10` and phases `2..20`.
- Key files:
  - `codex/scripts/goals-scaffold.sh`
  - `goals/task-manifest.csv`
  - `codex/scripts/prepare-phased-impl-validate.sh`
  - `codex/scripts/complexity-score.sh`

## Proposed behavior
- Behavior changes:
  - Manifest rebuild outputs five columns and default-fills `first_create_hhmmss` and `first_create_git_hash`.
  - Manifest sorting uses first-create date then first-create hhmmss then task name.
  - Stage 3 validator always runs complexity scoring and checks goal/phase counts against complexity-derived ranges plus hard global bounds (goal `0..20`, phase `1..12`).
  - Level mapping in complexity scoring aligns to the provided L1-L5 mapping.
- Edge cases:
  - Missing task-level signals file falls back to codex complexity template for deterministic scoring input.
  - Zero-goal count is treated as explicit blocker even though it is within the parseable bound.

## Technical design
### Architecture / modules impacted
- `codex/scripts/goals-scaffold.sh`
- `codex/scripts/prepare-phased-impl-validate.sh`
- `codex/scripts/complexity-score.sh`
- `goals/task-manifest.csv` (regenerated output)

### Stage 2 governing context
- Rules:
  - `codex/rules/expand-task-spec.rules`
  - `codex/rules/git-safe.rules`
- Skills:
  - `codex/skills/acac/SKILL.md`
  - `codex/skills/complexity-scaling/SKILL.md`
- Sandbox constraints:
  - workspace-write filesystem, no network required

### API changes (if any)
- None.

### UI/UX changes (if any)
- None.

### Data model / schema changes (PostgreSQL)
- Migrations: none
- Backward compatibility: existing manifest rows are backfilled with defaults
- Rollback: revert script and manifest changes

## Security & privacy
- No secret-handling changes.
- No external dependency additions.

## Observability (logs/metrics)
- Validator output includes explicit complexity-signal source and range mismatch blockers.

## Verification Commands
> Pin the exact commands discovered for this repo (also update canonical config docs when needed).

- Lint:
  - `not-configured`
- Build:
  - `not-configured`
- Test:
  - `not-configured`
- Targeted checks:
  - `bash -n codex/scripts/goals-scaffold.sh codex/scripts/prepare-phased-impl-validate.sh codex/scripts/complexity-score.sh`
  - `./codex/scripts/prepare-phased-impl-validate.sh improve-task-grain`
  - `./codex/scripts/implement-validate.sh improve-task-grain`
  - `./codex/scripts/revalidate-validate.sh improve-task-grain`

## Test strategy
- Unit:
  - shell-level syntax checks for modified scripts.
- Integration:
  - run Stage 3/4/5 validators against `improve-task-grain`.
- E2E / UI (if applicable):
  - n/a

## Acceptance criteria checklist
- [ ] Manifest header includes `first_create_hhmmss` and `first_create_git_hash`.
- [ ] Manifest ordering uses date then hhmmss.
- [ ] `prepare-phased-impl-validate.sh` always uses complexity scoring output.
- [ ] Stage 3 validation enforces goal `0..20` with zero-goal abort and phase `1..12`.
- [ ] Complexity level mapping matches requested L1-L5 table.

## IN SCOPE
- Script updates in:
  - `codex/scripts/goals-scaffold.sh`
  - `codex/scripts/prepare-phased-impl-validate.sh`
  - `codex/scripts/complexity-score.sh`
- Regenerated manifest output at `goals/task-manifest.csv`.
- Required lifecycle artifacts under `goals/improve-task-grain/` and `tasks/improve-task-grain/`.

## OUT OF SCOPE
- Unrelated skills/rules/scripts.
- Non-lifecycle repository content changes.

## Execution posture lock
- Simplicity bias: required.
- Surgical-change discipline: required.
- Fail-fast error handling: required.

## Change control
- Locked goals/constraints/success criteria from `goals/improve-task-grain/goals.v0.md` cannot change without relock.
- Scope expansion requires routing through `revalidate`.

## Implementation phase strategy
- Complexity: scored:L3 (multi-surface)
- Complexity scoring details: score=10; recommended-goals=6; forced-l1=false; signals=/Users/eric/.codex/worktrees/e9b1/prompts/tasks/improve-task-grain/complexity-signals.json
- Active phases: 1..4
- No new scope introduced: required
