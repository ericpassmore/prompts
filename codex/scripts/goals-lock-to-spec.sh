#!/usr/bin/env bash
set -euo pipefail

TASK_NAME="$1"
ITERATION="$2"

if [[ -z "$TASK_NAME" || -z "$ITERATION" ]]; then
  echo "ERROR: TASK_NAME_IN_KEBAB_CASE and iteration (vN) are required"
  exit 1
fi

GOALS_FILE="./goals/${TASK_NAME}/goals.${ITERATION}.md"
SPEC_FILE="./tasks/${TASK_NAME}/spec.md"
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
    if [[ -f "${candidate}/tasks/_templates/spec.template.md" ]]; then
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

SPEC_TEMPLATE="${CODEX_ROOT_RESOLVED}/tasks/_templates/spec.template.md"

if [[ ! -f "$GOALS_FILE" ]]; then
  echo "ERROR: Missing $GOALS_FILE"
  exit 1
fi

STATE=$(sed -n 's/^- State: //p; s/^State: //p' "$GOALS_FILE" | head -n 1)

if [[ "$STATE" != "locked" ]]; then
  echo "ERROR: Goals must be locked before copying to spec (state=${STATE})"
  exit 1
fi

mkdir -p "./tasks/${TASK_NAME}"

cp "$SPEC_TEMPLATE" "$SPEC_FILE"

extract_section_body() {
  local section_regex="$1"
  awk -v section_regex="$section_regex" '
    $0 ~ section_regex {in_section=1; next}
    /^## / && in_section {exit}
    in_section {print}
  ' "$GOALS_FILE"
}

{
  echo
  echo "## Goals (locked from ${ITERATION})"
  extract_section_body '^## Goals'
  echo
  echo "## Non-goals"
  extract_section_body '^## Non-goals'
  echo
  echo "## Success criteria"
  extract_section_body '^## Success criteria'
} >> "$SPEC_FILE"

echo "Locked goals copied to ${SPEC_FILE}"
