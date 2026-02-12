# Goals Extract
- Task name: no-empty-archive
- Iteration: v0
- State: ready-for-confirmation

## Goals

1. Update Stage 3 archive detection so template-only `phase-1.md` and `phase-2.md` do not count as archive-worthy artifacts.
2. Implement the deterministic solution using file-content comparison against expected template-rendered phase files.
3. Preserve current archive behavior when phase files contain substantive user planning content or when other Stage 3 artifacts (`phase-plan.md`) are present.
4. Add or update verification evidence to demonstrate the archive script skips empty/template-only phase files and still archives real artifacts.


## Non-goals (explicit exclusions)

- Introducing a new per-file state tag protocol (`INIT`/updated marker).
- Changing ACAC lifecycle verdict contracts, stage ordering, or unrelated Stage 3 planning behavior.


## Success criteria (objective checks)

> Tie each criterion to a goal number when possible.

- [G1] Running archive logic with only template-equivalent `phase-1.md` and `phase-2.md` does not create an archive directory and does not move files.
- [G2] Archive eligibility check is based on deterministic comparison to template-derived expected content, not manual status tags.
- [G3] If at least one phase file diverges from template baseline, archive behavior proceeds normally.
- [G4] Validation output (script command(s) and result) is recorded in task artifacts for reverification.

