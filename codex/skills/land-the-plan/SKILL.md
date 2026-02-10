---
name: land-the-plan
description: Finalize completed work by validating results, committing changes, and preparing a pull request for review.
---

# SKILL: land-the-plan

## Intent

Finalize verified task work into a reviewer-ready pull request, then cleanly release temporary stage resources and provide handoff details.

## Preconditions (hard)

- `revalidate` has emitted `READY TO LAND`.
- `./tasks/<TASK_NAME_IN_KEBAB_CASE>/` exists.
- Current git state may be a named branch or detached `HEAD`.
- Repository has no unmerged/conflicted paths.
- A remote push target exists for the resolved head branch (required by `git-commit` and PR creation flow).

If any hard precondition fails, emit `BLOCKED` and stop.

## Rule dependencies

Stage 6 depends on:

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
- Resolve active branch via `git branch --show-current`.
- If active branch is present, use it as `RESOLVED_HEAD_BRANCH`.
- If active branch is empty (detached `HEAD`), run:

```bash
<CODEX_SCRIPTS_DIR>/git-land-branch-safe.sh <TASK_NAME_IN_KEBAB_CASE> [agent-id] [timestamp]
```

Detached-head branch requirements (mandatory):

- run `git fetch origin --prune` (latest remote branches)
- construct branch name exactly as:
  - `land-the-plan/<TASK_NAME_IN_KEBAB_CASE>/<agent-id>-<timestamp>`
- verify local branch does not exist
- verify remote `origin` branch does not exist
- create branch and switch to it

On success, set `RESOLVED_HEAD_BRANCH` to the created branch.
If any check fails, emit `BLOCKED`.

### Step 1 — Enforce `READY TO LAND` hard gate

Run:

```bash
<CODEX_SCRIPTS_DIR>/revalidate-validate.sh <TASK_NAME_IN_KEBAB_CASE> [base-branch]
```

Proceed only if output is exactly:

`READY TO LAND`

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

If `git-commit` fails, emit `BLOCKED`.

### Step 3 — Resolve base branch for PR

Resolve base branch using the **Base branch resolution** rules in this skill.
If a valid configured value is missing, fallback to `main`.

### Step 4 — Build PR input context

Collect required context from task artifacts and code:

- Goals and Non-goals: `./tasks/<TASK_NAME_IN_KEBAB_CASE>/spec.md`
- ADR decisions:
  - referenced or newly added ADR documents
  - if no ADR applies, state `None`
- Exceptions:
  - blockers/deviations recorded in task artifacts (for example `final-phase.md`, `revalidate.md`, review notes)
- Deferred work:
  - discover real `//TODO` markers in changed files
  - include file references and short rationale where present

### Step 5 — Generate PR title and body with Codex

Generate:

- PR title: concise, imperative, specific to delivered behavior
- PR body: include all required sections from the **PR content contract**

Do not omit sections; use explicit `None` when a section has no entries.

### Step 6 — Create or update the PR

Create PR against resolved base branch:

```bash
gh pr create --base <BASE_BRANCH> --head <RESOLVED_HEAD_BRANCH> --title "<PR_TITLE>" --body-file <PR_BODY_FILE>
```

If a PR for the head branch already exists, update it instead of creating a duplicate.
Record the PR URL/number for handoff.

### Step 7 — Release held resources

Release all temporary stage resources:

- remove transient files created for PR composition

After release:

- stop modifying task/code files for this stage
- provide handoff-ready landing details only

### Step 8 — Emit final verdict

Emit exactly one verdict:

- `LANDED`
- `BLOCKED`

`LANDED` is allowed only when:

- `READY TO LAND` precondition passed
- detached-head branch preparation checks passed (when applicable)
- `git-commit` completed successfully
- branch push succeeded
- PR exists and is reviewer-ready
- temporary stage resources were released

## Stage gates

All gates must pass:

- Gate 1: `revalidate-validate.sh` returns `READY TO LAND`.
- Gate 1A: no open review findings; review verdict is `patch is correct` (or explicit risk-acceptance waiver is present).
- Gate 2: detached-head branch prep checks pass (fetch + name + non-existence + create/switch) when in detached `HEAD`.
- Gate 3: `git-commit` skill completed (including push).
- Gate 4: base branch resolved from `codex-config.yaml` or fallback `main`.
- Gate 5: PR title/body generated by Codex.
- Gate 6: PR body contains `Goals`, `Non-goals`, `ADR`, `Exceptions`, `Deferred work`.
- Gate 7: deferred work section reflects actual `//TODO` markers (or explicit none).
- Gate 8: PR created/updated successfully.
- Gate 9: held resources released.
- Gate 10: terminal verdict emitted (`LANDED` or `BLOCKED`).

## Constraints

- Do not run `land-the-plan` unless `READY TO LAND` is satisfied.
- Do not bypass the `git-commit` skill.
- Do not bypass detached-head branch prep checks when starting from detached `HEAD`.
- Do not run raw `git push -u origin <branch>`; use `git-push-branch-safe.sh`.
- Do not invent TODO items; only include observed `//TODO`.
- Do not skip required PR body sections.

## Required outputs

- terminal stage verdict: `LANDED` or `BLOCKED`
- resolved base branch used for the PR
- resolved head branch used for push/PR
- PR URL
- generated PR title
- generated PR body containing:
  - goals
  - non-goals
  - ADR
  - exceptions
  - deferred work (`//TODO`)
- explicit release summary for held resources
