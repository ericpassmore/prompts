---
name: implement
description: Execute the approved implementation phases in order and produce working changes that satisfy the locked goals.
---

# SKILL: implement

## Intent

Execute approved implementation work in deterministic phase order and produce truthful, verifiable outputs aligned to locked goals and scope.

## Preconditions (hard)

- `prepare-phased-impl` emitted `READY FOR IMPLEMENTATION`.
- Locked goals, constraints, and success criteria already exist.
- `./tasks/<TASK_NAME_IN_KEBAB_CASE>/` exists with:
  - `spec.md`
  - `phase-plan.md`
  - `final-phase.md`
  - `.scope-lock.md`
  - active `phase-<n>.md` files
- Verification commands are pinned in task `spec.md` and/or `./codex-commands.md` for:
  - lint
  - build
  - test

If any precondition fails, emit `BLOCKED` and stop.

## Rule dependencies

Stage 4 depends on:

- `codex/rules/expand-task-spec.rules`
- `codex/rules/git-safe.rules`

## Approved scripts (mandatory)

Stage 4 final gate validation MUST run through:

- `implement-validate.sh`

Direct shell reimplementation of the Stage 4 final gate logic is not allowed.

## Command resolution

Preferred (from persisted bootstrap reference in `./codex-commands.md`):

```bash
CODEX_ROOT=<CODEX_ROOT> <CODEX_SCRIPTS_DIR>/<script>.sh ...
```

Fallback order:

1. `./.codex/scripts/<script>.sh ...`
2. `./codex/scripts/<script>.sh ...`
3. `$HOME/.codex/scripts/<script>.sh ...`

## Phase-complete source of truth (mandatory)

Stage 4 phase completion truth comes from task artifacts, with `final-phase.md` as the authoritative completion ledger:

- final-phase checklist items are authoritative evidence of evaluation status
- `## Full verification` in `final-phase.md` is authoritative for lint/build/test status
- all checklist items must be evaluated, but not all must be completed

Evaluation rule for checklist lines:

- Completed item: `- [x] ...`
- Not completed but evaluated item: `- [ ] ... EVALUATED: <decision + reason>`

Accepted `EVALUATED:` decisions include:

- `deferred`
- `not-applicable`
- `blocked`

## Stage procedure

### Step 0 — Confirm task identity and active phase set

- Confirm `<TASK_NAME_IN_KEBAB_CASE>`.
- Read `phase-plan.md` to determine active phases and execution order.
- Proceed strictly in order (Phase 1 -> Phase 2 -> ...).

### Step 1 — Execute approved phase work in order

For each active phase:

1. Implement only the approved `Work items`.
2. Stay within locked scope (`## IN SCOPE` / `## OUT OF SCOPE`).
3. Run phase-specific verification steps from the phase file.
4. Update phase gate evidence in the phase file.

If a phase gate fails:

- stop progression
- record blockers and evidence
- emit `BLOCKED`

### Step 2 — Maintain final-phase completion ledger

Update `final-phase.md` continuously during implementation:

- evaluate every checklist item
- use `[x]` when complete
- for unchecked items, append `EVALUATED:` with explicit rationale

The validator treats unchecked items without `EVALUATED:` as unevaluated and blocks Stage 4.

### Step 3 — Mandatory full verification (`lint`, `build`, `test`)

- Run pinned lint/build/test commands from task `spec.md` and `./codex-commands.md`.
- Record command and outcome under `## Full verification` in `final-phase.md`.

Required pass notation:

- `- [x] Lint: \`<command>\` PASS`
- `- [x] Build: \`<command>\` PASS`
- `- [x] Tests: \`<command>\` PASS`

If any command cannot run (for example broken dependencies/toolchain):

- do not claim pass
- document the precise blocker in `final-phase.md`
- document it in `Outstanding issues`
- emit `BLOCKED`

### Step 4 — Accuracy, test integrity, and exceptions

Hard rules:

- represent code state honestly against locked goals
- do not rewrite/loosen tests just to force pass status
- keep tests true to goal/spec behavior
- document every exception and deviation explicitly

`//TODO` comments are permitted for delayed/future goals when:

- they do not hide required Stage 4 completion work
- they are traceable to an outstanding issue, deferral, or non-goal

### Step 5 — Document outstanding issues completely

In `## Outstanding issues (if any)`:

- record every known issue with severity, repro, and suggested fix
- if no issues exist, write an explicit none marker (for example `- None.`)

Placeholder-only issue entries are invalid.

### Step 6 — Emit implementation verdict via validator

Run:

```bash
<CODEX_SCRIPTS_DIR>/implement-validate.sh <TASK_NAME_IN_KEBAB_CASE>
```

Validator emits exactly one verdict:

- `READY FOR REVERIFICATION`
- `BLOCKED`

Validator also updates `phase-plan.md` verdict accordingly.

## Stage gates

All gates must pass:

- Gate 1: hard preconditions satisfied.
- Gate 2: active phases executed in approved order with gate evidence.
- Gate 3: `final-phase.md` checklist items are fully evaluated (`[x]` or `EVALUATED:`).
- Gate 4: lint/build/test are present and marked `PASS`.
- Gate 5: outstanding issues are fully documented.
- Gate 6: validator emits terminal verdict.

## Exit behavior

- On `READY FOR REVERIFICATION`: hand off to `revalidate`.
- On `BLOCKED`: stop and list precise blockers.

## Constraints

- No goal or scope expansion.
- No silent failure masking.
- No verification falsification.
- No code review stage in Stage 4.

## Non-goals

Stage 4 does not perform final code review.  
Code review is deferred to `revalidate`.

## Required handoff outputs

- stage verdict (`READY FOR REVERIFICATION` or `BLOCKED`)
- updated `final-phase.md` containing:
  - proof all checklist items were evaluated (completion not required for all)
  - full outstanding-issues documentation
  - lint/build/test pass evidence
- implemented code, documentation, and tests present in the repository changeset
- explicit exception notes for blockers/drift/verification gaps
- optional `//TODO` markers for delayed/future goals where justified
