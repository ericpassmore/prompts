# Fix Open Prompts Issues

## Stage status
- establish-goals verdict: `GOALS LOCKED` (`goals/fix-open-prompts-issues/goals.v0.md`)
- prepare-takeoff verdict: `READY FOR PLANNING`
- Stage 2 evidence:
  - Bootstrap config refreshed: `codex/codex-config.yaml`
  - Task scaffold created: `tasks/fix-open-prompts-issues/`
  - Safety prep executed: `./codex/scripts/prepare-takeoff-worktree.sh fix-open-prompts-issues`

## Overview
Resolve the currently open repository-backed defects and workflow-friction issues in `ericpassmore/prompts`, then validate the fixes and update the related GitHub issues with the verified outcome.

## Goals
1. Fix `codex/scripts/resolve-codex-root.sh` so an explicitly exported `CODEX_ROOT` is honored when it exists and satisfies required paths, even when it is outside the repository-local or home fallback roots.
2. Fix the establish-goals extraction/validation flow so scaffolded goal section headers are parsed correctly and populated goals are preserved and validated without manual header normalization.
3. Fix `codex/skills/acac/SKILL.md` so the user approval gate for goals is ordered before the orchestrator treats `GOALS LOCKED` as satisfied.
4. Add an explicit self-improvement routing checkpoint to the relevant centralized workflow guidance so shared-surface bugs or repeated friction are routed to `self-improve-skills` promptly.
5. Fix the `land-the-plan` PR fallback flow so an existing PR for the head branch is reused or updated instead of failing on `gh pr create` alone.
6. Validate each implemented fix with direct evidence tied to the affected scripts/skills and update the corresponding GitHub issues based on the verified outcome.

## Non-goals
- Redesigning unrelated lifecycle stages, telemetry, or issue triage policy beyond what is needed to resolve the current open issues.
- Broadening GitHub CLI permissions or fallback behavior beyond the narrow surfaces required by the existing open issues.

## Use cases / user stories
- As an agent running Stage 1, I can scaffold, extract, and validate goals artifacts without manually renaming section headers.
- As an agent using `#ACAC`, I see the mandatory user goal-approval gate before the workflow claims the goals are locked.
- As an agent hitting a shared-surface defect or repeated workflow friction, I am explicitly routed to `self-improve-skills`.
- As an agent landing a plan, I can recover when a PR for the head branch already exists instead of failing on a create-only fallback.
- As a maintainer, I can verify the fixes and close the associated GitHub issues with concrete evidence.

## Current behavior
- Notes:
  - `resolve-codex-root.sh` rejects valid explicit `CODEX_ROOT` values unless they match one of the built-in repository/home roots.
  - `goals-extract.sh` and `goals-validate.sh` depend on exact bare section headers even though the scaffolded template uses qualified headers.
  - `acac` currently implies `GOALS LOCKED` can happen before the user approval gate.
  - The shared-surface self-improvement routing rule is not explicit in the active workflow guidance.
  - `land-the-plan` documents "create or update the PR" but only spells out a `gh pr create` fallback path.
- Key files:
  - `codex/scripts/resolve-codex-root.sh`
  - `codex/scripts/goals-extract.sh`
  - `codex/scripts/goals-validate.sh`
  - `codex/goals/establish-goals.template.md`
  - `codex/skills/acac/SKILL.md`
  - `codex/skills/land-the-plan/SKILL.md`
  - `codex/prompts/self-improve-skills.md`

## Proposed behavior
- Behavior changes:
  - Accept any valid explicit `CODEX_ROOT` with the required files, regardless of whether it is one of the built-in fallback locations.
  - Make establish-goals extraction and validation robust to scaffolded section headers with parenthetical qualifiers.
  - Place the user goal approval gate before the `GOALS LOCKED` handoff in `acac`.
  - Add explicit self-improvement routing guidance for centralized workflow defects and recurring friction.
  - Document an existing-PR reuse/update path in the `land-the-plan` fallback flow.
  - Update related GitHub issues after verification with the exact validation signals used.
