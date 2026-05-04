# Goals Extract
- Task name: may-self-improvements
- Iteration: v0
- State: locked

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

