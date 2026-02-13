# Goals Extract
- Task name: align-complexity-policy
- Iteration: v0
- State: locked

## Goals (1-20, verifiable)

1. Restore `complexity-score.sh` level mapping block (lines 189-201) to pre-edit/original content and keep it unchanged by this task.
2. Update complexity policy bounds to `goals 1..20` and `phases 1..12` consistently in scorer schema/help text and any related bound checks.
3. Remove Stage 3 validator template fallback and require `tasks/<task>/complexity-signals.json`; when missing, validator must return `BLOCKED` with remediation text.
4. Add Stage 3 drift hard-gate checks so post-lock changes to selected signals path/content or scorer-derived ranges emit `BLOCKED` and direct the operator to run `revalidate`.
5. Align matching skill documentation with implemented script behavior and bounds.
6. Validate behavior with targeted script runs showing missing-signals blocking, bound consistency, and drift gate enforcement signals.


## Non-goals (explicit exclusions)

- Changing ACAC stage order, verdict vocabulary, or non-complexity lifecycle contracts.
- Modifying implementation-stage source code outside complexity-policy scripts/docs.


## Success criteria (objective checks)

> Tie each criterion to a goal number when possible.

- [G1] `complexity-score.sh` lines 189-201 match pre-edit/original mapping exactly.
- [G2] Script outputs and validation checks consistently enforce `goals 1..20` and `phases 1..12`.
- [G3] `prepare-phased-impl-validate.sh` no longer resolves template signals and explicitly blocks when task signals are missing with remediation.
- [G4] Stage 3 validation emits `BLOCKED` when lock-vs-current complexity signals path/hash or scorer-derived ranges drift.
- [G5] `codex/skills/complexity-scaling/SKILL.md` and `codex/skills/prepare-phased-impl/SKILL.md` reflect the same bounds and behavior.
- [G6] Command evidence is recorded for the targeted script checks executed in this task.

