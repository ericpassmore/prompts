# Goals Extract
- Task name: auto-worktree-pr
- Iteration: v0
- State: locked

## Goals (0–5, verifiable)

> If ambiguity is blocking, it is valid to have 0 goals.

1. `land-the-plan` defines and enforces detached-`HEAD` landing branch creation using `land-the-plan/<task>/<agent-id>-<timestamp>`.
2. Landing flow explicitly includes `git fetch origin`, local/remote branch collision checks, branch create/switch, commit via `git-commit`, push, PR creation, and PR merge to configured base branch.
3. Supporting scripts/rules are updated so the new flow is executable under repository git-safe policy without bypassing existing safety controls.
4. A regression check against `2c3c9b22755cfcc0e19f76950be63d0c4caedc96..HEAD` confirms secret/binary protections in `git-commit` remain intact (or documents actionable fixes if not).


## Non-goals (explicit exclusions)

- Reworking the full ACAC lifecycle order or verdict taxonomy.
- Refactoring unrelated scripts/skills outside detached-head landing and requested safety checks.


## Success criteria (objective checks)

> Tie each criterion to a goal number when possible.

- [G1] Stage 6 skill text and helper logic resolve a detached-head landing branch with required naming components (`task`, `agent-id`, `timestamp`).
- [G2] Stage 6 procedure documents and/or scripts encode all required git/PR/merge steps in order with fail-fast blockers on collision/invalid state.
- [G3] `git-safe.rules` allowlist includes new required commands/helper paths used by the updated landing flow.
- [G4] Review evidence (diff + script/skill audit) explicitly confirms secret/binary commit protections remain present in `git-commit` workflow.

