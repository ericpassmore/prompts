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

### 1. Establish Codex Command Root and Commands Manifest

- Before any other stage action, detect which codex directory is available:
  - Prefer repository-local `./.codex/` if required files exist.
  - Otherwise use repository-local `./codex/` if required files exist.
  - Otherwise fallback to `$HOME/.codex/`.
  - If neither is usable, halt as `BLOCKED`.
- Required files for availability check:
  - `<CODEX_ROOT>/scripts/task-scaffold.sh`
  - `<CODEX_ROOT>/scripts/prepare-takeoff-worktree.sh`
  - `<CODEX_ROOT>/codex-commands.md`
- Establish and persist:
  - `CODEX_ROOT` (`./.codex`, `./codex`, or `$HOME/.codex`)
  - `CODEX_SCRIPTS_DIR` (`<CODEX_ROOT>/scripts`)
- Check for `./codex-commands.md`.
  - If present, update it with the selected `CODEX_ROOT` and `CODEX_SCRIPTS_DIR` reference.
  - If missing, copy from `./.codex/codex-commands.md`.
  - If `./.codex/codex-commands.md` is unavailable, copy from `./codex/codex-commands.md`.
  - If `./codex/codex-commands.md` is unavailable, copy from `$HOME/.codex/codex-commands.md`.
  - If copy source is unavailable, halt as `BLOCKED`.
- `./codex-commands.md` must contain a durable section (or equivalent key-value entry) recording:
  - selected codex root path
  - selected scripts directory path
  - canonical and fallback paths for scripts

All subsequent script commands in this skill MUST be resolved from the stored `CODEX_SCRIPTS_DIR` reference in `./codex-commands.md`.

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

- Scaffold the task directory using the `CODEX_SCRIPTS_DIR` selected in `./codex-commands.md`.
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

### 5. Create Isolated Git Worktree

- Create a git worktree under:

`$HOME/workspace/<repository>/<sanitized-branch>/<TASK_NAME_IN_KEBAB_CASE>`

- Use the `CODEX_SCRIPTS_DIR` selected in `./codex-commands.md`.
- Preferred command:

```bash
CODEX_ROOT=<CODEX_ROOT> <CODEX_SCRIPTS_DIR>/prepare-takeoff-worktree.sh <TASK_NAME_IN_KEBAB_CASE> [branch]
```

- Canonical command:

```bash
./.codex/scripts/prepare-takeoff-worktree.sh <TASK_NAME_IN_KEBAB_CASE> [branch]
```

- Repository-local fallback:

```bash
./codex/scripts/prepare-takeoff-worktree.sh <TASK_NAME_IN_KEBAB_CASE> [branch]
```

- Home fallback:

```bash
$HOME/.codex/scripts/prepare-takeoff-worktree.sh <TASK_NAME_IN_KEBAB_CASE> [branch]
```

- Branch behavior:
  - If selected branch is `main` or `master`, create new branch `codex/<TASK_NAME_IN_KEBAB_CASE>`.
  - Otherwise, use the selected existing local branch as-is.
  - In all other conditions, fail and exit.
- Sanitize branch directory segment before composing the worktree path.
- Abort if the target path already exists.

### 6. Identify Governing Context

- Identify applicable rules files.
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

### 11. Emit Readiness Verdict

- Emit exactly one verdict:
  - `READY FOR PLANNING`
  - `BLOCKED`
- If `BLOCKED`, list precise blocking reasons.

## Stage Gates

All gates must pass before planning starts.

- Gate 1: Codex root and scripts directory selected and persisted in `./codex-commands.md`.
- Gate 2: `./codex-commands.md` exists (bootstrapped if needed).
- Gate 3: Goal lock asserted and recorded.
- Gate 4: Ambiguity check passed.
- Gate 5: Task scaffold exists.
- Gate 6: Worktree created at required path.
- Gate 7: Governing context and tooling status recorded.
- Gate 8: Scope boundaries declared.
- Gate 9: Execution posture lock recorded.
- Gate 10: Change-control rule recorded.
- Gate 11: Final verdict emitted.

## Constraints

- No planning, design, or implementation is permitted.
- no code/config changes are allowed except codex command bootstrap/update (./codex-commands.md), task scaffolding, and worktree creation

## Required Outputs

- `./codex-commands.md` present and updated with:
  - selected `CODEX_ROOT`
  - selected `CODEX_SCRIPTS_DIR`
  - canonical and fallback script paths
- Fully scaffolded `./tasks/<TASK_NAME_IN_KEBAB_CASE>/`.
- Git worktree created at `$HOME/workspace/<repository>/<sanitized-branch>/<TASK_NAME_IN_KEBAB_CASE>`.
- Updated `spec.md` with:
  - goal lock assertion
  - ambiguity check result
  - environment and tooling notes
  - scope boundaries
  - execution posture lock
  - change-control rules
  - readiness verdict
