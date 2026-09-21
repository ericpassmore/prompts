# Goals Extract
- Task name: script-retention-review
- Iteration: v1
- State: locked

## Goals (1-20, verifiable)

1. Inventory all remaining shell scripts and identify their dependencies and purpose.
2. Produce a concise keep/remove recommendation that distinguishes generic Git utilities from removed-harness support.
3. Preserve the approved generic utilities unchanged.
4. Delete only the scripts explicitly approved after this review.


## Non-goals (explicit exclusions)

- Do not refactor or modernize retained scripts in this task.
- Do not delete scripts before the user approves the exact keep/remove set.


## Success criteria (objective checks)

> Tie each criterion to a goal number when possible.

- [G1] Every remaining `*.sh` file is included in the inventory.
- [G2] Each script has a keep/remove recommendation and concise rationale.
- [G3] Retained scripts do not depend on deleted `.codex` lifecycle artifacts.
- [G4] The final deletion set matches the user-approved list exactly.
