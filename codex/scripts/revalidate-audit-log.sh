#!/usr/bin/env bash
set -euo pipefail

TASK_NAME="${1:-}"
shift || true

BASE_BRANCH_OVERRIDE=""
STATUS="success"
REASON="none"

usage() {
  echo "Usage (canonical): ./.codex/scripts/revalidate-audit-log.sh <task-name> [--status success|blocked] [--reason <text>] [--base-branch <branch>]"
  echo "Usage (repo-local fallback): ./codex/scripts/revalidate-audit-log.sh <task-name> [--status success|blocked] [--reason <text>] [--base-branch <branch>]"
  echo "Usage (home fallback): ${HOME}/.codex/scripts/revalidate-audit-log.sh <task-name> [--status success|blocked] [--reason <text>] [--base-branch <branch>]"
}

if [[ -z "${TASK_NAME}" ]]; then
  usage
  exit 2
fi

if [[ ! "${TASK_NAME}" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "Abort: task-name must be kebab-case using lowercase letters, digits, and hyphens only."
  exit 2
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --status)
      STATUS="${2:-}"
      shift 2
      ;;
    --reason)
      REASON="${2:-}"
      shift 2
      ;;
    --base-branch)
      BASE_BRANCH_OVERRIDE="${2:-}"
      shift 2
      ;;
    *)
      echo "Abort: unknown argument '$1'."
      usage
      exit 2
      ;;
  esac
done

if [[ "${STATUS}" != "success" && "${STATUS}" != "blocked" ]]; then
  echo "Abort: --status must be one of success|blocked."
  exit 2
fi

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "${ROOT_DIR}" ]]; then
  echo "Abort: not inside a git repository."
  exit 1
fi

TASK_DIR="${ROOT_DIR}/tasks/${TASK_NAME}"
REVALIDATE_FILE="${TASK_DIR}/revalidate.md"
REVIEW_FILE="${TASK_DIR}/revalidate-code-review.md"
LIFECYCLE_STATE_FILE="${TASK_DIR}/lifecycle-state.md"
COMPLEXITY_SIGNALS_FILE="${TASK_DIR}/complexity-signals.json"
AUDIT_LOG_FILE="${TASK_DIR}/audit-log.md"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=/dev/null
source "${SCRIPT_DIR}/resolve-codex-root.sh"

if [[ ! -d "${TASK_DIR}" ]]; then
  echo "Abort: missing task directory ${TASK_DIR}"
  exit 1
fi

is_valid_branch() {
  local branch="$1"
  [[ "${branch}" =~ ^[A-Za-z0-9._/-]+$ ]] && [[ "${branch}" != *"<"* ]] && [[ "${branch}" != *">"* ]]
}

resolve_base_branch() {
  local candidate=""
  local codex_root=""
  local config_file=""

  if [[ -n "${BASE_BRANCH_OVERRIDE}" ]]; then
    if ! is_valid_branch "${BASE_BRANCH_OVERRIDE}"; then
      echo "Abort: invalid base branch override '${BASE_BRANCH_OVERRIDE}'."
      exit 1
    fi
    echo "${BASE_BRANCH_OVERRIDE}"
    return 0
  fi

  if codex_root="$(resolve_codex_root codex-config.yaml 2>/dev/null)"; then
    config_file="${codex_root}/codex-config.yaml"
    if [[ -f "${config_file}" ]]; then
      candidate="$(sed -nE 's/^[[:space:]]*base_branch:[[:space:]]*"?([A-Za-z0-9._\/-]+)"?[[:space:]]*$/\1/p' "${config_file}" | head -n 1)"
      if [[ -n "${candidate}" ]] && is_valid_branch "${candidate}"; then
        echo "${candidate}"
        return 0
      fi
    fi
  fi

  if [[ -f "${ROOT_DIR}/codex/codex-config.yaml" ]]; then
    candidate="$(sed -nE 's/^[[:space:]]*base_branch:[[:space:]]*"?([A-Za-z0-9._\/-]+)"?[[:space:]]*$/\1/p' "${ROOT_DIR}/codex/codex-config.yaml" | head -n 1)"
    if [[ -n "${candidate}" ]] && is_valid_branch "${candidate}"; then
      echo "${candidate}"
      return 0
    fi
  fi

  echo "main"
}

BASE_BRANCH="$(resolve_base_branch)"
DIFF_MODE="base-branch"
if DIFF_TEXT="$(git diff "${BASE_BRANCH}...HEAD" 2>/dev/null)"; then
  :
