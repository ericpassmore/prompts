# Phase 3 — Remove Legacy Manifest And Reverify End-To-End

## Objective
Finalize migration by removing `codex/codex-commands.md` and proving lifecycle behavior remains valid under the new canonical files.

## Code areas impacted
- `codex/codex-commands.md` (deletion target)
- `codex/AGENTS.md`
- `codex/tasks/_templates/spec.template.md`
- `codex/tasks/_templates/final-phase.template.md`
- `codex/prompts/expand-task-spec.md`
- `tasks/migrate-to-config-and-project-structure/spec.md`

## Work items
- [x] Remove `codex/codex-commands.md` after all references are migrated.
- [x] Update any residual policy/template wording that still points to `codex-commands.md`.
- [x] Re-run migration scans and stage validators.
- [x] Record final status and remaining risks (if any) in task artifacts.

## Deliverables
- Legacy manifest removed from active repository content.
- Clean reference scan outputs for active lifecycle assets.
- Revalidated task artifacts ready for Stage 4 implementation handoff.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] `codex/codex-commands.md` is no longer present.
- [x] Active codex skill/script assets no longer reference `codex-commands.md`.
- [x] Missing `codex/project-structure.md` path behavior is enforced as abort.

## Verification steps
List exact commands and expected results.
- [x] Command: `test ! -f codex/codex-commands.md`
  - Expected: exits `0`.
- [x] Command: `rg -n "codex-commands\\.md" codex`
  - Expected: no active runtime references; any intentional historical references explicitly documented.
- [x] Command: `./codex/scripts/prepare-phased-impl-validate.sh migrate-to-config-and-project-structure`
  - Expected: prints `READY FOR IMPLEMENTATION`.

## Risks and mitigations
- Risk: hidden dependency on root `./codex-commands.md` created by bootstrap workflows.
- Mitigation: explicitly test bootstrap and downstream scripts against new config paths before removing legacy manifest.
