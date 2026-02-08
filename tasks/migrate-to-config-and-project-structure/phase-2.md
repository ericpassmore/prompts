# Phase 2 — Migrate Skills And Scripts To New Canonical Sources

## Objective
Update all affected skills and scripts to stop using `codex-commands.md` and use `codex/codex-config.yaml` or `codex/project-structure.md` based on mapping rules.

## Code areas impacted
- `codex/skills/prepare-takeoff/SKILL.md`
- `codex/skills/prepare-phased-impl/SKILL.md`
- `codex/skills/implement/SKILL.md`
- `codex/skills/revalidate/SKILL.md`
- `codex/skills/land-the-plan/SKILL.md`
- `codex/skills/code-review/SKILL.md`
- `codex/scripts/read-codex-paths.sh`
- `codex/scripts/prepare-takeoff-bootstrap.sh`
- `codex/scripts/revalidate-code-review.sh`
- `codex/scripts/resolve-codex-root.sh`

## Work items
- [x] Migrate skill documentation references from `codex-commands.md` to new canonical files.
- [x] Migrate script path/config parsing from `codex-commands.md` to `codex/codex-config.yaml` and/or `codex/project-structure.md`.
- [x] Add fail-fast runtime guard to scripts/entrypoints:
  - if `codex/project-structure.md` missing, abort immediately.
- [x] Update coupled templates/prompts/docs that instruct users to use `codex-commands.md`.
- [x] Preserve fallback root resolution order (`./.codex`, `./codex`, `$HOME/.codex`) where behavior currently depends on it.

## Deliverables
- Updated skills and scripts with no active dependency on `codex-commands.md`.
- Enforced abort behavior for missing `codex/project-structure.md`.
- Updated auxiliary docs/templates/prompts aligned with migration.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] All targeted skills/scripts are updated and internally consistent.
- [x] Missing `codex/project-structure.md` guard exists in required execution surfaces.
- [x] No direct `codex-commands.md` references remain in active lifecycle scripts/skills.

## Verification steps
List exact commands and expected results.
- [x] Command: `rg -n "codex-commands\\.md" codex/skills codex/scripts`
  - Expected: no matches, or only intentional historical comments explicitly marked deprecated.
- [x] Command: `test -f codex/project-structure.md`
  - Expected: exits `0`.
- [x] Command: `test -f codex/codex-config.yaml`
  - Expected: exits `0`.

## Risks and mitigations
- Risk: behavior drift if scripts previously depended on fields that are not represented in new files.
- Mitigation: document key mapping decisions in spec and keep validation checks explicit.
