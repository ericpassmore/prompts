#!/usr/bin/env bash
set -euo pipefail

TASK_NAME="${1:-}"
BASE_BRANCH="${2:-}"
ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
TASK_DIR="${ROOT_DIR}/tasks/${TASK_NAME}"
REVALIDATE_FILE="${TASK_DIR}/revalidate.md"
REVIEW_FILE="${TASK_DIR}/revalidate-code-review.md"
RISK_ACCEPTANCE_FILE="${TASK_DIR}/risk-acceptance.md"
LIFECYCLE_STATE_FILE="${TASK_DIR}/lifecycle-state.md"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  echo "Usage (canonical): ./.codex/scripts/revalidate-validate.sh <task-name> [base-branch]"
  echo "Usage (repo-local fallback): ./codex/scripts/revalidate-validate.sh <task-name> [base-branch]"
  echo "Usage (home fallback): ${HOME}/.codex/scripts/revalidate-validate.sh <task-name> [base-branch]"
}

if [[ -z "${TASK_NAME}" ]]; then
  usage
  exit 2
fi

if [[ ! "${TASK_NAME}" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "Abort: task-name must be kebab-case using lowercase letters, digits, and hyphens only."
  exit 2
fi

issues=()

if [[ ! -d "${TASK_DIR}" ]]; then
  issues+=("Missing task directory: ${TASK_DIR}")
fi

if [[ ! -f "${REVALIDATE_FILE}" ]]; then
  issues+=("Missing required file: ${REVALIDATE_FILE}")
fi

if [[ ! -f "${REVIEW_FILE}" ]]; then
  issues+=("Missing required file: ${REVIEW_FILE}")
fi

# Step 4 gate: code review must validate successfully.
review_cmd=( "${SCRIPT_DIR}/revalidate-code-review.sh" "${TASK_NAME}" )
if [[ -n "${BASE_BRANCH}" ]]; then
  review_cmd+=( "${BASE_BRANCH}" )
fi

review_output=""
if ! review_output="$("${review_cmd[@]}" 2>&1)"; then
  issues+=("Code review validation failed via revalidate-code-review.sh.")
  while IFS= read -r line; do
    [[ -z "${line}" ]] && continue
    issues+=("  ${line}")
  done <<< "${review_output}"
fi

verdict=""
trigger_source=""
review_status=""
review_verdict=""
findings_json=""
findings_compact=""
stage3_runs="0"
drift_revalidation_count="0"
if [[ -f "${REVALIDATE_FILE}" ]]; then
  trigger_source="$(sed -nE 's/^- Trigger source:[[:space:]]*(drift|ready-for-reverification)[[:space:]]*$/\1/p' "${REVALIDATE_FILE}" | head -n 1)"
  if [[ -z "${trigger_source}" ]]; then
    issues+=("Missing or invalid '- Trigger source:' in ${REVALIDATE_FILE}. Use drift or ready-for-reverification.")
  fi

  verdict="$(sed -nE 's/^- Final verdict:[[:space:]]*(READY TO REPLAN|READY TO LAND|BLOCKED)[[:space:]]*$/\1/p' "${REVALIDATE_FILE}" | head -n 1)"
  if [[ -z "${verdict}" ]]; then
    issues+=("Missing or invalid '- Final verdict:' in ${REVALIDATE_FILE}. Use READY TO REPLAN, READY TO LAND, or BLOCKED.")
  fi
fi

if [[ -f "${REVIEW_FILE}" ]]; then
  review_status="$(sed -nE 's/^- Findings status:[[:space:]]*(pending|complete|none)[[:space:]]*$/\1/p' "${REVIEW_FILE}" | head -n 1)"
  review_verdict="$(sed -nE 's/^- Verdict:[[:space:]]*(patch is correct|patch is incorrect)[[:space:]]*$/\1/p' "${REVIEW_FILE}" | head -n 1)"
  findings_json="$(awk '
    /^## Findings JSON$/ {in_section=1; next}
    in_section && /^```json$/ {in_json=1; next}
    in_section && /^```$/ && in_json {exit}
    in_json {print}
  ' "${REVIEW_FILE}")"
  findings_compact="$(printf '%s' "${findings_json}" | tr -d '[:space:]')"
fi

if [[ -f "${LIFECYCLE_STATE_FILE}" ]]; then
  stage3_runs="$(sed -nE 's/^- Stage 3 runs:[[:space:]]*([0-9]+)[[:space:]]*$/\1/p' "${LIFECYCLE_STATE_FILE}" | head -n 1)"
  drift_revalidation_count="$(sed -nE 's/^- Drift revalidation count:[[:space:]]*([0-9]+)[[:space:]]*$/\1/p' "${LIFECYCLE_STATE_FILE}" | head -n 1)"
  if [[ -z "${stage3_runs}" ]]; then
    stage3_runs="0"
    issues+=("Missing or invalid '- Stage 3 runs:' in ${LIFECYCLE_STATE_FILE}.")
  fi
  if [[ -z "${drift_revalidation_count}" ]]; then
    drift_revalidation_count="0"
    issues+=("Missing or invalid '- Drift revalidation count:' in ${LIFECYCLE_STATE_FILE}.")
  fi
fi

has_valid_risk_acceptance_waiver() {
  [[ -f "${RISK_ACCEPTANCE_FILE}" ]] || return 1

  local owner
  local justification
  local expiry
  owner="$(sed -nE 's/^- Owner:[[:space:]]*(.+)$/\1/p' "${RISK_ACCEPTANCE_FILE}" | head -n 1)"
  justification="$(sed -nE 's/^- Justification:[[:space:]]*(.+)$/\1/p' "${RISK_ACCEPTANCE_FILE}" | head -n 1)"
  expiry="$(sed -nE 's/^- Expiry:[[:space:]]*([0-9]{4}-[0-9]{2}-[0-9]{2})[[:space:]]*$/\1/p' "${RISK_ACCEPTANCE_FILE}" | head -n 1)"

  [[ -n "${owner}" && -n "${justification}" && -n "${expiry}" ]]
}

if [[ -n "${trigger_source}" && -n "${verdict}" ]]; then
  case "${trigger_source}" in
    drift)
      if [[ "${verdict}" == "READY TO LAND" ]]; then
        issues+=("Trigger source is drift; READY TO LAND is not permitted. Use READY TO REPLAN or BLOCKED.")
      fi
      ;;
    ready-for-reverification)
      if [[ "${verdict}" == "READY TO REPLAN" ]]; then
        issues+=("Trigger source is ready-for-reverification; READY TO REPLAN is not permitted. Use READY TO LAND or BLOCKED.")
      fi
      if [[ "${verdict}" == "READY TO LAND" && "${stage3_runs}" -lt 2 ]]; then
        issues+=("READY TO LAND requires at least 2 total Stage 3 executions; detected ${stage3_runs}.")
      fi
      if [[ "${verdict}" == "READY TO LAND" && "${drift_revalidation_count}" -lt 1 ]]; then
        issues+=("READY TO LAND requires at least 1 drift revalidation cycle before landing; detected ${drift_revalidation_count}.")
      fi
      ;;
  esac
