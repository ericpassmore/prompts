---
name: land-the-plan
description: Finalize completed work by validating results, committing changes, and preparing a pull request for review.
---

# SKILL: land-the-plan

## Intent

Finalize verified task work into a reviewer-ready pull request, then cleanly release temporary stage resources and provide handoff details.

## Preconditions (hard)

- `implement` has emitted `READY TO LAND`.
- `./tasks/<TASK_NAME_IN_KEBAB_CASE>/` exists.
- Current git state may be a named branch or detached `HEAD`.
- Repository has no unmerged/conflicted paths.
- A remote push target exists for the resolved head branch (required by `git-commit`, manifest update push, and PR creation flow).

If any hard precondition fails, emit `BLOCKED` and stop.

## Rule dependencies

Stage 5 depends on:

- `codex/rules/expand-task-spec.rules`
- `codex/rules/git-safe.rules`

## Required upstream skill (mandatory)

`land-the-plan` MUST run the `git-commit` skill before creating/updating a PR.

## Command resolution

Preferred (from persisted bootstrap reference in `codex-config.yaml`):

```bash
CODEX_ROOT=<CODEX_ROOT> <CODEX_SCRIPTS_DIR>/<script>.sh ...
```

Fallback order:

1. `./.codex/scripts/<script>.sh ...`
2. `./codex/scripts/<script>.sh ...`
3. `$HOME/.codex/scripts/<script>.sh ...`

## Base branch resolution

Resolve PR base branch in this order:

1. `./codex/codex-config.yaml` (repo-local canonical)
2. selected codex root `codex-config.yaml` (from bootstrap metadata)
3. fallback default: `main`

Accept only valid branch tokens (`[A-Za-z0-9._/-]+`).
Ignore placeholder values (for example `<main>`).
If parsing fails, use `main`.

## PR content contract (mandatory)

Use Codex to generate both PR title and PR body.

PR body MUST include these sections:

- `Goals`
- `Non-goals`
- `ADR`
- `Exceptions`
- `Deferred work`

`Deferred work` MUST be populated from real `//TODO` markers in the codebase (or explicitly state none).

## Stage procedure

### Step 0 — Confirm task identity and resolve head branch

- Confirm `<TASK_NAME_IN_KEBAB_CASE>`.
- Resolve the active branch or prepare a detached-head landing branch by running:

```bash
<CODEX_SCRIPTS_DIR>/git-resolve-head-branch-safe.sh <TASK_NAME_IN_KEBAB_CASE> [agent-id] [timestamp]
```

The helper MUST:

- if already on a named branch, print `Resolved head branch: <branch>`
- if in detached `HEAD`, delegate to the landing helper and print `Landing branch prepared: <branch>`
- for detached `HEAD`, fetch latest remote branches internally
- for detached `HEAD`, construct branch name exactly as:
  - `land-the-plan/<TASK_NAME_IN_KEBAB_CASE>/<agent-id>-<timestamp>`
- for detached `HEAD`, verify local branch does not exist
- for detached `HEAD`, verify remote `origin` branch does not exist
- for detached `HEAD`, create the branch and switch to it

On success, set `RESOLVED_HEAD_BRANCH` to the branch reported by the helper.
If any check fails, emit `BLOCKED`.

### Step 1 — Enforce `READY TO LAND` hard gate

Run:

```bash
<CODEX_SCRIPTS_DIR>/implement-validate.sh <TASK_NAME_IN_KEBAB_CASE>
```

Proceed only if output is exactly:

`READY TO LAND`

Otherwise emit `BLOCKED`.

### Step 1A — Enforce code-review readiness gate

Run:

```bash
<CODEX_SCRIPTS_DIR>/revalidate-code-review.sh <TASK_NAME_IN_KEBAB_CASE> [base-branch]
```

Proceed only when:

- review script result is `READY`
- review verdict is `patch is correct`
- findings status is `none`, or explicit risk acceptance exists at `./tasks/<TASK_NAME_IN_KEBAB_CASE>/risk-acceptance.md`

Otherwise emit `BLOCKED`.

### Step 2 — Execute `git-commit` skill (mandatory)

