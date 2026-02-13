# Phase 2 — Align Git-Safe Policy and Validate Lifecycle Artifacts

## Objective
Remove stale `gh pr` allow rules and close the implementation with validator-backed lifecycle evidence.

## Code areas impacted
- `codex/rules/git-safe.rules`
- `tasks/move-pr-to-mcp/final-phase.md`
- `tasks/move-pr-to-mcp/revalidate.md`
- `tasks/move-pr-to-mcp/revalidate-code-review.md`

## Work items
- [x] Remove all `gh pr` allowlist rule blocks from `git-safe.rules`.
- [x] Execute targeted verification commands and record results in `final-phase.md`.
- [x] Complete revalidate artifacts and run `revalidate-validate.sh`.

## Deliverables
- Updated git-safe ruleset without `gh pr` allow entries.
- Stage 4 and Stage 5 artifacts with passing validator verdicts.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] `git-safe.rules` contains no `gh pr` allow rules.
- [x] Stage validators emit expected success verdicts through revalidation.

## Verification steps
List exact commands and expected results.
- [x] Command: `rg -n "pattern = \\[\"gh\", \"pr\"" codex/rules/git-safe.rules`
  - Expected: no matches.
- [x] Command: `./codex/scripts/prepare-phased-impl-validate.sh move-pr-to-mcp`
  - Expected: `READY FOR IMPLEMENTATION`.
- [x] Command: `./codex/scripts/implement-validate.sh move-pr-to-mcp`
  - Expected: `READY FOR REVERIFICATION`.
- [x] Command: `./codex/scripts/revalidate-validate.sh move-pr-to-mcp`
  - Expected: `READY TO LAND`.

## Risks and mitigations
- Risk: Removing allow rules could block any remaining legacy `gh pr` calls.
- Mitigation: Ensure touched skill/script surfaces now use MCP prompt handoff.
