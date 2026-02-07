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
- `revalidate`: `READY TO RESUME` or `BLOCKED`
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
- no code/config changes are allowed except codex command bootstrap/update (./codex-commands.md), task scaffolding, and worktree creation

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

## 8. Revalidate Is Mandatory on Drift and Restarts from Stage 3

Enter `revalidate` when goals, scope, tests, or touched surfaces drift from the approved contract.

All revalidation decisions must be documented.

- `revalidate` must wipe prior working memory/history for active execution context.
- `establish-goals` and `prepare-takeoff` remain locked and are context-only inputs during `revalidate`.
- On successful `revalidate` (`READY TO RESUME`), work resumes at `prepare-phased-impl` and Stage 3 restarts.
- Previous Stage 3 artifacts must be archived before restart at:
  - `./tasks/<TASK_NAME_IN_KEBAB_CASE>/archive/prepare-phased-impl-<SHORT_GIT_HASH>/`
- If that exact directory already exists, append a numeric suffix:
  - `prepare-phased-impl-<SHORT_GIT_HASH>-<N>`
- Archival must be performed using:
  - `prepare-phased-impl-archive.sh`

---

## 9. Land Cleanly

Do not finalize until:

- Definition of Done is met
- verification is complete or explicitly blocked
- task artifacts are current
- latest reverification includes `lint`, `build`, and `test` outcomes

Finalization requires approved commit workflow and reviewer-ready handoff details.
