---
description: expand task into spec + phased plan + implementation
---

# Expand task into spec + phased plan + implementation

Use the `expand-task-spec` skill.

## Task name
<TASK_NAME_IN_KEBAB_CASE>

## Change request
<PASTE_SHORT_LIST_OF_MODIFICATIONS_HERE>

## Constraints (optional)
- Compatibility:
- Performance:
- Security/privacy:
- Rollout:
- Out of scope:

## Instructions

0) **Initial setup**
   - Check whether `/codex-commands.md` exists at the root of the local repository.
   - If it does not exist:
     - Copy `/Users/eric/.codex/codex-commands.md` to `/codex-commands.md`.
     - Update `/codex-commands.md` to reflect the local repository’s toolchain, scripts, and rules.

1) **Task scaffold (handles all directory scenarios)**
   - Create/verify the task directory and required task files by running:
     - `./.codex/scripts/task-scaffold.sh <TASK_NAME_IN_KEBAB_CASE>`
   - The scaffold step must be non-destructive (must not overwrite existing task files).
   - The scaffold step must materialize templates by stripping `.template` from filenames (e.g., `spec.template.md` → `spec.md`).

2) Ask clarifying questions if required before proceeding.

3) Write `./tasks/<TASK_NAME_IN_KEBAB_CASE>/spec.md` using the scaffolded file as a starting point.

4) Write phased plans in:
   - `./tasks/<TASK_NAME_IN_KEBAB_CASE>/phase-1.md`
   - `./tasks/<TASK_NAME_IN_KEBAB_CASE>/phase-2.md`
   - `./tasks/<TASK_NAME_IN_KEBAB_CASE>/phase-3.md`
   - `./tasks/<TASK_NAME_IN_KEBAB_CASE>/final-phase.md`

5) Execute work phase-by-phase, honoring defined gates and acceptance criteria.

6) Run lint, build, and tests using the pinned commands in `/codex-commands.md`.

7) Perform a code review and surface issues, risks, and follow-up recommendations.
