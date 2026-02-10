# Phase 2 — Update Landing Skill and Git-Safe Policy

## Objective
Align Stage 6 skill/rules with the detached-head landing branch workflow, including PR merge to configured base branch.

## Code areas impacted
- `codex/skills/land-the-plan/SKILL.md`
- `codex/skills/git-commit/SKILL.md`
- `codex/rules/git-safe.rules`

## Work items
- [x] Update Stage 6 procedure with required branch naming and creation sequence.
- [x] Add PR merge requirement after PR creation/update.
- [x] Align git-safe allowlist for new helper/commands used by Stage 6.

## Deliverables
- Updated Stage 6 skill with deterministic detached-head branch flow.
- Updated `git-commit` skill guidance for landing-branch preflight behavior.
- Updated git-safe rules for required Stage 6 commands.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] Stage 6 documents all required steps from fetch through merge.
- [x] Base-branch merge target is sourced from `codex-config.yaml` resolution rules.
- [x] Rule allowlist includes new Stage 6 helper and PR merge command.

## Verification steps
List exact commands and expected results.
- [x] Command: `rg -n "land-the-plan/<TASK_NAME_IN_KEBAB_CASE>/<agent-id>-<timestamp>|git fetch origin|gh pr merge" codex/skills/land-the-plan/SKILL.md`
  - Expected: Stage 6 flow explicitly includes branch-prepare and merge steps.
  - Result: PASS
- [x] Command: `rg -n "git-land-branch-safe.sh|gh pr merge|git fetch origin" codex/rules/git-safe.rules`
  - Expected: policy entries exist for new Stage 6 commands/helpers.
  - Result: PASS

## Risks and mitigations
- Risk: Stage text/rules drift can make documented commands unexecutable.
- Mitigation: Skill text and rules were updated together and verified with targeted checks.
