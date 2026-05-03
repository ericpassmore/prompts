# Git Wrapper Only

## Stage status
- establish-goals verdict: `GOALS LOCKED` (`goals/git-wrapper-only/goals.v1.md`)
- prepare-takeoff verdict: `READY FOR PLANNING`
- Stage 2 evidence:
  - Bootstrap config updated: `codex/codex-config.yaml`
  - Task scaffold created: `tasks/git-wrapper-only/`
  - Safety prep executed: `./codex/scripts/prepare-takeoff-worktree.sh git-wrapper-only eric/may-improvements`
  - Safety prep status summary at Stage 2: `codex/codex-config.yaml` modified, `goals/task-manifest.csv` modified, `goals/git-wrapper-only/` untracked, `tasks/git-wrapper-only/` untracked

## Overview
Update Codex lifecycle instructions so agent-facing git operations are routed through approved repository git wrapper/helper scripts instead of direct raw `git ...` instructions, standardize the `git-commit` environment-file exception as `development.env`, and avoid Codex MCP GitHub service usage.

## Goals
1. Update lifecycle skill and prompt instructions so agent-facing git operations use the approved git wrapper/helper scripts instead of instructing direct raw `git ...` command execution.
2. Preserve legitimate raw git usage inside repository-owned shell helper scripts where those scripts implement the approved wrapper/helper behavior.
3. Correct the `git-commit` environment-file exception spelling from `developement.env` to `development.env` in the `git-commit` skill and supporting helper behavior.
4. Keep the change scope limited to the git wrapper guidance and `development.env` exception correction.
5. Verify the updated instructions and helper behavior with repo/task-approved lint, build, and test command classes, or document explicit blockers if any class is unavailable.
6. Ensure the updated workflow does not instruct or require agents to use the Codex MCP GitHub service.

## Non-goals
- Do not redesign the ACAC lifecycle or stage gate contract.
- Do not add unrelated git or GitHub workflows.
- Do not change token handling, GitHub auth routing, or PR creation behavior except where wording must avoid direct raw git instructions.
- Do not use the Codex MCP GitHub service for this task or make it part of the updated workflow.
- Do not alter unrelated task artifacts or historical goal iterations.

## Use cases / user stories
- As an agent following lifecycle skill instructions, I use repository-approved git helper scripts for git operations instead of direct raw git commands.
- As a maintainer, I see the allowed example environment file consistently documented and handled as `development.env`.
- As a maintainer, I can verify this task without depending on the Codex MCP GitHub service.

## Current behavior
- Notes:
  - Some lifecycle skills and prompts include direct raw `git ...` command instructions for agent-facing workflows.
  - `codex/skills/git-commit/SKILL.md` spells the allowed environment example as `developement.env`.
  - `codex/scripts/git-track-safe-untracked.sh` preserves the same misspelled exception in helper behavior.
- Key files:
  - `codex/skills/git-commit/SKILL.md`
  - `codex/skills/land-the-plan/SKILL.md`
  - `codex/skills/prepare-takeoff/SKILL.md`
  - `codex/skills/code-review/SKILL.md`
  - `codex/prompts/gitpull.md`
  - `codex/scripts/git-track-safe-untracked.sh`
  - `codex/rules/git-safe.rules`

## Proposed behavior
- Behavior changes:
  - Agent-facing lifecycle instructions refer to approved git wrapper/helper scripts for git operations where a helper surface exists or is required.
  - Repository-owned helper scripts may keep internal raw git commands needed to implement safe wrapper behavior.
  - The allowed environment example exception is consistently `development.env`.
  - The workflow does not require or invoke the Codex MCP GitHub service.
- Edge cases:
  - If an existing instruction has no suitable helper, downstream work must either add a narrow helper within scope or document a blocker rather than preserving direct raw git guidance.
  - Historical references to `developement.env` are corrected only in current in-scope skill/helper surfaces.

## Technical design
### Architecture / modules impacted
- `codex/skills/*/SKILL.md` files with agent-facing git operation guidance
- `codex/prompts/gitpull.md`
- `codex/scripts/git-track-safe-untracked.sh`
- `codex/rules/git-safe.rules` if allow guidance needs alignment with wrapper-only behavior

### Stage 2 governing context
- Rules:
  - `codex/rules/expand-task-spec.rules`
  - `codex/rules/git-safe.rules`
- Skills:
  - `codex/skills/prepare-takeoff/SKILL.md`
  - `codex/skills/prepare-phased-impl/SKILL.md`
  - `codex/skills/implement/SKILL.md`
  - `codex/skills/land-the-plan/SKILL.md`
  - `codex/skills/git-commit/SKILL.md`
- Sandbox constraints:
  - Workspace-write filesystem sandbox
  - Network access is restricted
  - Codex MCP GitHub service is out of scope and must not be used for this task

### API changes (if any)
- None.

### UI/UX changes (if any)
- None.

