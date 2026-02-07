#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFEST_PATH="${ROOT_DIR}/codex-commands.md"
BOOTSTRAP_START="<!-- PREPARE-TAKEOFF BOOTSTRAP START -->"
BOOTSTRAP_END="<!-- PREPARE-TAKEOFF BOOTSTRAP END -->"

# shellcheck source=/dev/null
source "${SCRIPT_DIR}/resolve-codex-root.sh"

read_codex_paths() {
  local block
  local parsed_root=""
  local parsed_scripts=""
  local fallback_root=""

  if [[ -f "${MANIFEST_PATH}" ]]; then
    block="$(awk -v s="${BOOTSTRAP_START}" -v e="${BOOTSTRAP_END}" '
      index($0, s) {in_block=1; next}
      index($0, e) {in_block=0}
      in_block {print}
    ' "${MANIFEST_PATH}")"

    parsed_root="$(printf '%s\n' "${block}" | sed -n 's/^- CODEX_ROOT: //p' | head -n 1)"
    parsed_scripts="$(printf '%s\n' "${block}" | sed -n 's/^- CODEX_SCRIPTS_DIR: //p' | head -n 1)"
  fi

  if [[ -n "${parsed_root}" && -n "${parsed_scripts}" && -d "${parsed_root}" && -d "${parsed_scripts}" ]]; then
    export CODEX_ROOT="${parsed_root}"
    export CODEX_SCRIPTS_DIR="${parsed_scripts}"
    return 0
  fi

  if ! fallback_root="$(resolve_codex_root scripts codex-commands.md)"; then
    echo "Abort: unable to resolve codex root from manifest or fallback search."
    return 1
  fi

  export CODEX_ROOT="${fallback_root}"
  export CODEX_SCRIPTS_DIR="${fallback_root}/scripts"
  return 0
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  if read_codex_paths; then
    echo "Resolved CODEX_ROOT: ${CODEX_ROOT}"
    echo "Resolved CODEX_SCRIPTS_DIR: ${CODEX_SCRIPTS_DIR}"
    exit 0
  fi
  exit 1
fi

if ! read_codex_paths; then
  return 1 2>/dev/null || exit 1
fi
