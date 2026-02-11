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
  echo "Usage (canonical): ./.codex/scripts/prepare-phased-impl-scaffold.sh <task-name> [simple|medium|complex|very-complex|surgical|focused|multi-surface|cross-system|program|2..20|@/path/to/complexity-signals.json]"
  echo "Usage (repo-local fallback): ./codex/scripts/prepare-phased-impl-scaffold.sh <task-name> [simple|medium|complex|very-complex|surgical|focused|multi-surface|cross-system|program|2..20|@/path/to/complexity-signals.json]"
  echo "Usage (home fallback): ${HOME}/.codex/scripts/prepare-phased-impl-scaffold.sh <task-name> [simple|medium|complex|very-complex|surgical|focused|multi-surface|cross-system|program|2..20|@/path/to/complexity-signals.json]"
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
  local input="$1"
  case "${input}" in
    simple|surgical) echo "2" ;;
    focused) echo "4" ;;
    medium) echo "6" ;;
    multi-surface) echo "8" ;;
    complex) echo "12" ;;
    cross-system) echo "13" ;;
    very-complex|program) echo "18" ;;
    *)
      if [[ "$1" =~ ^[0-9]+$ ]] && (( 10#$1 >= 2 && 10#$1 <= 20 )); then
        echo "$1"
      else
        echo "Abort: complexity must be a supported label or a phase count in [2..20]."
        exit 2
      fi
      ;;
  esac
}

COMPLEXITY_DESCRIPTOR="${COMPLEXITY_INPUT}"
SCORING_DETAILS=""
PHASE_COUNT=""

if [[ "${COMPLEXITY_INPUT}" == @* ]]; then
  scores_file="${COMPLEXITY_INPUT#@}"
  if [[ -z "${scores_file}" ]]; then
    echo "Abort: complexity signals file path must be provided after '@'."
    exit 2
  fi

  if [[ "${scores_file}" == /* ]]; then
    resolved_scores_file="${scores_file}"
  else
    resolved_scores_file="${ROOT_DIR}/${scores_file}"
  fi

  if [[ ! -f "${resolved_scores_file}" ]]; then
    echo "Abort: complexity signals file not found: ${resolved_scores_file}"
    exit 1
  fi

  score_script="${SCRIPT_DIR}/complexity-score.sh"
  if [[ ! -x "${score_script}" ]]; then
    echo "Abort: missing executable complexity scorer: ${score_script}"
    exit 1
  fi

  score_json="$("${score_script}" "${resolved_scores_file}" --format json)"
  PHASE_COUNT="$(echo "${score_json}" | jq -r '.recommended.phases')"
  recommended_goals="$(echo "${score_json}" | jq -r '.recommended.goals')"
  level="$(echo "${score_json}" | jq -r '.level')"
  level_name="$(echo "${score_json}" | jq -r '.level_name')"
  total_score="$(echo "${score_json}" | jq -r '.total_score')"
  force_l1="$(echo "${score_json}" | jq -r '.force_l1')"

  if [[ ! "${PHASE_COUNT}" =~ ^[0-9]+$ ]] || (( 10#${PHASE_COUNT} < 2 || 10#${PHASE_COUNT} > 20 )); then
    echo "Abort: invalid recommended phase count from complexity scorer."
    exit 1
  fi

  COMPLEXITY_DESCRIPTOR="scored:${level} (${level_name})"
  SCORING_DETAILS="score=${total_score}; recommended-goals=${recommended_goals}; forced-l1=${force_l1}; signals=${resolved_scores_file}"
else
  PHASE_COUNT="$(phase_count_from_complexity "${COMPLEXITY_INPUT}")"
fi

TASK_DIR="${ROOT_DIR}/tasks/${TASK_NAME}"
SPEC_FILE="${TASK_DIR}/spec.md"
FINAL_PHASE_FILE="${TASK_DIR}/final-phase.md"
PHASE_PLAN_FILE="${TASK_DIR}/phase-plan.md"
LIFECYCLE_STATE_FILE="${TASK_DIR}/lifecycle-state.md"

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

ensure_lifecycle_state_file() {
  local stage3_runs="0"
  local current_cycle="0"
  local last_validated_cycle="0"
  local drift_revalidation_count="0"

  if [[ -f "${LIFECYCLE_STATE_FILE}" ]]; then
    stage3_runs="$(sed -nE 's/^- Stage 3 runs:[[:space:]]*([0-9]+)[[:space:]]*$/\1/p' "${LIFECYCLE_STATE_FILE}" | head -n 1)"
    current_cycle="$(sed -nE 's/^- Stage 3 current cycle:[[:space:]]*([0-9]+)[[:space:]]*$/\1/p' "${LIFECYCLE_STATE_FILE}" | head -n 1)"
    last_validated_cycle="$(sed -nE 's/^- Stage 3 last validated cycle:[[:space:]]*([0-9]+)[[:space:]]*$/\1/p' "${LIFECYCLE_STATE_FILE}" | head -n 1)"
    drift_revalidation_count="$(sed -nE 's/^- Drift revalidation count:[[:space:]]*([0-9]+)[[:space:]]*$/\1/p' "${LIFECYCLE_STATE_FILE}" | head -n 1)"
  fi

  [[ "${stage3_runs}" =~ ^[0-9]+$ ]] || stage3_runs="0"
  [[ "${current_cycle}" =~ ^[0-9]+$ ]] || current_cycle="0"
  [[ "${last_validated_cycle}" =~ ^[0-9]+$ ]] || last_validated_cycle="0"
  [[ "${drift_revalidation_count}" =~ ^[0-9]+$ ]] || drift_revalidation_count="0"

  current_cycle=$((current_cycle + 1))

  cat > "${LIFECYCLE_STATE_FILE}" <<EOF
# Lifecycle State
- Stage 3 runs: ${stage3_runs}
- Stage 3 current cycle: ${current_cycle}
- Stage 3 last validated cycle: ${last_validated_cycle}
- Drift revalidation count: ${drift_revalidation_count}
EOF
}

ensure_lifecycle_state_file

# Enforce Stage 3 archival on restart/rerun when prior Stage 3 records exist.
archived_prior_stage3=0
shopt -s nullglob
existing_phase_files=( "${TASK_DIR}"/phase-[0-9]*.md )
shopt -u nullglob

# A standalone scope lock can exist on first run (Step 2 before scaffold) and
# must not trigger archival. Archive only when actual prior Stage 3 planning
# artifacts exist.
if [[ -f "${PHASE_PLAN_FILE}" || "${#existing_phase_files[@]}" -gt 0 ]]; then
  "${SCRIPT_DIR}/prepare-phased-impl-archive.sh" "${TASK_NAME}"
  archived_prior_stage3=1
fi

# Regenerate active scope lock after archival so validate never observes a moved lock.
if [[ "${archived_prior_stage3}" -eq 1 ]]; then
  "${SCRIPT_DIR}/prepare-phased-impl-scope-lock.sh" "${TASK_NAME}" >/dev/null
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
    echo "- Complexity: ${COMPLEXITY_DESCRIPTOR}"
    if [[ -n "${SCORING_DETAILS}" ]]; then
      echo "- Complexity scoring details: ${SCORING_DETAILS}"
    fi
    echo "- Active phases: 1..${PHASE_COUNT}"
    echo "- No new scope introduced: required"
  } >> "${SPEC_FILE}"
fi

cat > "${PHASE_PLAN_FILE}" <<EOF
# Phase Plan
- Task name: ${TASK_NAME}
- Complexity: ${COMPLEXITY_DESCRIPTOR}
- Phase count: ${PHASE_COUNT}
- Active phases: 1..${PHASE_COUNT}
- Verdict: PENDING

## Constraints
- no code/config changes are allowed except phase-plan document updates under ./tasks/*
- no new scope is allowed; scope drift is BLOCKED
EOF

if [[ -n "${SCORING_DETAILS}" ]]; then
  {
    echo
    echo "## Complexity scoring details"
    echo "- ${SCORING_DETAILS}"
  } >> "${PHASE_PLAN_FILE}"
fi

echo "Prepared phased implementation plan scaffold for ${TASK_NAME}"
echo "Phase count: ${PHASE_COUNT}"
echo "Phase plan: ${PHASE_PLAN_FILE}"
echo "Lifecycle state: ${LIFECYCLE_STATE_FILE}"
if [[ "${#created_files[@]}" -gt 0 ]]; then
  echo "Created phase files:"
  for f in "${created_files[@]}"; do
    echo "  - ${f}"
  done
else
  echo "No new phase files created (required files already existed)."
fi
