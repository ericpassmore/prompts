# Goals Extract
- Task name: complexity-upward-only-scaling
- Iteration: v0
- State: locked

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

