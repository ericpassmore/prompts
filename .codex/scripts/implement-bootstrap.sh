#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/resolve-codex-root.sh"

START="# IMPLEMENT BOOTSTRAP START"
END="# IMPLEMENT BOOTSTRAP END"

if ! CODEX_ROOT_SELECTED="$(resolve_codex_root scripts/task-scaffold.sh scripts/implement-preflight.sh project-structure.md)"; then
  echo "BLOCKED: unable to resolve a Codex root containing task scaffolding, implementation preflight, and project structure."
  exit 1
fi

CONFIG="${CODEX_ROOT_SELECTED}/codex-config.yaml"
if [[ ! -f "${CONFIG}" ]]; then
  for candidate in "${ROOT_DIR}/.codex/codex-config.yaml" "${ROOT_DIR}/codex/codex-config.yaml" "${HOME}/.codex/codex-config.yaml"; do
    if [[ -f "${candidate}" ]]; then
      cp "${candidate}" "${CONFIG}"
      break
    fi
  done
fi

if [[ ! -f "${CONFIG}" ]]; then
  printf 'code_review:\n  base_branch: main\n' > "${CONFIG}"
fi

tmp_file="$(mktemp "${CONFIG}.tmp.XXXXXX")"
awk -v start="${START}" -v end="${END}" '
  index($0, start) {skip=1; next}
  index($0, end) {skip=0; next}
  !skip {lines[++count]=$0}
  END {
    while (count > 0 && lines[count] ~ /^[[:space:]]*$/) count--
    for (i=1; i<=count; i++) print lines[i]
  }
' "${CONFIG}" > "${tmp_file}"

cat >> "${tmp_file}" <<EOF

${START}
bootstrap:
  codex_root: "${CODEX_ROOT_SELECTED}"
  codex_scripts_dir: "${CODEX_ROOT_SELECTED}/scripts"
${END}
EOF
mv "${tmp_file}" "${CONFIG}"

echo "CODEX_ROOT=${CODEX_ROOT_SELECTED}"
echo "CODEX_SCRIPTS_DIR=${CODEX_ROOT_SELECTED}/scripts"
