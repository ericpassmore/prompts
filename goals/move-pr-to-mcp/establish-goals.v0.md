# establish-goals

## Status

- Iteration: v0
- State: locked
- Task name (proposed, kebab-case): move-pr-to-mcp

## Request restatement

- Sandbox lockdown removed network access, so `gh` commands cannot run.
- In `land-the-plan`, replace `gh pr create` command usage with a prompt instructing use of GitHub MCP.
- Remove `gh pr` allow rules from `codex/rules/git-safe.rules`.
- Update `create_commit_and_pr` in `codex/scripts/project-init.sh` to use a prompt and GitHub MCP instead of `gh`.

## Context considered

- Repo/rules/skills consulted:
  - `codex/AGENTS.md`
  - `codex/skills/acac/SKILL.md`
  - `codex/skills/land-the-plan/SKILL.md`
  - `codex/rules/git-safe.rules`
  - `codex/scripts/project-init.sh`
- Relevant files (if any):
  - `codex/skills/land-the-plan/SKILL.md`
  - `codex/rules/git-safe.rules`
  - `codex/scripts/project-init.sh`
- Constraints (sandbox, commands, policy):
  - Workspace-write filesystem sandbox
  - No network access, so `gh` PR operations fail
  - Lifecycle stage order and verdicts must be followed

## Ambiguities

### Blocking (must resolve)

1. None.

### Non-blocking (can proceed with explicit assumptions)

1. "Use GitHub MCP" means replacing command execution with explicit operator prompt text that directs the user/agent to create or update PRs via MCP tools.
2. Scope is limited to requested documentation/rule/script surfaces and their corresponding task artifacts.

## Questions for user

1. None; request is sufficiently specific.

## Assumptions (explicit; remove when confirmed)

1. Existing references to `gh pr` in non-requested files are out of scope unless required for consistency with touched surfaces.
2. No additional runtime automation for MCP PR creation is required beyond prompt updates in skill/script text.

## Goals (1-10, verifiable)

1. Update `codex/skills/land-the-plan/SKILL.md` so Step 6 no longer uses `gh pr create` command invocation and instead directs PR creation/update via GitHub MCP prompt flow.
2. Remove `gh pr` allow rules from `codex/rules/git-safe.rules`.
3. Update `create_commit_and_pr` in `codex/scripts/project-init.sh` to replace `gh` PR command behavior with prompt text directing GitHub MCP usage.
4. Keep all changes surgical and limited to requested files plus required lifecycle artifacts.
5. Re-run stage validators and targeted checks to verify ACAC stage consistency after behavior changes.

## Non-goals (explicit exclusions)

- Implementing real networked PR creation from scripts.
- Refactoring unrelated lifecycle stages, scripts, or rules outside requested scope.

## Success criteria (objective checks)

> Tie each criterion to a goal number when possible.

- [G1] `codex/skills/land-the-plan/SKILL.md` no longer instructs `gh pr create`; it explicitly instructs using GitHub MCP prompt flow for create/update.
- [G2] `codex/rules/git-safe.rules` has no `gh pr` allow entries.
- [G3] `codex/scripts/project-init.sh` `create_commit_and_pr` function no longer runs `gh pr create`; it emits a GitHub MCP prompt/instruction.
- [G4] `git diff` confirms only scoped source files and expected lifecycle artifacts changed.
- [G5] Required stage validators for planning/implementation/revalidation emit success verdicts for this task.

## Risks / tradeoffs

- Replacing executable PR commands with prompts introduces a manual/operator step; this is intentional under no-network constraints.

## Next action

- Goals locked; proceed to `prepare-takeoff`.
