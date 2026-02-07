---
name: revalidate
description: Reassess correctness, scope alignment, and plan adequacy when execution deviates or new information emerges.
---

# SKILL: revalidate

## Intent

Reassess execution integrity when drift is detected, preserve locked upstream context, and deterministically restart work at `prepare-phased-impl`.

## Preconditions (hard)

- Revalidation is triggered by at least one of:
  - detected drift in goals, scope, tests, touched surfaces, verification plan, or completion criteria
  - progress budget breach (`N=45m`, `M=5 cycles`, `K=2 no-evidence cycles`)
  - explicit Stage 4 handoff for reverification
- `./tasks/<TASK_NAME_IN_KEBAB_CASE>/` exists.
- `spec.md` exists.

If any precondition fails, emit `BLOCKED` and stop.

## Rule dependencies

Stage 5 depends on:

- `codex/rules/expand-task-spec.rules`
- `codex/rules/git-safe.rules`

## Approved scripts (mandatory)

Stage 5 archival and code-review operations MUST run through:

- `prepare-phased-impl-archive.sh`
- `revalidate-code-review.sh`
- `revalidate-validate.sh`

Direct shell reimplementation of these operations is not allowed.

## Command resolution

Preferred (from persisted bootstrap reference in `./codex-commands.md`):

```bash
CODEX_ROOT=<CODEX_ROOT> <CODEX_SCRIPTS_DIR>/<script>.sh ...
```

Fallback order:

1. `./.codex/scripts/<script>.sh ...`
2. `./codex/scripts/<script>.sh ...`
3. `$HOME/.codex/scripts/<script>.sh ...`

## Drift policy (hard gate)

Revalidate MUST enforce `codex/AGENTS.md` Section 8 as hard gate policy:

- locked contract integrity
- stage/surface enforcement
- verification stability
- progress budget (`N=45m`, `M=5`, `K=2 no-evidence cycles`)
- completion declaration integrity

Any unresolved drift signal requires `BLOCKED`.

## Stage procedure

### Step 0 — Confirm task identity and trigger

- Confirm `<TASK_NAME_IN_KEBAB_CASE>`.
- Record the trigger source and concrete evidence in:
  - `./tasks/<TASK_NAME_IN_KEBAB_CASE>/revalidate.md`

### Step 1 — Reset active execution context (mandatory actions)

Step 1 MUST execute both of the following actions:

1. Start a new chat thread and do not access or rely on context/history from the previous thread.
2. Run Stage 3 archival using:

```bash
<CODEX_SCRIPTS_DIR>/prepare-phased-impl-archive.sh <TASK_NAME_IN_KEBAB_CASE>
```

These two actions satisfy active execution context reset.
No additional reset records are required.

### Step 2 — Lock upstream context as read-only inputs

Treat these as locked context-only inputs:

- establish-goals outputs (`./goals/<TASK_NAME_IN_KEBAB_CASE>/goals.vN.md` in locked state)
- prepare-takeoff outputs in `spec.md` and `codex-commands.md`

Do not modify or reinterpret these locked artifacts in Stage 5.

### Step 3 — Reassess contract and execution integrity

Assess and document each category:

- goals/constraints/non-goals/success criteria integrity
- scope/surface adherence
- verification plan integrity and test alignment
- progress-loop evidence quality
- implementation/reverification consistency

If any category is unresolved, emit `BLOCKED`.

### Step 4 — Execute explicit code review

Run:

```bash
<CODEX_SCRIPTS_DIR>/revalidate-code-review.sh <TASK_NAME_IN_KEBAB_CASE> [base-branch]
```

Script behavior:

- reads base branch from `codex-commands.md` when specified
- falls back to base branch `main`
- if base-branch diff is empty/errors, falls back to `git diff`
- scaffolds/updates:
  - `./tasks/<TASK_NAME_IN_KEBAB_CASE>/revalidate-code-review.md`
- enforces review completeness:
  - findings status present and non-pending
  - findings schema fields present (`file`, `line_range`, `severity`, `explanation`)
  - verdict present (`patch is correct` or `patch is incorrect`)
  - confidence present and in `[0,1]`

If script validation fails, emit `BLOCKED`.

### Step 5 — Emit revalidation verdict

Emit exactly one verdict:

- `READY TO RESUME`
- `BLOCKED`

Set verdict in `./tasks/<TASK_NAME_IN_KEBAB_CASE>/revalidate.md` using:

- `- Final verdict: READY TO RESUME`
or
- `- Final verdict: BLOCKED`

### Step 6 — Validate Step 4/5 gates mechanically

Run:

```bash
<CODEX_SCRIPTS_DIR>/revalidate-validate.sh <TASK_NAME_IN_KEBAB_CASE> [base-branch]
```

Validator behavior:

- executes `revalidate-code-review.sh` to enforce Step 4
- enforces Step 5 final verdict format in `revalidate.md`
- emits exactly:
  - `READY TO RESUME`
  - `BLOCKED`

## Stage gates

All gates must pass:

- Gate 1: trigger and evidence recorded.
- Gate 2: new thread started and prior-thread context excluded.
- Gate 3: `prepare-phased-impl-archive.sh` executed (archive or no-op).
- Gate 4: locked upstream context identified and treated read-only.
- Gate 5: drift categories assessed with explicit outcomes.
- Gate 6: explicit code review completed and validated.
- Gate 7: final verdict recorded in `revalidate.md`.
- Gate 8: `revalidate-validate.sh` emits terminal verdict.

## Exit behavior

- On `READY TO RESUME`: return control to `prepare-phased-impl`; Stage 3 restarts.
- On `BLOCKED`: stop progression and list blocking reasons.

## Constraints

- No goal/constraint reinterpretation.
- No scope expansion.
- No verification weakening.
- No completion declaration without satisfied checks or explicit blockers.
- No code/config changes outside required revalidation records and archival operations.

## Required outputs

- `./tasks/<TASK_NAME_IN_KEBAB_CASE>/revalidate.md` with:
  - trigger evidence
  - drift category decisions
  - final verdict (`- Final verdict: READY TO RESUME|BLOCKED`)
- `./tasks/<TASK_NAME_IN_KEBAB_CASE>/revalidate-code-review.md` with:
  - actionable findings (or explicit no-findings state)
  - overall correctness verdict
  - confidence score
- archived Stage 3 artifacts under task `archive/` using short-hash GUID format
