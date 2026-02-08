# AGENTS.md

## Autonomous Coding Agent Contract

This contract applies to the lifecycle:
`establish-goals` → `prepare-takeoff` → `prepare-phased-impl` → `implement` → `revalidate` → `land-the-plan`

Stage mechanics are defined in stage artifacts, including `codex/skills/prepare-takeoff/SKILL.md`. This file defines cross-stage invariants only.

---

## 1. Stage Flow Contract (Mandatory)

Stages must run in lifecycle order and must emit one of the exact verdicts below.

- `establish-goals`: `GOALS LOCKED` or `BLOCKED`
- `prepare-takeoff`: `READY FOR PLANNING` or `BLOCKED`
- `prepare-phased-impl`: `READY FOR IMPLEMENTATION` or `BLOCKED`
- `implement`: `READY FOR REVERIFICATION` or `BLOCKED`
- `revalidate`: `READY TO REPLAN`, `READY TO LAND`, or `BLOCKED`
- `land-the-plan`: `LANDED` or `BLOCKED`

If any stage emits `BLOCKED`, stop progression immediately.

---

## 2. Goals Must Be Locked Before Planning or Implementation

Before goals are locked, you MUST NOT:

- plan implementation
- prepare implementation phases
- write or modify source code

Locked goals are the execution contract:

- goals, constraints, and success criteria must be explicit and verifiable
- goals must not be reinterpreted or expanded after lock

---

## 3. `prepare-takeoff` Is the Planning Gate

Planning may begin only after `prepare-takeoff` emits `READY FOR PLANNING`.

If `prepare-takeoff` emits `BLOCKED`:

- stop
- record precise blockers
- do not continue to planning or implementation

During `prepare-takeoff`:

- no planning, design, or implementation is allowed
- no code/config changes are allowed except codex command bootstrap/update (`./codex-commands.md`), task scaffolding, worktree creation, and Stage 2 readiness metadata updates in `./tasks/<TASK_NAME_IN_KEBAB_CASE>/spec.md`

---

## 4. Prepare-Phased-Impl and Implement Are Distinct Gates

`prepare-phased-impl` is planning-only and must not perform implementation.

- Exit `prepare-phased-impl` only on `READY FOR IMPLEMENTATION`.
- Exit `implement` only on `READY FOR REVERIFICATION`.
- If either stage emits `BLOCKED`, stop and record blockers.

---

## 5. Traceability Requirement (Simple)

Traceability is required but does not require a formal table format.

- Planned phase work must map back to locked goals.
- Implemented changes must map back to approved phase work.
- Reverification evidence must map back to implemented changes.

---

## 6. Reverification Defines Completion

- tests or equivalent validation must exist
- work is complete only when verification passes or blockers are explicitly documented
- unverifiable goals are invalid goals
- `lint`, `build`, and `test` are mandatory minimum reverification command classes
- command instances must come from pinned task/repo command records (`spec.md` and `./codex-commands.md`)

---

## 7. Execution Posture Is Fixed After `prepare-takeoff`

For all downstream stages:

- apply simplicity bias
- apply surgical-change discipline
- apply fail-fast error handling

---

## 8. Drift Detection and Revalidation Hard Gate

To prevent goal redefinition, unbounded iteration, or stalled execution, all post-lock stages MUST continuously check for drift signals.

### 8.1 Locked Contract Integrity

Once goals and gate contracts are locked, the following are immutable unless an explicit unlock/relock process is executed:

- goals
- constraints
- success criteria
- non-goals
- active stage gate contract

Any unauthorized modification, reinterpretation, or implicit relaxation CONSTITUTES drift and REQUIRES entering `revalidate`.

### 8.2 Stage and Surface Enforcement

Stages MUST operate only on actions and file surfaces authorized by the active stage contract and approved plan.

Touching disallowed files, expanding affected surfaces, or running unauthorized stage actions CONSTITUTES drift and REQUIRES entering `revalidate`.

### 8.3 Verification Stability

Definition of Done and verification plans are immutable once locked for active execution.

Removing, weakening, bypassing, or silently redefining verification, or introducing new behavior without corresponding verification, CONSTITUTES drift and REQUIRES entering `revalidate`.

### 8.4 Progress Budget (Loop Prevention)

Each stage has a strict budget:

- `N = 45 minutes` maximum wall-clock time in a stage
- `M = 5 cycles` maximum plan -> attempt -> observe -> adjust loops in a stage
- `K = 2 cycles` maximum consecutive loops without new evidence

New evidence means at least one of:

- new or changed test output
- narrowed or falsified hypothesis
- reduced failure surface
- concrete reproducible observation not previously recorded

Exceeding `N`, `M`, or `K` CONSTITUTES drift and REQUIRES entering `revalidate`.

### 8.5 Completion Declaration Integrity

A stage MAY be declared complete only when all locked success criteria and verification steps are satisfied, or blockers are explicitly documented.

Declaring completion without satisfying this condition CONSTITUTES drift and REQUIRES entering `revalidate`.

### 8.6 Revalidate Execution Requirements

All revalidation decisions must be documented.

- `revalidate` must wipe prior working memory/history for active execution context.
- `establish-goals` and `prepare-takeoff` remain locked and are context-only inputs during `revalidate`.
- Trigger classes are explicit:
  - drift-triggered revalidation (entered due to Section 8 drift signals)
  - direct reverification revalidation (entered directly after `implement` emits `READY FOR REVERIFICATION`)
- Drift-triggered `revalidate` may exit only as:
  - `READY TO REPLAN`
  - `BLOCKED`
- Direct reverification `revalidate` may exit only as:
  - `READY TO LAND`
  - `BLOCKED`
- On successful drift-triggered `revalidate` (`READY TO REPLAN`), work resumes at `prepare-phased-impl` and Stage 3 restarts.
- On successful direct reverification `revalidate` (`READY TO LAND`), do not restart Stage 3; hand off to `land-the-plan`.
- `READY TO LAND` is valid only when:
  - `prepare-phased-impl` has been executed at least once total for the task
  - current `revalidate` entry was direct from Stage 4 verdict `READY FOR REVERIFICATION`
- Previous Stage 3 artifacts must be archived before each Stage 3 restart at:
  - `./tasks/<TASK_NAME_IN_KEBAB_CASE>/archive/prepare-phased-impl-<SHORT_GIT_HASH>/`
- If that exact directory already exists, append a numeric suffix:
  - `prepare-phased-impl-<SHORT_GIT_HASH>-<N>`
- Archival must be performed using:
  - `prepare-phased-impl-archive.sh`
- If no prior Stage 3 artifacts exist, archival is a no-op and must be recorded as such.

---

## 9. Land Cleanly

Do not finalize until:

- Definition of Done is met
- verification is complete or explicitly blocked
- task artifacts are current
- latest reverification includes `lint`, `build`, and `test` outcomes

Finalization requires approved commit workflow and reviewer-ready handoff details.
