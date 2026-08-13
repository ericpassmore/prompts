#!/usr/bin/env bash
set -euo pipefail

TASK_NAME="${1:-}"
MODE="${2:-}"
BASE_OVERRIDE="${3:-}"
ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[[ -n "${ROOT_DIR}" ]] || { echo "BLOCKED: not inside a git repository."; exit 1; }
TASK_DIR="${ROOT_DIR}/tasks/${TASK_NAME}"
REVIEW_FILE="${TASK_DIR}/code-review.md"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/resolve-codex-root.sh"

usage() { echo "Usage: code-review-validate.sh <task-name> <prepare|validate> [base-branch]"; }
valid_branch() { [[ "$1" =~ ^[A-Za-z0-9._/-]+$ ]] && [[ "$1" != *"<"* ]] && [[ "$1" != *">"* ]]; }

if [[ -z "${TASK_NAME}" || ! "${TASK_NAME}" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ || ! "${MODE}" =~ ^(prepare|validate)$ ]]; then
  usage
  exit 2
fi
mkdir -p "${TASK_DIR}"

resolve_base() {
  if [[ -n "${BASE_OVERRIDE}" ]]; then
    valid_branch "${BASE_OVERRIDE}" || { echo "BLOCKED: invalid base branch '${BASE_OVERRIDE}'."; exit 1; }
    echo "${BASE_OVERRIDE}"
    return
  fi
  local root candidate
  root="$(resolve_codex_root codex-config.yaml 2>/dev/null || true)"
  if [[ -n "${root}" ]]; then
    candidate="$(sed -nE 's/^[[:space:]]*base_branch:[[:space:]]*"?([A-Za-z0-9._\/-]+)"?[[:space:]]*$/\1/p' "${root}/codex-config.yaml" | head -n 1)"
    if [[ -n "${candidate}" ]] && valid_branch "${candidate}"; then echo "${candidate}"; return; fi
  fi
  echo main
}

BASE_BRANCH="$(resolve_base)"

if [[ "${MODE}" == "prepare" ]]; then
  changed="$({ git diff --cached --name-only; git diff --name-only; git ls-files --others --exclude-standard; } | sed '/^$/d' | sort -u)"
  if [[ -z "${changed}" ]]; then
    changed="$(git diff --name-only "${BASE_BRANCH}...HEAD" 2>/dev/null || true)"
    diff_command="git diff ${BASE_BRANCH}...HEAD"
  else
    diff_command="git diff --cached; git diff; inspect listed untracked files"
  fi
  citations="$({ git diff --cached -U0; git diff -U0; } 2>/dev/null | awk '
    /^diff --git / {file=$4; sub("^b/", "", file); next}
    /^@@ / && match($0, /\+[0-9]+(,[0-9]+)?/) {
      token=substr($0,RSTART+1,RLENGTH-1); split(token,p,","); start=p[1]+0; len=(p[2]==""?1:p[2]+0); end=(len>0?start+len-1:start); if(file!="") print file ":" start "-" end
    }' | sort -u)"

  {
    echo "# Code Review"
    echo "- Task name: ${TASK_NAME}"
    echo "- Findings status: pending"
    echo
    echo "## Context"
    echo "- Base branch: ${BASE_BRANCH}"
    echo "- Diff command: \`${diff_command}\`"
    echo "- Changed files:"
    if [[ -n "${changed}" ]]; then printf '%s\n' "${changed}" | sed 's/^/  - `/' | sed 's/$/`/'; else echo "  - _none_"; fi
    echo "- Citation candidates (verify before use):"
    if [[ -n "${citations}" ]]; then printf '%s\n' "${citations}" | sed 's/^/  - `/' | sed 's/$/`/'; else echo "  - _none_"; fi
    echo
    echo "## Findings JSON"
    echo '```json'
    echo '[]'
    echo '```'
    echo
    echo "## Verdict"
    echo "- Verdict: pending"
    echo "- Confidence: pending"
    echo "- Justification:"
  } > "${REVIEW_FILE}"
  echo "REVIEW READY: ${REVIEW_FILE}"
  exit 0
fi

[[ -f "${REVIEW_FILE}" ]] || { echo "BLOCKED: missing ${REVIEW_FILE}; run prepare first."; exit 1; }
status="$(sed -nE 's/^- Findings status:[[:space:]]*(pending|none|complete)$/\1/p' "${REVIEW_FILE}" | head -n 1)"
findings="$(awk '/^## Findings JSON$/{s=1;next} s&&/^```json$/{j=1;next} s&&j&&/^```$/{exit} j{print}' "${REVIEW_FILE}")"
verdict="$(sed -nE 's/^- Verdict:[[:space:]]*(patch is correct|patch is incorrect)$/\1/p' "${REVIEW_FILE}" | head -n 1)"
confidence="$(sed -nE 's/^- Confidence:[[:space:]]*([0-9]+([.][0-9]+)?)$/\1/p' "${REVIEW_FILE}" | head -n 1)"
justification="$(sed -nE 's/^- Justification:[[:space:]]*(.+)$/\1/p' "${REVIEW_FILE}" | head -n 1)"

[[ "${status}" =~ ^(none|complete)$ ]] || { echo "BLOCKED: findings status must be none or complete."; exit 1; }
printf '%s' "${findings}" | jq -e 'type=="array" and all(.[]; type=="object" and (.file|type=="string" and length>0) and (.line_range|type=="string" and length>0) and (.severity=="low" or .severity=="medium" or .severity=="high") and (.explanation|type=="string" and length>0))' >/dev/null || { echo "BLOCKED: invalid findings JSON."; exit 1; }
count="$(printf '%s' "${findings}" | jq 'length')"
[[ -n "${confidence}" ]] && awk -v c="${confidence}" 'BEGIN{exit !(c>=0 && c<=1)}' || { echo "BLOCKED: confidence must be in [0,1]."; exit 1; }
[[ -n "${justification}" ]] || { echo "BLOCKED: justification is required."; exit 1; }

if [[ "${status}" == "none" && "${count}" -eq 0 && "${verdict}" == "patch is correct" ]]; then
  echo "READY"
  exit 0
fi
if [[ "${status}" == "complete" && "${count}" -gt 0 && "${verdict}" == "patch is incorrect" ]]; then
  echo "BLOCKED: actionable review findings must be fixed before landing."
  exit 1
fi
echo "BLOCKED: findings status, JSON, and verdict are inconsistent."
exit 1
