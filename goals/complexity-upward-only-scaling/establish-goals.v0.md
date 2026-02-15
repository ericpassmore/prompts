# establish-goals

## Status

- Iteration: v0
- State: locked
- Task name (proposed, kebab-case): complexity-upward-only-scaling

## Request restatement

- Implement an upward-only complexity policy so complexity scaling still enforces minimum planning depth for harder work but does not block lower-complexity tasks for exceeding complexity max goal/phase ranges.

## Context considered

- Repo/rules/skills consulted:
  - `codex/AGENTS.md`
  - `codex/skills/acac/SKILL.md`
  - `codex/skills/complexity-scaling/SKILL.md`
  - `codex/skills/prepare-phased-impl/SKILL.md`
  - `codex/skills/establish-goals/SKILL.md`
- Relevant files (if any):
  - `codex/scripts/complexity-score.sh`
  - `codex/scripts/goals-validate.sh`
  - `codex/scripts/prepare-phased-impl-scaffold.sh`
  - `codex/scripts/prepare-phased-impl-validate.sh`
  - `codex/tasks/_templates/complexity-signals.template.json`
- Constraints (sandbox, commands, policy):
  - Maintain stage order and exact verdict contracts.
  - Keep scorer/signals/complexity lock artifacts.
  - Preserve scope-lock and drift hard gates.
  - Use approved lifecycle scripts.

## Ambiguities

### Blocking (must resolve)

1. None.

### Non-blocking (can proceed with explicit assumptions)

1. "Remove forced-L1 as a hard classifier" means removing guardrail-forced level override and associated consistency rejection path, while retaining score-band level mapping.
2. "Remove complexity-based goal-count blocking" applies to validation gates tied to scored level ranges, not the global goal-count guardrail (`1..20`).

## Questions for user

1. None.

## Assumptions (explicit; remove when confirmed)

1. The provided goals/non-goals/success criteria are the locked contract and can be executed without further clarification.
2. Existing lifecycle artifacts and stage scripts remain the system of record; changes should be limited to complexity policy behavior and aligned docs/templates.

## Goals (1-20, verifiable)

1. Preserve all existing lifecycle stages, stage verdict contracts, and drift/revalidation mechanics.
2. Keep deterministic scoring, evidence validation, and complexity lock artifacts.
3. Remove forced-L1 as a hard classifier; complexity level should derive from score bands only.
4. Change enforcement so complexity only prevents under-scaling:
   - phase count must satisfy minimum complexity expectation,
   - phase count above complexity max should not block.
5. Remove complexity-based goal-count blocking; keep only global goal bounds (`1..20`) and existing locked-state validations.
6. Keep complex-task scale-up pressure so high complexity cannot collapse into too few phases.
7. Update docs/templates to match the new policy and remove contradictory guidance.

## Non-goals (explicit exclusions)

- Do not remove the complexity scorer, complexity signals, or complexity lock files.
- Do not change stage order, stage names, or verdict strings.
- Do not relax scope-lock, no-new-scope, or drift hard gates.
- Do not introduce new lifecycle artifacts unless compatibility requires them.
- Do not redesign unrelated scripts or task flows outside complexity enforcement behavior.

## Success criteria (objective checks)

> Tie each criterion to a goal number when possible.

- [G4][G5] A small task with extra phases/goals no longer fails solely for exceeding complexity range maximums.
- [G4][G6] A complex task with too few phases fails until phase count meets minimum required complexity.
- [G1][G2] Existing ACAC lifecycle execution still passes with unchanged stage contracts.
- [G7] Documentation and templates accurately describe upward-only enforcement behavior.

## Risks / tradeoffs

- Reduced upper-bound enforcement can increase planning variance for low-complexity tasks, so minimum-phase enforcement and deterministic scoring outputs must remain strict.

## Next action

- Goals locked. Proceed to `prepare-takeoff`.
