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
MANIFEST_FILE="./goals/task-manifest.csv"
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

current_date_utc() {
  date -u "+%Y-%m-%d"
}

file_epoch() {
  local file_path="$1"
  if stat -f "%m" "$file_path" >/dev/null 2>&1; then
    stat -f "%m" "$file_path"
    return 0
  fi
  stat -c "%Y" "$file_path"
}

epoch_to_date() {
  local epoch="$1"
  if date -u -r "$epoch" "+%Y-%m-%d" >/dev/null 2>&1; then
    date -u -r "$epoch" "+%Y-%m-%d"
    return 0
  fi
  date -u -d "@$epoch" "+%Y-%m-%d"
}

infer_first_create_date() {
  local manifest_date
  local task_dir="./goals/$1"
  local earliest_epoch=""
  local file_path
  local file_date_epoch

  if [[ -f "$MANIFEST_FILE" ]]; then
    manifest_date="$(awk -F',' -v task="$1" 'NR > 1 && $2 == task { print $3; exit }' "$MANIFEST_FILE")"
    if [[ -n "$manifest_date" ]]; then
      echo "$manifest_date"
      return 0
    fi
  fi

  shopt -s nullglob
  local goal_files=(
    "${task_dir}"/establish-goals.v*.md
    "${task_dir}"/goals.v*.md
    "${task_dir}"/establish-goals.*.md
    "${task_dir}"/goals.*.md
  )
  shopt -u nullglob

  for file_path in "${goal_files[@]}"; do
    [[ -f "$file_path" ]] || continue
    file_date_epoch="$(file_epoch "$file_path")"
    if [[ -z "$earliest_epoch" || "$file_date_epoch" -lt "$earliest_epoch" ]]; then
      earliest_epoch="$file_date_epoch"
    fi
  done

  if [[ -n "$earliest_epoch" ]]; then
    epoch_to_date "$earliest_epoch"
    return 0
  fi

  current_date_utc
}

rebuild_task_manifest() {
  local tmp_unsorted
  local tmp_sorted
  local task_dir
  local task
  local first_create_date
  local number=0

  tmp_unsorted="$(mktemp)"
  tmp_sorted="$(mktemp)"

  for task_dir in ./goals/*; do
    [[ -d "$task_dir" ]] || continue
    task="$(basename "$task_dir")"

    if [[ ! "${task}" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
      continue
    fi

    first_create_date="$(infer_first_create_date "$task")"
    printf "%s,%s\n" "$task" "$first_create_date" >> "$tmp_unsorted"
  done

  sort -t',' -k2,2 -k1,1 "$tmp_unsorted" > "$tmp_sorted"

  {
    echo "number,taskname,first_create_date"
    while IFS=',' read -r task first_create_date; do
      [[ -n "$task" ]] || continue
      number=$((number + 1))
      printf "%d,%s,%s\n" "$number" "$task" "$first_create_date"
    done < "$tmp_sorted"
  } > "$MANIFEST_FILE"

  rm -f "$tmp_unsorted" "$tmp_sorted"
}

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

rebuild_task_manifest

echo "Scaffolded goals for task '${TASK_NAME}' (${ITERATION})"
