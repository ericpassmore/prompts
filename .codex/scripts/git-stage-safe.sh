#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage (canonical): ./.codex/scripts/git-stage-safe.sh <path>..."
  echo "Usage (repo-local fallback): ./codex/scripts/git-stage-safe.sh <path>..."
  echo "Usage (home fallback): ${HOME}/.codex/scripts/git-stage-safe.sh <path>..."
  echo "Example: ./codex/scripts/git-stage-safe.sh codex/skills/git-commit/SKILL.md"
}

if [[ "$#" -eq 0 ]]; then
  usage
  exit 2
fi

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
config_file="${repo_root}/codex/codex-config.yaml"

is_env_like_file() {
  case "$1" in
    .env|.env.*|*.env|*.env.*)
      return 0
      ;;
  esac
  return 1
}

is_allowed_env_sample_file() {
  local path="$1"

  if [[ "$path" == "development.env" ]]; then
    return 0
  fi

  if [[ -f "$config_file" ]] && awk '
    /^[[:space:]]*allowed_env_sample_files:[[:space:]]*$/ {in_list=1; next}
    in_list && /^[^[:space:]-]/ {exit}
    in_list && /^[[:space:]]*-[[:space:]]*/ {
      value=$0
      sub(/^[[:space:]]*-[[:space:]]*/, "", value)
      gsub(/^"|"$/, "", value)
      gsub(/^'\''|'\''$/, "", value)
      print value
    }
  ' "$config_file" | grep -Fx -- "$path" >/dev/null 2>&1; then
    git ls-files --error-unmatch -- "$path" >/dev/null 2>&1
    return
  fi

  return 1
}

for path in "$@"; do
  base="${path##*/}"
  if is_env_like_file "$base" && ! is_allowed_env_sample_file "$path"; then
    echo "Abort: refusing to stage env-like file '${path}'."
    echo "Allowed sample env files must be listed in codex/codex-config.yaml and already tracked, or be exactly development.env."
    exit 1
  fi
done

git add -- "$@"
