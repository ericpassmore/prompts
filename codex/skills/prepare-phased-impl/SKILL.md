---
name: prepare-phased-impl
description: Convert locked goals and scope into an ordered, complexity-adjusted implementation phase plan and emit implementation readiness.
---

# SKILL: prepare-phased-impl

## Intent

Prepare a deterministic, planning-only phase plan after `prepare-takeoff` and before `implement`.

## Preconditions (hard)

- `prepare-takeoff` has emitted `READY FOR PLANNING`.
- Locked goals, constraints, and success criteria already exist.
- `./tasks/<TASK_NAME_IN_KEBAB_CASE>/` exists with `spec.md` and `final-phase.md`.
- `## IN SCOPE` and `## OUT OF SCOPE` exist in `spec.md`.

If any precondition fails, emit `BLOCKED` and stop.

## Rule dependencies

Stage 3 depends on the same rule files as Stage 2:

- `codex/rules/expand-task-spec.rules`
- `codex/rules/git-safe.rules`
- `codex/skills/complexity-scaling/SKILL.md`

## Approved scripts (mandatory)

All Stage 3 setup/locking/validation operations MUST run through:

- `prepare-phased-impl-archive.sh`
- `prepare-phased-impl-scaffold.sh`
- `prepare-phased-impl-scope-lock.sh`
- `prepare-phased-impl-validate.sh`
- `complexity-score.sh` (when deriving complexity from scored signals JSON)

Direct shell reimplementation of these operations is not allowed.

## Command resolution

Preferred (from persisted bootstrap reference in `codex-config.yaml`):

```bash
CODEX_ROOT=<CODEX_ROOT> <CODEX_SCRIPTS_DIR>/<script>.sh ...
```

Fallback order:

1. `./.codex/scripts/<script>.sh ...`
2. `./codex/scripts/<script>.sh ...`
3. `$HOME/.codex/scripts/<script>.sh ...`

## Stage procedure

### Step 0 — Confirm task identity and complexity

- Confirm `<TASK_NAME_IN_KEBAB_CASE>`.
- Select one complexity value:
  - `surgical`
  - `focused`
  - `multi-surface`
  - `cross-system`
  - `program`
  - compatibility labels: `simple|medium|complex|very-complex`
  - explicit phase count override: `1..12`
  - deterministic scored input: `@<path-to-complexity-signals.json>`

Complexity drives phase count dynamically.

### Step 1 — Archive prior Stage 3 artifacts before restart

If restarting Stage 3 after `revalidate`, archive prior Stage 3 artifacts using:

```bash
<CODEX_SCRIPTS_DIR>/prepare-phased-impl-archive.sh <TASK_NAME_IN_KEBAB_CASE>
```

Archive location/format:

- `./tasks/<TASK_NAME_IN_KEBAB_CASE>/archive/prepare-phased-impl-<SHORT_GIT_HASH>/`
- collision fallback: `prepare-phased-impl-<SHORT_GIT_HASH>-<N>`

`prepare-phased-impl-scaffold.sh` enforces this automatically when prior Stage 3 records exist.

### Step 2 — Lock scope snapshot (no-new-scope guard)

Run:

```bash
<CODEX_SCRIPTS_DIR>/prepare-phased-impl-scope-lock.sh <TASK_NAME_IN_KEBAB_CASE>
```

This writes `./tasks/<TASK_NAME_IN_KEBAB_CASE>/.scope-lock.md` from `spec.md` scope sections.

### Step 3 — Scaffold dynamic phase-plan artifacts

Run:

```bash
<CODEX_SCRIPTS_DIR>/prepare-phased-impl-scaffold.sh <TASK_NAME_IN_KEBAB_CASE> <complexity-label|1..12>
```

or (deterministic scored input):

```bash
<CODEX_SCRIPTS_DIR>/prepare-phased-impl-scaffold.sh <TASK_NAME_IN_KEBAB_CASE> @<path-to-complexity-signals.json>
```

Script behavior:

