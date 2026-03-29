# Phase 1 — Add Config Contract and GH Wrapper

## Objective
Create the config contract and primary GitHub CLI wrapper that resolves owner/org mappings, preserves default ambient auth behavior, and hard-blocks when a configured mapped env var is unset.

## Code areas impacted
- `codex/codex-config.yaml`
- `codex/scripts/gh-wrap.sh`

## Work items
- [x] Add owner/org token-env mapping documentation to `codex/codex-config.yaml`.
- [x] Implement `codex/scripts/gh-wrap.sh` with supported command-shape validation and owner/org token-env selection.
- [x] Support the wrapper command families requested in issue `#38`, including `pr`, `issue`, and `label` subcommands plus the `edit` alias.

## Deliverables
- Updated config contract in `codex/codex-config.yaml`.
- Executable `codex/scripts/gh-wrap.sh`.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] Wrapper supports the approved command shapes and exits non-zero on unsupported shapes.
- [x] Wrapper leaves ambient auth untouched when no owner/org mapping exists.
- [x] Wrapper emits a clear auth-block message when a mapped env var is configured but unset.

## Verification steps
List exact commands and expected results.
- [x] Command: `bash -n codex/scripts/gh-wrap.sh`
  - Expected: exit code `0`. Result: PASS.
- [x] Command: `GH_TOKEN=ambient GH_WRAP_DEBUG=1 ./codex/scripts/gh-wrap.sh pr view --repo ericpassmore/prompts --json number,url`
  - Expected: debug output shows ambient auth path because no mapped env var is configured. Result: PASS.
- [x] Command: `GH_WRAP_DEBUG=1 ./codex/scripts/gh-wrap.sh pr create --repo example-owner/repo --title Test --body Test`
  - Expected: explicit non-zero auth-block when a mapped env var is selected but unset. Result: PASS (exit code `4` with expected auth-block).

## Risks and mitigations
- Risk: wrapper parsing could silently allow unsupported command shapes.
- Mitigation: validate the allowed command families explicitly and fail fast on anything else.
