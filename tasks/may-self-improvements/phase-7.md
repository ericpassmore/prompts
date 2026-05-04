# Phase 7 — Code Review Revalidation Diff Selection

## Objective

Implement G7 by ensuring code-review revalidation includes the current task implementation diff before commit or fails with actionable guidance.

## Code areas impacted
- `codex/scripts/revalidate-code-review.sh`
- `codex/skills/code-review/SKILL.md`
- `codex/skills/land-the-plan/SKILL.md`
- `codex/scripts/git-diff-unstaged-skip-binary.sh`
- `codex/scripts/git-diff-staged-skip-binary.sh`

## Work items
- [ ] Inspect current diff source precedence in `revalidate-code-review.sh`.
- [ ] Ensure staged and unstaged task changes are considered before base-branch diff can mislead review context.
- [ ] Define fail-fast behavior when the script cannot safely select a diff source.
- [ ] Add fixture coverage for branch diff plus current working-tree changes.

## Deliverables
- Revalidation context includes the current task diff before commit.
- Misleading base-only diff selection is prevented or explicitly blocked.
- G7 verification evidence is recorded.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [ ] Working-tree changes are included or trigger a non-zero actionable failure.
- [ ] Existing base-branch review behavior still works when no current task diff exists.
- [ ] Generated review artifacts identify the selected diff source.

## Verification steps
List exact commands and expected results.
- [ ] Command: `./codex/scripts/revalidate-code-review.sh may-self-improvements main`
  - Expected: selected diff source includes current task changes or the script fails with precise instructions.
- [ ] Command: `rg -n "unstaged|staged|base|diff source|working" codex/scripts/revalidate-code-review.sh`
  - Expected: diff selection precedence is explicit.

## Risks and mitigations
- Risk: combining branch and working-tree diffs could create noisy review context.
- Mitigation: prioritize task-current changes and label the selected source clearly.
