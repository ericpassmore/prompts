#!/usr/bin/env bash
set -euo pipefail

TASK_NAME="${1:-}"
EXPECTED_BRANCH="${2:-}"

if [[ -z "${TASK_NAME}" || ! "${TASK_NAME}" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "Usage: implement-preflight.sh <task-name> [expected-branch]"
  exit 2
fi

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "${ROOT_DIR}" ]]; then
  echo "BLOCKED: not inside a git repository."
  exit 1
fi
cd "${ROOT_DIR}"

branch="$(git branch --show-current)"
branch="${branch:-detached-HEAD}"
if [[ -n "${EXPECTED_BRANCH}" && "${EXPECTED_BRANCH}" != "${branch}" ]]; then
  echo "BLOCKED: expected branch '${EXPECTED_BRANCH}', found '${branch}'."
  exit 1
fi

conflicts="$(git diff --name-only --diff-filter=U)"
if [[ -n "${conflicts}" ]]; then
  echo "BLOCKED: unresolved merge conflicts require operator resolution:"
  printf '%s\n' "${conflicts}"
  exit 1
fi

git worktree prune
status="$(git status --porcelain)"
count="$(printf '%s\n' "${status}" | sed '/^$/d' | wc -l | tr -d ' ')"

echo "IMPLEMENT PREFLIGHT READY"
echo "Repository: ${ROOT_DIR}"
echo "Task: ${TASK_NAME}"
echo "Branch: ${branch}"
echo "Uncommitted entries: ${count}"
if [[ "${count}" -gt 0 ]]; then
  printf '%s\n' "${status}" | sed '/^$/d' | sed 's/^/  /'
  echo "Record continue, isolate, or stop in the task spec."
fi
