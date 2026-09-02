# establish-goals

## Status

- Iteration: v0
- State: locked
- Task name: simplify-lifecycle-workflow

## Request restatement

Simplify and consolidate the active coding lifecycle around concrete goal alignment, rapid execution, and end-loaded quality gates.

## Context considered

- Skills: `establish-goals`, `prepare-takeoff`, `prepare-phased-impl`, `implement`, `code-review`, `land-the-plan`, and `skill-creator`.
- Active supporting scripts, validators, rules, templates, and task scaffolding.
- User-confirmed consolidation and merge-safety requirements.
- Existing unstaged work must be preserved.

## Ambiguities

### Blocking

None; consolidation, historical-record policy, and clean-merge semantics were confirmed.

### Non-blocking

None.

## Questions for user

None.

## Assumptions

1. Retain the name `implement` for the consolidated rapid-execution skill.
2. A clean merge means the branch can integrate the current base through fast-forward or Git's `ort` strategy without conflicts; conflicts require operator resolution.

## Goals

1. Keep `establish-goals` as a concise goal-lock skill centered on explicit, verifiable goals and blocking ambiguity.
2. Consolidate `prepare-takeoff`, `prepare-phased-impl`, and `implement` into one streamlined `implement` skill that moves directly from locked goals to scoped execution.
3. Keep `code-review` independently reusable and concise, with actionable findings, exact citations, correctness verdict, and confidence.
4. Simplify `land-the-plan` around end-loaded pinned lint/build/test validation, code review, clean-merge verification, authorized commit/push, and PR creation.
5. Simplify active scripts, validators, rules, templates, and future task scaffolding to match the consolidated workflow and remove obsolete stage/phase machinery.
6. Preserve all historical records under existing `goals/` and `tasks/` directories except artifacts created for this task.
7. Validate modified skills, shell syntax, representative workflow behavior, quality-gate enforcement, and clean-merge behavior.

## Non-goals

- Rewriting or deleting historical task and goal records.
- Weakening pinned lint/build/test or code-review quality gates.
- Automatically resolving merge conflicts or selecting conflicting lines.
- Changing unrelated product-development skills.

## Success criteria

- [G1] `establish-goals/SKILL.md` contains only goal alignment, artifact, validation, and goal-lock essentials.
- [G2] `prepare-takeoff` and `prepare-phased-impl` are removed from active skills; `implement` owns setup, scope, execution, and readiness for landing.
- [G3] `code-review` remains independently callable and its required review output is mechanically enforceable.
- [G4] Landing runs pinned lint/build/tests and code review, then verifies the current branch can merge with the fetched base via fast-forward or conflict-free `ort` before PR creation.
- [G5] Active scaffolding and validation no longer require phase plans, phase files, lifecycle-state files, scope-lock files, or final-phase ledgers for future tasks.
- [G6] Pre-existing historical records are unchanged.
- [G7] Skill validation, shell syntax checks, active-reference searches, and representative success/failure fixtures pass.

## Risks / tradeoffs

- Existing repositories may still contain old task artifacts; compatibility must tolerate them without requiring or rewriting them.
- End-loaded gates shorten execution but defer some failures until landing; failures must remain explicit and block delivery.

## Next action

Goals confirmed by the user. Hand off to the current preparation gate before consolidating it into `implement`.
