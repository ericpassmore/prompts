# Phase 2 — Wire Landing Flow and Sandbox Rules

## Objective
Integrate the new script into landing stage order and allow its execution via git-safe sandbox rules.

## Code areas impacted
- `codex/skills/land-the-plan/SKILL.md`
- `codex/rules/git-safe.rules`

## Work items
- [x] Insert a new landing step after `git-commit` and before PR creation to run the manifest script.
- [x] Renumber downstream landing steps/gates/constraints to preserve deterministic flow.
- [x] Add trusted helper allow-rules for home/canonical/repo-local script paths.

## Deliverables
- Updated landing skill documentation.
- Updated git-safe rules file.

## Gate (must pass before proceeding)
Phase passes when landing sequence includes the new script between commit and PR, and rules include all required script path variants.
- [x] Skill and rules updates are present and ordered correctly.

## Verification steps
List exact commands and expected results.
- [x] Command: `rg -n "task-manifest-land-update|Step 3 — Update task manifest metadata|Step 4 — Resolve base branch" codex/skills/land-the-plan/SKILL.md`
  - Expected: new step appears after git-commit and before PR section.
- [x] Command: `rg -n "task-manifest-land-update.sh" codex/rules/git-safe.rules`
  - Expected: trusted helper rule entries exist for 3 path variants.

## Risks and mitigations
- Risk: step/gate renumbering drifts and introduces contradictory skill instructions.
- Mitigation: update all downstream references in one edit and verify with targeted grep.
