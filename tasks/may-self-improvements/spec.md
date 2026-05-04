# May Self Improvements

## Overview

This task resolves the currently open self-improvement issues in `ericpassmore/prompts` that affect ACAC lifecycle reliability, planning setup, staging safety, landing, and review validation.

## Goal lock assertion

- Goals source: `goals/may-self-improvements/goals.v0.md`
- Goal state: locked
- Locked on: 2026-05-03
- User approval: `approve`
- Constraints: goals, non-goals, success criteria, and issue scope are immutable unless the task is explicitly relocked.

## Ambiguity check

- Result: passed
- Accepted assumptions:
  - All 8 open issues reviewed during goal establishment are in scope.
  - Repository-local lifecycle assets under `codex/` are the canonical implementation surface.
  - GitHub issue state changes are out of scope unless explicitly requested later.

## Goals

1. Resolve issues #33 and #42 by making the complexity-signal workflow first-pass reliable: Stage 2 or Stage 3 must materialize a task-local `complexity-signals.json` when required, and the shared template/guidance must satisfy `complexity-score.sh` validation without requiring manual discovery of tokens such as `interfaces=`.
2. Resolve issue #34 by preventing safe untracked-file staging from including unrelated task-external files by default; the workflow must either stage only task-owned untracked files or explicitly ask before including/excluding unrelated untracked paths.
3. Resolve issue #35 by handling named branches without upstream before late commit preflight blocks landing; the landing/git-commit workflow must provide a safe upstream setup path or an explicit branch strategy before declaring the stage blocked.
4. Resolve issue #36 by ensuring the ACAC orchestrator continues from successful `prepare-takeoff` into `prepare-phased-impl`, `implement`, and `land-the-plan` when goals are approved and no stage has emitted `BLOCKED`.
5. Resolve issue #37 by surfacing pre-existing dirty worktree risk before downstream progression; the workflow must record the dirty-state observation and require an explicit continue/isolate/stop decision before the risk can affect staging or landing.
6. Resolve issue #40 by replacing hardcoded env-example filename assumptions with repository-aware configuration or detection so legitimate tracked env sample files, such as `develop.env`, can be reviewed and committed without a misleading policy mismatch.
7. Resolve issue #41 by making code-review revalidation include the current task implementation diff before commit, or fail fast with actionable instructions when the selected base-branch diff would omit staged or unstaged task changes.

## Non-goals

- Do not broaden scope beyond GitHub issues #33, #34, #35, #36, #37, #40, #41, and #42 without a new goal iteration.
- Do not change external repositories referenced inside issue bodies as reproduction sources.
- Do not close, label, or comment on GitHub issues unless explicitly added to scope.
- Do not weaken ACAC stage gates, verification requirements, or drift detection to make the issues easier to resolve.

## Current behavior

- Complexity-signal authoring and materialization can require manual recovery before Stage 3 scoring/scaffolding succeeds.
- Safe untracked staging can include unrelated files outside task scope.
- Landing can block late when a named branch has no upstream.
- ACAC can return early after Stage 2 despite no blocker.
- Dirty worktree risk can be surfaced too late.
- Env sample policy can be too filename-specific for repository reality.
- Code-review revalidation can omit the current task diff before commit.

## Proposed behavior

- Lifecycle scripts and skills fail fast with actionable guidance, preserve conservative git safety, and keep issue-specific fixes mapped to their locked goals.
- Stage transitions continue only through valid gates and do not stop early when no blocker exists.
- Verification must demonstrate each affected workflow behavior or document a precise blocker.

## Governing context

- Contract: `codex/AGENTS.md`
- Principles: `codex/principles.md`
- Project structure: `codex/project-structure.md`
- Config: `codex/codex-config.yaml`
- Rules:
  - `codex/rules/expand-task-spec.rules`
  - `codex/rules/git-safe.rules`
- Skills:
  - `acac`
  - `establish-goals`
  - `prepare-takeoff`
  - `prepare-phased-impl`
  - `implement`
  - `land-the-plan`
  - `git-commit`
  - `code-review`
  - `complexity-scaling`

## Environment and tooling notes

- Repository: `/Users/eric/side-projects/prompts`
- Branch: `eric/may-improvements`
- Selected `CODEX_ROOT`: `/Users/eric/side-projects/prompts/codex`
- Selected `CODEX_SCRIPTS_DIR`: `/Users/eric/side-projects/prompts/codex/scripts`
- Stage 2 bootstrap command completed: `./codex/scripts/prepare-takeoff-bootstrap.sh`
- Task scaffold command completed: `CODEX_ROOT=/Users/eric/side-projects/prompts/codex /Users/eric/side-projects/prompts/codex/scripts/task-scaffold.sh may-self-improvements`
- Existing-worktree safety prep completed: `CODEX_ROOT=/Users/eric/side-projects/prompts/codex /Users/eric/side-projects/prompts/codex/scripts/prepare-takeoff-worktree.sh may-self-improvements`
- Safety prep reported 4 uncommitted entries:
  - `M codex/codex-config.yaml`
  - `M goals/task-manifest.csv`
  - `?? goals/may-self-improvements/`
  - `?? tasks/may-self-improvements/`
