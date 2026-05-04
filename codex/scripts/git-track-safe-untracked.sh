#!/usr/bin/env bash
set -euo pipefail

max_auto_images=5
max_image_size_bytes=1048576

eligible=()
skipped=()
needs_permission=()
auto_image_count=0
TASK_NAME="${1:-${CODEX_TASK_NAME:-}}"

usage() {
  echo "Usage (canonical): ./.codex/scripts/git-track-safe-untracked.sh [task-name]"
  echo "Usage (repo-local fallback): ./codex/scripts/git-track-safe-untracked.sh [task-name]"
  echo "Usage (home fallback): ${HOME}/.codex/scripts/git-track-safe-untracked.sh [task-name]"
}

if [ "$#" -gt 1 ]; then
  echo "Abort: too many arguments."
  usage
  exit 2
fi

if [ -n "$TASK_NAME" ] && ! [[ "$TASK_NAME" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "Abort: task-name must be kebab-case using lowercase letters, digits, and hyphens only."
  exit 2
fi

is_exception_env_file() {
  local path="$1"
  local repo_root
  local config_file

  [ "$path" = "development.env" ] && return 0

  repo_root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
  config_file="${repo_root}/codex/codex-config.yaml"
  [ -f "$config_file" ] || return 1

  awk '
    /^[[:space:]]*allowed_env_sample_files:[[:space:]]*$/ {in_list=1; next}
    in_list && /^[^[:space:]-]/ {exit}
    in_list && /^[[:space:]]*-[[:space:]]*/ {
      value=$0
      sub(/^[[:space:]]*-[[:space:]]*/, "", value)
      gsub(/^"|"$/, "", value)
      gsub(/^'\''|'\''$/, "", value)
      print value
    }
  ' "$config_file" | grep -Fx -- "$path" >/dev/null 2>&1
}

infer_task_name_from_untracked() {
  local inferred=""
  local candidate=""

  while IFS= read -r -d '' path; do
    case "$path" in
      tasks/*/*|goals/*/*)
        candidate="${path#*/}"
        candidate="${candidate%%/*}"
        ;;
      *)
        continue
        ;;
    esac

    if ! [[ "$candidate" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
      continue
    fi

    if [ -z "$inferred" ]; then
      inferred="$candidate"
    elif [ "$inferred" != "$candidate" ]; then
      echo ""
      return 0
    fi
  done < <(git ls-files -o --exclude-standard -z)

  echo "$inferred"
}

if [ -z "$TASK_NAME" ]; then
  TASK_NAME="$(infer_task_name_from_untracked)"
fi

is_task_owned_untracked_path() {
  local path="$1"

  [ -n "$TASK_NAME" ] || return 1

  case "$path" in
    "tasks/${TASK_NAME}/"*|"goals/${TASK_NAME}/"*)
      return 0
      ;;
  esac

  return 1
}

is_env_like_file() {
  case "$1" in
    .env|.env.*|*.env|*.env.*)
      return 0
      ;;
  esac
  return 1
}

is_forbidden_dir_path() {
  case "$1" in
    node_modules/*|\
    .venv/*|\
    venv/*|\
    .pytest_cache/*|\
    .mypy_cache/*|\
    .ruff_cache/*|\
    .cache/*|\
    dist/*|\
    build/*|\
    bin/*|\
    out/*|\
    target/*)
      return 0
      ;;
  esac
  return 1
}

is_compiled_or_cache_path() {
  case "$1" in
    __pycache__/*|*/__pycache__/*|\
    *.pyc|*.pyo|*.o|*.class)
      return 0
      ;;
  esac
  return 1
}

to_lower() {
  printf '%s' "$1" | tr '[:upper:]' '[:lower:]'
}

file_size_bytes() {
  local size
  size="$(wc -c < "$1")"
  size="${size//[[:space:]]/}"
  printf '%s' "$size"
}

while IFS= read -r -d '' path; do
  base="${path##*/}"
  lower_path="$(to_lower "$path")"

  if [ "$base" = ".DS_Store" ]; then
    skipped+=("$path (forbidden file: .DS_Store)")
    continue
  fi

  if is_forbidden_dir_path "$path"; then
    skipped+=("$path (forbidden directory)")
    continue
  fi

  if is_compiled_or_cache_path "$path"; then
    skipped+=("$path (compiled/cache output)")
    continue
  fi

  if ! is_exception_env_file "$path" && is_env_like_file "$base"; then
    skipped+=("$path (env-like file)")
    continue
  fi

  if ! is_task_owned_untracked_path "$path"; then
    needs_permission+=("$path (untracked path outside task scope)")
    continue
  fi

  case "$lower_path" in
    *.mp4|*.mp3)
      skipped+=("$path (video/audio not allowed)")
      continue
      ;;
  esac

  case "$lower_path" in
    *.psd|*.zip|*.dll|*.exe|*.zstd|*.gz|*.pdf)
      skipped+=("$path (non-media binary not allowed)")
      continue
      ;;
  esac

  case "$lower_path" in
    *.tar|*.tar.gz|*.tgz|*.tar.zst|*.tar.bz2|*.tar.xz)
      skipped+=("$path (tar archive not allowed)")
      continue
      ;;
  esac

  case "$lower_path" in
    *.jpg|*.jpeg|*.png|*.gif|*.svg)
      size_bytes="$(file_size_bytes "$path")"
      if [ "$size_bytes" -gt "$max_image_size_bytes" ]; then
        needs_permission+=("$path (image exceeds 1MB)")
        continue
      fi

      auto_image_count=$((auto_image_count + 1))
      if [ "$auto_image_count" -gt "$max_auto_images" ]; then
        needs_permission+=("$path (more than 5 images)")
        continue
      fi
      ;;
  esac

  eligible+=("$path")
done < <(git ls-files -o --exclude-standard -z)

if [ "${#eligible[@]}" -gt 0 ]; then
  git add -N -- "${eligible[@]}"
fi

echo "Intent-to-add staged files: ${#eligible[@]}"
if [ "${#eligible[@]}" -gt 0 ]; then
  printf '%s\n' "${eligible[@]}"
fi

if [ "${#skipped[@]}" -gt 0 ]; then
  echo
  echo "Skipped files: ${#skipped[@]}"
  printf '%s\n' "${skipped[@]}"
fi

if [ "${#needs_permission[@]}" -gt 0 ]; then
  echo
  echo "Permission-required files (not added): ${#needs_permission[@]}"
  printf '%s\n' "${needs_permission[@]}"
  echo "Action required: request explicit user approval before adding these files, or stage intended paths explicitly with git-stage-safe.sh."
fi
