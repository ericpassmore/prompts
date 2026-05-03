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

git add -- "$@"
