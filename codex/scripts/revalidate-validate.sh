#!/usr/bin/env bash
set -euo pipefail

TASK_NAME="${1:-}"
BASE_BRANCH="${2:-}"
ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
TASK_DIR="${ROOT_DIR}/tasks/${TASK_NAME}"
REVALIDATE_FILE="${TASK_DIR}/revalidate.md"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  echo "Usage (canonical): ./.codex/scripts/revalidate-validate.sh <task-name> [base-branch]"
  echo "Usage (repo-local fallback): ./codex/scripts/revalidate-validate.sh <task-name> [base-branch]"
  echo "Usage (home fallback): ${HOME}/.codex/scripts/revalidate-validate.sh <task-name> [base-branch]"
}

if [[ -z "${TASK_NAME}" ]]; then
  usage
  exit 2
fi

if [[ ! "${TASK_NAME}" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "Abort: task-name must be kebab-case using lowercase letters, digits, and hyphens only."
  exit 2
fi

issues=()

if [[ ! -d "${TASK_DIR}" ]]; then
  issues+=("Missing task directory: ${TASK_DIR}")
fi

if [[ ! -f "${REVALIDATE_FILE}" ]]; then
  issues+=("Missing required file: ${REVALIDATE_FILE}")
fi

# Step 4 gate: code review must validate successfully.
review_cmd=( "${SCRIPT_DIR}/revalidate-code-review.sh" "${TASK_NAME}" )
if [[ -n "${BASE_BRANCH}" ]]; then
  review_cmd+=( "${BASE_BRANCH}" )
fi

review_output=""
if ! review_output="$("${review_cmd[@]}" 2>&1)"; then
  issues+=("Code review validation failed via revalidate-code-review.sh.")
  while IFS= read -r line; do
    [[ -z "${line}" ]] && continue
    issues+=("  ${line}")
  done <<< "${review_output}"
fi

verdict=""
if [[ -f "${REVALIDATE_FILE}" ]]; then
  verdict="$(sed -nE 's/^- Final verdict:[[:space:]]*(READY TO RESUME|BLOCKED)[[:space:]]*$/\1/p' "${REVALIDATE_FILE}" | head -n 1)"
  if [[ -z "${verdict}" ]]; then
    issues+=("Missing or invalid '- Final verdict:' in ${REVALIDATE_FILE}. Use READY TO RESUME or BLOCKED.")
  fi
fi

if [[ "${#issues[@]}" -gt 0 ]]; then
  echo "BLOCKED"
  for issue in "${issues[@]}"; do
    echo "- ${issue}"
  done
  exit 1
fi

if [[ "${verdict}" == "BLOCKED" ]]; then
  echo "BLOCKED"
  echo "- Final verdict in ${REVALIDATE_FILE} is BLOCKED."
  exit 1
fi

echo "READY TO RESUME"
exit 0
