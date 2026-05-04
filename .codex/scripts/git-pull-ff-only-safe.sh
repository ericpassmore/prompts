#!/usr/bin/env bash
set -euo pipefail

conflicts="$(git diff --name-only --diff-filter=U)"
if [[ -n "${conflicts}" ]]; then
  echo "Abort: merge conflicts/unmerged paths detected:"
  echo "${conflicts}"
  exit 1
fi

branch="$(git branch --show-current)"
if [[ -z "${branch}" ]]; then
  echo "Abort: empty branch name (detached HEAD)."
  exit 1
fi

status="$(git status --porcelain)"
if [[ -n "${status}" ]]; then
  echo "Abort: repo is not clean; refusing to pull:"
  echo "${status}"
  exit 1
fi

if ! upstream="$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null)"; then
  echo "Abort: no upstream configured; set upstream or push branch first."
  exit 1
fi

git fetch --prune

read -r ahead behind < <(git rev-list --left-right --count HEAD..."${upstream}")

if [[ "${behind}" -eq 0 && "${ahead}" -eq 0 ]]; then
  echo "No pull needed: already up to date."
  exit 0
fi

if [[ "${ahead}" -gt 0 && "${behind}" -gt 0 ]]; then
  echo "Abort: branch has diverged; refusing to pull."
  echo "Ahead: ${ahead}; behind: ${behind}; upstream: ${upstream}"
  exit 1
fi

if [[ "${ahead}" -gt 0 ]]; then
  echo "Abort: local branch has commits not on upstream; refusing to pull."
  echo "Ahead: ${ahead}; behind: ${behind}; upstream: ${upstream}"
  exit 1
fi

if ! pull_output="$(git pull --ff-only 2>&1)"; then
  echo "${pull_output}"
  echo "Abort: fast-forward pull failed."
  exit 1
fi

echo "${pull_output}"
echo "Pull OK on branch '${branch}' (upstream: ${upstream}; fast-forwarded ${behind} commit(s))."