- enforces hard precondition: `spec.md` must contain `READY FOR PLANNING`
- maps complexity labels to default phase counts within the policy ranges in `codex/skills/complexity-scaling/SKILL.md`
- accepts explicit phase count override only in `1..12`
- when provided a scored input file (`@...`), derives phase count using `complexity-score.sh`
- requires task-local complexity signals at `./tasks/<TASK_NAME_IN_KEBAB_CASE>/complexity-signals.json`
- creates missing `phase-<n>.md` files for active phases
- writes `./tasks/<TASK_NAME_IN_KEBAB_CASE>/phase-plan.md` with `PENDING` verdict
- writes `./tasks/<TASK_NAME_IN_KEBAB_CASE>/.complexity-lock.json` and treats post-lock signals path/content/range drift as `BLOCKED` in validation
- initializes/advances `./tasks/<TASK_NAME_IN_KEBAB_CASE>/lifecycle-state.md` Stage 3 cycle metadata
- appends implementation strategy section to `spec.md` when missing
- Stage 3 validation enforces complexity minimum phase count and does not block when phase count exceeds complexity max (global `1..12` still applies)

### Step 4 — Populate planning documents

Update planning docs under `./tasks/<TASK_NAME_IN_KEBAB_CASE>/` only:

- `spec.md`
- `phase-plan.md`
- `phase-<n>.md` for active phases
- `final-phase.md` (planning content only)

For each active phase, define:

- objective
- code areas impacted
- work items
- deliverables
- gate
- verification steps
- risks and mitigations

`verification mapping` is not required in this stage.

### Step 5 — Enforce no-new-scope hard stop

Do not alter `## IN SCOPE` or `## OUT OF SCOPE` after lock.

If scope changes are needed:

- stop Stage 3
- emit `BLOCKED`
- route to `revalidate`

### Step 6 — Enforce drift hard-gate policy

Continuously enforce the cross-stage drift policy from `codex/AGENTS.md`:

- locked contract integrity
- stage/surface enforcement
- verification stability
- progress budget (`N=45m`, `M=5`, `K=2 no-evidence cycles`)
- completion declaration integrity

If any drift signal is detected, stop Stage 3, document evidence, emit `BLOCKED`, and route to `revalidate`.

### Step 7 — Emit readiness verdict

Run:

```bash
<CODEX_SCRIPTS_DIR>/prepare-phased-impl-validate.sh <TASK_NAME_IN_KEBAB_CASE>
```

The validator emits exactly one verdict:

- `READY FOR IMPLEMENTATION`
- `BLOCKED`

It also updates `phase-plan.md` verdict accordingly.
On success, it updates `./tasks/<TASK_NAME_IN_KEBAB_CASE>/lifecycle-state.md` Stage 3 run count deterministically.

## Stage gates

All gates must pass:

- Gate 1: hard precondition satisfied (`READY FOR PLANNING` present in `spec.md`).
- Gate 2: scope lock snapshot exists.
- Gate 3: dynamic phase plan scaffolded based on complexity.
- Gate 4: required planning sections exist in all active phase files.
- Gate 5: no scope drift relative to lock snapshot.
- Gate 6: drift hard-gate policy respected or stage blocked with evidence.
- Gate 7: verdict emitted by validator.

## Exit behavior

- On `READY FOR IMPLEMENTATION`: proceed to `implement`.
- On `BLOCKED`: abort Stage 3 and list blockers.

## Constraints

- Planning-only stage.
- no code/config changes are allowed except phase-plan document updates under ./tasks/*

## Required outputs

- `./tasks/<TASK_NAME_IN_KEBAB_CASE>/phase-plan.md` with final verdict.
- `./tasks/<TASK_NAME_IN_KEBAB_CASE>/.scope-lock.md`.
- `./tasks/<TASK_NAME_IN_KEBAB_CASE>/.complexity-lock.json`.
- `./tasks/<TASK_NAME_IN_KEBAB_CASE>/lifecycle-state.md` with Stage 3 run metadata.
  - includes `Stage 3 runs`, `Stage 3 current cycle`, `Stage 3 last validated cycle`, and `Drift revalidation count`
- Active phase files matching chosen complexity.
- Updated planning docs under `./tasks/<TASK_NAME_IN_KEBAB_CASE>/`.
