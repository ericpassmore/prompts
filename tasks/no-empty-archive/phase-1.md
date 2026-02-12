# Phase 1 — Implement Deterministic Template-Comparison Archive Guard

## Objective
Update `prepare-phased-impl-archive.sh` so template-only `phase-1.md` and `phase-2.md` are treated as non-artifacts and do not trigger archive when `phase-plan.md` is absent.

## Code areas impacted
- `codex/scripts/prepare-phased-impl-archive.sh`

## Work items
- [x] Add a deterministic helper that renders expected template baselines and compares current files against those baselines.
- [x] Update archive precondition logic to no-op when all current phase files are template-equivalent and `phase-plan.md` is absent.
- [x] Preserve current archive behavior for substantive phase changes and existing `phase-plan.md`.
- [x] Keep fail-fast behavior for missing template resolution errors.

## Deliverables
- Updated archive script implementing the template-comparison guard.
- Script output message explaining no-op behavior for template-only phase files.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] Guard uses template-content comparison (no mutable tags).
- [x] With template-only `phase-1.md` and `phase-2.md`, archive exits no-op.
- [x] With substantive phase content, archive still archives as before.

## Verification steps
List exact commands and expected results.
- [x] Command: `./codex/scripts/prepare-phased-impl-archive.sh no-empty-archive`
  - Expected: with untouched template-only phase files and no `phase-plan.md`, prints no-op message and creates no archive directory.
  - Result: PASS (observed no-op message and archive directory list unchanged)
- [x] Command: `./codex/scripts/prepare-phased-impl-archive.sh no-empty-archive`
  - Expected: with substantive phase artifacts (`phase-plan.md` present), archive runs and creates a new archive directory.
  - Result: PASS (created `tasks/no-empty-archive/archive/prepare-phased-impl-9514b87-1` and `prepare-phased-impl-9514b87-2`)

## Risks and mitigations
- Risk: strict textual comparison may treat harmless formatting edits as substantive.
- Mitigation: this deterministic bias is intentional and acceptable for fail-fast archive gating.
