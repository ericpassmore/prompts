# Self-Improve Skills

## Stage status
- establish-goals verdict: `GOALS LOCKED` (`goals/self-improve-skills/goals.v1.md`)
- prepare-takeoff verdict: `READY FOR PLANNING`
- Stage 2 evidence:
  - Bootstrap config refreshed: `codex/codex-config.yaml`
  - Task scaffold created: `tasks/self-improve-skills/`
  - Safety prep executed: `./codex/scripts/prepare-takeoff-worktree.sh self-improve-skills`

## Overview
Prepare the task for downstream planning and implementation of an issue-first skill-improvement process for centralized skills used across repositories, with GitHub issue capture in `ericpassmore/prompts` as the required starting point.

## Goals
1. Define a repository-local process specification requiring every concrete skill or workflow incident to begin with a GitHub issue in `ericpassmore/prompts`.
2. Define explicit issue-intake triggers and minimum required issue fields for obvious bugs, confirmed defects, repeated bash runs, repeated permission escalations for the same command, lack-of-access blocks without actionable resolution steps, and poor-fit skill invocation.
3. Define a fast-path workflow for obvious bugs and confirmed defects with immediate filing, minimal repro, severity guidance, and continue-if-safe handling.
4. Define an automated triage and clustering process for child issues, cross-repository provenance, and threshold-based parent issue creation or updates.
5. Define the end-to-end loop from issue capture to proposed skill change, validation, and rollout, with clear ownership and expected verification evidence.
6. Define the metrics for rework reduction and the secondary goals-to-PR timing metric.
7. Deliver the process in durable repository-local assets without requiring heavyweight telemetry or cross-repository infrastructure for the first rollout.
8. Update the relevant local rules or command-approval configuration so `["gh", "issue", "create"]` is allowed for creating issues in `ericpassmore/prompts` as part of the process.

## Non-goals
- Building a telemetry-heavy analytics platform before the basic issue-first process exists.
- Redesigning the entire skill framework or changing lifecycle stage contracts unrelated to this process.
- Adding rejection logic to every poor-fit skill path before incident evidence has been captured.

## Use cases / user stories
- As an executing agent, I can file a concrete issue in `ericpassmore/prompts` as soon as I observe a skill defect, workaround, or repeated friction pattern.
- As a triage agent, I can classify and cluster repeated incidents across repositories without losing child-issue provenance.
- As a maintainer, I can move from repeated incident evidence to a proposed skill change, validate it, and roll it out with measurable success criteria.

## Current behavior
- Notes:
  - There is no repository-local task implementation yet for the issue-first skill-improvement workflow.
  - Idea refinement artifacts exist under `project-ideas/self-improve-skills/` and define the baseline process model.
  - Current local rules include `gh pr create` allowance but do not yet include the requested `gh issue create` allowance for central issue capture.
- Key files:
  - `project-ideas/self-improve-skills/00-baseline.md`
  - `project-ideas/self-improve-skills/01-surface-map.md`
  - `project-ideas/self-improve-skills/04a-capability-inventory.md`
  - `project-ideas/self-improve-skills/04b-objective-mapping.md`
  - `codex/rules/expand-task-spec.rules`
  - `codex/rules/git-safe.rules`

## Proposed behavior
- Behavior changes:
  - Add repository-local assets that define the issue-first process, fast-path bug handling, triage and clustering flow, and rollout loop.
  - Add the narrow rules or approval update needed to permit `gh issue create` for `ericpassmore/prompts`.
- Edge cases:
  - Incident intake must stay lightweight enough that agents actually file issues.
  - Cross-repository provenance must remain attached to child issues when parent issues are created.

## Technical design
### Architecture / modules impacted
- `tasks/self-improve-skills/*`
- `codex/prompts/self-improve-skills.md`
- `codex/prompts/self-improve-skills-triage.md`
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
  - Network restricted

### API changes (if any)
- None planned in Stage 2.

### UI/UX changes (if any)
- None planned in Stage 2.

### Data model / schema changes (PostgreSQL)
- Migrations: none
- Backward compatibility: full
- Rollback: revert repository-local process/rules changes if later stages introduce them

## Security & privacy
- No new secrets or credentials are required for Stage 2.
- Cross-repository issue filing must remain scoped to `ericpassmore/prompts`.
- Permission or rule expansion for `gh issue create` must remain narrow and documented.

## Observability (logs/metrics)
- Primary process metrics are locked from goals: late goal changes, post-lock drift, repeated similar tasks, and secondary goals-to-PR timing.
- Stage 2 observability comes from scaffolded task artifacts, goal artifacts, and safety-prep output.

## Verification Commands
> Pin the exact commands discovered for this repo (also update `./codex/project-structure.md` and `./codex/codex-config.yaml` if canon changes).

- Lint:
  - `not-configured`
- Build:
  - `not-configured`
- Test:
  - `not-configured`
- Stage helpers:
  - `./codex/scripts/prepare-takeoff-bootstrap.sh`
  - `./codex/scripts/task-scaffold.sh self-improve-skills`
  - `./codex/scripts/prepare-takeoff-worktree.sh self-improve-skills`

## Test strategy
- Unit:
  - n/a in Stage 2
- Integration:
  - rely on Stage 2 script success, scaffold verification, and downstream stage validators
- E2E / UI (if applicable):
  - n/a

## Acceptance criteria checklist
- [x] Goal lock is asserted by reference to `goals/self-improve-skills/goals.v1.md`.
- [x] No unresolved blocking ambiguity remains for Stage 2.
- [x] Governing rules, skills, tooling status, scope boundaries, execution posture, and change control are recorded.
- [x] Task scaffold and existing-worktree safety prep completed without worktree creation or switching.

## Ambiguity check
- Result: no unresolved blocking ambiguity for Stage 2.

## IN SCOPE
- Stage 2 readiness metadata in `tasks/self-improve-skills/spec.md`.
- Repository-local process assets, rules changes, and supporting docs/templates needed to satisfy the locked goals in later stages.
- Narrow permission/rules enablement for `gh issue create` against `ericpassmore/prompts`.

## OUT OF SCOPE
- Planning beyond what Stage 2 must record for readiness.
- Heavy telemetry infrastructure or unrelated skill-framework redesign.
- Broad permission expansion beyond the issue-creation workflow required by the locked goals.

## Execution posture lock
- Simplicity bias: required.
- Surgical-change discipline: required.
- Fail-fast error handling: required.

## Change control
- Locked goals, constraints, and success criteria from `goals/self-improve-skills/goals.v1.md` are immutable unless relocked through `establish-goals`.
- Scope expansion, verification weakening, or behavior not traceable to locked goals is drift and must stop the stage.
- Override authority for goal or constraint changes is a new approved establish-goals iteration.

## Implementation phase strategy
- Complexity: scored:L3 (multi-surface)
- Complexity scoring details: score=12; recommended-goals=6; guardrails-all-true=false; signals=/Users/eric/side-projects/prompts/tasks/self-improve-skills/complexity-signals.json
- Active phases: 1..6
- No new scope introduced: required
