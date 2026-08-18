---
description: Establish locked goals from a GitHub issue
argument-hint: N
---

# establish-issue-goals

Treat `$1` as the sole argument `N`, the GitHub issue number.

Before invoking GitHub, require `N` to be a positive base-10 integer. If it is missing, zero, negative, non-numeric, or accompanied by another argument, stop with an explicit usage error and do not invoke GitHub.

From the repository root, use one shell context to run:

```sh
source ./tok~ns && .codex/scripts/gh-wrap.sh issue view "$N"
```

Set shell variable `N` to the validated issue number before running that command. Do not print, inspect, summarize, or otherwise expose the contents of `./tok~ns` or any secret values it defines. If `./tok~ns` is missing or cannot be sourced, stop with an explicit error. If the issue-view command fails, stop and report the command's error without proceeding.

After a successful issue read, use the complete retrieved issue as the request input to the `establish-goals` skill. Follow that skill faithfully: create or update its required goal artifacts with repository scripts, ask only blocking questions, require explicit user approval, and do not plan or implement the issue.

Stop only at the establish-goals stage gate with `GOALS LOCKED` or `BLOCKED`.
