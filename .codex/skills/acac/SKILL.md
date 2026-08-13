---
name: acac
description: Run the complete coding lifecycle for a request whose first non-empty line is exactly #ACAC: lock goals with user approval, implement them, then validate, review, and land the change.
---

# ACAC

Use only for the exact, case-sensitive `#ACAC` trigger.

1. Confirm a kebab-case task name.
2. Run `establish-goals`. Present normalized goals and obtain explicit user approval. Continue only on `GOALS LOCKED`.
3. Run `implement`. Continue only on `READY TO LAND`.
4. Run `land-the-plan`. Finish on `LANDED`.

Any ambiguity, failed gate, goal or scope drift, unresolved conflict, or operator decision emits `BLOCKED` and stops the workflow. Never skip goal approval, pinned lint/build/tests, code review, clean-merge verification, or authorized git/PR helpers.

Successful intermediate verdicts continue automatically unless the user explicitly pauses.
