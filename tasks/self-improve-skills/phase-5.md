# Phase 5 — Rules Enablement For GitHub Issue Creation

## Objective
Plan the narrow repository rule or approval-surface change that permits `gh issue create` for `ericpassmore/prompts` and document how the process assets rely on it.

## Code areas impacted
- `codex/rules/git-safe.rules`
- `codex/prompts/self-improve-skills.md`
- `tasks/self-improve-skills/phase-5.md`

## Work items
- [x] Identify the narrowest existing rules surface that should own the `gh issue create` allowance.
- [x] Define the exact scope and justification so the rule expansion remains limited to the central issue workflow.
- [x] Align the process prompt with the approved command path so executing agents know when and why to use it.

## Deliverables
- Implemented rules change for `["gh", "issue", "create"]` in `codex/rules/git-safe.rules`.
- Process documentation in `codex/prompts/self-improve-skills.md` that references the approved issue-creation workflow and its scope limit.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] The planned rule change is narrow, documented, and sufficient to satisfy locked goal G8 without broadening unrelated command permissions.

## Verification steps
List exact commands and expected results.
- [x] Command: `sed -n '1,260p' codex/rules/git-safe.rules`
  - Expected: confirms the existing approval surface already houses adjacent GitHub CLI command permissions and is an appropriate narrow target.
- [x] Result: PASS. `git-safe.rules` already housed adjacent GitHub CLI permissions and now includes the narrow `gh issue create` rule.
- [x] Command: `rg -n "gh\", \"pr\", \"create|gh issue create|ericpassmore/prompts" codex/rules/*.rules codex/prompts/*.md`
  - Expected: confirms the planned rule addition and process references stay tightly scoped to the central issue workflow.
- [x] Result: PASS. The new rule and process docs only reference `gh issue create` for `ericpassmore/prompts` and adjacent PR creation behavior.

## Risks and mitigations
- Risk: a broad GitHub CLI rule can become an unintended privilege expansion.
- Mitigation: add only the exact `gh issue create` prefix and document repository-specific usage in the process assets.
