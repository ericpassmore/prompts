#!/usr/bin/env bash
set -euo pipefail

BASE_BRANCH="${1:-}"
HEAD_BRANCH="${2:-$(git branch --show-current)}"
valid_branch() { [[ "$1" =~ ^[A-Za-z0-9._/-]+$ ]] && [[ "$1" != *".."* ]]; }

if ! valid_branch "${BASE_BRANCH}" || ! valid_branch "${HEAD_BRANCH}"; then
  echo "Usage: git-clean-merge-check.sh <base-branch> [head-branch]"
  exit 2
fi

if [[ -n "$(git diff --name-only --diff-filter=U)" ]]; then
  echo "BLOCKED: unresolved merge conflicts require operator resolution."
  exit 1
fi

git fetch origin "${BASE_BRANCH}"
BASE_REF="refs/remotes/origin/${BASE_BRANCH}"
git rev-parse --verify "${BASE_REF}" >/dev/null
git rev-parse --verify "${HEAD_BRANCH}" >/dev/null

if git merge-base --is-ancestor "${BASE_REF}" "${HEAD_BRANCH}"; then
  echo "CLEAN MERGE"
  echo "Method: fast-forward"
  exit 0
fi

if output="$(git merge-tree --write-tree "${BASE_REF}" "${HEAD_BRANCH}" 2>&1)"; then
  echo "CLEAN MERGE"
  echo "Method: ort"
  exit 0
fi

echo "BLOCKED: '${HEAD_BRANCH}' does not merge cleanly into '${BASE_BRANCH}' with ort."
echo "An operator must resolve conflicting files and select the correct lines before PR creation."
printf '%s\n' "${output}"
exit 1