### Data model / schema changes (PostgreSQL)
- Migrations: none
- Backward compatibility: `development.env` becomes the documented and helper-preserved exception
- Rollback: revert the in-scope skill/prompt/helper/rule text and lifecycle artifacts together

## Security & privacy
- Environment-like files remain excluded from tracking except the explicit `development.env` example exception.
- Wrapper/helper script guidance should narrow direct git command exposure in agent-facing workflows.
- No token values or external service credentials are introduced.

## Observability (logs/metrics)
- Helper scripts should continue to fail with explicit messages for unsafe or unsupported states.
- Verification evidence should record search results for raw git guidance and the environment exception spelling.

## Verification Commands
> Pin the exact commands discovered for this repo (also update `./codex/project-structure.md` and `./codex/codex-config.yaml` if canon changes).

- Lint:
  - `not-configured`
- Build:
  - `not-configured`
- Test:
  - `not-configured`
- Targeted checks:
  - `bash -n codex/scripts/git-track-safe-untracked.sh codex/scripts/git-commit-preflight.sh codex/scripts/git-pull-ff-only-safe.sh codex/scripts/git-diff-unstaged-skip-binary.sh codex/scripts/git-resolve-head-branch-safe.sh codex/scripts/git-commit-safe.sh codex/scripts/git-stage-safe.sh`
  - `rg -n "developement\\.env" codex/skills/git-commit/SKILL.md codex/scripts/git-track-safe-untracked.sh`
  - `rg -n "development\\.env" codex/skills/git-commit/SKILL.md codex/scripts/git-track-safe-untracked.sh`
  - `rg -n "git (branch|status|fetch|pull|push|diff|rev-parse|rev-list|ls-files|add|rm|worktree|commit|checkout|switch|ls-remote)" codex/skills codex/prompts`
  - `rg -n "\`git [^\`]+\`|Run: \`git|raw \`git|git push -u origin" codex/skills codex/prompts`
  - `rg -n "GitHub MCP|MCP GitHub|Codex MCP GitHub" codex/skills codex/prompts`
  - `./codex/scripts/prepare-phased-impl-validate.sh git-wrapper-only`
  - `./codex/scripts/implement-validate.sh git-wrapper-only`

## Test strategy
- Unit:
  - Shell syntax check for the affected helper script.
- Integration:
  - Search-based verification that the misspelled exception is removed from in-scope current skill/helper surfaces.
  - Search-based verification that agent-facing raw git instructions have been routed to wrapper/helper guidance.
  - Lifecycle validator runs for planning and implementation readiness.
- E2E / UI (if applicable):
  - n/a

## Acceptance criteria checklist
- [x] Goal lock is asserted and references `goals/git-wrapper-only/goals.v1.md`.
- [x] No unresolved blocking ambiguity remains for Stage 2.
- [x] Verification commands are pinned to repo-local commands or explicit `not-configured` outcomes.
- [x] Scope excludes Codex MCP GitHub service usage.
- [x] Implementation evidence confirms no agent-facing raw git instructions remain in `codex/skills` or `codex/prompts`.

## IN SCOPE
- `codex/skills/git-commit/SKILL.md`
- Other `codex/skills/*/SKILL.md` files with direct agent-facing raw git instructions
- `codex/prompts/gitpull.md`
- `codex/scripts/git-track-safe-untracked.sh`
- `codex/rules/git-safe.rules` if required to align wrapper-only allowed command guidance
- Lifecycle artifacts under `goals/git-wrapper-only/` and `tasks/git-wrapper-only/`

## OUT OF SCOPE
- ACAC lifecycle redesign.
- Unrelated GitHub workflows, token handling, auth routing, or PR creation behavior.
- Codex MCP GitHub service usage or workflow dependency.
- Historical completed task artifacts outside `goals/git-wrapper-only/` and `tasks/git-wrapper-only/`.
- Application runtime, UI, database, deployment, or CI hosting changes.

## Execution posture lock
- Simplicity bias: required.
- Surgical-change discipline: required.
- Fail-fast error handling: required.

## Change control
- Locked goals, constraints, and success criteria from `goals/git-wrapper-only/goals.v1.md` are immutable unless relocked through `establish-goals`.
- Scope expansion, verification weakening, or behavior not traceable to the locked goals is drift and must stop the active stage.
- Override authority for goal or constraint changes is a new approved establish-goals iteration.

## Drift hard-gate status
- Stage 2 progress budget is within limits.
- No goal, constraint, success-criterion, file-surface, verification, or completion-integrity drift detected.

## Implementation phase strategy
- Complexity: scored:L3 (multi-surface)
- Complexity scoring details: score=12; recommended-goals=6; guardrails-all-true=true; signals=/Users/eric/side-projects/prompts/tasks/git-wrapper-only/complexity-signals.json
- Active phases: 1..5
- No new scope introduced: required
