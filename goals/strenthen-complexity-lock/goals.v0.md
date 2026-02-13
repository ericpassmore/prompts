# Goals Extract
- Task name: strenthen-complexity-lock
- Iteration: v0
- State: locked

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

