# Phase 2 — Add Diagnostic Wrapper and Migrate Callsites

## Objective
Add the manual-only diagnostic wrapper and update repo-owned workflow guidance plus allow rules to use wrapper scripts instead of raw `gh` commands.

## Code areas impacted
- `codex/scripts/gh-auth-check.sh`
- `codex/skills/land-the-plan/SKILL.md`
- `codex/prompts/self-improve-skills.md`
- `codex/rules/git-safe.rules`

## Work items
- [x] Implement `codex/scripts/gh-auth-check.sh` with distinct exit codes for login failure versus create/delete permission failure.
- [x] Update `land-the-plan` CLI fallback guidance to reference `gh-wrap.sh` and `gh-auth-check.sh`.
- [x] Update `self-improve-skills` CLI guidance to reference `gh-wrap.sh issue create`.
- [x] Remove direct raw `gh` allow entries and replace them with wrapper-script allow entries for the approved wrapper command surface.

## Deliverables
- Executable `codex/scripts/gh-auth-check.sh`.
- Updated skill/prompt guidance and wrapper-script rule entries.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] Repo-owned guidance no longer instructs the affected raw `gh` commands directly.
- [x] `git-safe.rules` allows the wrapper scripts instead of the migrated raw `gh` entries.
- [x] Diagnostic wrapper is documented as manual-only.

## Verification steps
List exact commands and expected results.
- [x] Command: `bash -n codex/scripts/gh-auth-check.sh`
  - Expected: exit code `0`. Result: PASS.
- [x] Command: `rg -n "gh-wrap.sh|gh-auth-check.sh|gh pr create|gh issue create" codex/skills/land-the-plan/SKILL.md codex/prompts/self-improve-skills.md codex/rules/git-safe.rules`
  - Expected: wrapper references present; migrated raw `gh` instructions/rules removed from touched surfaces. Result: PASS.
- [x] Command: `./codex/scripts/gh-auth-check.sh --repo example-owner/repo`
  - Expected: mapped-but-unset env returns explicit non-zero auth-block. Result: PASS (exit code `4` with expected auth-block).

## Risks and mitigations
- Risk: rule updates could accidentally broaden command access beyond the requested surface.
- Mitigation: allow only the specific wrapper command patterns requested in issue `#38`.