else
  DIFF_TEXT=""
fi

if [[ -z "${DIFF_TEXT}" ]]; then
  DIFF_MODE="fallback"
fi

if [[ "${DIFF_MODE}" == "base-branch" ]]; then
  CHANGED_FILES_RAW="$(git diff --name-only "${BASE_BRANCH}...HEAD" 2>/dev/null || true)"
  NUMSTAT_RAW="$(git diff --numstat "${BASE_BRANCH}...HEAD" 2>/dev/null || true)"
else
  CHANGED_FILES_RAW="$(git diff --name-only 2>/dev/null || true)"
  NUMSTAT_RAW="$(git diff --numstat 2>/dev/null || true)"
fi

CHANGED_FILES_COUNT="$(printf '%s\n' "${CHANGED_FILES_RAW}" | sed '/^[[:space:]]*$/d' | wc -l | tr -d ' ')"
LINES_ADDED=0
LINES_DELETED=0
while IFS=$'\t' read -r add_count delete_count _path; do
  [[ "${add_count}" =~ ^[0-9]+$ ]] && LINES_ADDED=$((LINES_ADDED + add_count))
  [[ "${delete_count}" =~ ^[0-9]+$ ]] && LINES_DELETED=$((LINES_DELETED + delete_count))
done <<< "${NUMSTAT_RAW}"

TRIGGER_SOURCE="unknown"
FINAL_VERDICT="unknown"
if [[ -f "${REVALIDATE_FILE}" ]]; then
  TRIGGER_SOURCE="$(sed -nE 's/^- Trigger source:[[:space:]]*(drift|ready-for-reverification)[[:space:]]*$/\1/p' "${REVALIDATE_FILE}" | head -n 1)"
  FINAL_VERDICT="$(sed -nE 's/^- Final verdict:[[:space:]]*(READY TO REPLAN|READY TO LAND|BLOCKED)[[:space:]]*$/\1/p' "${REVALIDATE_FILE}" | head -n 1)"
fi
TRIGGER_SOURCE="${TRIGGER_SOURCE:-unknown}"
FINAL_VERDICT="${FINAL_VERDICT:-unknown}"

FINDINGS_STATUS="unknown"
REVIEW_VERDICT="unknown"
CONFIDENCE_VALUE="unknown"
FINDINGS_JSON="[]"
if [[ -f "${REVIEW_FILE}" ]]; then
  FINDINGS_STATUS="$(sed -nE 's/^- Findings status:[[:space:]]*(pending|complete|none)[[:space:]]*$/\1/p' "${REVIEW_FILE}" | head -n 1)"
  REVIEW_VERDICT="$(sed -nE 's/^- Verdict:[[:space:]]*(patch is correct|patch is incorrect)[[:space:]]*$/\1/p' "${REVIEW_FILE}" | head -n 1)"
  CONFIDENCE_VALUE="$(sed -nE 's/^- Confidence:[[:space:]]*([0-9]+(\.[0-9]+)?)[[:space:]]*$/\1/p' "${REVIEW_FILE}" | head -n 1)"
  FINDINGS_JSON="$(awk '
    /^## Findings JSON$/ {in_section=1; next}
    in_section && /^```json$/ {in_json=1; next}
    in_section && /^```$/ && in_json {exit}
    in_json {print}
  ' "${REVIEW_FILE}")"
fi
FINDINGS_STATUS="${FINDINGS_STATUS:-unknown}"
REVIEW_VERDICT="${REVIEW_VERDICT:-unknown}"
CONFIDENCE_VALUE="${CONFIDENCE_VALUE:-unknown}"
FINDINGS_JSON="${FINDINGS_JSON:-[]}"

FINDINGS_TOTAL="$(grep -Eoc '"file"[[:space:]]*:' <<< "${FINDINGS_JSON}" || true)"
SEVERITY_HIGH="$(grep -Eoc '"severity"[[:space:]]*:[[:space:]]*"high"' <<< "${FINDINGS_JSON}" || true)"
SEVERITY_MEDIUM="$(grep -Eoc '"severity"[[:space:]]*:[[:space:]]*"medium"' <<< "${FINDINGS_JSON}" || true)"
SEVERITY_LOW="$(grep -Eoc '"severity"[[:space:]]*:[[:space:]]*"low"' <<< "${FINDINGS_JSON}" || true)"
FINDINGS_TOTAL="${FINDINGS_TOTAL:-0}"
SEVERITY_HIGH="${SEVERITY_HIGH:-0}"
SEVERITY_MEDIUM="${SEVERITY_MEDIUM:-0}"
SEVERITY_LOW="${SEVERITY_LOW:-0}"
PRIORITY_P1="${SEVERITY_HIGH}"
PRIORITY_P2="${SEVERITY_MEDIUM}"
PRIORITY_P3="${SEVERITY_LOW}"

