# Phase 1 — Define Canonical Files And Migration Inventory

## Objective
Define the canonical replacement contract and produce a complete inventory of all `codex-commands.md` references across skills/scripts and directly coupled artifacts.

## Code areas impacted
- `codex/project-structure.md`
- `codex/codex-config.yaml`
- `codex/AGENTS.md`
- `codex/tasks/_templates/spec.template.md`
- `codex/tasks/_templates/final-phase.template.md`
- `codex/prompts/expand-task-spec.md`

## Work items
- [x] Define exact required locations for new canonical files:
  - `codex/project-structure.md`
  - `codex/codex-config.yaml`
- [x] Define minimum required `codex/codex-config.yaml` semantic content for Code Review + Notes.
- [x] Define required `codex/project-structure.md` format (repository-specific structure document matching existing format family).
- [x] Produce a full migration inventory of every skill and script currently referencing `codex-commands.md`.
- [x] Document mapping rules for when references must target `codex/codex-config.yaml` vs `codex/project-structure.md`.

## Deliverables
- Completed specification (`spec.md`) sections for goals, current/proposed behavior, and mapping contract.
- Complete migration inventory list for all impacted skills and scripts.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] Inventory includes every direct skill/script reference to `codex-commands.md`.
- [x] Canonical file locations and semantics are fully specified.
- [x] No unresolved ambiguity remains for replacement mapping.

## Verification steps
List exact commands and expected results.
- [x] Command: `rg -n "codex-commands\\.md" codex/skills codex/scripts`
  - Expected: complete baseline reference list captured in spec for migration.
- [x] Command: `test -f tasks/migrate-to-config-and-project-structure/spec.md`
  - Expected: exits `0`.

## Risks and mitigations
- Risk: missing one or more reference sites creates partial migration and regressions.
- Mitigation: enforce full inventory from `rg` output as an explicit gate.
