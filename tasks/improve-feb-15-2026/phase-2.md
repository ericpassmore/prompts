# Phase 2 — Governance Alignment and Trimming

## Objective
Apply principles-consistent documentation and skill updates that remove contradictions and reduce redundant instruction text while preserving lifecycle behavior.

## Code areas impacted
- `codex/AGENTS.md`
- `codex/skills/establish-goals/SKILL.md`
- `codex/skills/revalidate/SKILL.md`

## Work items
- [x] Add/refresh principle traceability language in `codex/AGENTS.md` to make consistency explicit.
- [x] Fix `1-10` vs `1-20` mismatch in establish-goals success conditions.
- [x] Fix incorrect section reference in revalidate skill and trim redundant wording where safe.
- [x] Add clear note that this repository uses `./codex`, while preserving `./.codex` and `$HOME/.codex` fallback behavior.

## Deliverables
- Updated governance/skill docs with unchanged stage order and verdict vocabulary.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] Contract keywords (`GOALS LOCKED`, `READY FOR PLANNING`, `READY FOR IMPLEMENTATION`, `READY FOR REVERIFICATION`, `READY TO REPLAN`, `READY TO LAND`, `LANDED`, `BLOCKED`) remain unchanged and present.

## Verification steps
List exact commands and expected results.
- [x] Command: `rg -n "goals exist \(1-10\)|Section 8|GOALS LOCKED|READY FOR PLANNING|READY FOR IMPLEMENTATION|READY FOR REVERIFICATION|READY TO REPLAN|READY TO LAND|LANDED|BLOCKED" codex/AGENTS.md codex/skills/**/SKILL.md`
  - Expected: no stale mismatch references; stage/verdict vocabulary preserved.
  - Result: PASS (`goals exist (1-10)` removed; stale `Section 8` reference removed; required verdict vocabulary preserved).

## Risks and mitigations
- Risk: Trimming text could weaken hard-gate clarity.
- Mitigation: Keep normative MUST/STOP/BLOCKED requirements and only remove duplication.
