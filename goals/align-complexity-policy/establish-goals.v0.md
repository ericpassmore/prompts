# establish-goals

## Status

- Iteration: v0
- State: locked
- Task name (proposed, kebab-case): align-complexity-policy

## Request restatement

- Align complexity policy behavior and documentation around fixed bounds (`goals 1..20`, `phases 1..12`) while preserving the original scorer level mapping block at `complexity-score.sh` lines 189-201.
- Remove Stage 3 validator fallback to template signals and require task-local `complexity-signals.json` with explicit `BLOCKED` remediation when missing.
- Treat post-lock complexity drift (signals path/content or scorer-derived ranges) as a hard gate that blocks and routes to `revalidate`.

## Context considered

- Repo/rules/skills consulted:
  - `codex/AGENTS.md`
  - `codex/skills/complexity-scaling/SKILL.md`
  - `codex/skills/prepare-phased-impl/SKILL.md`
  - `codex/scripts/complexity-score.sh`
  - `codex/scripts/prepare-phased-impl-scaffold.sh`
  - `codex/scripts/prepare-phased-impl-validate.sh`
- Relevant files (if any):
  - `codex/tasks/_templates/complexity-signals.template.json`
- Constraints (sandbox, commands, policy):
  - Stage-gated ACAC flow: lock goals before downstream edits.
  - Keep `complexity-score.sh` lines 189-201 unchanged from pre-edit/original.
  - Enforce `goals 1..20` and `phases 1..12` consistently in policy text and script validation behavior.
  - Emit `BLOCKED` on drift/missing signals (no silent fallback).

## Ambiguities

### Blocking (must resolve)

1. None after user clarification.

### Non-blocking (can proceed with explicit assumptions)

1. "Everywhere" applies to complexity policy owners/consumers in this repo (scorer contract text, Stage 3 scripts, and matching skill docs).
2. Drift detection may use a task-local lock artifact to compare selected signals path/hash and scorer-derived ranges across Stage 3 cycles.

## Questions for user

1. Resolved in-thread: restore pre-edit/original scorer level mapping and drop unstaged edits first.
2. Resolved in-thread: enforce `goals 1..20` and `phases 1..12` everywhere; emit `BLOCKED` for drift.

## Assumptions (explicit; remove when confirmed)

1. Scope includes all directly coupled policy surfaces needed for deterministic behavior: scorer contract text, Stage 3 scaffold/validate scripts, and complexity/Stage 3 skill docs.
2. Existing downstream stages can consume explicit `BLOCKED` remediation text without additional artifact formats.

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

## Risks / tradeoffs

- Enforcing strict drift and missing-signals hard gates may block tasks that previously passed via fallback; this is intentional for determinism and gate integrity.

## Next action

- Ready to proceed to downstream stage execution with these locked goals.