- Dirty-state decision: continue with isolation because all reported entries are Stage 1/2 artifacts for this task or bootstrap metadata.
- Local `gh auth status` failed during goal establishment; GitHub issue data was retrieved through the GitHub MCP connector.

## Verification Commands

> Pinned from `codex/project-structure.md`, `codex/codex-config.yaml`, and task/stage records.

- Lint:
  - `not-configured`
- Build:
  - `not-configured`
- Test:
  - `not-configured`
- Script health:
  - `./codex/scripts/prepare-takeoff-bootstrap.sh`
- Stage 3 plan validation:
  - `./codex/scripts/prepare-phased-impl-validate.sh may-self-improvements`
- Stage 4 implementation validation:
  - `./codex/scripts/implement-validate.sh may-self-improvements`

## Test strategy

- Unit or script-level checks for each changed lifecycle script where practical.
- Fixture-driven git workflow checks for staging, upstream detection, and review diff selection where practical.
- Manual or scripted lifecycle dry-run evidence for ACAC continuation and dirty-worktree surfacing.
- Explicit blocked documentation for lint, build, and test command classes currently marked `not-configured`.

## Acceptance criteria checklist

- [x] [G1] A newly scaffolded or Stage-3-entering task has a valid task-local `complexity-signals.json` when the scorer requires it, and `complexity-score.sh` accepts the provided template/guidance without missing required evidence tokens. PASS: task scaffold and Stage 3 missing-signals fixtures passed.
- [x] [G2] In a repo with both task-owned and unrelated untracked files, the safe untracked staging path does not intent-add unrelated files unless the user explicitly authorizes them. PASS: mixed untracked fixture left `reports/spr-complete.csv` unadded.
- [x] [G3] On a named branch without upstream, the landing/git-commit path detects the condition before commit preflight failure and provides a verified safe recovery path. PASS: no-upstream preflight fixture emitted push-helper recovery.
- [x] [G4] An ACAC run with approved goals and successful Stage 2 does not return early solely because Stage 2 completed; it continues until the next real gate, user approval requirement, `LANDED`, or `BLOCKED`. PASS: ACAC skill and prompt now treat intermediate success verdicts as continuation gates.
- [x] [G5] Starting or continuing a task in a dirty worktree produces an explicit recorded decision before downstream task execution proceeds. PASS: worktree helper reports dirty decision requirement and this spec records the decision.
- [x] [G6] The git-commit/landing env-file policy accepts repository-configured tracked sample env filenames or fails with a precise explanation that references the repo's actual tracked file state. PASS: env staging fixture accepted tracked `develop.env` and rejected `.env.local`.
- [x] [G7] Code-review revalidation before task commit includes the current working-tree task diff, or exits non-zero with instructions to stage/commit/select the correct diff source. PASS: review fixture selected `working-tree` diff mode over non-empty base diff.
- [x] [All] Verification includes the pinned command classes above, with explicit blocked documentation for `not-configured` classes. PASS: final ledger records `not-configured` lint/build/test and targeted script verification.
- [x] [All] Each listed GitHub issue maps to exactly one primary goal, with #33 and #42 intentionally deduplicated into G1. PASS: goal mapping preserved.

## IN SCOPE

- `codex/AGENTS.md`
- `codex/codex-config.yaml`
- `codex/project-structure.md`
- `codex/goals/*`
- `codex/prompts/*`
- `codex/rules/*`
- `codex/scripts/*`
- `codex/skills/*/SKILL.md`
- `codex/tasks/_templates/*`
- `goals/may-self-improvements/*`
- `goals/task-manifest.csv`
- `tasks/may-self-improvements/*`

## OUT OF SCOPE

- External repositories cited in issue bodies.
- Installed `$HOME/.codex` assets unless a later approved stage explicitly adds sync/install work.
- GitHub issue comments, labels, or closures.
- Application code outside lifecycle governance and automation assets.
- Any behavior unrelated to the locked issue set.

## Execution posture lock

- Simplicity bias: prefer direct, script-local fixes over broad lifecycle rewrites.
- Surgical-change discipline: touch only files required by the locked goals and approved phase plan.
- Fail-fast handling: impossible states, missing required files, and unsafe git conditions must produce explicit errors or blockers.
- Traceability: every planned phase must map to locked goals; every implementation change must map to an approved phase; verification evidence must map to changed behavior.

## Change control

- Goal, constraint, success-criteria, non-goal, and verification-scope changes require returning to goal establishment or explicit relock.
- Scope expansion outside `IN SCOPE` is drift and must stop the active stage.
- Weakening or bypassing verification is drift and must stop the active stage.

## Stage 2 readiness verdict

- READY FOR PLANNING

## Implementation phase strategy
- Complexity: scored:L4 (cross-system)
- Complexity scoring details: score=16; recommended-goals=11; guardrails-all-true=false; signals=/Users/eric/side-projects/prompts/tasks/may-self-improvements/complexity-signals.json
- Active phases: 1..8
- No new scope introduced: required
