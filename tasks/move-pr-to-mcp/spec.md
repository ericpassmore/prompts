# Move PR Creation Flow to GitHub MCP

## Stage status
- establish-goals verdict: `GOALS LOCKED` (`goals/move-pr-to-mcp/goals.v0.md`)
- prepare-takeoff verdict: `READY FOR PLANNING`
- Stage 2 evidence:
  - Bootstrap config updated: `codex/codex-config.yaml`
  - Task scaffold created: `tasks/move-pr-to-mcp/`
  - Safety prep executed: `./codex/scripts/prepare-takeoff-worktree.sh move-pr-to-mcp`

## Overview
Replace direct `gh pr` command usage in landing/init flows with explicit prompts to use GitHub MCP because network-restricted sandboxes cannot run `gh` successfully.

## Goals
1. Change `land-the-plan` Step 6 from `gh pr create` command execution to a prompt-driven GitHub MCP handoff for PR create/update.
2. Remove `gh pr` allow rules from `codex/rules/git-safe.rules`.
3. Update `create_commit_and_pr` in `codex/scripts/project-init.sh` to emit a GitHub MCP prompt/instruction instead of invoking `gh`.
4. Keep changes limited to requested files and lifecycle artifacts.

## Non-goals
- Implementing networked PR creation in scripts.
- Refactoring unrelated rules or lifecycle stages.

## Use cases / user stories
- As an agent in a network-restricted sandbox, I can still land changes by handing PR operations to GitHub MCP.
- As a maintainer, git-safe allow rules no longer imply `gh pr` execution is supported.

## Current behavior
- Notes:
  - `land-the-plan` instructs `gh pr create`.
  - `project-init.sh` requires `gh` and calls `gh pr create`/`gh pr view`.
  - `git-safe.rules` explicitly allows `gh pr create|edit|view|merge`.
- Key files:
  - `codex/skills/land-the-plan/SKILL.md`
  - `codex/rules/git-safe.rules`
  - `codex/scripts/project-init.sh`

## Proposed behavior
- Behavior changes:
  - `land-the-plan` Step 6 instructs operators to create/update PR via GitHub MCP prompt flow.
  - `git-safe.rules` removes `gh pr` allowlist entries.
  - `create_commit_and_pr` emits PR title/body plus MCP handoff instructions rather than running `gh`.
- Edge cases:
  - If automation expects a returned PR URL from `gh`, users now provide URL/number after MCP execution.

## Technical design
### Architecture / modules impacted
- `codex/skills/land-the-plan/SKILL.md`
- `codex/rules/git-safe.rules`
- `codex/scripts/project-init.sh`

### Stage 2 governing context
- Rules:
  - `codex/rules/expand-task-spec.rules`
  - `codex/rules/git-safe.rules`
- Skills:
  - `codex/skills/land-the-plan/SKILL.md`
  - `codex/skills/acac/SKILL.md`
- Sandbox constraints:
  - Workspace-write filesystem
  - Network unavailable for `gh` operations

### API changes (if any)
- None.

### UI/UX changes (if any)
- None.

### Data model / schema changes (PostgreSQL)
- Migrations: none
- Backward compatibility: n/a
- Rollback: revert touched skill/rule/script files

## Security & privacy
- No new secrets handling paths are introduced.
- Removing `gh pr` allow rules narrows command allow surface.

## Observability (logs/metrics)
- Script output now prints explicit MCP handoff instructions and PR content payload.

## Verification Commands
> Pin the exact commands discovered for this repo (also update canonical config docs when needed).

- Lint:
  - `not-configured`
- Build:
  - `not-configured`
- Test:
  - `not-configured`
- Targeted checks:
  - `rg -n "gh pr create|gh pr edit|gh pr view|gh pr merge|GitHub MCP|MCP" codex/skills/land-the-plan/SKILL.md codex/rules/git-safe.rules codex/scripts/project-init.sh`
  - `bash -n codex/scripts/project-init.sh`
  - `./codex/scripts/prepare-phased-impl-validate.sh move-pr-to-mcp`
  - `./codex/scripts/implement-validate.sh move-pr-to-mcp`
  - `./codex/scripts/revalidate-validate.sh move-pr-to-mcp`

## Test strategy
- Unit:
  - Syntax-check updated shell script.
- Integration:
  - Validate lifecycle artifacts via Stage 3/4/5 validators.
- E2E / UI (if applicable):
  - n/a

## Acceptance criteria checklist
- [x] `land-the-plan` no longer requires `gh pr create` command invocation and instead instructs GitHub MCP usage.
- [x] All `gh pr` allow rules are removed from `git-safe.rules`.
- [x] `create_commit_and_pr` no longer invokes `gh`; it outputs PR handoff content for GitHub MCP.
- [x] Validators and targeted checks pass.

## IN SCOPE
- Requested edits in `codex/skills/land-the-plan/SKILL.md`, `codex/rules/git-safe.rules`, and `codex/scripts/project-init.sh`.
- Required task lifecycle artifacts under `goals/move-pr-to-mcp/` and `tasks/move-pr-to-mcp/`.

## OUT OF SCOPE
- Adding network-based PR automation.
- Changes to unrelated scripts, rules, or task artifacts.

## Execution posture lock
- Simplicity bias: required.
- Surgical-change discipline: required.
- Fail-fast error handling: required.

## Change control
- Locked goals/constraints/success criteria from `goals/move-pr-to-mcp/goals.v0.md` cannot change without relock.
- Scope expansion requires routing through `revalidate`.

## Implementation phase strategy
- Complexity: surgical
- Active phases: 1..2
- No new scope introduced: required
