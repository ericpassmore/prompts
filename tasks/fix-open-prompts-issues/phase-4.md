# Phase 4 — PR Fallback Reuse Path

## Objective
Update `land-the-plan` so its PR fallback contract matches the documented create-or-update behavior when a head-branch PR already exists, using GitHub MCP for the PR check before `gh pr` fallback.

## Code areas impacted
- `codex/skills/land-the-plan/SKILL.md`
- `tasks/fix-open-prompts-issues/phase-4.md`

## Work items
- [x] Add an explicit existing-PR detect/reuse/update fallback path to the Stage 5 skill instructions.
- [x] Keep the CLI fallback narrow and aligned with the repo's GitHub access constraints.
- [x] Record phase verification evidence after implementation.

## Deliverables
- Updated `land-the-plan` fallback instructions covering MCP-first PR existence checks and CLI reuse/update fallback.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] The fallback flow explicitly checks for an existing PR through GitHub MCP first and only falls back to `gh pr` reuse/create behavior when MCP create/update is unavailable.

## Verification steps
List exact commands and expected results.
- [x] Command: `rg -n "GitHub MCP|existing PR|gh pr create|gh pr view|gh pr edit" codex/skills/land-the-plan/SKILL.md`
  - Expected: shows an MCP-first existing-PR check and a CLI reuse/update fallback path in the instructions.

## Risks and mitigations
- Risk: fallback wording could imply unsupported broad CLI behavior.
- Mitigation: keep the instructions scoped to reuse/update for the current head branch only.
