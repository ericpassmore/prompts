#!/usr/bin/env bash
set -euo pipefail

TASK_NAME="${1:-}"
COMPLEXITY_INPUT="${2:-medium}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

# shellcheck source=/dev/null
source "${SCRIPT_DIR}/resolve-codex-root.sh"

# shellcheck source=/dev/null
if [[ -f "${SCRIPT_DIR}/read-codex-paths.sh" ]]; then
  source "${SCRIPT_DIR}/read-codex-paths.sh" >/dev/null 2>&1 || true
fi

usage() {
  echo "Usage (canonical): ./.codex/scripts/prepare-phased-impl-scaffold.sh <task-name> [simple|medium|complex|1|2|3|4]"
  echo "Usage (repo-local fallback): ./codex/scripts/prepare-phased-impl-scaffold.sh <task-name> [simple|medium|complex|1|2|3|4]"
  echo "Usage (home fallback): ${HOME}/.codex/scripts/prepare-phased-impl-scaffold.sh <task-name> [simple|medium|complex|1|2|3|4]"
}

if [[ -z "${TASK_NAME}" ]]; then
  usage
  exit 2
fi

if [[ ! "${TASK_NAME}" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "Abort: task-name must be kebab-case using lowercase letters, digits, and hyphens only."
  exit 2
fi

phase_count_from_complexity() {
  case "$1" in
    simple) echo "2" ;;
    medium) echo "3" ;;
    complex) echo "4" ;;
    1|2|3|4) echo "$1" ;;
    *)
      echo "Abort: complexity must be simple, medium, complex, or a phase count in [1..4]."
      exit 2
      ;;
  esac
}

PHASE_COUNT="$(phase_count_from_complexity "${COMPLEXITY_INPUT}")"
TASK_DIR="${ROOT_DIR}/tasks/${TASK_NAME}"
SPEC_FILE="${TASK_DIR}/spec.md"
FINAL_PHASE_FILE="${TASK_DIR}/final-phase.md"
PHASE_PLAN_FILE="${TASK_DIR}/phase-plan.md"
SCOPE_LOCK_FILE="${TASK_DIR}/.scope-lock.md"

if [[ ! -d "${TASK_DIR}" ]]; then
  echo "Abort: missing task directory ${TASK_DIR}"
  exit 1
fi

if [[ ! -f "${SPEC_FILE}" ]]; then
  echo "Abort: missing ${SPEC_FILE}"
  exit 1
fi

if ! grep -q 'READY FOR PLANNING' "${SPEC_FILE}"; then
  echo "Abort: hard precondition failed; ${SPEC_FILE} must contain READY FOR PLANNING."
  exit 1
fi

if [[ ! -f "${FINAL_PHASE_FILE}" ]]; then
  echo "Abort: missing ${FINAL_PHASE_FILE}"
  exit 1
fi

# Enforce Stage 3 archival on restart/rerun when prior Stage 3 records exist.
if [[ -f "${PHASE_PLAN_FILE}" || -f "${SCOPE_LOCK_FILE}" ]]; then
  "${SCRIPT_DIR}/prepare-phased-impl-archive.sh" "${TASK_NAME}"
fi

if ! CODEX_ROOT_RESOLVED="$(resolve_codex_root tasks/_templates/phase.template.md)"; then
  echo "Abort: unable to resolve codex root for phase template."
  exit 1
fi

PHASE_TEMPLATE="${CODEX_ROOT_RESOLVED}/tasks/_templates/phase.template.md"
if [[ ! -f "${PHASE_TEMPLATE}" ]]; then
  echo "Abort: missing template ${PHASE_TEMPLATE}"
  exit 1
fi

created_files=()
for n in $(seq 1 "${PHASE_COUNT}"); do
  phase_file="${TASK_DIR}/phase-${n}.md"
  if [[ ! -f "${phase_file}" ]]; then
    sed "s/{{PHASE_N}}/${n}/g" "${PHASE_TEMPLATE}" > "${phase_file}"
    created_files+=("${phase_file}")
  fi
done

if ! grep -q '^## Implementation phase strategy$' "${SPEC_FILE}"; then
  {
    echo
    echo "## Implementation phase strategy"
    echo "- Complexity: ${COMPLEXITY_INPUT}"
    echo "- Active phases: 1..${PHASE_COUNT}"
    echo "- No new scope introduced: required"
  } >> "${SPEC_FILE}"
fi

cat > "${PHASE_PLAN_FILE}" <<EOF
# Phase Plan
- Task name: ${TASK_NAME}
- Complexity: ${COMPLEXITY_INPUT}
- Phase count: ${PHASE_COUNT}
- Active phases: 1..${PHASE_COUNT}
- Verdict: PENDING

## Constraints
- no code/config changes are allowed except phase-plan document updates under ./tasks/*
- no new scope is allowed; scope drift is BLOCKED
EOF

echo "Prepared phased implementation plan scaffold for ${TASK_NAME}"
echo "Phase count: ${PHASE_COUNT}"
echo "Phase plan: ${PHASE_PLAN_FILE}"
if [[ "${#created_files[@]}" -gt 0 ]]; then
  echo "Created phase files:"
  for f in "${created_files[@]}"; do
    echo "  - ${f}"
  done
else
  echo "No new phase files created (required files already existed)."
fi