- Edge cases:
  - Section matching must stop at the next heading without swallowing unrelated content.
  - Existing explicit `CODEX_ROOT` fast-path behavior must still reject roots missing required files.
  - The PR fallback guidance must stay narrow and not imply unrelated GitHub CLI expansion.

## Technical design
### Architecture / modules impacted
- `codex/scripts/resolve-codex-root.sh`
- `codex/scripts/goals-extract.sh`
- `codex/scripts/goals-validate.sh`
- `codex/skills/acac/SKILL.md`
- `codex/skills/land-the-plan/SKILL.md`
- `codex/prompts/self-improve-skills.md`

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
  - Network restricted unless `gh issue` is escalated

### API changes (if any)
- None.

### UI/UX changes (if any)
- None.

### Data model / schema changes (PostgreSQL)
- Migrations: none
- Backward compatibility: full
- Rollback: revert the script/skill/prompt edits if validation fails or issue behavior regresses

## Security & privacy
- No new secrets or credentials are introduced.
- Issue updates remain scoped to `ericpassmore/prompts`.
- Explicit path-resolution changes must continue to require the expected files under any accepted codex root.

## Observability (logs/metrics)
- Validation evidence comes from direct script output, task artifact updates, and issue comments closing the loop on the affected issues.
- No new telemetry surface is introduced.

## Verification Commands
> Pin the exact commands discovered for this repo (also update `./codex/project-structure.md` and `./codex/codex-config.yaml` if canon changes).

- Lint:
  - `not-configured`
- Build:
  - `not-configured`
- Test:
  - `not-configured`
- Script checks:
  - `./codex/scripts/goals-extract.sh fix-open-prompts-issues v0`
  - `./codex/scripts/goals-validate.sh fix-open-prompts-issues v0`
  - `./codex/scripts/prepare-takeoff-bootstrap.sh`
  - `./codex/scripts/prepare-phased-impl-validate.sh fix-open-prompts-issues`
  - `./codex/scripts/implement-validate.sh fix-open-prompts-issues`

## Test strategy
- Unit:
  - n/a; this repository validates behavior through shell command probes and artifact inspection
- Integration:
  - run the affected scripts against representative inputs and inspect the resulting artifacts/output
- E2E / UI (if applicable):
  - n/a

## Acceptance criteria checklist
- [x] Locked goals map directly to the currently open issue surfaces.
- [x] Scope is limited to the affected scripts, skills, prompt guidance, and issue-status updates.
- [x] Verification commands are pinned to repository-local commands or explicit `not-configured` outcomes.
- [x] No unresolved blocking ambiguity remains for Stage 2.

## Ambiguity check
- Result: no unresolved blocking ambiguity for Stage 2.

## IN SCOPE
- Fixes for issues `#15`, `#16`, `#27/#30/#31`, `#28`, and `#29`.
- Validation evidence for those fixes.
- Issue updates in `ericpassmore/prompts` that reflect the verified outcomes.

## OUT OF SCOPE
- Fixing unrelated closed issues or creating new feature work outside the open issue set.
- Broad workflow redesign outside the specific defects/friction already reported.
- Landing/PR creation work unless explicitly required later.

## Execution posture lock
- Simplicity bias: required.
- Surgical-change discipline: required.
- Fail-fast error handling: required.

## Change control
- Locked goals, constraints, and success criteria from `goals/fix-open-prompts-issues/goals.v0.md` are immutable unless relocked through `establish-goals`.
- Scope expansion, verification weakening, or behavior not traceable to the locked goals is drift and must stop the stage.
- Override authority for goal or constraint changes is a new approved establish-goals iteration.


## Implementation phase strategy
- Complexity: scored:L3 (multi-surface)
- Complexity scoring details: score=12; recommended-goals=6; guardrails-all-true=false; signals=/Users/eric/.codex/worktrees/d105/prompts/tasks/fix-open-prompts-issues/complexity-signals.json
- Active phases: 1..6
- No new scope introduced: required