fi

if [[ "${verdict}" == "READY TO LAND" ]]; then
  if [[ "${review_status}" != "none" || "${findings_compact}" != "[]" || "${review_verdict}" != "patch is correct" ]]; then
    if ! has_valid_risk_acceptance_waiver; then
      issues+=("READY TO LAND requires no open review findings and review verdict 'patch is correct'. Provide a valid ${RISK_ACCEPTANCE_FILE} waiver to proceed with unresolved findings.")
    fi
  fi
fi

update_drift_revalidation_count() {
  local lifecycle_exists="0"
  local stage3_runs_local="0"
  local current_cycle_local="0"
  local last_validated_cycle_local="0"
  local drift_revalidation_count_local="0"

  [[ -f "${LIFECYCLE_STATE_FILE}" ]] && lifecycle_exists="1"

  if [[ "${lifecycle_exists}" == "1" ]]; then
    stage3_runs_local="$(sed -nE 's/^- Stage 3 runs:[[:space:]]*([0-9]+)[[:space:]]*$/\1/p' "${LIFECYCLE_STATE_FILE}" | head -n 1)"
    current_cycle_local="$(sed -nE 's/^- Stage 3 current cycle:[[:space:]]*([0-9]+)[[:space:]]*$/\1/p' "${LIFECYCLE_STATE_FILE}" | head -n 1)"
    last_validated_cycle_local="$(sed -nE 's/^- Stage 3 last validated cycle:[[:space:]]*([0-9]+)[[:space:]]*$/\1/p' "${LIFECYCLE_STATE_FILE}" | head -n 1)"
    drift_revalidation_count_local="$(sed -nE 's/^- Drift revalidation count:[[:space:]]*([0-9]+)[[:space:]]*$/\1/p' "${LIFECYCLE_STATE_FILE}" | head -n 1)"
  fi

  [[ "${stage3_runs_local}" =~ ^[0-9]+$ ]] || stage3_runs_local="0"
  [[ "${current_cycle_local}" =~ ^[0-9]+$ ]] || current_cycle_local="0"
  [[ "${last_validated_cycle_local}" =~ ^[0-9]+$ ]] || last_validated_cycle_local="0"
  [[ "${drift_revalidation_count_local}" =~ ^[0-9]+$ ]] || drift_revalidation_count_local="0"

  drift_revalidation_count_local=$((drift_revalidation_count_local + 1))

  cat > "${LIFECYCLE_STATE_FILE}" <<EOF
# Lifecycle State
- Stage 3 runs: ${stage3_runs_local}
- Stage 3 current cycle: ${current_cycle_local}
- Stage 3 last validated cycle: ${last_validated_cycle_local}
- Drift revalidation count: ${drift_revalidation_count_local}
EOF
}

if [[ "${#issues[@]}" -gt 0 ]]; then
  echo "BLOCKED"
  for issue in "${issues[@]}"; do
    echo "- ${issue}"
  done
  exit 1
fi

if [[ "${verdict}" == "BLOCKED" ]]; then
  echo "BLOCKED"
  echo "- Final verdict in ${REVALIDATE_FILE} is BLOCKED."
  exit 1
fi

if [[ "${trigger_source}" == "drift" && "${verdict}" == "READY TO REPLAN" ]]; then
  update_drift_revalidation_count
fi

echo "${verdict}"
exit 0
