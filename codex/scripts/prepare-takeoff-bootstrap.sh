#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/resolve-codex-root.sh"

DEST_MANIFEST="${ROOT_DIR}/codex-commands.md"

BOOTSTRAP_START="<!-- PREPARE-TAKEOFF BOOTSTRAP START -->"
BOOTSTRAP_END="<!-- PREPARE-TAKEOFF BOOTSTRAP END -->"

copy_manifest_if_missing() {
  local source

  [[ -f "${DEST_MANIFEST}" ]] && return 0

  for source in \
    "${ROOT_DIR}/.codex/codex-commands.md" \
    "${ROOT_DIR}/codex/codex-commands.md" \
    "${HOME}/.codex/codex-commands.md"; do
    if [[ -f "${source}" ]]; then
      cp "${source}" "${DEST_MANIFEST}"
      echo "Bootstrap: copied codex-commands from ${source}"
      return 0
    fi
  done

  echo "Abort: unable to bootstrap ./codex-commands.md (no source found)."
  return 1
}

append_bootstrap_block() {
  local manifest="$1"
  local selected_root="$2"
  local selected_scripts="$3"

  cat >> "${manifest}" <<EOF

${BOOTSTRAP_START}
- CODEX_ROOT: ${selected_root}
- CODEX_SCRIPTS_DIR: ${selected_scripts}
- Canonical scripts path: ./.codex/scripts
- Repository-local fallback scripts path: ./codex/scripts
- Home fallback scripts path: \$HOME/.codex/scripts
${BOOTSTRAP_END}
EOF
}

replace_bootstrap_block() {
  local manifest="$1"
  local selected_root="$2"
  local selected_scripts="$3"
  local tmp_file

  tmp_file="$(mktemp)"

  awk -v start="${BOOTSTRAP_START}" -v end="${BOOTSTRAP_END}" '
    BEGIN {in_block=0}
    index($0, start) {in_block=1; next}
    index($0, end) {in_block=0; next}
    !in_block {print}
  ' "${manifest}" > "${tmp_file}"

  mv "${tmp_file}" "${manifest}"
  append_bootstrap_block "${manifest}" "${selected_root}" "${selected_scripts}"
}

if ! copy_manifest_if_missing; then
  exit 1
fi

if ! SELECTED_CODEX_ROOT="$(resolve_codex_root scripts/task-scaffold.sh scripts/prepare-takeoff-worktree.sh codex-commands.md)"; then
  echo "Abort: unable to resolve CODEX_ROOT with required files."
  echo "Checked: ${ROOT_DIR}/.codex, ${ROOT_DIR}/codex, ${HOME}/.codex"
  exit 1
fi

SELECTED_SCRIPTS_DIR="${SELECTED_CODEX_ROOT}/scripts"

if [[ ! -f "${DEST_MANIFEST}" ]]; then
  echo "Abort: codex-commands manifest missing after bootstrap."
  exit 1
fi

if grep -qF "${BOOTSTRAP_START}" "${DEST_MANIFEST}"; then
  replace_bootstrap_block "${DEST_MANIFEST}" "${SELECTED_CODEX_ROOT}" "${SELECTED_SCRIPTS_DIR}"
else
  append_bootstrap_block "${DEST_MANIFEST}" "${SELECTED_CODEX_ROOT}" "${SELECTED_SCRIPTS_DIR}"
fi

echo "Selected CODEX_ROOT: ${SELECTED_CODEX_ROOT}"
echo "Selected CODEX_SCRIPTS_DIR: ${SELECTED_SCRIPTS_DIR}"
echo "Updated manifest: ${DEST_MANIFEST}"
