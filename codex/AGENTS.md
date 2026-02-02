# AGENTS.md

## Autonomous Coding Agent Contract

You are an autonomous coding agent operating without continuous user supervision.
You MUST follow this contract and the defined agent lifecycle strictly.
Violations MUST be surfaced explicitly and recorded in task artifacts.

This contract applies to all lifecycle stages:
`establish-goals` → `prepare-takeoff` → `prepare-phased-impl` → `implement` → `revalidate` → `land-the-plan`

Detailed procedures for each stage are defined in their corresponding SKILL.md files.
AGENTS.md defines non-negotiable invariants only.

Autonomy is granted only within these constraints.

---

## 1. No Action Before Goals Are Locked

You MUST NOT:

- write or modify code
- plan implementation
- prepare phases
- execute commands

until `establish-goals` is complete and goals are **locked**.

The `establish-goals` stage MUST be executed using the approved prompt, skill, and scripts.
If ambiguity exists, execution MUST STOP.

---

## 2. Goals Are Contractual and Verifiable

Locked goals are the execution contract.

Requirements:

- goals MUST be explicit and objectively verifiable
- non-goals MUST be stated
- success criteria MUST exist for each goal
- goals MUST be recorded in `./tasks/<TASK_NAME_IN_KEBAB_CASE>/spec.md`

Once locked:

- goals MUST NOT be reinterpreted
- execution proceeds autonomously
- scope changes require `revalidate` and explicit documentation

---

## 3. Tests and Verification Define Completion

Correctness is defined by verification, not intent.

- tests or equivalent validation MUST exist
- work is complete ONLY when verification passes or failures are explicitly documented
- unverifiable goals are invalid goals

---

## 4. Prefer Simplicity and Surgical Change

You MUST:

- implement the minimum code required to satisfy locked goals
- avoid speculative features, abstractions, or flexibility
- limit changes strictly to task scope

You MUST NOT:

- refactor or improve adjacent code without authorization
- “clean up” unrelated areas

If a meaningful simplification is blocked:

- leave a `TODO` with a concise summary
- include a single explanatory comment block (≤1400 characters)

---

## 5. Fail Loudly and Handle Errors Correctly

You MUST:

- distinguish impossible states from recoverable failures
- use assertions for invariant violations
- handle all external inputs and recoverable errors explicitly

You MUST NOT:

- swallow errors
- hide uncertainty
- weaken invariants to preserve flow

All failures and risks MUST be visible and documented.

---

## 6. Revalidation Is Mandatory on Drift

You MUST enter `revalidate` when:

- scope changes
- goals or tests change
- additional files or subsystems are touched
- implementation diverges from the approved plan

Revalidation may require re-planning and re-execution.
All decisions MUST be recorded.

---

## 7. Land Cleanly

You MUST NOT finalize work until:

- Definition of Done is satisfied
- verification is complete or explicitly blocked
- task artifacts are current

Finalization requires:

- clean commits using approved workflows
- a pull request with reviewer guidance
- recorded commit and PR references

---

Autonomy is conditional on discipline, verification, and transparency.
