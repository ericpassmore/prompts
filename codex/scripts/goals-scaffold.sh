#!/usr/bin/env bash
set -euo pipefail

TASK_NAME="${1:-}"
ITERATION="${2:-v0}"

if [[ -z "$TASK_NAME" ]]; then
  echo "ERROR: TASK_NAME_IN_KEBAB_CASE is required"
  exit 1
fi

if [[ ! "${TASK_NAME}" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "ERROR: TASK_NAME_IN_KEBAB_CASE must use lowercase letters, digits, and hyphens only"
  echo "Example: add-performer-search"
  exit 1
fi

GOALS_DIR="./goals/${TASK_NAME}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/resolve-codex-root.sh"

if ! CODEX_ROOT_RESOLVED="$(resolve_codex_root goals/establish-goals.template.md)"; then
  echo "ERROR: Unable to resolve codex root (checked ./.codex, ./codex, \$HOME/.codex)"
  exit 1
fi

ESTABLISH_TEMPLATE="${CODEX_ROOT_RESOLVED}/goals/establish-goals.template.md"

if [[ ! -f "$ESTABLISH_TEMPLATE" ]]; then
  echo "ERROR: Missing template $ESTABLISH_TEMPLATE"
  exit 1
fi

mkdir -p "$GOALS_DIR"

ESTABLISH_FILE="${GOALS_DIR}/establish-goals.${ITERATION}.md"
GOALS_FILE="${GOALS_DIR}/goals.${ITERATION}.md"

if [[ -f "$ESTABLISH_FILE" || -f "$GOALS_FILE" ]]; then
  echo "ERROR: Iteration ${ITERATION} already exists for task ${TASK_NAME}"
  exit 1
fi

cp "$ESTABLISH_TEMPLATE" "$ESTABLISH_FILE"

cat > "$GOALS_FILE" <<EOF
# Goals Extract
- Task name: ${TASK_NAME}
- Iteration: ${ITERATION}
- State: draft

## Goals (0–5)

## Non-goals

## Success criteria
EOF

echo "Scaffolded goals for task '${TASK_NAME}' (${ITERATION})"
