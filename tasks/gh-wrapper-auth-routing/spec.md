# GH Wrapper Auth Routing

## Stage status
- establish-goals verdict: `GOALS LOCKED` (`goals/gh-wrapper-auth-routing/goals.v0.md`)
- prepare-takeoff verdict: `READY FOR PLANNING`
- Stage 2 evidence:
  - Bootstrap config updated: `codex/codex-config.yaml`
  - Task scaffold created: `tasks/gh-wrapper-auth-routing/`
  - Safety prep executed: `./codex/scripts/prepare-takeoff-worktree.sh gh-wrapper-auth-routing codex/gh-wrapper-auth-routing`

## Overview
Implement issue `#38` by routing repo-controlled GitHub CLI usage through wrapper scripts that choose owner/org-specific token env vars, fall back to ambient `GH_TOKEN`, and fail fast when a configured mapped env var is missing.

## Goals
1. Add a repo-level config contract in `codex/codex-config.yaml` for owner/org-specific GitHub CLI token-env selection that falls back to ambient `GH_TOKEN` when no mapping exists.
2. Add wrapper script support under `codex/scripts/` for the GitHub CLI command families requested in issue `#38`, plus a separate `gh-auth-check.sh` diagnostic surface.
3. Make the wrappers fail fast with a clear auth-block message when a configured alternate token env var is selected but unset.
4. Update workflow callsites and guidance so repo-controlled GitHub CLI usage references the wrappers instead of direct raw `gh` commands.
5. Replace raw `gh` allow rules in `codex/rules/git-safe.rules` with allow rules for the wrapper scripts only, covering the wrapper command surface requested in issue `#38`.
6. Add verification evidence showing the wrappers preserve default `GH_TOKEN` behavior when no mapping exists and correctly block when a configured mapped env var is missing.
7. Land the completed fix on a pushed branch and open a reviewer-ready pull request targeting `main`.

## Non-goals
- Changing GitHub MCP authentication behavior or permission routing.
- Adding automatic execution of the diagnostic auth check during normal agent flows.
- Implementing live integration tests that require real repository issue mutation across external GitHub repositories.

## Use cases / user stories
- As an agent invoking repo-approved GitHub CLI flows, I use wrapper scripts instead of raw `gh` commands.
- As a maintainer working across multiple owners/orgs, I can map a specific owner/org to a different token env var without storing secrets in repo config.
- As an operator, I can run a manual auth diagnostic that distinguishes login failure from insufficient issue create/delete permission.

## Current behavior
- Notes:
  - `land-the-plan` still documents raw `gh pr view|edit|create` fallback commands.
  - `self-improve-skills` still documents raw `gh issue create`.
  - `git-safe.rules` still allows direct `gh pr create|view|edit` and `gh issue create`.
  - `codex/codex-config.yaml` has no owner/org token-env mapping contract.
- Key files:
  - `codex/codex-config.yaml`
  - `codex/scripts/`
  - `codex/skills/land-the-plan/SKILL.md`
  - `codex/prompts/self-improve-skills.md`
  - `codex/rules/git-safe.rules`

## Proposed behavior
- Behavior changes:
  - A wrapper script resolves the target owner/org, selects a configured token env var when present, and executes `gh` with scoped `GH_TOKEN` rebinding only for the child process.
  - A manual-only diagnostic wrapper checks login state and create/delete issue access without being run automatically by agents.
  - Workflow guidance and rule allowlists point to wrapper scripts instead of raw `gh`.
- Edge cases:
  - If no owner/org mapping exists, wrappers leave ambient auth untouched.
  - If a mapping exists but the named env var is unset, wrappers exit non-zero with a clear auth-block message.
  - Diagnostic operations must require explicit invocation and clean up the temporary issue on success.

## Technical design
### Architecture / modules impacted
- `codex/codex-config.yaml`
- `codex/scripts/gh-wrap.sh`
- `codex/scripts/gh-auth-check.sh`
- `codex/skills/land-the-plan/SKILL.md`
- `codex/prompts/self-improve-skills.md`
- `codex/rules/git-safe.rules`