CODE_FILES=()
DOC_FILES=()
SCRIPT_FILES=()

classify_touched_file() {
  local file_path="$1"
  local lower_path
  local ext

  lower_path="$(printf '%s' "${file_path}" | tr '[:upper:]' '[:lower:]')"
  ext="${lower_path##*.}"

  if [[ "${lower_path}" == *"/scripts/"* || "${lower_path}" == scripts/* ]]; then
    echo "scripts"
    return 0
  fi

  case "${ext}" in
    sh|bash|zsh|fish|ps1|bat|cmd)
      echo "scripts"
      return 0
      ;;
  esac

  case "${ext}" in
    md|mdx|rst|adoc|txt)
      echo "docs"
      return 0
      ;;
  esac

  if [[ "${lower_path}" == docs/* || "${lower_path}" == *"/docs/"* || "${lower_path}" == documentation/* ]]; then
    echo "docs"
    return 0
  fi

  echo "code"
}

while IFS= read -r changed_file; do
  [[ -z "${changed_file}" ]] && continue
  case "$(classify_touched_file "${changed_file}")" in
    scripts) SCRIPT_FILES+=("${changed_file}") ;;
    docs) DOC_FILES+=("${changed_file}") ;;
    *) CODE_FILES+=("${changed_file}") ;;
  esac
done <<< "${CHANGED_FILES_RAW}"

CODE_COUNT="${#CODE_FILES[@]}"
DOC_COUNT="${#DOC_FILES[@]}"
SCRIPT_COUNT="${#SCRIPT_FILES[@]}"

STAGE3_RUNS="unknown"
STAGE3_CURRENT_CYCLE="unknown"
DRIFT_REVALIDATION_COUNT="unknown"
if [[ -f "${LIFECYCLE_STATE_FILE}" ]]; then
  STAGE3_RUNS="$(sed -nE 's/^- Stage 3 runs:[[:space:]]*([0-9]+)[[:space:]]*$/\1/p' "${LIFECYCLE_STATE_FILE}" | head -n 1)"
  STAGE3_CURRENT_CYCLE="$(sed -nE 's/^- Stage 3 current cycle:[[:space:]]*([0-9]+)[[:space:]]*$/\1/p' "${LIFECYCLE_STATE_FILE}" | head -n 1)"
  DRIFT_REVALIDATION_COUNT="$(sed -nE 's/^- Drift revalidation count:[[:space:]]*([0-9]+)[[:space:]]*$/\1/p' "${LIFECYCLE_STATE_FILE}" | head -n 1)"
fi
STAGE3_RUNS="${STAGE3_RUNS:-unknown}"
STAGE3_CURRENT_CYCLE="${STAGE3_CURRENT_CYCLE:-unknown}"
DRIFT_REVALIDATION_COUNT="${DRIFT_REVALIDATION_COUNT:-unknown}"

COMPLEXITY_SCORE="unknown"
COMPLEXITY_LEVEL="unknown"
COMPLEXITY_RECOMMENDED_GOALS="unknown"
COMPLEXITY_RECOMMENDED_PHASES="unknown"
COMPLEXITY_GUARDRAILS_ALL_TRUE="unknown"
COMPLEXITY_SIGNALS_STATUS="missing"
if [[ -f "${COMPLEXITY_SIGNALS_FILE}" ]]; then
  COMPLEXITY_SIGNALS_STATUS="present"
  if [[ -x "${SCRIPT_DIR}/complexity-score.sh" ]] && command -v jq >/dev/null 2>&1; then
    SCORE_SHELL="$("${SCRIPT_DIR}/complexity-score.sh" "${COMPLEXITY_SIGNALS_FILE}" --format shell 2>/dev/null || true)"
    COMPLEXITY_SCORE="$(sed -nE 's/^total_score=([0-9]+)$/\1/p' <<< "${SCORE_SHELL}" | head -n 1)"
    SCORE_LEVEL="$(sed -nE 's/^level=([A-Z0-9]+)$/\1/p' <<< "${SCORE_SHELL}" | head -n 1)"
    SCORE_LEVEL_NAME="$(sed -nE 's/^level_name=([a-z-]+)$/\1/p' <<< "${SCORE_SHELL}" | head -n 1)"
    COMPLEXITY_RECOMMENDED_GOALS="$(sed -nE 's/^recommended_goals=([0-9]+)$/\1/p' <<< "${SCORE_SHELL}" | head -n 1)"
    COMPLEXITY_RECOMMENDED_PHASES="$(sed -nE 's/^recommended_phases=([0-9]+)$/\1/p' <<< "${SCORE_SHELL}" | head -n 1)"
    COMPLEXITY_GUARDRAILS_ALL_TRUE="$(sed -nE 's/^guardrails_all_true=(true|false)$/\1/p' <<< "${SCORE_SHELL}" | head -n 1)"
    if [[ -n "${SCORE_LEVEL}" || -n "${SCORE_LEVEL_NAME}" ]]; then
      COMPLEXITY_LEVEL="${SCORE_LEVEL:-unknown} (${SCORE_LEVEL_NAME:-unknown})"
    fi
  fi
fi
COMPLEXITY_SCORE="${COMPLEXITY_SCORE:-unknown}"
COMPLEXITY_RECOMMENDED_GOALS="${COMPLEXITY_RECOMMENDED_GOALS:-unknown}"
COMPLEXITY_RECOMMENDED_PHASES="${COMPLEXITY_RECOMMENDED_PHASES:-unknown}"
COMPLEXITY_GUARDRAILS_ALL_TRUE="${COMPLEXITY_GUARDRAILS_ALL_TRUE:-unknown}"

PROJECT_STRUCTURE_FILE=""
if CODEX_ROOT_RESOLVED="$(resolve_codex_root project-structure.md 2>/dev/null)"; then
  PROJECT_STRUCTURE_FILE="${CODEX_ROOT_RESOLVED}/project-structure.md"
elif [[ -f "${ROOT_DIR}/codex/project-structure.md" ]]; then
  PROJECT_STRUCTURE_FILE="${ROOT_DIR}/codex/project-structure.md"
fi

FRAGILE_ARTIFACTS=()
if [[ -n "${PROJECT_STRUCTURE_FILE}" && -f "${PROJECT_STRUCTURE_FILE}" ]]; then
  while IFS= read -r fragile_path; do
    [[ -z "${fragile_path}" ]] && continue
    FRAGILE_ARTIFACTS+=("${fragile_path}")
  done < <(awk '
    /^## Fragile Artifacts$/ {in_section=1; next}
    /^## / {if (in_section) exit}
    in_section && /^- `/ {
      line=$0
      sub(/^- `/, "", line)
      sub(/`.*$/, "", line)
      if (line != "") {
        print line
      }
    }
  ' "${PROJECT_STRUCTURE_FILE}")
fi
FRAGILE_COUNT="${#FRAGILE_ARTIFACTS[@]}"

TOUCHED_FRAGILE_ARTIFACTS=()
if [[ "${FRAGILE_COUNT}" -gt 0 ]]; then
  while IFS= read -r changed_file; do
    [[ -z "${changed_file}" ]] && continue
    for fragile_path in "${FRAGILE_ARTIFACTS[@]}"; do
      if [[ "${changed_file}" == "${fragile_path}" ]]; then
        TOUCHED_FRAGILE_ARTIFACTS+=("${fragile_path}")
      fi
    done
  done <<< "${CHANGED_FILES_RAW}"
fi
TOUCHED_FRAGILE_COUNT="${#TOUCHED_FRAGILE_ARTIFACTS[@]}"

if [[ ! -f "${AUDIT_LOG_FILE}" ]]; then
  cat > "${AUDIT_LOG_FILE}" <<EOF
# Task Audit Log
- Task name: ${TASK_NAME}
- Purpose: Preserve lifecycle evidence for revalidate and landing stages.

EOF
fi

REASON_ONE_LINE="$(printf '%s' "${REASON}" | tr '\n' ' ' | sed -E 's/[[:space:]]+/ /g; s/^[[:space:]]+//; s/[[:space:]]+$//')"
if [[ -z "${REASON_ONE_LINE}" ]]; then
  REASON_ONE_LINE="none"
fi

{
  echo "## Revalidate Run $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  echo "- Status: ${STATUS}"
  echo "- Blocker: ${REASON_ONE_LINE}"
  echo "- Trigger source: ${TRIGGER_SOURCE}"
  echo "- Final verdict snapshot: ${FINAL_VERDICT}"
  echo "- Review findings snapshot:"
  echo "  - Findings status: ${FINDINGS_STATUS}"
  echo "  - Findings count: total=${FINDINGS_TOTAL}; high=${SEVERITY_HIGH}; medium=${SEVERITY_MEDIUM}; low=${SEVERITY_LOW}"
  echo "  - Normalized priorities: P1=${PRIORITY_P1}; P2=${PRIORITY_P2}; P3=${PRIORITY_P3} (high->P1, medium->P2, low->P3)"
  echo "  - Review verdict: ${REVIEW_VERDICT}"
  echo "  - Confidence: ${CONFIDENCE_VALUE}"
  echo "- Complexity snapshot:"
  echo "  - Score: ${COMPLEXITY_SCORE}"
  echo "  - Level: ${COMPLEXITY_LEVEL}"
  echo "  - Recommended goals: ${COMPLEXITY_RECOMMENDED_GOALS}"
  echo "  - Recommended phases: ${COMPLEXITY_RECOMMENDED_PHASES}"
  echo "  - Guardrails all true: ${COMPLEXITY_GUARDRAILS_ALL_TRUE}"
  echo "  - Signals file: \`${COMPLEXITY_SIGNALS_FILE#${ROOT_DIR}/}\` (${COMPLEXITY_SIGNALS_STATUS})"
  echo "- Fragile artifacts snapshot (\`codex/project-structure.md\`):"
  echo "  - Count: ${FRAGILE_COUNT}"
  echo "  - Touched in diff: ${TOUCHED_FRAGILE_COUNT}"
  if [[ "${FRAGILE_COUNT}" -gt 0 ]]; then
    for fragile_path in "${FRAGILE_ARTIFACTS[@]}"; do
      echo "  - \`${fragile_path}\`"
    done
  else
    echo "  - _none recorded_"
  fi
  if [[ "${TOUCHED_FRAGILE_COUNT}" -gt 0 ]]; then
    echo "  - Touched fragile artifacts:"
    for fragile_path in "${TOUCHED_FRAGILE_ARTIFACTS[@]}"; do
      echo "    - \`${fragile_path}\`"
    done
  fi
  echo "- Diff surface snapshot:"
  echo "  - Base branch: ${BASE_BRANCH}"
  echo "  - Diff mode: ${DIFF_MODE}"
  echo "  - Changed files: ${CHANGED_FILES_COUNT}"
  echo "  - Added lines: ${LINES_ADDED}"
  echo "  - Deleted lines: ${LINES_DELETED}"
  echo "  - Touched files by type:"
  echo "    - Code (${CODE_COUNT})"
  if [[ "${CODE_COUNT}" -gt 0 ]]; then
    for changed_file in "${CODE_FILES[@]}"; do
      echo "      - \`${changed_file}\`"
    done
  fi
  echo "    - Docs (${DOC_COUNT})"
  if [[ "${DOC_COUNT}" -gt 0 ]]; then
    for changed_file in "${DOC_FILES[@]}"; do
      echo "      - \`${changed_file}\`"
    done
  fi
  echo "    - Scripts (${SCRIPT_COUNT})"
  if [[ "${SCRIPT_COUNT}" -gt 0 ]]; then
    for changed_file in "${SCRIPT_FILES[@]}"; do
      echo "      - \`${changed_file}\`"
    done
  fi
  echo "- Lifecycle counters snapshot:"
  echo "  - Stage 3 runs: ${STAGE3_RUNS}"
  echo "  - Stage 3 current cycle: ${STAGE3_CURRENT_CYCLE}"
  echo "  - Drift revalidation count: ${DRIFT_REVALIDATION_COUNT}"
  echo "- Outcome:"
  if [[ "${STATUS}" == "success" ]]; then
    echo "  - Revalidate gates passed and audit signals captured for trend tuning."
  else
    echo "  - Revalidate blocked; captured findings and stage signals to support tuning and rerun planning."
  fi
  echo
} >> "${AUDIT_LOG_FILE}"

echo "Updated revalidate audit log: ${AUDIT_LOG_FILE}"
