---
name: establish-goals
description: Clarify an ambiguous or incomplete request and produce 1-20 explicit, verifiable goals before any planning or implementation.
---

# SKILL: establish-goals

## Purpose

Execute the `establish-goals` lifecycle stage in isolation to eliminate ambiguity and produce **1-20 verifiable goals** with explicit success criteria.

This skill establishes the contractual foundation for downstream execution and ends at goal lock.

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
- task scaffolding
- `spec.md` population
- phased planning
- implementation
- testing
- git operations

---

## Rule dependencies

Goal count should scale with complexity according to:

- `codex/skills/complexity-scaling/SKILL.md`

---

## Hard stop rule (mandatory)

If an iteration cannot produce **at least one verifiable goal**, execution MUST STOP.

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

- `<CODEX_ROOT>/goals/establish-goals.template.md`
- `<CODEX_ROOT>/goals/goal.template.md` (optional drafting helper)
- `<CODEX_ROOT>/goals/establish-goals.checklist.md`

`CODEX_ROOT` resolution order:

1. `./.codex`
2. `./codex`
3. `$HOME/.codex`

If none exist, STOP as blocked.

---

## Work product storage (mandatory)

All goal artifacts are stored under:

`./goals/<TASK_NAME_IN_KEBAB_CASE>/`

The establish-goals phase also maintains:

- `./goals/task-manifest.csv`
  - repository-wide manifest ordered by first create date
  - tracks only `number`, `taskname`, and `first_create_date`

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

All file creation, iteration, validation, and extraction MUST be performed using the following scripts:

- `codex-config-bootstrap-sync.sh`
- `goals-scaffold.sh`
- `goals-next-iteration.sh`
- `goals-extract.sh`
- `goals-validate.sh`
- `complexity-score.sh` (for deterministic level/range selection when signals are available)

Direct manual file creation or copying is NOT permitted.

`CODEX_SCRIPTS_DIR` resolution order:

1. `./.codex/scripts`
2. `./codex/scripts`
3. `$HOME/.codex/scripts`

If none exist, STOP as blocked.

---

## Procedure

### Step -1 — Sync bootstrap paths for detached-head worktrees

At establish-goals entry, run:

`<CODEX_SCRIPTS_DIR>/codex-config-bootstrap-sync.sh apply`

Rules:

- runs only in detached `HEAD` mode; otherwise no-op
- resolves codex root from current working directory in order:
  - `./.codex`
  - `./codex`
  - `$HOME/.codex`
- preserves existing bootstrap values in `codex-config.yaml`
- updates bootstrap paths to current worktree-resolved codex root/scripts

If sync fails, stop as `BLOCKED`.

---

### Step 0 — Confirm task identity

- Ensure `<TASK_NAME_IN_KEBAB_CASE>` is defined and stable.
- If not provided, propose one and confirm with the user before proceeding.

---

### Step 1 — Scaffold initial iteration (v0)

Create the v0 iteration using:
`<CODEX_SCRIPTS_DIR>/goals-scaffold.sh <TASK_NAME_IN_KEBAB_CASE>`

This MUST create:

- `establish-goals.v0.md`
- `goals.v0.md`
- ensure `./goals/task-manifest.csv` is updated with the task's first create date

---

### Step 2 — Populate establish-goals.vN.md

Edit `establish-goals.vN.md` to populate:

- Request restatement
- Context considered (only what was actually inspected)
- Ambiguities (blocking vs non-blocking)
- Questions for user (blocking first)
- Assumptions (explicit; never implicit)
- Goals (1-20, verifiable)
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

`<CODEX_SCRIPTS_DIR>/goals-extract.sh <TASK_NAME_IN_KEBAB_CASE> vN`

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

`<CODEX_SCRIPTS_DIR>/goals-validate.sh <TASK_NAME_IN_KEBAB_CASE> vN`

Optional complexity-linked validation:

`<CODEX_SCRIPTS_DIR>/goals-validate.sh <TASK_NAME_IN_KEBAB_CASE> vN <path-to-complexity-signals.json>`

This validation enforces:

- goal count ∈ [1,20]
- goals present ⇒ success criteria required
- locked state consistency
- when a signals file is provided: goal count must be within the scored level range

Validation failures MUST be resolved before proceeding.

---

### Step 6 — Hard stop enforcement

If at least one verifiable goal cannot be stated:

- State MUST be `blocked`
- Ask ONLY the blocking clarification questions
- STOP execution

No iteration bump is permitted until blocking ambiguity is resolved.

---

### Step 7 — Iteration protocol

When user input is required:

- ask ONLY the questions listed in the current iteration
- on reply, create the next iteration using:

`<CODEX_SCRIPTS_DIR>/goals-next-iteration.sh <TASK_NAME_IN_KEBAB_CASE>`

- populate `establish-goals.v(N+1).md`
- re-run extraction and validation

Do NOT modify earlier iterations.

---

### Step 8 — Locking goals and stage completion

When the user confirms the goals:

1. Set `State = locked` in `establish-goals.vN.md`
2. Re-run extraction and validation
3. Emit stage verdict `GOALS LOCKED`.
4. Add a one-line handoff note in `establish-goals.vN.md` stating that `prepare-takeoff` owns task scaffolding and `spec.md` readiness content.

This step completes the `establish-goals` skill.

---

## Success conditions

This skill is complete ONLY when:

- goals exist (1-10)
- goals are verifiable
- State = `locked`
- validation passes
- stage verdict emitted is exactly `GOALS LOCKED`

Autonomous execution is NOT permitted before these conditions are met.

---

## Contractual note

Textual compliance is insufficient.

The establish-goals phase is considered valid ONLY if:

- artifacts exist in the correct locations
- scripts were used
- validation passed

Failure to follow this skill invalidates downstream autonomy.
