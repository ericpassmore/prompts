# Goals Extract
- Task name: move-pr-to-mcp
- Iteration: v0
- State: locked

## Goals (1-10, verifiable)

1. Update `codex/skills/land-the-plan/SKILL.md` so Step 6 no longer uses `gh pr create` command invocation and instead directs PR creation/update via GitHub MCP prompt flow.
2. Remove `gh pr` allow rules from `codex/rules/git-safe.rules`.
3. Update `create_commit_and_pr` in `codex/scripts/project-init.sh` to replace `gh` PR command behavior with prompt text directing GitHub MCP usage.
4. Keep all changes surgical and limited to requested files plus required lifecycle artifacts.
5. Re-run stage validators and targeted checks to verify ACAC stage consistency after behavior changes.


## Non-goals (explicit exclusions)

- Implementing real networked PR creation from scripts.
- Refactoring unrelated lifecycle stages, scripts, or rules outside requested scope.


## Success criteria (objective checks)

> Tie each criterion to a goal number when possible.

- [G1] `codex/skills/land-the-plan/SKILL.md` no longer instructs `gh pr create`; it explicitly instructs using GitHub MCP prompt flow for create/update.
- [G2] `codex/rules/git-safe.rules` has no `gh pr` allow entries.
- [G3] `codex/scripts/project-init.sh` `create_commit_and_pr` function no longer runs `gh pr create`; it emits a GitHub MCP prompt/instruction.
- [G4] `git diff` confirms only scoped source files and expected lifecycle artifacts changed.
- [G5] Required stage validators for planning/implementation/revalidation emit success verdicts for this task.

