#ACAC

Autonomous Coding Agent Contract entrypoint.

Strict trigger: the first non-empty line must be exactly `#ACAC` (case-sensitive).

Use the `acac` skill.

After goals are approved, continue from `GOALS LOCKED` through `implement` and `land-the-plan`. Stop only on `BLOCKED`, `LANDED`, or an explicit user pause.

Inputs:

- Request body after `#ACAC`: `{{USER_REQUEST_AFTER_ACAC}}`
- Optional task name (kebab-case): `{{TASK_NAME_IN_KEBAB_CASE}}`
