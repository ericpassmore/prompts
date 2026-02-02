#!/usr/bin/env bash
set -euo pipefail

TASK_NAME="$1"
ITERATION="$2"

if [[ -z "$TASK_NAME" || -z "$ITERATION" ]]; then
  echo "ERROR: TASK_NAME_IN_KEBAB_CASE and iteration (vN) are required"
  exit 1
fi

GOALS_FILE="./.codex/goals/${TASK_NAME}/goals.${ITERATION}.md"
SPEC_FILE="./tasks/${TASK_NAME}/spec.md"
SPEC_TEMPLATE="./.codex/tasks/_templates/spec.template.md"

if [[ ! -f "$GOALS_FILE" ]]; then
  echo "ERROR: Missing $GOALS_FILE"
  exit 1
fi

STATE=$(sed -n 's/^State: //p' "$GOALS_FILE" | head -n 1)

if [[ "$STATE" != "locked" ]]; then
  echo "ERROR: Goals must be locked before copying to spec (state=${STATE})"
  exit 1
fi

mkdir -p "./tasks/${TASK_NAME}"

cp "$SPEC_TEMPLATE" "$SPEC_FILE"

{
  echo
  echo "## Goals (locked from ${ITERATION})"
  sed -n '/^## Goals/,/^## /p' "$GOALS_FILE" | sed '$d'
  echo
  echo "## Non-goals"
  sed -n '/^## Non-goals/,/^## /p' "$GOALS_FILE" | sed '$d'
  echo
  echo "## Success criteria"
  sed -n '/^## Success criteria/,/^## /p' "$GOALS_FILE" | sed '$d'
} >> "$SPEC_FILE"

echo "Locked goals copied to ${SPEC_FILE}"
