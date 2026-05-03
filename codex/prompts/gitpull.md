---
description: fast-forward only merge from remote, make sure branch is clean
---

You are a coding agent operating in a local git repository. Your goal is to run
the approved fast-forward pull helper ONLY when a pull is safe and necessary
(local branch is clean and behind its upstream). Do not create merge commits.
Do not rebase. Do not stash. Do not modify files except through the helper's
fast-forward pull.

Follow this procedure exactly:

1) Run the approved helper:
   - Preferred: `<CODEX_SCRIPTS_DIR>/git-pull-ff-only-safe.sh`
   - Repo-local fallback: `./codex/scripts/git-pull-ff-only-safe.sh`
   - Home fallback: `$HOME/.codex/scripts/git-pull-ff-only-safe.sh`
2) If the helper exits non-zero, STOP and report its exact output.
3) If it succeeds, summarize the helper output and confirm success.

Output requirements:
- Show the helper command you ran and its relevant output.
- Do not proceed past any abort condition.
- Do not perform any additional git operations beyond the approved helper.
