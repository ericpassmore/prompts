# establish-goals

## Status

- Iteration: v0
- State: locked
- Task name (proposed, kebab-case): strenthen-complexity-lock

## Request restatement

- Stage 3 validation must fail fast when `.complexity-lock.json` is present but missing required metadata for path/content drift enforcement.
- The validator must not silently fall back to `complexity-signals.json` when lock metadata is incomplete.

## Context considered

- Repo/rules/skills consulted:
  - `codex/AGENTS.md`
  - `codex/skills/acac/SKILL.md`
  - `codex/scripts/prepare-phased-impl-validate.sh`
- Relevant files (if any):
  - `codex/scripts/prepare-phased-impl-scaffold.sh`
  - `codex/tasks/_templates/complexity-signals.template.json`
- Constraints (sandbox, commands, policy):
  - Keep change surgical and limited to Stage 3 complexity drift gate behavior.
  - Missing/incomplete lock metadata must produce `BLOCKED` with explicit remediation.

## Ambiguities

### Blocking (must resolve)

1. None.

### Non-blocking (can proceed with explicit assumptions)

1. Required lock metadata for drift hard gate includes `selected_signals_path` and `selected_signals_sha256`.
2. Existing range metadata checks remain in place and should continue to block when invalid.

## Questions for user

1. None required; request is specific and executable.

## Assumptions (explicit; remove when confirmed)

1. Stage 3 validator should block when lock metadata is incomplete even if scorer ranges are present.
2. No other lifecycle behavior changes are requested beyond this validator gap.

## Goals (1-20, verifiable)

1. Ensure `prepare-phased-impl-validate.sh` treats incomplete `.complexity-lock.json` metadata as `BLOCKED`.
2. Remove silent fallback behavior when lock metadata omits `selected_signals_path`.
3. Require `selected_signals_sha256` presence when lock file exists and block if missing.
4. Preserve existing complexity range and phase/goal validation behavior.
5. Validate the fix with concrete command evidence showing `BLOCKED` on incomplete lock metadata.

## Non-goals (explicit exclusions)

- Changing complexity scoring formulas or stage verdict vocabulary.
- Broad refactors outside Stage 3 validator complexity lock handling.

## Success criteria (objective checks)

> Tie each criterion to a goal number when possible.

- [G1] Validator emits `BLOCKED` when `.complexity-lock.json` is missing `selected_signals_path`.
- [G2] Validator emits `BLOCKED` when `.complexity-lock.json` is missing `selected_signals_sha256`.
- [G3] No fallback path allows `READY FOR IMPLEMENTATION` with incomplete lock metadata.
- [G4] Existing range checks still run and report correctly when metadata is complete.

## Risks / tradeoffs

- Tightened lock requirements may block older task artifacts until they are regenerated; this is intentional for drift integrity.

## Next action

- Goals locked; proceed with surgical validator update and verification.
