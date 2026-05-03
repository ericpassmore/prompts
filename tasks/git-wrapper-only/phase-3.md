# Phase 3 — Route Skill And Prompt Git Guidance

## Objective
Update agent-facing skill and prompt text so git operations route through approved repository git wrapper/helper scripts rather than direct raw `git ...` commands.

## Code areas impacted
- `codex/skills/git-commit/SKILL.md`
- Other in-scope `codex/skills/*/SKILL.md` files identified in Phase 1
- `codex/prompts/gitpull.md`

## Work items
- [x] Replace direct raw git command instructions with bootstrap-resolved or repo-local helper script guidance where helper surfaces exist.
- [x] Keep shell helper implementation details out of this phase unless a narrow helper reference requires wording alignment.
- [x] Preserve fail-fast behavior in the resulting workflow guidance.
- [x] Ensure updated wording does not introduce Codex MCP GitHub service use.

## Deliverables
- Agent-facing skill/prompt guidance that directs git operations through approved wrapper/helper scripts.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] In-scope direct raw git instructions have been replaced or explicitly documented as legitimate non-agent-facing references.
- [x] No Codex MCP GitHub service dependency is introduced.

## Verification steps
List exact commands and expected results.
- [x] Command: `rg -n "git (branch|status|fetch|pull|push|diff|rev-parse|rev-list|ls-files|add|rm|worktree|commit|checkout|switch|ls-remote)" codex/skills codex/prompts`
  - Expected: no remaining in-scope agent-facing raw git instructions that should route through helpers.
  - Evidence: PASS, command exited 1 with no output after replacing the final prohibition example.
- [x] Command: `rg -n "GitHub MCP|MCP GitHub|Codex MCP GitHub" codex/skills codex/prompts`
  - Expected: no new requirement for Codex MCP GitHub service usage.
  - Evidence: PASS, only prohibitions remain in `land-the-plan`; no required use is present.

## Risks and mitigations
- Risk: Some direct command examples may not have an existing helper equivalent.
- Mitigation: Add only narrow helper coverage within scope or stop as `BLOCKED` instead of preserving unsafe guidance.
