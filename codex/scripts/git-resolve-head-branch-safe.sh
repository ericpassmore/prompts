#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage (canonical): ./.codex/scripts/git-resolve-head-branch-safe.sh <task-name> [agent-id] [timestamp]"
  echo "Usage (repo-local fallback): ./codex/scripts/git-resolve-head-branch-safe.sh <task-name> [agent-id] [timestamp]"
  echo "Usage (home fallback): ${HOME}/.codex/scripts/git-resolve-head-branch-safe.sh <task-name> [agent-id] [timestamp]"
  echo "Example: ./codex/scripts/git-resolve-head-branch-safe.sh add-feature-x codex-agent 20260210153045"
}

TASK_NAME="${1:-}"
if [[ -z "${TASK_NAME}" ]]; then
  usage
  exit 2
fi

CURRENT_BRANCH="$(git branch --show-current)"
if [[ -n "${CURRENT_BRANCH}" ]]; then
  echo "Resolved head branch: ${CURRENT_BRANCH}"
  exit 0
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAND_HELPER="${SCRIPT_DIR}/git-land-branch-safe.sh"
if [[ ! -x "${LAND_HELPER}" ]]; then
  echo "Abort: missing executable landing helper ${LAND_HELPER}"
  exit 1
fi

"${LAND_HELPER}" "$@"
