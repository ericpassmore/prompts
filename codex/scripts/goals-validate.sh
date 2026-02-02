#!/usr/bin/env bash
set -euo pipefail

TASK_NAME="$1"
ITERATION="$2"

if [[ -z "$TASK_NAME" || -z "$ITERATION" ]]; then
  echo "ERROR: TASK_NAME_IN_KEBAB_CASE and iteration (vN) are required"
  exit 1
fi

GOALS_FILE="./.codex/goals/${TASK_NAME}/goals.${ITERATION}.md"

if [[ ! -f "$GOALS_FILE" ]]; then
  echo "ERROR: Missing $GOALS_FILE"
  exit 1
fi

STATE=$(sed -n 's/^State: //p' "$GOALS_FILE" | head -n 1)

GOAL_COUNT=$(sed -n '/^## Goals/,/^## /p' "$GOALS_FILE" | grep -E '^[0-9]+\.' | wc -l | tr -d ' ')

if [[ "$GOAL_COUNT" -gt 5 ]]; then
  echo "ERROR: Too many goals (${GOAL_COUNT}); max is 5"
  exit 1
fi

if [[ "$GOAL_COUNT" -eq 0 && "$STATE" != "blocked" ]]; then
  echo "ERROR: Zero goals requires State=blocked"
  exit 1
fi

if [[ "$GOAL_COUNT" -gt 0 ]]; then
  SUCCESS_COUNT=$(sed -n '/^## Success criteria/,/^## /p' "$GOALS_FILE" | grep -E '^\-' | wc -l | tr -d ' ')
  if [[ "$SUCCESS_COUNT" -eq 0 ]]; then
    echo "ERROR: Goals present but no success criteria defined"
    exit 1
  fi
fi

echo "Validation passed for ${TASK_NAME} ${ITERATION}"
