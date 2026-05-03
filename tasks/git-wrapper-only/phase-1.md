# Phase 1 — Inventory Current Git Guidance

## Objective
Find the exact in-scope skill, prompt, rule, and helper surfaces that mention direct git commands, git helper scripts, the misspelled environment exception, or Codex MCP GitHub service usage.

## Code areas impacted
- `codex/skills/`
- `codex/prompts/`
- `codex/scripts/git-track-safe-untracked.sh`
- `codex/rules/git-safe.rules`

## Work items
- [x] Search in-scope instruction surfaces for raw agent-facing `git ...` command guidance.
- [x] Search helper surfaces for `developement.env` and `development.env`.
- [x] Identify which raw git references are legitimate internal helper implementation details and which are agent-facing instructions.
- [x] Search in-scope workflow text for Codex MCP GitHub service references.

## Deliverables
- A concrete edit inventory with each touched surface mapped to G1, G2, G3, or G6.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] Every in-scope surface that needs editing is identified, or a blocker is documented.
- [x] No out-of-scope historical task artifact is selected for editing.

## Verification steps
List exact commands and expected results.
- [x] Command: `rg -n "developement\\.env|development\\.env" codex/skills/git-commit/SKILL.md codex/scripts/git-track-safe-untracked.sh`
  - Expected: Current exception references are located.
  - Evidence: located misspelled references in `codex/skills/git-commit/SKILL.md` and `codex/scripts/git-track-safe-untracked.sh`.
- [x] Command: `rg -n "git (branch|status|fetch|pull|push|diff|rev-parse|rev-list|ls-files|add|rm|worktree|commit|checkout|switch|ls-remote)" codex/skills codex/prompts`
  - Expected: Agent-facing raw git guidance candidates are located for review.
  - Evidence: located raw guidance in `codex/prompts/gitpull.md`, `codex/skills/git-commit/SKILL.md`, `codex/skills/land-the-plan/SKILL.md`, `codex/skills/code-review/SKILL.md`, and `codex/skills/prepare-takeoff/SKILL.md`.
- [x] Command: `rg -n "GitHub MCP|MCP GitHub|Codex MCP GitHub" codex/skills codex/prompts`
  - Expected: Any in-scope MCP GitHub references are located and classified.
  - Evidence: located `land-the-plan` MCP-first PR flow for replacement with wrapper-only flow.

## Risks and mitigations
- Risk: Search results include code examples that should remain as wrapper internals or historical context.
- Mitigation: Classify references before editing and keep scope limited to current in-scope agent guidance.
