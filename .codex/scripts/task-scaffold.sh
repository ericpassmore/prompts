#!/usr/bin/env bash
set -euo pipefail

TASK_NAME="${1:-}"
if [[ -z "${TASK_NAME}" || ! "${TASK_NAME}" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "Usage: task-scaffold.sh <task-name>"
  exit 2
fi

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/resolve-codex-root.sh"

if ! CODEX_ROOT_SELECTED="$(resolve_codex_root tasks/_templates/spec.template.md)"; then
  echo "BLOCKED: unable to resolve spec template."
  exit 1
fi

TASK_DIR="${ROOT_DIR}/tasks/${TASK_NAME}"
SPEC_FILE="${TASK_DIR}/spec.md"
mkdir -p "${TASK_DIR}"

if [[ ! -f "${SPEC_FILE}" ]]; then
  cp "${CODEX_ROOT_SELECTED}/tasks/_templates/spec.template.md" "${SPEC_FILE}"
  echo "Created ${SPEC_FILE}"
else
  echo "Task spec already exists: ${SPEC_FILE}"
fi

echo "TASK SCAFFOLD READY"
