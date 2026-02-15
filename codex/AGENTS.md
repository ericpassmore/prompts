# AGENTS.md

## Autonomous Coding Agent Contract

This contract defines cross-stage invariants for the lifecycle:
`establish-goals` -> `prepare-takeoff` -> `prepare-phased-impl` -> `implement` -> `revalidate` -> `land-the-plan`

Stage mechanics, commands, and file-surface details are owned by stage artifacts under `codex/skills/*/SKILL.md`.

---

## 1. Stage Flow Contract (Mandatory)

Stages must run in lifecycle order and emit only these verdicts:

- `establish-goals`: `GOALS LOCKED` or `BLOCKED`
- `prepare-takeoff`: `READY FOR PLANNING` or `BLOCKED`
- `prepare-phased-impl`: `READY FOR IMPLEMENTATION` or `BLOCKED`
- `implement`: `READY FOR REVERIFICATION` or `BLOCKED`
- `revalidate`: `READY TO REPLAN`, `READY TO LAND`, or `BLOCKED`
- `land-the-plan`: `LANDED` or `BLOCKED`

If any stage emits `BLOCKED`, progression stops immediately.

### 1.1 Codex Root Resolution Compatibility

Execution MUST use bootstrap-resolved paths from `codex/codex-config.yaml` when available:

- `CODEX_ROOT`
- `CODEX_SCRIPTS_DIR`

Repository note:

- this repository is rooted at `./codex` (not `./.codex`)
- fallback compatibility remains required for `./.codex` and `$HOME/.codex`
- command examples may show canonical `./.codex/...` paths, but runtime resolution must honor bootstrap-selected paths first

---

## 2. Goal Lock Contract

Before goals are locked, you MUST NOT:

- plan implementation
- prepare implementation phases
- write or modify source code

Locked goals are immutable execution input:

- goals, constraints, and success criteria must be explicit and verifiable
- goals must not be reinterpreted or expanded after lock

---

## 3. Execution Invariants

For all downstream stages after `prepare-takeoff`:

- apply simplicity bias
- apply surgical-change discipline
- apply fail-fast error handling
- change only in-scope files and behavior required to satisfy locked goals

Fail-fast behavior is mandatory:

- assert impossible states
- handle external and recoverable failures explicitly
- do not hide uncertainty or errors

Traceability is mandatory:

- planned phase work maps to locked goals
- implemented changes maps to approved phase work
- reverification evidence maps to implemented changes

### 3.1 Principles Traceability Matrix

`codex/principles.md` is authoritative. This contract enforces those principles as follows:

- `Lock Goals Before Action` -> Section 2 (`Goal Lock Contract`)
- `Respect Stage Gates` -> Section 1 (`Stage Flow Contract`)
- `Keep Changes Minimal` -> Section 3 (`Execution Invariants`)
- `Fail Fast and Explicitly` -> Section 3 (`Execution Invariants`)
- `Verify, Then Declare Done` -> Section 4 (`Verification and Completion Contract`)
- `Revalidate on Drift` -> Section 5 and Section 6 (`Drift and Revalidation`)

---

## 4. Verification and Completion Contract

Completion requires passing verification or explicit blocker documentation.

- tests or equivalent validation must exist
- tests are mandatory when behavior is changed
- unverifiable goals are invalid
- `lint`, `build`, and `test` are mandatory reverification command classes
- command instances must come from pinned task/repo command records:
  - `spec.md`
  - `./codex/project-structure.md`
  - `./codex/codex-config.yaml`

A stage MAY be declared complete only when locked success criteria and verification steps are satisfied, or blockers are explicitly documented.

---

## 5. Drift and Revalidation Hard Gate

Post-lock stages MUST continuously detect drift and enter `revalidate` on drift.

### 5.1 Drift signals

Any unauthorized change to locked contract items is drift:

- goals
- constraints
- success criteria
- non-goals
- active stage gate contract

Any unauthorized stage/surface change is drift:

- actions outside the active stage contract
- file-surface expansion outside approved scope
- touched surfaces outside approved scope

Any verification contract change is drift:

- removing, weakening, bypassing, or silently redefining verification
- changing test requirements or test scope without relock
- introducing new behavior without corresponding verification

Any completion-integrity violation is drift:

- declaring completion without satisfying locked criteria/verification or explicit blockers

### 5.2 Progress budget (loop prevention)

Per stage limits:

- `N = 45 minutes` maximum wall-clock time
- `M = 5` maximum plan -> attempt -> observe -> adjust cycles
- `K = 2` maximum consecutive cycles without new evidence

New evidence is at least one of:

- new or changed test output
- narrowed or falsified hypothesis
- reduced failure surface
- concrete reproducible observation not previously recorded

Exceeding `N`, `M`, or `K` is drift and requires `revalidate`.

---

## 6. Revalidate Contract

All revalidation decisions must be documented.

- `revalidate` wipes prior working memory/history for active execution context
- `establish-goals` and `prepare-takeoff` remain locked context-only inputs
- trigger classes:
  - drift-triggered revalidation
  - direct reverification revalidation (direct from `implement` verdict `READY FOR REVERIFICATION`)

Allowed exits by trigger:

- drift-triggered: `READY TO REPLAN` or `BLOCKED`
- direct reverification: `READY TO LAND` or `BLOCKED`

Outcome routing:

- `READY TO REPLAN`: resume at `prepare-phased-impl` (Stage 3 restart)
- `READY TO LAND`: hand off directly to `land-the-plan` (no Stage 3 restart)

`READY TO LAND` is valid only when:

- `prepare-phased-impl` has been executed at least once total for the task
- current `revalidate` entry is direct from Stage 4 verdict `READY FOR REVERIFICATION`
- no open actionable code-review findings
- code-review verdict is `patch is correct`
- unresolved actionable findings are covered by explicit risk acceptance at:
  - `./tasks/<TASK_NAME_IN_KEBAB_CASE>/risk-acceptance.md`

Stage 3 state source of truth:

- `./tasks/<TASK_NAME_IN_KEBAB_CASE>/lifecycle-state.md`:
  - `- Stage 3 runs: <N>`
  - `- Drift revalidation count: <N>`

Stage 3 restart archival requirement:

- archive prior Stage 3 artifacts before each restart at:
  - `./tasks/<TASK_NAME_IN_KEBAB_CASE>/archive/prepare-phased-impl-<SHORT_GIT_HASH>/`
- if collision exists, append numeric suffix:
  - `prepare-phased-impl-<SHORT_GIT_HASH>-<N>`
- archival must use:
  - `prepare-phased-impl-archive.sh`
- if no prior Stage 3 artifacts exist, archival is a recorded no-op

---

## 7. Land Cleanly

Do not finalize until:

- Definition of Done is met
- verification is complete or explicitly blocked
- task artifacts are current
- latest reverification includes `lint`, `build`, and `test` outcomes

Finalization requires approved commit workflow and reviewer-ready handoff details.
