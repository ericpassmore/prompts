# Phase 3 — Script Speedup Without Semantic Drift

## Objective
Implement a low-risk performance speedup in codex path-resolution scripts while preserving behavior.

## Code areas impacted
- `codex/scripts/resolve-codex-root.sh`
- `codex/scripts/read-codex-paths.sh` (only if needed for a companion fast-path)

## Work items
- [x] Introduce an early-return fast-path when `CODEX_ROOT` (and optionally `CODEX_SCRIPTS_DIR`) is already valid.
- [x] Preserve resolution precedence and fallback semantics.
- [x] Keep fail-fast behavior unchanged for invalid/missing required paths.

## Deliverables
- Script update with comments explaining fast-path intent and unchanged resolution semantics.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] Existing command resolution behavior remains unchanged under both configured and fallback scenarios.

## Verification steps
List exact commands and expected results.
- [x] Command: `./codex/scripts/resolve-codex-root.sh scripts codex-config.yaml project-structure.md`
  - Expected: resolves to valid codex root in current repo.
  - Result: PASS (resolved `/Users/eric/.codex/worktrees/2994/prompts/codex`).
- [x] Command: `./codex/scripts/read-codex-paths.sh`
  - Expected: prints resolved `CODEX_ROOT` and `CODEX_SCRIPTS_DIR` without errors.
  - Result: PASS (printed resolved paths with no errors).
- [x] Command: `bash -n codex/scripts/resolve-codex-root.sh codex/scripts/read-codex-paths.sh`
  - Expected: no syntax errors.
  - Result: PASS.

## Risks and mitigations
- Risk: Fast-path may skip required validations.
- Mitigation: Apply fast-path only after validating required paths and keep existing fallback path intact.