### Stage 2 governing context
- Rules:
  - `codex/rules/expand-task-spec.rules`
  - `codex/rules/git-safe.rules`
- Skills:
  - `codex/skills/prepare-takeoff/SKILL.md`
  - `codex/skills/prepare-phased-impl/SKILL.md`
  - `codex/skills/implement/SKILL.md`
  - `codex/skills/land-the-plan/SKILL.md`
- Sandbox constraints:
  - Workspace-write filesystem sandbox
  - Networked GitHub operations require auth and may require escalation at runtime

### API changes (if any)
- None.

### UI/UX changes (if any)
- None.

### Data model / schema changes (PostgreSQL)
- Migrations: none
- Backward compatibility: full; unmapped owners/orgs continue to use ambient auth
- Rollback: revert the config, wrapper scripts, skill/prompt text, and rule entries together

## Security & privacy
- Config stores env-var names only, never token values.
- Wrappers scope any `GH_TOKEN` rebinding to the child `gh` process.
- Removing raw `gh` rule entries narrows the direct command surface exposed to agents.

## Observability (logs/metrics)
- Wrapper failures should print explicit owner/org, selected env-var name, and failure reason.
- The diagnostic wrapper should print which step failed: login, create, or delete.

## Verification Commands
> Pin the exact commands discovered for this repo (also update `./codex/project-structure.md` and `./codex/codex-config.yaml` if canon changes).

- Lint:
  - `not-configured`
- Build:
  - `not-configured`
- Test:
  - `not-configured`
- Targeted checks:
  - `bash -n codex/scripts/gh-wrap.sh codex/scripts/gh-auth-check.sh`
  - `rg -n "gh-wrap.sh|gh-auth-check.sh|gh pr |gh issue create" codex/skills/land-the-plan/SKILL.md codex/prompts/self-improve-skills.md codex/rules/git-safe.rules`
  - `./codex/scripts/prepare-phased-impl-validate.sh gh-wrapper-auth-routing`
  - `./codex/scripts/implement-validate.sh gh-wrapper-auth-routing`

## Test strategy
- Unit:
  - Shell syntax checks for the new wrapper scripts.
- Integration:
  - Wrapper dry-run style probes for mapping resolution and configured-but-unset env behavior.
  - Stage validator runs for planning and implementation readiness.
- E2E / UI (if applicable):
  - n/a

## Acceptance criteria checklist
- [x] Scope is limited to config, wrapper scripts, workflow guidance, rule entries, and lifecycle artifacts tied to issue `#38`.
- [x] GitHub MCP behavior remains unchanged.
- [x] Verification commands are pinned to repo-local commands or explicit `not-configured` outcomes.
- [x] No unresolved blocking ambiguity remains for Stage 2.

## IN SCOPE
- `codex/codex-config.yaml`
- `codex/scripts/gh-wrap.sh`
- `codex/scripts/gh-auth-check.sh`
- `codex/skills/land-the-plan/SKILL.md`
- `codex/prompts/self-improve-skills.md`
- `codex/rules/git-safe.rules`
- Lifecycle artifacts under `goals/gh-wrapper-auth-routing/` and `tasks/gh-wrapper-auth-routing/`

## OUT OF SCOPE
- GitHub MCP auth changes.
- Unrelated GitHub CLI workflows not listed in issue `#38`.
- Automatic execution of the diagnostic wrapper.

## Execution posture lock
- Simplicity bias: required.
- Surgical-change discipline: required.
- Fail-fast error handling: required.

## Change control
- Locked goals, constraints, and success criteria from `goals/gh-wrapper-auth-routing/goals.v0.md` are immutable unless relocked through `establish-goals`.
- Scope expansion, verification weakening, or behavior not traceable to the locked goals is drift and must stop the stage.
- Override authority for goal or constraint changes is a new approved establish-goals iteration.

## Implementation phase strategy
- Complexity: scored:L2 (focused)
- Complexity scoring details: score=8; recommended-goals=4; guardrails-all-true=true; signals=/Users/eric/.codex/worktrees/898e/prompts/tasks/gh-wrapper-auth-routing/complexity-signals.json
- Active phases: 1..3
- No new scope introduced: required