Run the `git-commit` skill workflow completely on `RESOLVED_HEAD_BRANCH`:

- branch/update safety checks
- secure file tracking policy
- staged diff review (text only)
- commit message generation
- commit creation
- push to `origin/<RESOLVED_HEAD_BRANCH>`

If upstream push is required with `-u`, use:

```bash
<CODEX_SCRIPTS_DIR>/git-push-branch-safe.sh <RESOLVED_HEAD_BRANCH>
```

Run this upstream setup before the `git-commit` preflight step when the resolved named branch has no upstream. Do not wait for commit preflight to discover the no-upstream condition late in landing.

If `git-commit` fails, emit `BLOCKED`.

### Step 3 — Update task manifest metadata and compact task artifacts

Run:

```bash
<CODEX_SCRIPTS_DIR>/task-manifest-land-update.sh <TASK_NAME_IN_KEBAB_CASE>
```

This helper MUST:

- update `goals/task-manifest.csv` for `<TASK_NAME_IN_KEBAB_CASE>`:
  - `first_create_hhmmss` to current UTC `HHMMSS`
  - `first_create_git_hash` to current `HEAD` hash at script start
- run `task-artifacts-compact.sh` for `<TASK_NAME_IN_KEBAB_CASE>` during Stage 5 and enforce compact retention:
  - preserve exactly one locked `goals.vN.md` file under `goals/<task>/` and keep it unmodified
  - preserve exactly one task spec file: `tasks/<task>/spec.md`
  - preserve risk-acceptance evidence files when present (for example `tasks/<task>/risk-acceptance.md`)
  - create/update `tasks/<task>/audit-log.md`
  - create/update compact retention outputs:
    - `tasks/<task>/retention.min.json`
    - `tasks/<task>/goal-versions.diff` when multiple goal versions (`goals.v0.md` through `goals.vN.md`) exist before compaction
  - remove redundant files under `goals/<task>/` and `tasks/<task>/`
- commit manifest and compacted task/goal artifacts together
- push manifest update to remote when a new manifest commit is created

If manifest update/compaction/commit/push fails, emit `BLOCKED`.

### Step 4 — Resolve base branch for PR

Resolve base branch using the **Base branch resolution** rules in this skill.
If a valid configured value is missing, fallback to `main`.

### Step 5 — Build PR input context

Collect required context from task artifacts and code:

- Goals and Non-goals: `./tasks/<TASK_NAME_IN_KEBAB_CASE>/spec.md`
- ADR decisions:
  - referenced or newly added ADR documents
  - if no ADR applies, state `None`
- Exceptions:
  - blockers/deviations recorded in retained task artifacts (for example `audit-log.md` and review notes)
- Deferred work:
  - discover real `//TODO` markers in changed files
  - include file references and short rationale where present

### Step 6 — Generate PR title and body with Codex

Generate:

- PR title: concise, imperative, specific to delivered behavior
- PR body: include all required sections from the **PR content contract**

Do not omit sections; use explicit `None` when a section has no entries.

### Step 7 — Create or update the PR (wrapper CLI only)

Use the repository GitHub CLI wrapper only. Do not use the Codex MCP GitHub service.

First detect whether a PR already exists for the resolved head branch:

```bash
./codex/scripts/gh-wrap.sh pr view <RESOLVED_HEAD_BRANCH> --json number,url
```

If `gh-wrap.sh pr view` finds an existing PR, update it with:

```bash
./codex/scripts/gh-wrap.sh pr edit <PR_NUMBER> --title "<PR_TITLE>" --body "<PR_BODY>"
```

If no PR exists for the head branch, create one with:

```bash
./codex/scripts/gh-wrap.sh pr create --base <BASE_BRANCH> --head <RESOLVED_HEAD_BRANCH> --title "<PR_TITLE>" --body "<PR_BODY>"
```

If the wrapper reports an auth-block, suggest `./codex/scripts/gh-auth-check.sh [--repo owner/name]` for manual diagnosis; do not run it automatically.
If sandbox/network restrictions block the wrapper command, rerun the needed wrapper command with elevated permissions.
On wrapper success, record PR URL/number and continue to Step 8.

