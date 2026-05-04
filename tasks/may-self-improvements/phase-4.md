# Phase 4 — Safe Untracked Staging Scope

## Objective

Implement G2 by preventing safe untracked-file tracking from intent-adding unrelated task-external files by default.

## Code areas impacted
- `codex/scripts/git-track-safe-untracked.sh`
- `codex/scripts/git-stage-safe.sh`
- `codex/skills/git-commit/SKILL.md`
- `codex/skills/land-the-plan/SKILL.md`
- `codex/rules/git-safe.rules`

## Work items
- [ ] Inspect current untracked-file detection and staging behavior.
- [ ] Define task-owned path allowlist behavior for task artifacts and approved implementation surfaces.
- [ ] Require explicit user approval or exclusion guidance for unrelated untracked paths.
- [ ] Add fixture coverage for mixed task-owned and unrelated untracked files.

## Deliverables
- Unrelated untracked files are not intent-added by default.
- Operator-facing output identifies skipped or approval-required paths.
- G2 verification evidence is recorded.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [ ] A mixed untracked-file fixture stages only task-owned paths without explicit authorization.
- [ ] Safety messaging is precise enough to prevent accidental inclusion.
- [ ] Existing safe staging behavior for task-owned files still works.

## Verification steps
List exact commands and expected results.
- [ ] Command: `./codex/scripts/git-track-safe-untracked.sh`
  - Expected: in a controlled mixed fixture, unrelated untracked files are not intent-added by default.
- [ ] Command: `git status --short`
  - Expected: skipped unrelated fixture paths remain untracked unless explicitly authorized.

## Risks and mitigations
- Risk: stricter staging could skip legitimate implementation files.
- Mitigation: make skipped paths visible and provide a deliberate approval path.
