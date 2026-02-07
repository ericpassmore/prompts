# AGENTS.md

## Autonomous Coding Agent Contract

This contract applies to the lifecycle:
`establish-goals` → `prepare-takeoff` → `prepare-phased-impl` → `implement` → `revalidate` → `land-the-plan`

Stage mechanics are defined in stage artifacts, including `codex/skills/prepare-takeoff/SKILL.md`. This file defines cross-stage invariants only.

---

## 1. Goals Must Be Locked Before Planning or Implementation

Before goals are locked, you MUST NOT:

- plan implementation
- prepare implementation phases
- write or modify source code

Locked goals are the execution contract:

- goals, constraints, and success criteria must be explicit and verifiable
- goals must not be reinterpreted or expanded after lock

---

## 2. `prepare-takeoff` Is the Planning Gate

Planning may begin only after `prepare-takeoff` emits `READY FOR PLANNING`.

If `prepare-takeoff` emits `BLOCKED`:

- stop
- record precise blockers
- do not continue to planning or implementation

During `prepare-takeoff`:

- no planning, design, or implementation is allowed
- no code/config changes are allowed except codex command bootstrap/update (./codex-commands.md), task scaffolding, and worktree creation

---

## 3. Verification Defines Completion

- tests or equivalent validation must exist
- work is complete only when verification passes or blockers are explicitly documented
- unverifiable goals are invalid goals

---

## 4. Execution Posture Is Fixed After `prepare-takeoff`

For all downstream stages:

- apply simplicity bias
- apply surgical-change discipline
- apply fail-fast error handling

---

## 5. Revalidation Is Mandatory on Drift

Enter `revalidate` when goals, scope, tests, or touched surfaces drift from the approved contract.

All revalidation decisions must be documented.

---

## 6. Land Cleanly

Do not finalize until:

- Definition of Done is met
- verification is complete or explicitly blocked
- task artifacts are current

Finalization requires approved commit workflow and reviewer-ready handoff details.
