---
name: code-review
description: Review a proposed code change for actionable regressions with exact citations, severity, a correctness verdict, and confidence. Use independently or as the mandatory review gate during landing.
---

# Code Review

Review only issues introduced by the change that affect correctness, security, performance, maintainability, or developer experience. Prioritize material issues; omit nits.

## Flow

1. Run `code-review-validate.sh <task> prepare [base-branch]` to refresh diff context in `tasks/<task>/code-review.md`.
2. Inspect the diff and verify every cited line against the current file.
3. Record findings as JSON objects with `file`, `line_range`, `severity` (`low|medium|high`), and `explanation`.
4. Set findings status to `none` or `complete`, then record `patch is correct` or `patch is incorrect`, a confidence in `[0,1]`, and a concise justification.
5. Run `code-review-validate.sh <task> validate [base-branch]`.

Any actionable finding makes the patch incorrect and blocks landing until fixed and reviewed again. Success requires exact citations, valid output, no findings, and `patch is correct`.
