# Phase 1 — Replace GH PR Flow with MCP Prompt Contracts

## Objective
Update lifecycle/script behavior to remove direct `gh pr create` execution paths and replace them with explicit GitHub MCP prompt-driven handoff.

## Code areas impacted
- `codex/skills/land-the-plan/SKILL.md`
- `codex/scripts/project-init.sh`

## Work items
- [x] Update `land-the-plan` Step 6 and related gates/outputs so PR create/update is performed via GitHub MCP prompt flow, not `gh pr create`.
- [x] Update `create_commit_and_pr` in `project-init.sh` to output PR title/body plus MCP handoff instructions.
- [x] Remove obsolete `gh` runtime requirement from `project-init.sh`.

## Deliverables
- Updated landing skill procedure text and gates for MCP PR handoff.
- Updated `project-init.sh` PR handoff behavior and command requirements.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] `rg` confirms no `gh pr create` execution instructions remain in touched files.
- [x] `bash -n codex/scripts/project-init.sh` passes.

## Verification steps
List exact commands and expected results.
- [x] Command: `rg -n "gh pr create|GitHub MCP|create or update the PR" codex/skills/land-the-plan/SKILL.md codex/scripts/project-init.sh`
  - Expected: `land-the-plan` and `project-init.sh` show MCP prompt flow and no executable `gh pr create` call path.
- [x] Command: `bash -n codex/scripts/project-init.sh`
  - Expected: exit code `0`.

## Risks and mitigations
- Risk: Prompt-only PR flow might be less deterministic for automation.
- Mitigation: Keep prompt language explicit (base/head/title/body and expected MCP action).
