# Goals Extract
- Task name: git-wrapper-only
- Iteration: v0
- State: ready-for-confirmation

## Goals (1-20, verifiable)

1. Update lifecycle skill and prompt instructions so agent-facing git operations use the approved git wrapper/helper scripts instead of instructing direct raw `git ...` command execution.
2. Preserve legitimate raw git usage inside repository-owned shell helper scripts where those scripts implement the approved wrapper/helper behavior.
3. Correct the `git-commit` environment-file exception spelling from `developement.env` to `development.env` in the `git-commit` skill and supporting helper behavior.
4. Keep the change scope limited to the git wrapper guidance and `development.env` exception correction.
5. Verify the updated instructions and helper behavior with repo/task-approved lint, build, and test command classes, or document explicit blockers if any class is unavailable.


## Non-goals (explicit exclusions)

- Do not redesign the ACAC lifecycle or stage gate contract.
- Do not add unrelated git or GitHub workflows.
- Do not change token handling, GitHub auth routing, or PR creation behavior except where wording must avoid direct raw git instructions.
- Do not alter unrelated task artifacts or historical goal iterations.


## Success criteria (objective checks)

> Tie each criterion to a goal number when possible.

- [G1] Agent-facing skill/prompt text no longer directs users or agents to run raw `git ...` commands where an approved wrapper/helper path should be used.
- [G2] Shell helper scripts that implement git wrapper behavior still perform their internal git operations and continue to fail fast on unsafe states.
- [G3] No `developement.env` references remain in the in-scope current skill/helper surfaces; the allowed example-file exception is spelled `development.env`.
- [G4] The diff is limited to in-scope instruction/helper files and required lifecycle artifacts for this task.
- [G5] Verification records include lint, build, and test outcomes from approved repo/task command records, or explicit blocker documentation for unavailable commands.

