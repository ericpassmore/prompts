#!/usr/bin/env bash
set -euo pipefail

conflicts="$(git diff --name-only --diff-filter=U)"
if [ -n "$conflicts" ]; then
  echo "Abort: merge conflicts/unmerged paths detected:"
  echo "$conflicts"
  exit 1
fi

branch="$(git branch --show-current)"
if [ -z "$branch" ]; then
  echo "Abort: detached HEAD or invalid branch state."
  exit 1
fi

case "$branch" in
  main|master)
    echo "Abort: direct commits to protected branch '$branch' are not allowed."
    exit 1
    ;;
esac

if ! upstream="$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null)"; then
  echo "Abort: branch '$branch' has no upstream and must be pushed first."
  echo "Run: git push -u origin $branch"
  exit 1
fi

if ! pull_output="$(git pull --ff-only 2>&1)"; then
  echo "$pull_output"
  case "$pull_output" in
    *"couldn't find remote ref"*|*"no such ref"*|*"no tracking information"*)
      echo "Abort: branch '$branch' has no valid upstream ref."
      echo "Push the branch first or configure a working upstream."
      ;;
    *)
      echo "Abort: fast-forward pull failed and requires manual intervention."
      ;;
  esac
  exit 1
fi

echo "$pull_output"
echo "Preflight OK on branch '$branch' (upstream: $upstream)."
