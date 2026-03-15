# Phase 2 — Verify And Review Against Principles

## Objective
Validate the `codex/AGENTS.md` wording, record repository-standard verification evidence, and complete a principles alignment review against `codex/principles.md`.

## Code areas impacted
- `tasks/hook-self-improvement/final-phase.md`
- `codex/principles.md`
- `codex/AGENTS.md`

## Work items
- [x] Review the final `codex/AGENTS.md` wording against each principle in `codex/principles.md`.
- [x] Record `not-configured` lint/build/test command-class evidence plus targeted checks in `final-phase.md`.
- [x] Confirm there is no scope drift relative to the locked `IN SCOPE` and `OUT OF SCOPE` sections.

## Deliverables
- Completed Stage 4 closeout entries in `tasks/hook-self-improvement/final-phase.md`.
- Short principles review captured in the final handoff and `final-phase.md`.

## Gate (must pass before proceeding)
Phase 2 passes only when verification evidence is recorded truthfully and the principles review concludes the wording does not introduce drift.
- [x] `final-phase.md` contains complete verification and principles-review evidence for Goals 3-4.

## Verification steps
List exact commands and expected results.
- [x] Command: `./codex/scripts/prepare-phased-impl-validate.sh hook-self-improvement`
  - Expected: `READY FOR IMPLEMENTATION` after phase planning is complete.
- [x] Command: `./codex/scripts/implement-validate.sh hook-self-improvement`
  - Expected: `READY TO LAND` after Stage 4 evidence is complete.

## Risks and mitigations
- Risk: Stage 4 evidence might imply stronger automated verification than this repository actually supports.
- Mitigation: use the repository-standard `not-configured` PASS entries and keep additional checks targeted to the changed contract file.