If wrapper PR create/update fails:

- emit `BLOCKED`
- include the wrapper failure summary
- suggest manual PR creation URL:
  - `https://github.com/<OWNER>/<REPO>/pull/new/<RESOLVED_HEAD_BRANCH>`

### Step 8 — Release held resources

Release all temporary stage resources:

- remove transient files created for PR composition

After release:

- stop modifying task/code files for this stage
- provide handoff-ready landing details only

### Step 9 — Emit final verdict

Emit exactly one verdict:

- `LANDED`
- `BLOCKED`

`LANDED` is allowed only when:

- `READY TO LAND` precondition passed
- code-review readiness gate passed
- head branch resolution helper passed
- `git-commit` completed successfully
- task manifest metadata update completed successfully
- branch push succeeded
- PR exists and is reviewer-ready
- temporary stage resources were released

## Stage gates

All gates must pass:

- Gate 1: `implement-validate.sh` returns `READY TO LAND`.
- Gate 1A: `revalidate-code-review.sh` returns `READY`, verdict is `patch is correct`, and findings are closed or explicitly risk-accepted.
- Gate 2: head branch resolution helper passes, including detached-head branch prep checks when applicable.
- Gate 3: `git-commit` skill completed (including push).
- Gate 4: `task-manifest-land-update.sh` completed (manifest update + compaction + commit + required push behavior).
- Gate 4A: compact retention outputs exist and satisfy policy:
  - one retained locked goal file in `goals/<task>/`
  - one retained spec file in `tasks/<task>/spec.md`
  - if present, risk-acceptance evidence remains retained
  - `tasks/<task>/audit-log.md`
  - `tasks/<task>/retention.min.json`
  - if multiple goal versions existed pre-compaction: `tasks/<task>/goal-versions.diff`; otherwise no diff file
- Gate 5: base branch resolved from `codex-config.yaml` or fallback `main`.
- Gate 6: PR title/body generated by Codex.
- Gate 7: PR body contains `Goals`, `Non-goals`, `ADR`, `Exceptions`, `Deferred work`.
- Gate 8: deferred work section reflects actual `//TODO` markers (or explicit none).
- Gate 9: Codex MCP GitHub service is not used.
- Gate 9A: wrapper lookup checks whether a PR already exists for the resolved head branch.
- Gate 9B: PR is created/updated successfully by `gh-wrap.sh`; otherwise stage is `BLOCKED` and manual PR URL is provided.
- Gate 10: held resources released.
- Gate 11: terminal verdict emitted (`LANDED` or `BLOCKED`).

## Constraints

- Do not run `land-the-plan` unless `READY TO LAND` is satisfied.
- Do not bypass the `git-commit` skill.
- Do not skip `task-manifest-land-update.sh` between commit and PR creation.
- Do not bypass task artifact compaction in Stage 5.
- Do not modify the retained goal file content during compaction.
- Do not bypass the head branch resolution helper.
- Do not run raw branch push commands; use `git-push-branch-safe.sh`.
- Do not use the Codex MCP GitHub service.
- Do not use raw `gh pr create`; use `gh-wrap.sh`.
- Do not create a duplicate PR when one already exists for the resolved head branch; reuse or update it instead.
- Do not invent TODO items; only include observed `//TODO`.
- Do not skip required PR body sections.

## Required outputs

- terminal stage verdict: `LANDED` or `BLOCKED`
- resolved base branch used for the PR
- resolved head branch used for push/PR
- manifest update summary (`first_create_hhmmss`, `first_create_git_hash`, and manifest commit hash)
- compaction summary:
  - retained goal file path
  - retained spec file path
  - audit log path
  - goal-versions diff path when present
  - removed artifacts count under `goals/<task>/` and `tasks/<task>/`
- PR URL
- PR creation method used (`gh-wrap.sh pr view`/`gh-wrap.sh pr edit`/`gh-wrap.sh pr create`)
- generated PR title
- generated PR body containing:
  - goals
  - non-goals
  - ADR
  - exceptions
  - deferred work (`//TODO`)
- explicit release summary for held resources
- when `BLOCKED` in Step 7: wrapper error summary and manual PR create URL
