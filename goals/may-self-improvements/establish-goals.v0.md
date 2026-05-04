# establish-goals

## Status

- Iteration: v0
- State: locked
- Task name (proposed, kebab-case): may-self-improvements

## Request restatement

- Review the open issues in `ericpassmore/prompts`, deduplicate overlapping issue themes, draft explicit verifiable goals that would resolve those issues, and ask clarifying questions before any downstream ACAC planning or implementation begins.

## Context considered

- Repo/rules/skills consulted:
  - `/Users/eric/.codex/skills/acac/SKILL.md`
  - `/Users/eric/.codex/skills/establish-goals/SKILL.md`
  - `/Users/eric/.codex/plugins/cache/openai-curated/github/3c463363/skills/github/SKILL.md`
  - `codex/AGENTS.md`
  - `codex/codex-config.yaml`
  - `codex/project-structure.md`
  - `codex/goals/establish-goals.checklist.md`
- Relevant files/artifacts:
  - GitHub open issues for `ericpassmore/prompts`, retrieved 2026-05-03:
    - #33 `prepare-phased-impl: complexity signals template guidance can fail scorer validation`
    - #34 `git-commit: safe untracked staging includes unrelated task-external files`
    - #35 `land-the-plan/git-commit: no-upstream named branch blocks late landing`
    - #36 `acac: returns early after Stage 2 despite no blocker`
    - #37 `acac/prepare-takeoff: dirty worktree risk is surfaced too late`
    - #40 `git-commit / land-the-plan: env example filename mismatch`
    - #41 `land-the-plan: code-review revalidation can omit unstaged task diff`
    - #42 `prepare-phased-impl: complexity signals required after task scaffold omission`
- Constraints (sandbox, commands, policy):
  - ACAC lifecycle order must be preserved.
  - Goal artifacts must be created and validated through approved establish-goals scripts.
  - No source code or implementation planning may occur before goals are approved and locked.
  - Goals must remain unique, explicit, and verifiable.
  - `gh auth status` failed locally, so live issues were retrieved through the GitHub MCP connector.

## Ambiguities

### Blocking (must resolve)

1. None for drafting goals. User approval is still required before goal lock.

### Non-blocking (can proceed with explicit assumptions)

1. The task should cover all currently open GitHub issues #33, #34, #35, #36, #37, #40, #41, and #42 unless the user explicitly excludes one.
2. The implementation target should be this repository's lifecycle assets under `codex/`, with task artifacts under `goals/` and `tasks/`; changes to `$HOME/.codex` or other repositories are out of scope unless explicitly approved later.
3. Related complexity-signal issues #33 and #42 should be resolved through one combined goal because both concern making task-local complexity signals reliable before Stage 3 scoring/scaffolding.
4. Issue closure on GitHub is not part of the implementation unless the user explicitly asks for it during landing.

## Questions for user

1. Should this ACAC task include all 8 open issues listed above, or should any issue be deferred or excluded from this goal set?
2. Should fixes be made only in this repository's `codex/` lifecycle assets, or should the eventual implementation also update the installed `$HOME/.codex` skills/scripts if they differ?
3. Should the final landed work update or close the corresponding GitHub issues, or should it only produce code/task artifacts and leave issue management manual?

## Assumptions (explicit; remove when confirmed)

1. All 8 open issues are in scope for goal establishment.
2. Repository-local lifecycle assets are the canonical implementation surface for this task.
3. GitHub issue state changes are out of scope until explicitly requested.

## Goals (1-20, verifiable)

1. Resolve issues #33 and #42 by making the complexity-signal workflow first-pass reliable: Stage 2 or Stage 3 must materialize a task-local `complexity-signals.json` when required, and the shared template/guidance must satisfy `complexity-score.sh` validation without requiring manual discovery of tokens such as `interfaces=`.
2. Resolve issue #34 by preventing safe untracked-file staging from including unrelated task-external files by default; the workflow must either stage only task-owned untracked files or explicitly ask before including/excluding unrelated untracked paths.
3. Resolve issue #35 by handling named branches without upstream before late commit preflight blocks landing; the landing/git-commit workflow must provide a safe upstream setup path or an explicit branch strategy before declaring the stage blocked.
4. Resolve issue #36 by ensuring the ACAC orchestrator continues from successful `prepare-takeoff` into `prepare-phased-impl`, `implement`, and `land-the-plan` when goals are approved and no stage has emitted `BLOCKED`.
5. Resolve issue #37 by surfacing pre-existing dirty worktree risk before downstream progression; the workflow must record the dirty-state observation and require an explicit continue/isolate/stop decision before the risk can affect staging or landing.
6. Resolve issue #40 by replacing hardcoded env-example filename assumptions with repository-aware configuration or detection so legitimate tracked env sample files, such as `develop.env`, can be reviewed and committed without a misleading policy mismatch.
7. Resolve issue #41 by making code-review revalidation include the current task implementation diff before commit, or fail fast with actionable instructions when the selected base-branch diff would omit staged or unstaged task changes.

## Non-goals (explicit exclusions)

- Do not implement fixes, prepare phases, or modify source code during this establish-goals iteration.
- Do not broaden scope beyond the listed GitHub issues without a new goal iteration.
- Do not change external repositories referenced inside issue bodies as reproduction sources.
- Do not close, label, or comment on GitHub issues unless explicitly added to scope.
- Do not weaken ACAC stage gates, verification requirements, or drift detection to make the issues easier to resolve.

## Success criteria (objective checks)

> Tie each criterion to a goal number when possible.

- [G1] A newly scaffolded or Stage-3-entering task has a valid task-local `complexity-signals.json` when the scorer requires it, and `complexity-score.sh` accepts the provided template/guidance without missing required evidence tokens.
- [G2] In a repo with both task-owned and unrelated untracked files, the safe untracked staging path does not intent-add unrelated files unless the user explicitly authorizes them.
- [G3] On a named branch without upstream, the landing/git-commit path detects the condition before commit preflight failure and provides a verified safe recovery path.
- [G4] An ACAC run with approved goals and successful Stage 2 does not return early solely because Stage 2 completed; it continues until the next real gate, user approval requirement, `LANDED`, or `BLOCKED`.
- [G5] Starting or continuing a task in a dirty worktree produces an explicit recorded decision before downstream task execution proceeds.
- [G6] The git-commit/landing env-file policy accepts repository-configured tracked sample env filenames or fails with a precise explanation that references the repo's actual tracked file state.
- [G7] Code-review revalidation before task commit includes the current working-tree task diff, or exits non-zero with instructions to stage/commit/select the correct diff source.
- [All] Verification for the eventual implementation includes the repository-pinned lint, build, and test command classes from `spec.md`, `codex/project-structure.md`, or `codex/codex-config.yaml`, with explicit blocked documentation for command classes marked `not-configured`.
- [All] Each listed GitHub issue maps to exactly one primary goal above, with #33 and #42 intentionally deduplicated into G1.

## Risks / tradeoffs

- Combining #33 and #42 reduces duplicate work but requires the eventual implementation to cover both template validity and scaffold/materialization timing.
- Some issues reference failures observed in other repositories or `$HOME/.codex`; fixing only this repository may require a later sync/install step outside the initial source change.
- Git workflow changes have high safety impact; downstream planning must preserve conservative staging, branch, and env-file protections.

## Next action

- GOALS LOCKED. Handoff: `prepare-takeoff` owns task scaffolding and `spec.md` readiness content.
