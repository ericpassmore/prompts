#!/usr/bin/env bash
set -euo pipefail

TASK_NAME="${1:-}"

usage() {
  echo "Usage: ./.codex/scripts/task-scaffold.sh <task-name>"
  echo "Example: ./.codex/scripts/task-scaffold.sh add-performer-search"
}

if [[ -z "${TASK_NAME}" ]]; then
  usage
  exit 2
fi

# Enforce kebab-case and prevent path traversal / weird names
# - only lowercase letters, digits, and hyphens
# - must start with a letter or digit
if [[ ! "${TASK_NAME}" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "Abort: task-name must be kebab-case using only lowercase letters, digits, and hyphens."
  echo "Example: add-performer-search"
  exit 2
fi

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
TASKS_DIR="${ROOT_DIR}/tasks"
TASK_DIR="${TASKS_DIR}/${TASK_NAME}"

# Prefer repo-local templates; fall back to user-level templates
REPO_TEMPLATES_DIR="${ROOT_DIR}/.codex/tasks/_templates"
USER_TEMPLATES_DIR="/Users/eric/.codex/tasks/_templates"

TEMPLATES_DIR=""
if [[ -d "${REPO_TEMPLATES_DIR}" ]]; then
  TEMPLATES_DIR="${REPO_TEMPLATES_DIR}"
elif [[ -d "${USER_TEMPLATES_DIR}" ]]; then
  TEMPLATES_DIR="${USER_TEMPLATES_DIR}"
else
  echo "Abort: no templates directory found."
  echo "Expected one of:"
  echo "  - ${REPO_TEMPLATES_DIR}"
  echo "  - ${USER_TEMPLATES_DIR}"
  exit 1
fi

SPEC_TPL="${TEMPLATES_DIR}/spec.template.md"
PHASE_TPL="${TEMPLATES_DIR}/phase.template.md"
FINAL_TPL="${TEMPLATES_DIR}/final-phase.template.md"

# Ensure task directory exists (covers all scenarios)
mkdir -p "${TASK_DIR}"

# Ensure required templates exist
if [[ ! -f "${SPEC_TPL}" || ! -f "${PHASE_TPL}" || ! -f "${FINAL_TPL}" ]]; then
  echo "Abort: missing required templates under ${TEMPLATES_DIR}"
  echo "Expected:"
  echo "  ${SPEC_TPL}"
  echo "  ${PHASE_TPL}"
  echo "  ${FINAL_TPL}"
  exit 1
fi

# Template materialization rules:
# - Source templates are *.template.md
# - Destination strips ".template" (foo.template.md -> foo.md)
# - Non-destructive: do not overwrite existing destination files
#
# Special cases:
# - phase.template.md expands into phase-1..3.md with {{PHASE_N}} substitution
# - spec.template.md -> spec.md
# - final-phase.template.md -> final-phase.md

created_files=()

# spec.template.md -> spec.md
if [[ ! -f "${TASK_DIR}/spec.md" ]]; then
  cp "${SPEC_TPL}" "${TASK_DIR}/spec.md"
  created_files+=("${TASK_DIR}/spec.md")
fi

# phase.template.md -> phase-1..3.md
for n in 1 2 3; do
  if [[ ! -f "${TASK_DIR}/phase-${n}.md" ]]; then
    sed "s/{{PHASE_N}}/${n}/g" "${PHASE_TPL}" > "${TASK_DIR}/phase-${n}.md"
    created_files+=("${TASK_DIR}/phase-${n}.md")
  fi
done

# final-phase.template.md -> final-phase.md
if [[ ! -f "${TASK_DIR}/final-phase.md" ]]; then
  cp "${FINAL_TPL}" "${TASK_DIR}/final-phase.md"
  created_files+=("${TASK_DIR}/final-phase.md")
fi

# Materialize any additional *.template.md files (beyond the known ones)
# - Strip ".template" from the basename
# - Skip if destination already exists
# - Skip known templates that are handled above
shopt -s nullglob
for tpl in "${TEMPLATES_DIR}"/*.template.md; do
  base="$(basename "${tpl}")"

  case "${base}" in
    "spec.template.md"|"phase.template.md"|"final-phase.template.md")
      continue
      ;;
  esac

  dest_base="${base/.template.md/.md}"
  dest_path="${TASK_DIR}/${dest_base}"

  if [[ -f "${dest_path}" ]]; then
    continue
  fi

  cp "${tpl}" "${dest_path}"
  created_files+=("${dest_path}")
done
shopt -u nullglob

# Validate required files exist (prompt expects only 1..3 + final)
required=(
  "${TASK_DIR}/spec.md"
  "${TASK_DIR}/phase-1.md"
  "${TASK_DIR}/phase-2.md"
  "${TASK_DIR}/phase-3.md"
  "${TASK_DIR}/final-phase.md"
)

missing=0
for f in "${required[@]}"; do
  if [[ ! -f "${f}" ]]; then
    echo "Missing: ${f}"
    missing=1
  fi
done

if [[ "${missing}" -ne 0 ]]; then
  echo "Abort: required task files missing."
  exit 1
fi

echo "Task scaffold ready: ${TASK_DIR}"
echo "Templates source: ${TEMPLATES_DIR}"

if [[ "${#created_files[@]}" -gt 0 ]]; then
  echo "Files created:"
  for f in "${created_files[@]}"; do
    echo "  - ${f}"
  done
else
  echo "No files created (everything already existed)."
fi

echo "Required files verified:"
for f in "${required[@]}"; do
  echo "  - ${f}"
done
