#!/usr/bin/env bash
set -euo pipefail

TASK_NAME="$1"
ITERATION="$2"

if [[ -z "$TASK_NAME" || -z "$ITERATION" ]]; then
  echo "ERROR: TASK_NAME_IN_KEBAB_CASE and iteration (vN) are required"
  exit 1
fi

GOALS_FILE="./goals/${TASK_NAME}/goals.${ITERATION}.md"

if [[ ! -f "$GOALS_FILE" ]]; then
  echo "ERROR: Missing $GOALS_FILE"
  exit 1
fi

STATE=$(sed -n 's/^- State: //p; s/^State: //p' "$GOALS_FILE" | head -n 1)

GOAL_COUNT=$(sed -n '/^## Goals/,/^## /p' "$GOALS_FILE" | awk '/^[0-9]+\./ {count++} END {print count+0}')
SUCCESS_COUNT=$(sed -n '/^## Success criteria/,/^## /p' "$GOALS_FILE" | awk '/^-/ {count++} END {print count+0}')

if [[ "$GOAL_COUNT" -gt 5 ]]; then
  echo "ERROR: Too many goals (${GOAL_COUNT}); max is 5"
  exit 1
fi

if [[ "$GOAL_COUNT" -eq 0 ]]; then
  if [[ "$STATE" == "locked" ]]; then
    echo "ERROR: Locked state requires at least one goal"
    exit 1
  fi
  if [[ "$STATE" != "blocked" ]]; then
    echo "ERROR: Zero goals requires State=blocked"
    exit 1
  fi
fi

if [[ "$GOAL_COUNT" -gt 0 && "$SUCCESS_COUNT" -eq 0 ]]; then
  if [[ "$STATE" == "locked" ]]; then
    echo "ERROR: Locked state requires success criteria"
    exit 1
  fi
  echo "ERROR: Goals present but no success criteria defined"
  exit 1
fi

echo "Validation passed for ${TASK_NAME} ${ITERATION}"
