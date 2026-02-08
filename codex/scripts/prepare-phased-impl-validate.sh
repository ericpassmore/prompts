#!/usr/bin/env bash
set -euo pipefail

TASK_NAME="${1:-}"
ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
TASK_DIR="${ROOT_DIR}/tasks/${TASK_NAME}"
SPEC_FILE="${TASK_DIR}/spec.md"
PHASE_PLAN_FILE="${TASK_DIR}/phase-plan.md"
LOCK_FILE="${TASK_DIR}/.scope-lock.md"
FINAL_PHASE_FILE="${TASK_DIR}/final-phase.md"
LIFECYCLE_STATE_FILE="${TASK_DIR}/lifecycle-state.md"

usage() {
  echo "Usage (canonical): ./.codex/scripts/prepare-phased-impl-validate.sh <task-name>"
  echo "Usage (repo-local fallback): ./codex/scripts/prepare-phased-impl-validate.sh <task-name>"
  echo "Usage (home fallback): ${HOME}/.codex/scripts/prepare-phased-impl-validate.sh <task-name>"
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

extract_section_from_file() {
  local file="$1"
  local heading_regex="$2"
  awk -v heading_regex="${heading_regex}" '
    $0 ~ heading_regex {in_section=1; next}
    /^## / && in_section {exit}
    in_section {print}
  ' "${file}" | sed 's/[[:space:]]\+$//'
}

set_verdict() {
  local verdict="$1"
  local tmp_file

  if [[ ! -f "${PHASE_PLAN_FILE}" ]]; then
    return
  fi

  tmp_file="$(mktemp)"
  awk -v verdict="${verdict}" '
    BEGIN {updated=0}
    /^- Verdict:/ {print "- Verdict: " verdict; updated=1; next}
    {print}
    END {
      if (updated == 0) {
        print "- Verdict: " verdict
      }
    }
  ' "${PHASE_PLAN_FILE}" > "${tmp_file}"
  mv "${tmp_file}" "${PHASE_PLAN_FILE}"
}

update_lifecycle_stage3_runs() {
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

  if [[ "${current_cycle}" -eq 0 ]]; then
    current_cycle=1
  fi

  if [[ "${last_validated_cycle}" -lt "${current_cycle}" ]]; then
    stage3_runs=$((stage3_runs + 1))
    last_validated_cycle="${current_cycle}"
  fi

  cat > "${LIFECYCLE_STATE_FILE}" <<EOF
# Lifecycle State
- Stage 3 runs: ${stage3_runs}
- Stage 3 current cycle: ${current_cycle}
- Stage 3 last validated cycle: ${last_validated_cycle}
- Drift revalidation count: ${drift_revalidation_count}
EOF
}

if [[ ! -f "${SPEC_FILE}" ]]; then
  issues+=("Missing required file: ${SPEC_FILE}")
fi

if [[ ! -f "${PHASE_PLAN_FILE}" ]]; then
  issues+=("Missing required file: ${PHASE_PLAN_FILE}")
fi

if [[ ! -f "${LOCK_FILE}" ]]; then
  issues+=("Missing required scope lock file: ${LOCK_FILE}")
fi

if [[ ! -f "${FINAL_PHASE_FILE}" ]]; then
  issues+=("Missing required file: ${FINAL_PHASE_FILE}")
fi

if [[ -f "${SPEC_FILE}" ]]; then
  if ! grep -q 'READY FOR PLANNING' "${SPEC_FILE}"; then
    issues+=("Hard precondition failed: ${SPEC_FILE} does not contain READY FOR PLANNING")
  fi

  if [[ -n "$(extract_section_from_file "${SPEC_FILE}" '^##[[:space:]]+IN SCOPE$')" && \
        -n "$(extract_section_from_file "${SPEC_FILE}" '^##[[:space:]]+OUT OF SCOPE$')" ]]; then
    :
  else
    issues+=("Missing or empty scope sections in ${SPEC_FILE}: require ## IN SCOPE and ## OUT OF SCOPE")
  fi
fi

phase_count=""
if [[ -f "${PHASE_PLAN_FILE}" ]]; then
  phase_count="$(sed -n 's/^- Phase count: \([1-4]\)$/\1/p' "${PHASE_PLAN_FILE}" | head -n 1)"
  if [[ -z "${phase_count}" ]]; then
    issues+=("Unable to parse '- Phase count: <1-4>' from ${PHASE_PLAN_FILE}")
  fi
fi

if [[ -n "${phase_count}" ]]; then
  for n in $(seq 1 "${phase_count}"); do
    phase_file="${TASK_DIR}/phase-${n}.md"
    if [[ ! -f "${phase_file}" ]]; then
      issues+=("Missing active phase file: ${phase_file}")
      continue
    fi

    if ! grep -q '^## Objective$' "${phase_file}"; then
      issues+=("Missing '## Objective' in ${phase_file}")
    fi
    if ! grep -q '^## Work items$' "${phase_file}"; then
      issues+=("Missing '## Work items' in ${phase_file}")
    fi
    if ! grep -q '^## Gate (must pass before proceeding)$' "${phase_file}"; then
      issues+=("Missing gate section in ${phase_file}")
    fi
    if ! grep -q '^## Verification steps$' "${phase_file}"; then
      issues+=("Missing verification steps section in ${phase_file}")
    fi
  done
fi

if [[ -f "${LOCK_FILE}" && -f "${SPEC_FILE}" ]]; then
  locked_in="$(extract_section_from_file "${LOCK_FILE}" '^##[[:space:]]+IN SCOPE$')"
  locked_out="$(extract_section_from_file "${LOCK_FILE}" '^##[[:space:]]+OUT OF SCOPE$')"
  current_in="$(extract_section_from_file "${SPEC_FILE}" '^##[[:space:]]+IN SCOPE$')"
  current_out="$(extract_section_from_file "${SPEC_FILE}" '^##[[:space:]]+OUT OF SCOPE$')"

  if [[ "${locked_in}" != "${current_in}" || "${locked_out}" != "${current_out}" ]]; then
    issues+=("No-new-scope hard stop: scope sections changed since lock snapshot (${LOCK_FILE})")
  fi
fi

if [[ "${#issues[@]}" -eq 0 ]]; then
  update_lifecycle_stage3_runs
  set_verdict "READY FOR IMPLEMENTATION"
  echo "READY FOR IMPLEMENTATION"
  exit 0
fi

set_verdict "BLOCKED"
echo "BLOCKED"
for issue in "${issues[@]}"; do
  echo "- ${issue}"
done
exit 1
