# Phase 1 — Path Resolution Fix

## Objective
Restore the documented fast path for explicit `CODEX_ROOT` values so valid non-default roots are honored when they satisfy the required paths.

## Code areas impacted
- `codex/scripts/resolve-codex-root.sh`
- `tasks/fix-open-prompts-issues/phase-1.md`

## Work items
- [x] Remove the built-in-root restriction from the explicit `CODEX_ROOT` fast path.
- [x] Keep required-path validation in place for any accepted explicit root.
- [x] Add phase verification evidence after implementation.

## Deliverables
- Updated explicit-root resolution logic in `codex/scripts/resolve-codex-root.sh`.
- Validation evidence showing valid explicit roots outside the fallback set are accepted.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] A valid explicit `CODEX_ROOT` outside the built-in fallback roots is accepted when required files exist, and invalid roots are still rejected.

## Verification steps
List exact commands and expected results.
- [x] Command: `CODEX_ROOT="/Users/eric/.codex/worktrees/d105/prompts/codex" ./codex/scripts/resolve-codex-root.sh scripts codex-config.yaml project-structure.md`
  - Expected: prints the explicit codex root path.
- [x] Command: `TMP_ROOT="$(mktemp -d)" && mkdir -p "$TMP_ROOT/scripts" && touch "$TMP_ROOT/codex-config.yaml" "$TMP_ROOT/project-structure.md" && CODEX_ROOT="$TMP_ROOT" ./codex/scripts/resolve-codex-root.sh scripts codex-config.yaml project-structure.md`
  - Expected: prints the temporary explicit root path even though it is outside the built-in root set.

## Risks and mitigations
- Risk: loosening explicit-root acceptance could permit incomplete codex roots.
- Mitigation: keep the required-path existence checks as the gate for acceptance.
