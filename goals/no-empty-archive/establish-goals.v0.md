# establish-goals

## Status

- Iteration: v0
- State: ready-for-confirmation
- Task name (proposed, kebab-case): no-empty-archive

## Request restatement

- Prevent `prepare-phased-impl-archive.sh` from archiving when Stage 3 phase files are still untouched template content.
- Specifically, ensure empty/default `phase-1.md` and `phase-2.md` do not trigger archive creation and movement.
- Choose and implement the most deterministic approach between state-tagging and template-content comparison.

## Context considered

- Repo/rules/skills consulted: `codex/AGENTS.md`, `codex/skills/acac/SKILL.md`, `codex/skills/establish-goals/SKILL.md`
- Relevant files (if any): `codex/scripts/prepare-phased-impl-archive.sh`, `codex/scripts/prepare-phased-impl-scaffold.sh`, `codex/tasks/_templates/phase.template.md`
- Constraints (sandbox, commands, policy): ACAC lifecycle order enforced; no implementation before goals are locked.

## Ambiguities

### Blocking (must resolve)

1. None identified.

### Non-blocking (can proceed with explicit assumptions)

1. "Empty templates" means phase files that still match generated template content (allowing only phase-number substitution).
2. Archive skipping should depend on meaningful Stage 3 artifacts, not just the presence of phase files on disk.

## Questions for user

1. Please confirm these goals so I can lock them and proceed through takeoff/planning/implementation.

## Assumptions (explicit; remove when confirmed)

1. A deterministic content comparison to template-derived baseline is preferable to mutable INIT/updated tags.
2. Existing archive behavior for non-template/populated phase files should remain unchanged.

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

## Risks / tradeoffs

- Strict textual comparison can classify formatting-only edits as substantive; this is acceptable for deterministic behavior and fail-fast semantics.

## Next action

- Ready to lock after user confirmation.
