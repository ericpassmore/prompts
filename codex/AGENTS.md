# Codex Operating Instructions (Repo-local)

This repository’s Codex configuration lives under `./.codex/`. Follow these instructions whenever you work in this repo.

## 1) Primary goals

1. Use the provided **skills** and **prompts** to ensure consistent workflows.
2. Produce task documentation under `./tasks/<task-name>/` using the provided templates.
3. Run only allowed shell commands under the configured sandbox policy.

## 2) Repository layout

- `./.codex/config.toml`
  - Codex runtime configuration (model, sandbox settings, approval policy, MCP servers).

- `./.codex/rules/`
  - `git-safe.rules`: allow-list for safe git operations and approved helper scripts.
  - `expand-task-spec.rules`: allow-list for expand-task-spec related commands + `task-scaffold.sh`.

- `./.codex/scripts/`
  - `git-check-conflicts.sh`: detect merge conflicts/unmerged paths; exits non-zero if present.
  - `git-diff-staged-skip-binary.sh`: show staged diffs for text files only; skip binaries.
  - `task-scaffold.sh`: scaffold and validate `./tasks/<task-name>/` task structure.

- `./.codex/tasks/_templates/`
  - `spec.template.md`, `phase.template.md`, `final-phase.template.md`: canonical templates for task artifacts.

- `./.codex/codex-commands.md`
  - Commands manifest. Pins the canonical lint/build/test commands once discovered.

- `./.codex/prompts/`
  - `expand-task-spec.md`: reusable prompt for expanding a request into spec + phases + execution.
  - `gitpull.md`: reusable prompt for safe fast-forward pull behavior.

- `./.codex/skills/`
  - `git-commit/SKILL.md`: safe commit workflow.
  - `expand-task-spec/SKILL.md`: spec + phased plan + phased execution workflow.

## 3) Execution policy (sandbox + rules)

- All shell commands must execute inside the configured **sandboxed workspace**.
- Do not run commands that are not explicitly allowed by the rules files in `./.codex/rules/`.
- Do not execute compound shell pipelines inline (pipes, `&&` chains, `while` loops) unless the exact operation is implemented in an approved script under `./.codex/scripts/`.

### Preferred replacements for unsafe pipelines

- Conflict detection:
  - Prefer: `./.codex/scripts/git-check-conflicts.sh`
  - Avoid: `git ... | grep ... && ...`

- Staged diff review:
  - Prefer: `./.codex/scripts/git-diff-staged-skip-binary.sh`
  - Avoid: inline loops with `awk` / `while read`

## 4) Task workflow standards

### 4.1 Task directory location (source of truth)

All task artifacts must be created under:

- `./tasks/<task-name>/`

Task name rules:
- kebab-case (no spaces)
- stable and descriptive

### 4.2 Scaffolding (mandatory)

Before writing task docs, scaffold the task directory:

- `./.codex/scripts/task-scaffold.sh <task-name>`

This must create (at minimum):
- `./tasks/<task-name>/spec.md`
- `./tasks/<task-name>/phase-1.md`
- `./tasks/<task-name>/phase-2.md`
- `./tasks/<task-name>/phase-3.md`
- `./tasks/<task-name>/final-phase.md`
(Phase-4 may exist if needed.)

**Important:** If `task-scaffold.sh` currently writes to `./.codex/tasks/`, it must be updated to target `./tasks/` at repo root.

### 4.3 Templates (mandatory)

Use the templates in `./.codex/tasks/_templates/` as the structure for:
- `./tasks/<task-name>/spec.md`
- `./tasks/<task-name>/phase-<n>.md`
- `./tasks/<task-name>/final-phase.md`

### 4.4 Commands manifest (mandatory)

During toolchain discovery, determine the canonical lint/build/test commands and:
1) record them in `./tasks/<task-name>/spec.md` under “Verification Commands”
2) update `./.codex/codex-commands.md` to pin them for future tasks

## 5) Git workflow standards

- For pulls:
  - Prefer fast-forward-only pulls (`git pull --ff-only`).
  - If conflicts/unmerged paths exist, abort and list them.

- For commits:
  - Use the `git-commit` skill.
  - Review staged diffs using the approved staged diff script.
  - Never commit secrets or real env files.

## 6) Sensitive data and env-file policy

- Never commit real env-like files.
- Allowed exception: `developement.env` is a template/example file and may be committed if repo policy requires it.
- If secrets are found in code/config:
  - replace with env var references
  - ensure env-like patterns remain ignored
  - document required env vars in task spec and/or repo docs

## 7) Definition of done for “expand-task-spec” work

A task is complete only when:
- all required task markdown files exist under `./tasks/<task-name>/`
- each phase gate has passed
- lint/build/tests have been run (or failures recorded as blockers)
- final-phase includes documentation and review closeout
- code review has been performed and issues fixed or explicitly recorded with severity and repro steps
