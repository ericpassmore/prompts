# Phase 4 — Align Rule And Wrapper Surfaces

## Objective
Align rule/help surfaces with wrapper-only git behavior while preserving legitimate raw git internals inside repository-owned helper scripts.

## Code areas impacted
- `codex/rules/git-safe.rules`
- `codex/scripts/`
- In-scope skill/prompt references identified in Phase 1

## Work items
- [x] Review git-safe rules for direct raw git allowances that conflict with wrapper-only agent guidance.
- [x] Prefer approved helper-script allow guidance over direct raw git command guidance where the workflow now uses helpers.
- [x] Preserve helper-script rules needed by lifecycle execution.
- [x] Confirm no Codex MCP GitHub service usage or requirement appears in the updated workflow.

## Deliverables
- Rule/help surfaces that match the wrapper-only agent-facing workflow without disabling required helper scripts.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] Rule/help surfaces do not contradict the updated wrapper-only instructions.
- [x] Required lifecycle helper scripts remain allowed/documented.

## Verification steps
List exact commands and expected results.
- [x] Command: `rg -n "git (branch|status|fetch|pull|push|diff|rev-parse|rev-list|ls-files|add|rm|worktree|commit|checkout|switch|ls-remote)" codex/rules/git-safe.rules codex/skills codex/prompts`
  - Expected: remaining raw git references are either removed from agent-facing guidance or classified as legitimate helper/rule context.
  - Evidence: PASS, skills/prompts are clean; rule references are command allowlist context.
- [x] Command: `rg -n "GitHub MCP|MCP GitHub|Codex MCP GitHub" codex/skills codex/prompts codex/rules/git-safe.rules`
  - Expected: no requirement to use the Codex MCP GitHub service.
  - Evidence: PASS, remaining matches are explicit prohibitions in `land-the-plan`.

## Risks and mitigations
- Risk: Removing direct git allowances too broadly could break lifecycle bootstrap or helper execution.
- Mitigation: Keep required helper-script allow rules and adjust only surfaces that conflict with locked goals.
