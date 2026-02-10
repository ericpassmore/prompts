---
name: prepare-takeoff
description: Prepare the execution environment and task structure after goals are locked but before any planning or implementation begins.
---

# SKILL: prepare-takeoff

## Intent

Prepare a deterministic execution environment after goals are locked and before planning begins.

## Preconditions

- Goals, constraints, and success criteria are explicitly defined.
- All ambiguity is resolved.

## The Agent MUST

### 1. Establish Codex Command Root and Canonical Config

- Run the bootstrap script; do not perform this step manually.
- Command resolution order:

1. Canonical command:

```bash
./.codex/scripts/prepare-takeoff-bootstrap.sh
```

2. Repository-local fallback:

```bash
./codex/scripts/prepare-takeoff-bootstrap.sh
```

3. Home fallback:

```bash
$HOME/.codex/scripts/prepare-takeoff-bootstrap.sh
```

- Script responsibilities (authoritative):
  - resolve `CODEX_ROOT` using `./.codex`, `./codex`, then `$HOME/.codex`
  - verify required files under selected root
  - enforce required `project-structure.md` under selected root (abort if missing)
  - bootstrap `codex-config.yaml` if missing
  - persist `CODEX_ROOT` and `CODEX_SCRIPTS_DIR` in `codex-config.yaml`
  - persist canonical and fallback script paths in `codex-config.yaml`
  - fail with explicit `BLOCKED` reason if bootstrap cannot be completed

All subsequent script commands in this skill MUST be resolved from the stored `CODEX_SCRIPTS_DIR` reference in `codex-config.yaml`.
This is mechanized via `<CODEX_SCRIPTS_DIR>/read-codex-paths.sh`, which Stage 2 scripts source automatically.

### 2. Assert Goal Lock

- Confirm goals, constraints, and success criteria are final.
- Confirm no reinterpretation or expansion is permitted.
- Record a brief goal snapshot or reference in `spec.md`.

### 3. Run Ambiguity Check

- Verify no unresolved ambiguity remains.
- If ambiguity is detected:
  - Halt the stage.
  - Record the blocking issue.
  - Do not proceed.

### 4. Scaffold Task Structure

- Scaffold the task directory using the `CODEX_SCRIPTS_DIR` selected in `codex-config.yaml`.
- Preferred command:

```bash
CODEX_ROOT=<CODEX_ROOT> <CODEX_SCRIPTS_DIR>/task-scaffold.sh <TASK_NAME_IN_KEBAB_CASE>
```

- Canonical command:

```bash
./.codex/scripts/task-scaffold.sh <TASK_NAME_IN_KEBAB_CASE>
```

- Repository-local fallback:

```bash
./codex/scripts/task-scaffold.sh <TASK_NAME_IN_KEBAB_CASE>
```

- Home fallback:

```bash
$HOME/.codex/scripts/task-scaffold.sh <TASK_NAME_IN_KEBAB_CASE>
```

- Do not modify existing code.

### 5. Run Existing-Worktree Safety Prep

- Assume execution starts inside an already-managed existing worktree.
- Do not create, initialize, switch, or remove any worktree in Stage 2.
- Use the `CODEX_SCRIPTS_DIR` selected in `codex-config.yaml`.
- Preferred command:

```bash
CODEX_ROOT=<CODEX_ROOT> <CODEX_SCRIPTS_DIR>/prepare-takeoff-worktree.sh <TASK_NAME_IN_KEBAB_CASE> [expected-branch]
```

- Canonical command:

```bash
./.codex/scripts/prepare-takeoff-worktree.sh <TASK_NAME_IN_KEBAB_CASE> [expected-branch]
```

- Repository-local fallback:

```bash
./codex/scripts/prepare-takeoff-worktree.sh <TASK_NAME_IN_KEBAB_CASE> [expected-branch]
```

- Home fallback:

```bash
$HOME/.codex/scripts/prepare-takeoff-worktree.sh <TASK_NAME_IN_KEBAB_CASE> [expected-branch]
```

- The safety-prep helper must:
  - run `git worktree prune`
  - validate repository/branch context
  - fail fast on unresolved merge conflicts
  - report status summary for current worktree
- If `expected-branch` is provided and does not match current branch, fail with `BLOCKED`.

### 6. Identify Governing Context

- Identify applicable rules files.
  - Stage 2 depends on:
    - `codex/rules/expand-task-spec.rules`
    - `codex/rules/git-safe.rules`
- Identify applicable skills.
- Identify sandbox constraints.
- Record findings in `spec.md`.

### 7. Discover Tooling

- Discover or confirm canonical lint commands.
- Discover or confirm canonical build commands.
- Discover or confirm canonical test commands.
- If unknown, mark as `unknown`.

### 8. Declare Scope Boundaries

- Declare `IN SCOPE`.
- Declare `OUT OF SCOPE`.
- Record both in `spec.md`.

### 9. Lock Execution Posture

- Lock simplicity bias for downstream stages.
- Lock surgical-change rule for downstream stages.
- Lock fail-fast error handling for downstream stages.
- Record posture lock in `spec.md`.

### 10. Define Change Control

- State that goal or constraint changes are not allowed.
- Define required override authority.
- Record in `spec.md`.

### 11. Enforce drift hard-gate policy

During Stage 2, continuously enforce the cross-stage drift policy from `codex/AGENTS.md`:

- locked contract integrity
- stage/surface enforcement
- verification stability
- progress budget (`N=45m`, `M=5`, `K=2 no-evidence cycles`)
- completion declaration integrity

If any drift signal is detected, stop Stage 2, emit `BLOCKED` with explicit evidence, and route to `revalidate`.

### 12. Emit Readiness Verdict

- Emit exactly one verdict:
  - `READY FOR PLANNING`
  - `BLOCKED`
- If `BLOCKED`, list precise blocking reasons.

## Stage Gates

All gates must pass before planning starts.

- Gate 1: Codex root and scripts directory selected and persisted in `codex-config.yaml`.
- Gate 2: required canonical files exist: `codex-config.yaml` and `project-structure.md`.
- Gate 3: Goal lock asserted and recorded.
- Gate 4: Ambiguity check passed.
- Gate 5: Task scaffold exists.
- Gate 6: Existing-worktree safety prep completed without creating/switching/removing worktrees.
- Gate 7: Governing context and tooling status recorded.
- Gate 8: Scope boundaries declared.
- Gate 9: Execution posture lock recorded.
- Gate 10: Change-control rule recorded.
- Gate 11: Drift hard-gate policy respected or stage blocked with evidence.
- Gate 12: Final verdict emitted.

## Constraints

- No planning, design, or implementation is permitted.
- no code/config changes are allowed except codex bootstrap/config updates (`./codex/codex-config.yaml` and `./codex/project-structure.md`), task scaffolding, existing-worktree safety prep, and Stage 2 readiness metadata updates in `./tasks/<TASK_NAME_IN_KEBAB_CASE>/spec.md`

## Required Outputs

- `codex-config.yaml` present and updated with:
  - selected `CODEX_ROOT`
  - selected `CODEX_SCRIPTS_DIR`
  - canonical and fallback script paths
- `project-structure.md` present; stage aborts if missing
- Fully scaffolded `./tasks/<TASK_NAME_IN_KEBAB_CASE>/`.
- Existing-worktree safety-prep evidence recorded (for example prune + status safety checks).
- Updated `spec.md` with:
  - goal lock assertion
  - ambiguity check result
  - environment and tooling notes
  - scope boundaries
  - execution posture lock
  - change-control rules
  - readiness verdict
