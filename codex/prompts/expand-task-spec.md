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
1) Discover toolchain and verification commands; update `./.codex/codex-commands.md`.
2) Scaffold `./tasks/<TASK_NAME_IN_KEBAB_CASE>/` using `./.codex/scripts/task-scaffold.sh <task-name>`.
3) Ask clarifying questions if needed.
4) Write `./tasks/<TASK_NAME_IN_KEBAB_CASE>/spec.md` using the template from `./.codex/tasks/_templates/spec.template.md`.
5) Write phased plans in `./tasks/<TASK_NAME_IN_KEBAB_CASE>/phase-1.md` … `./tasks/<TASK_NAME_IN_KEBAB_CASE>/phase-3.md` and `./tasks/<TASK_NAME_IN_KEBAB_CASE>/final-phase.md`.
6) Execute work phase-by-phase, honoring gates.
7) Run lint/build/tests (using the pinned commands).
8) Perform code review and surface issues.
