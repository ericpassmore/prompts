#ACAC

Autonomous Coding Agent Contract entrypoint.

Strict trigger: the first non-empty line must be exactly `#ACAC` (case-sensitive).

Use the `acac` skill.

After goals are approved, successful intermediate stage verdicts are continuation gates. Do not stop after `READY FOR PLANNING`, `READY FOR IMPLEMENTATION`, or `READY TO LAND` unless a stage emits `BLOCKED` or the user explicitly pauses the run.

Inputs:

- Request body after `#ACAC`: `{{USER_REQUEST_AFTER_ACAC}}`
- Optional task name (kebab-case): `{{TASK_NAME_IN_KEBAB_CASE}}`
