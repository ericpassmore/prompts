---
name: implement
description: Execute locked coding goals rapidly and minimally, including environment preflight, task scoping, implementation, and a handoff for final quality gates.
---

# Implement

## Entry

Require a locked `goals/<task>/goals.vN.md`. If goals are missing, ambiguous, or changed, return to `establish-goals` or emit `BLOCKED`.

## Flow

1. Run `implement-bootstrap.sh`, `task-scaffold.sh <task>`, and `implement-preflight.sh <task> [expected-branch]` from the resolved Codex scripts directory.
2. Populate `tasks/<task>/spec.md` with:
   - the locked-goal reference;
   - in-scope and out-of-scope boundaries;
   - exact lint, build, and test commands;
   - the dirty-worktree decision when needed;
   - a short execution approach only when it adds clarity.
3. Implement the goals directly. Use your judgment to scale the number of goals and implementation phases to the task’s complexity. Do not create phase artifacts.
4. Keep changes minimal, handle recoverable failures explicitly, and run focused checks when they accelerate feedback.
5. Update the spec with delivered behavior, exceptions, and deferred work. Verify every locked success criterion is satisfied and no scope drift occurred.

## Stop conditions

Emit `BLOCKED` when required input is unavailable, conflicts are unresolved, scope or goals drift, a necessary check fails, or operator judgment is required. Include concrete evidence and the next required action.

## Exit

Emit `READY TO LAND` only when implementation satisfies the locked goals and the spec contains executable pinned lint/build/test commands. Full validation and code review run in `land-the-plan`.
