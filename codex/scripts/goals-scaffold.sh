#!/usr/bin/env bash
set -euo pipefail

TASK_NAME="$1"
ITERATION="${2:-v0}"

if [[ -z "$TASK_NAME" ]]; then
  echo "ERROR: TASK_NAME_IN_KEBAB_CASE is required"
  exit 1
fi

GOALS_DIR="./.codex/goals/${TASK_NAME}"
ESTABLISH_TEMPLATE="./.codex/goals/establish-goals.template.md"

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
