# Phase 2 — Correct Environment Exception Behavior

## Objective
Standardize the allowed example environment file exception from `developement.env` to `development.env` in the `git-commit` skill and supporting helper behavior.

## Code areas impacted
- `codex/skills/git-commit/SKILL.md`
- `codex/scripts/git-track-safe-untracked.sh`

## Work items
- [x] Replace misspelled `developement.env` references in current in-scope `git-commit` guidance.
- [x] Update helper exception matching so `development.env` is the preserved example file.
- [x] Preserve the broader env-like exclusion behavior for all other environment-like files.
- [x] Do not add support for both spellings unless verification shows compatibility requires it and the locked goals are still satisfied.

## Deliverables
- `git-commit` guidance and helper behavior consistently use `development.env`.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] No `developement.env` reference remains in the in-scope current skill/helper surfaces.
- [x] The helper script remains syntactically valid.

## Verification steps
List exact commands and expected results.
- [x] Command: `bash -n codex/scripts/git-track-safe-untracked.sh`
  - Expected: exits 0.
  - Evidence: PASS.
- [x] Command: `rg -n "developement\\.env" codex/skills/git-commit/SKILL.md codex/scripts/git-track-safe-untracked.sh`
  - Expected: no matches.
  - Evidence: PASS, command exited 1 with no output.
- [x] Command: `rg -n "development\\.env" codex/skills/git-commit/SKILL.md codex/scripts/git-track-safe-untracked.sh`
  - Expected: intended exception references are present.
  - Evidence: PASS, intended references found in skill and helper.

## Risks and mitigations
- Risk: Existing local files may still use the historical misspelling.
- Mitigation: Treat historical files as out of scope and standardize the current helper/skill behavior to the locked goal.
