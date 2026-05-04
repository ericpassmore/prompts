# Phase 8 — Documentation Alignment and Full Validation

## Objective

Align lifecycle documentation with implemented behavior, run required validation, and prepare the task for Stage 5 landing.

## Code areas impacted
- `codex/AGENTS.md`
- `codex/project-structure.md`
- `codex/codex-config.yaml`
- `codex/skills/*/SKILL.md`
- `codex/prompts/*`
- `tasks/may-self-improvements/*`

## Work items
- [ ] Update skill and prompt guidance to match script behavior changed in phases 2-7.
- [ ] Record verification results against each acceptance criterion in task artifacts.
- [ ] Run mandatory command classes or document `not-configured` blockers explicitly.
- [ ] Run Stage 4 validation and prepare closeout notes.

## Deliverables
- Documentation and scripts agree on lifecycle behavior.
- Acceptance criteria are updated with verification evidence.
- Stage 4 can emit `READY TO LAND`.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [ ] All G1-G7 acceptance criteria have pass evidence or explicit blockers.
- [ ] `lint`, `build`, and `test` command classes are accounted for.
- [ ] `./codex/scripts/implement-validate.sh may-self-improvements` passes before Stage 5.

## Verification steps
List exact commands and expected results.
- [ ] Command: `./codex/scripts/prepare-takeoff-bootstrap.sh`
  - Expected: exits 0.
- [ ] Command: `./codex/scripts/prepare-phased-impl-validate.sh may-self-improvements`
  - Expected: exits 0 with `READY FOR IMPLEMENTATION` during Stage 3 and remains valid after planning.
- [ ] Command: `./codex/scripts/implement-validate.sh may-self-improvements`
  - Expected: exits 0 with `READY TO LAND` after Stage 4 implementation artifacts are complete.

## Risks and mitigations
- Risk: documentation drift between local repo assets and installed `$HOME/.codex` assets.
- Mitigation: keep this task scoped to repo-local assets and document any sync follow-up separately.
