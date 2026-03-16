# Phase 2 — Goals Parsing Fix

## Objective
Make the establish-goals extraction and validation scripts compatible with the scaffolded section-header format so populated content is preserved without manual normalization.

## Code areas impacted
- `codex/scripts/goals-extract.sh`
- `codex/scripts/goals-validate.sh`
- `tasks/fix-open-prompts-issues/phase-2.md`

## Work items
- [x] Replace exact-range parsing that drops qualified section headers with heading-aware section extraction.
- [x] Update validation counting so it reads the normalized extract reliably after the parsing change.
- [x] Add verification evidence using a scaffold-compatible goals artifact.

## Deliverables
- Updated `goals-extract.sh` and `goals-validate.sh`.
- Proof that populated scaffold-style sections survive extraction and validate successfully.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] A scaffold-compatible establish-goals file extracts populated sections into `goals.vN.md`, and validation passes without manual header renaming.

## Verification steps
List exact commands and expected results.
- [x] Command: `./codex/scripts/goals-extract.sh fix-open-prompts-issues v0`
  - Expected: writes `goals/fix-open-prompts-issues/goals.v0.md` with populated `Goals`, `Non-goals`, and `Success criteria` sections.
- [x] Command: `./codex/scripts/goals-validate.sh fix-open-prompts-issues v0`
  - Expected: prints `GOALS LOCKED`.

## Risks and mitigations
- Risk: section matching could overrun into later headings.
- Mitigation: stop extraction/counting at the next `## ` heading that is not the current section.
