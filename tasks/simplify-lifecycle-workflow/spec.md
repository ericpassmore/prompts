# Simplify Lifecycle Workflow

## Goal reference

- `goals/simplify-lifecycle-workflow/goals.v0.md`

## Scope

### In scope

- Consolidate `prepare-takeoff` and `prepare-phased-impl` into `implement`.
- Simplify `establish-goals`, `implement`, `code-review`, `land-the-plan`, ACAC, and their active scripts, validators, rules, prompts, and templates.
- Require pinned lint/build/tests, code review, and a clean fast-forward or `ort` merge before PR creation.
- Synchronize active personal Codex fallback assets.

### Out of scope

- Historical goal and task records.
- Automatic conflict resolution.
- Unrelated product-development workflows.

## Approach

- Keep goal lock, collapse execution into one skill, and load quality gates at landing.
- Let the agent scale goals and internal implementation phases; create no phase artifacts.
- Preserve the dirty worktree and all prior approved changes (`continue`).

## Verification commands

- Lint: `bash -n .codex/scripts/*.sh`
- Build: `for skill_dir in .codex/skills/establish-goals .codex/skills/implement .codex/skills/code-review .codex/skills/land-the-plan .codex/skills/acac; do uv run --with pyyaml python /Users/eric/.codex/skills/.system/skill-creator/scripts/quick_validate.py "$skill_dir"; done`
- Tests: `./.codex/scripts/lifecycle-workflow-test.sh`

## Delivery

- Delivered: three-step lifecycle, independently reusable code review, concise task scaffolding, structured review validation, and non-mutating clean-merge verification.
- Exceptions: None.
- Deferred work: None.
- Dirty-worktree decision: continue.

## Quality gate results

- Lint: passed; all active shell scripts parse and `git diff --check` is clean.
- Build: passed; all five retained lifecycle/ACAC skills validate.
- Tests: passed; fixtures cover spec-only scaffolding, review validation, fast-forward, clean `ort`, and blocking conflicts for operator resolution.
- Code review: passed; no findings, `patch is correct`, confidence `0.96`, validator `READY`.
- Clean merge: behavior passed fixtures; actual branch check is deferred to landing after commit/push.
