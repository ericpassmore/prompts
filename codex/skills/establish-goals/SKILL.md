---
name: establish-goals
description: Clarify an ambiguous or incomplete request and produce 0–5 explicit, verifiable goals before any planning or implementation.
---

# SKILL: establish-goals

## Purpose

Execute the `establish-goals` lifecycle stage in isolation to eliminate ambiguity and produce **0–5 verifiable goals** with explicit success criteria.

This skill establishes the contractual foundation for all subsequent autonomous execution.

All work in this skill MUST be performed using the approved establish-goals scripts.

---

## Scope

This skill includes:

- clarifying intent
- identifying ambiguities and assumptions
- drafting goals, non-goals, and success criteria
- producing immutable, per-iteration goal artifacts

This skill explicitly excludes:

- environment setup
- phased planning
- implementation
- testing
- git operations

---

## Hard stop rule (mandatory)

If an iteration produces **ZERO goals**, execution MUST STOP.

The agent MUST NOT proceed to:

- prepare-takeoff
- prepare-phased-impl
- implementation
- any other lifecycle stage

until goals exist and are confirmed.

This rule is enforced mechanically via validation scripts.

---

## Required templates

The following templates MUST be used as the basis for all artifacts:

- `./.codex/goals/establish-goals.template.md`
- `./.codex/goals/goal.template.md` (optional drafting helper)
- `./.codex/goals/establish-goals.checklist.md`

---

## Work product storage (mandatory)

All goal artifacts are stored under:

`./goals/<TASK_NAME_IN_KEBAB_CASE>/`

For each iteration `vN`, the following files MUST exist:

- `establish-goals.vN.md`
  - complete establish-goals artifact

- `goals.vN.md`
  - normalized extract containing ONLY:
    - goals
    - non-goals
    - success criteria

Iteration numbering is strictly linear:

- v0 → v1 → v2 → …

Earlier iterations MUST NOT be modified.

---

## Approved scripts (mandatory)

All file creation, iteration, validation, extraction, and locking MUST be performed using the following scripts:

- `goals-scaffold.sh`
- `goals-next-iteration.sh`
- `goals-extract.sh`
- `goals-validate.sh`
- `goals-lock-to-spec.sh`

Direct manual file creation or copying is NOT permitted.

---

## Procedure

### Step 0 — Confirm task identity

- Ensure `<TASK_NAME_IN_KEBAB_CASE>` is defined and stable.
- If not provided, propose one and confirm with the user before proceeding.

---

### Step 1 — Scaffold initial iteration (v0)

Create the v0 iteration using:
`./.codex/scripts/goals-scaffold.sh <TASK_NAME_IN_KEBAB_CASE>`

This MUST create:

- `establish-goals.v0.md`
- `goals.v0.md`

---

### Step 2 — Populate establish-goals.vN.md

Edit `establish-goals.vN.md` to populate:

- Request restatement
- Context considered (only what was actually inspected)
- Ambiguities (blocking vs non-blocking)
- Questions for user (blocking first)
- Assumptions (explicit; never implicit)
- Goals (0–5, verifiable)
- Non-goals (explicit exclusions)
- Success criteria (objective, mapped to goals)
- Risks / tradeoffs
- Next action

Set:

- Iteration: vN
- State: draft | blocked | ready-for-confirmation | locked

---

### Step 3 — Extract normalized goals

After updating `establish-goals.vN.md`, run:

`./.codex/scripts/goals-extract.sh <TASK_NAME_IN_KEBAB_CASE> vN`

This produces or updates:

- `goals.vN.md`

This file MUST contain ONLY goals, non-goals, and success criteria.

---

### Step 4 — Checklist enforcement

Manually review `establish-goals.checklist.md`.

If any checklist item fails:

- fix the establish-goals artifact, OR
- explicitly document why the item cannot yet be satisfied

Checklist completion is required before validation.

---

### Step 5 — Mechanical validation (mandatory)

Validate the iteration using:

`./.codex/scripts/goals-validate.sh <TASK_NAME_IN_KEBAB_CASE> vN`

This validation enforces:

- goal count ∈ [0,5]
- zero goals ⇒ State = blocked
- goals present ⇒ success criteria required
- locked state consistency

Validation failures MUST be resolved before proceeding.

---

### Step 6 — Hard stop enforcement

If goals == 0:

- State MUST be `blocked`
- Ask ONLY the blocking clarification questions
- STOP execution

No iteration bump is permitted until blocking ambiguity is resolved.

---

### Step 7 — Iteration protocol

When user input is required:

- ask ONLY the questions listed in the current iteration
- on reply, create the next iteration using:

`./.codex/scripts/goals-next-iteration.sh <TASK_NAME_IN_KEBAB_CASE>`

- populate `establish-goals.v(N+1).md`
- re-run extraction and validation

Do NOT modify earlier iterations.

---

### Step 8 — Locking goals and handoff

When the user confirms the goals:

1. Set `State = locked` in `establish-goals.vN.md`
2. Re-run extraction and validation
3. Copy goals into the canonical task spec using:

`./.codex/scripts/goals-lock-to-spec.sh <TASK_NAME_IN_KEBAB_CASE> vN`

This writes to:

`./tasks/<TASK_NAME_IN_KEBAB_CASE>/spec.md`

using the canonical spec template.

This step completes the `establish-goals` skill.

---

## Success conditions

This skill is complete ONLY when:

- goals exist (1–5)
- goals are verifiable
- State = `locked`
- validation passes
- goals are recorded in `./tasks/<TASK_NAME_IN_KEBAB_CASE>/spec.md`

Autonomous execution is NOT permitted before these conditions are met.

---

## Contractual note

Textual compliance is insufficient.

The establish-goals phase is considered valid ONLY if:

- artifacts exist in the correct locations
- scripts were used
- validation passed

Failure to follow this skill invalidates downstream autonomy.
