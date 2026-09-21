# Hook Self Improvement

## Stage status
- establish-goals verdict: `GOALS LOCKED` (`goals/hook-self-improvement/goals.v0.md`)
- prepare-takeoff verdict: `READY FOR PLANNING`
- Stage 2 evidence:
  - Bootstrap config refreshed: `codex/codex-config.yaml`
  - Task scaffold created: `tasks/hook-self-improvement/`
  - Safety prep executed: `./codex/scripts/prepare-takeoff-worktree.sh hook-self-improvement`

## Overview
Add one narrow instruction in `codex/AGENTS.md` that activates `Prompt: self-improve-skills` when ACAC or product-idea work encounters the prompt's defined centralized-skill or workflow incidents, then verify the wording against the repository principles.

## Goals
1. Add explicit `codex/AGENTS.md` guidance that makes `codex/prompts/self-improve-skills.md` the activation path when an ACAC or product-idea run encounters the kind of centralized-skill or workflow incident described by that prompt.
2. Keep the implementation surgical by preserving existing lifecycle-stage contracts and limiting behavioral change to the new prompt-activation guidance.
3. Verify the resulting change with the repository's pinned command classes recorded for this repo, including the applicable lint/build/test status or explicit `not-configured` evidence required by the lifecycle contract.
4. Review the final wording against `codex/principles.md` and confirm alignment without introducing drift.

## Non-goals
- Editing `codex/prompts/self-improve-skills.md`, `codex/prompts/self-improve-skills-triage.md`, or any centralized skill body.
- Expanding ACAC or product-idea behavior beyond prompt-activation guidance for qualifying self-improvement incidents.

## Use cases / user stories
- As an executing agent using ACAC, I can route observed skill-process incidents into the existing self-improvement prompt without guessing when to invoke it.
- As an agent refining a product idea, I can activate the same prompt when the refinement workflow itself reveals repeated centralized-skill friction or poor-fit workflow behavior.
- As a maintainer, I can see the routing rule in `codex/AGENTS.md` without changing lifecycle verdicts or unrelated contract sections.

## Current behavior
- Notes:
  - `codex/prompts/self-improve-skills.md` exists, but `codex/AGENTS.md` does not currently tell agents when ACAC or product-idea work should activate it.
  - Existing repository practice already treats `codex/AGENTS.md` as the central contract surface for cross-stage behavior.
- Key files:
  - `codex/AGENTS.md`
  - `codex/principles.md`
  - `codex/prompts/self-improve-skills.md`
  - `/Users/eric/.codex/skills/acac/SKILL.md`
  - `/Users/eric/.codex/skills/product-idea/SKILL.md`

## Proposed behavior
- Behavior changes:
  - Add one explicit routing rule in `codex/AGENTS.md` for ACAC and product-idea executions that encounter incidents matching `Prompt: self-improve-skills`.
  - Keep the routing rule advisory to prompt activation only; it must not alter lifecycle order, stage verdicts, or scope rules.
  - Review the final wording against `codex/principles.md` in Stage 4 closeout.
- Edge cases:
  - The wording must avoid triggering on ordinary implementation friction that does not match the prompt's incident classes.
  - The wording must not imply that running the prompt bypasses stage gates or authorizes unrelated repo changes.

## Technical design
### Architecture / modules impacted
- `codex/AGENTS.md`
- `tasks/hook-self-improvement/*`

### Stage 2 governing context
- Rules:
  - `codex/rules/expand-task-spec.rules`
  - `codex/rules/git-safe.rules`
- Skills:
  - `/Users/eric/.codex/skills/acac/SKILL.md`
  - `/Users/eric/.codex/skills/product-idea/SKILL.md`
  - `/Users/eric/.codex/skills/prepare-phased-impl/SKILL.md`
  - `/Users/eric/.codex/skills/implement/SKILL.md`
- Sandbox constraints:
  - workspace-write filesystem sandbox
  - restricted network

### API changes (if any)
- None.

### UI/UX changes (if any)
- None.

### Data model / schema changes (PostgreSQL)
- Migrations: none
- Backward compatibility: full
- Rollback: revert the `codex/AGENTS.md` wording and task artifacts if later stages introduce them

## Security & privacy
- No new secrets, credentials, or network access paths.
- The change only affects local workflow guidance for when to activate an existing prompt.

## Observability (logs/metrics)
- Observability remains artifact-based: diff review, stage validators, and the final principles alignment review.

## Verification Commands
> Pin the exact commands discovered for this repo (also update `./codex/project-structure.md` and `./codex/codex-config.yaml` if canon changes).

- Lint:
  - `not-configured`
- Build:
  - `not-configured`
- Test:
  - `not-configured`
- Targeted checks:
  - `rg -n "self-improve-skills|ACAC|product-idea" codex/AGENTS.md`
  - `git diff -- codex/AGENTS.md`
  - `./codex/scripts/prepare-phased-impl-validate.sh hook-self-improvement`
  - `./codex/scripts/implement-validate.sh hook-self-improvement`

## Test strategy
- Unit:
  - n/a for a documentation contract change
- Integration:
  - Stage 3 and Stage 4 validator runs for this task
- E2E / UI (if applicable):
  - n/a

## Acceptance criteria checklist
- [x] Locked goals are asserted by reference to `goals/hook-self-improvement/goals.v0.md`.
- [x] No unresolved blocking ambiguity remains for Stage 2.
- [x] Governing rules, skills, tooling status, scope boundaries, execution posture, and change control are recorded.
- [x] The intended implementation surface is limited to `codex/AGENTS.md` plus required task artifacts.

## Ambiguity check
- Result: no unresolved blocking ambiguity for Stage 2.

## IN SCOPE
- Requested edit in:
  - `codex/AGENTS.md`
- Required lifecycle artifacts under:
  - `goals/hook-self-improvement/`
  - `tasks/hook-self-improvement/`
- Final principles review against:
  - `codex/principles.md`

## OUT OF SCOPE
- Changes to `codex/prompts/self-improve-skills.md` or `codex/prompts/self-improve-skills-triage.md`
- Changes to lifecycle verdicts, stage order, or unrelated skill behavior
- Any workflow automation beyond the explicit routing instruction requested

## Execution posture lock
- Simplicity bias: required.
- Surgical-change discipline: required.
- Fail-fast error handling: required.

## Change control
- Locked goals, constraints, and success criteria from `goals/hook-self-improvement/goals.v0.md` are immutable unless relocked through `establish-goals`.
- Scope expansion, verification weakening, or behavior not traceable to the locked goals is drift and must stop the stage.
- Override authority for goal or constraint changes is a new approved establish-goals iteration.

## Implementation phase strategy
- Complexity: scored:L2 (focused)
- Complexity scoring details: score=6; recommended-goals=4; guardrails-all-true=true; signals=/Users/eric/side-projects/prompts/tasks/hook-self-improvement/complexity-signals.json
- Active phases: 1..2
- No new scope introduced: required
