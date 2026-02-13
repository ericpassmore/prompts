#!/usr/bin/env bash
set -euo pipefail

TASK_NAME="${1:-}"

usage() {
  echo "Usage (canonical): ./.codex/scripts/task-manifest-land-update.sh <task-name>"
  echo "Usage (repo-local fallback): ./codex/scripts/task-manifest-land-update.sh <task-name>"
  echo "Usage (home fallback): ${HOME}/.codex/scripts/task-manifest-land-update.sh <task-name>"
  echo "Example: ./codex/scripts/task-manifest-land-update.sh add-performer-search"
}

if [[ -z "${TASK_NAME}" ]]; then
  usage
  exit 2
fi

if [[ ! "${TASK_NAME}" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "Abort: task-name must be kebab-case using lowercase letters, digits, and hyphens only."
  exit 2
fi

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "${ROOT_DIR}" ]]; then
  echo "Abort: not inside a git repository."
  exit 1
fi

cd "${ROOT_DIR}"

CURRENT_BRANCH="$(git branch --show-current)"
if [[ -z "${CURRENT_BRANCH}" ]]; then
  echo "Abort: detached HEAD is not supported for task manifest landing updates."
  exit 1
fi

MANIFEST_FILE="${ROOT_DIR}/goals/task-manifest.csv"
if [[ ! -f "${MANIFEST_FILE}" ]]; then
  echo "Abort: missing manifest file ${MANIFEST_FILE}"
  exit 1
fi

EXPECTED_HEADER="number,taskname,first_create_date,first_create_hhmmss,first_create_git_hash"
ACTUAL_HEADER="$(head -n 1 "${MANIFEST_FILE}")"
if [[ "${ACTUAL_HEADER}" != "${EXPECTED_HEADER}" ]]; then
  echo "Abort: unexpected manifest header in ${MANIFEST_FILE}"
  echo "Expected: ${EXPECTED_HEADER}"
  echo "Actual:   ${ACTUAL_HEADER}"
  exit 1
fi

if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
  echo "Abort: unable to resolve current git commit (HEAD)."
  exit 1
fi

SOURCE_COMMIT_HASH="$(git rev-parse --short=7 HEAD)"
CURRENT_HHMMSS="$(date -u "+%H%M%S")"

TMP_FILE="$(mktemp)"
cleanup() {
  rm -f "${TMP_FILE}"
}
trap cleanup EXIT

set +e
awk -F',' -v OFS=',' -v task="${TASK_NAME}" -v hhmmss="${CURRENT_HHMMSS}" -v commit_hash="${SOURCE_COMMIT_HASH}" '
  NR == 1 {
    print
    next
  }
  {
    if ($2 == task) {
      $4 = hhmmss
      $5 = commit_hash
      found = 1
    }
    print
  }
  END {
    if (!found) {
      exit 42
    }
  }
' "${MANIFEST_FILE}" > "${TMP_FILE}"
awk_status=$?
set -e

if [[ "${awk_status}" -eq 42 ]]; then
  echo "Abort: task '${TASK_NAME}' not found in ${MANIFEST_FILE}."
  exit 1
fi

if [[ "${awk_status}" -ne 0 ]]; then
  echo "Abort: failed to update manifest row for task '${TASK_NAME}'."
  exit 1
fi

if cmp -s "${MANIFEST_FILE}" "${TMP_FILE}"; then
  echo "No manifest update required for '${TASK_NAME}' (values already current)."
  exit 0
fi

mv "${TMP_FILE}" "${MANIFEST_FILE}"

git add "${MANIFEST_FILE}"

if git diff --cached --quiet -- "${MANIFEST_FILE}"; then
  echo "No staged manifest changes detected after update for '${TASK_NAME}'."
  exit 0
fi

COMMIT_MESSAGE="Update task manifest metadata for ${TASK_NAME}"
git commit -m "${COMMIT_MESSAGE}" -- "${MANIFEST_FILE}"

if git rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1; then
  git push origin "${CURRENT_BRANCH}"
else
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  PUSH_HELPER="${SCRIPT_DIR}/git-push-branch-safe.sh"

  if [[ ! -x "${PUSH_HELPER}" ]]; then
    echo "Abort: missing executable push helper ${PUSH_HELPER}"
    exit 1
  fi

  "${PUSH_HELPER}" "${CURRENT_BRANCH}"
fi

echo "Updated manifest metadata for task '${TASK_NAME}' (hhmmss=${CURRENT_HHMMSS}, commit=${SOURCE_COMMIT_HASH})."
echo "Manifest commit created and pushed on branch '${CURRENT_BRANCH}'."
