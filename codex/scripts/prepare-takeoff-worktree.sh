#!/usr/bin/env bash
set -euo pipefail

INTERACTIVE_SHELL="${PREPARE_TAKEOFF_INTERACTIVE_SHELL:-0}"
POSITIONAL_ARGS=()

usage() {
  echo "Usage (canonical): ./.codex/scripts/prepare-takeoff-worktree.sh <task-name> [branch] [--interactive-shell]"
  echo "Usage (fallback): ${HOME}/.codex/scripts/prepare-takeoff-worktree.sh <task-name> [branch] [--interactive-shell]"
  echo "Example: ./.codex/scripts/prepare-takeoff-worktree.sh add-performer-search main"
}

for arg in "$@"; do
  case "${arg}" in
    --interactive-shell)
      INTERACTIVE_SHELL=1
      ;;
    --no-interactive-shell)
      INTERACTIVE_SHELL=0
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      POSITIONAL_ARGS+=("${arg}")
      ;;
  esac
done

TASK_NAME="${POSITIONAL_ARGS[0]:-}"
BRANCH_NAME="${POSITIONAL_ARGS[1]:-}"

if [[ "${#POSITIONAL_ARGS[@]}" -gt 2 ]]; then
  echo "Abort: too many positional arguments."
  usage
  exit 2
fi

if [[ -z "${TASK_NAME}" ]]; then
  usage
  exit 2
fi

if [[ ! "${TASK_NAME}" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "Abort: task-name must be kebab-case using only lowercase letters, digits, and hyphens."
  exit 2
fi

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "${REPO_ROOT}" ]]; then
  echo "Abort: not inside a git repository."
  exit 1
fi

if [[ -z "${BRANCH_NAME}" ]]; then
  BRANCH_NAME="$(git branch --show-current)"
fi

if [[ -z "${BRANCH_NAME}" ]]; then
  echo "Abort: branch is empty (detached HEAD). Pass an explicit branch name."
  exit 1
fi

sanitize_branch_for_path() {
  local raw="$1"
  raw="${raw//\//-}"
  raw="${raw//:/-}"
  printf '%s' "${raw}" | sed -E 's/[^A-Za-z0-9._-]+/-/g; s/-+/-/g; s/^-+//; s/-+$//'
}

REPO_NAME="$(basename "${REPO_ROOT}")"

cd "${REPO_ROOT}"

TARGET_BRANCH="${BRANCH_NAME}"
SOURCE_BRANCH="${BRANCH_NAME}"

if [[ "${BRANCH_NAME}" == "main" || "${BRANCH_NAME}" == "master" ]]; then
  if ! git show-ref --verify --quiet "refs/heads/${BRANCH_NAME}"; then
    echo "Abort: base branch must exist locally: ${BRANCH_NAME}"
    exit 1
  fi

  TARGET_BRANCH="codex/${TASK_NAME}"

  if git show-ref --verify --quiet "refs/heads/${TARGET_BRANCH}"; then
    echo "Abort: target branch already exists locally: ${TARGET_BRANCH}"
    exit 1
  fi

  if git show-ref --verify --quiet "refs/remotes/origin/${TARGET_BRANCH}"; then
    echo "Abort: target branch already exists on origin: ${TARGET_BRANCH}"
    exit 1
  fi
else
  if ! git show-ref --verify --quiet "refs/heads/${BRANCH_NAME}"; then
    echo "Abort: non-main/master branch must already exist locally: ${BRANCH_NAME}"
    exit 1
  fi
fi

BRANCH_DIR_NAME="$(sanitize_branch_for_path "${TARGET_BRANCH}")"
if [[ -z "${BRANCH_DIR_NAME}" ]]; then
  echo "Abort: sanitized branch path segment is empty for branch: ${TARGET_BRANCH}"
  exit 1
fi

WORKTREE_DIR="${HOME}/workspace/${REPO_NAME}/${BRANCH_DIR_NAME}/${TASK_NAME}"
WORKTREE_PARENT="$(dirname "${WORKTREE_DIR}")"

if [[ -e "${WORKTREE_DIR}" ]]; then
  echo "Abort: target worktree path already exists: ${WORKTREE_DIR}"
  exit 1
fi

mkdir -p "${WORKTREE_PARENT}"

if [[ "${BRANCH_NAME}" == "main" || "${BRANCH_NAME}" == "master" ]]; then
  git worktree add -b "${TARGET_BRANCH}" "${WORKTREE_DIR}" "${SOURCE_BRANCH}"
else
  git worktree add "${WORKTREE_DIR}" "${TARGET_BRANCH}"
fi

cd "${WORKTREE_DIR}"

echo "Worktree created: ${WORKTREE_DIR}"
echo "Branch in worktree: ${TARGET_BRANCH}"
echo "Current directory: $(pwd)"

if [[ "${INTERACTIVE_SHELL}" == "1" ]]; then
  if [[ -z "${SHELL:-}" ]]; then
    echo "Abort: SHELL is not set."
    exit 1
  fi
  exec "${SHELL}"
fi

echo "Non-interactive mode: worktree setup complete."
