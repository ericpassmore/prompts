---
name: land-the-plan
description: Run final pinned validation and code review, verify clean mergeability, then commit, push, and create or update a reviewer-ready pull request.
---

# Land the Plan

## Entry

Require `READY TO LAND`, a populated `tasks/<task>/spec.md`, no unresolved paths, and a usable remote. Otherwise emit `BLOCKED`.

## Quality gates

1. Read the exact lint, build, and test commands pinned in the task spec. Run all three and record their outputs and pass/fail status in the spec. Missing, placeholder, skipped, or failing commands block landing.
2. Run the `code-review` skill. Any actionable finding or an incorrect verdict returns the work to `implement` and blocks landing.

## Delivery

1. Resolve the head branch with `git-resolve-head-branch-safe.sh <task> [agent-id] [timestamp]` and the base branch from `codex-config.yaml` (fallback `main`).
2. Run the `git-commit` skill completely, including push.
3. Before creating or updating a PR, run `git-clean-merge-check.sh <base> <head>`. It must fetch the base and prove integration is possible by fast-forward or conflict-free `ort` without modifying the worktree.
4. If merge conflicts exist, emit `BLOCKED`. List the conflicting evidence and require an operator to choose the correct lines; never resolve conflicts automatically.
5. Use `gh-wrap.sh pr view` to reuse an existing PR, then `pr edit` or `pr create`. Do not use raw `gh` or create a duplicate PR.

The PR body must summarize goals, non-goals, validation results, review verdict, merge method, exceptions, and deferred work. Use explicit `None` where applicable.

## Exit

Emit `LANDED` only after all quality gates pass, the branch is committed and pushed, the clean-merge check passes, and the PR exists. Otherwise emit `BLOCKED` with the failing gate and next action.
