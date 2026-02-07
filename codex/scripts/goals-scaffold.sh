#!/usr/bin/env bash
set -euo pipefail

TASK_NAME="$1"
ITERATION="${2:-v0}"

if [[ -z "$TASK_NAME" ]]; then
  echo "ERROR: TASK_NAME_IN_KEBAB_CASE is required"
  exit 1
fi

GOALS_DIR="./goals/${TASK_NAME}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_CODEX_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

resolve_codex_root() {
  local candidate
  local candidates=()

  if [[ -n "${CODEX_ROOT:-}" ]]; then
    candidates+=("${CODEX_ROOT}")
  fi

  candidates+=("${SCRIPT_CODEX_ROOT}" "./.codex" "./codex" "${HOME}/.codex")

  for candidate in "${candidates[@]}"; do
    if [[ -f "${candidate}/goals/establish-goals.template.md" ]]; then
      echo "${candidate}"
      return 0
    fi
  done

  return 1
}

if ! CODEX_ROOT_RESOLVED="$(resolve_codex_root)"; then
  echo "ERROR: Unable to resolve codex root (checked script root, ./.codex, ./codex, \$HOME/.codex)"
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
