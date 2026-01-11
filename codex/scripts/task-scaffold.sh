#!/usr/bin/env bash
set -euo pipefail

TASK_NAME="${1:-}"
ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
TASKS_DIR="${ROOT_DIR}/tasks"
TASK_DIR="${TASKS_DIR}/${TASK_NAME}"

TEMPLATES_DIR="${ROOT_DIR}/.codex/tasks/_templates"
SPEC_TPL="${TEMPLATES_DIR}/spec.template.md"
PHASE_TPL="${TEMPLATES_DIR}/phase.template.md"
FINAL_TPL="${TEMPLATES_DIR}/final-phase.template.md"

usage() {
  echo "Usage: .codex/scripts/task-scaffold.sh <task-name>"
  echo "Example: .codex/scripts/task-scaffold.sh add-performer-search"
}

if [[ -z "${TASK_NAME}" ]]; then
  usage
  exit 2
fi

# Basic sanity for task name
if [[ "${TASK_NAME}" =~ [[:space:]] ]]; then
  echo "Abort: task-name must not contain spaces. Use kebab-case."
  exit 2
fi

mkdir -p "${TASK_DIR}"

# Ensure templates exist
if [[ ! -f "${SPEC_TPL}" || ! -f "${PHASE_TPL}" || ! -f "${FINAL_TPL}" ]]; then
  echo "Abort: missing templates under ${TEMPLATES_DIR}"
  echo "Expected:"
  echo "  ${SPEC_TPL}"
  echo "  ${PHASE_TPL}"
  echo "  ${FINAL_TPL}"
  exit 1
fi

# Create spec if missing
if [[ ! -f "${TASK_DIR}/spec.md" ]]; then
  cp "${SPEC_TPL}" "${TASK_DIR}/spec.md"
fi

# Create phases 1..4 if missing (agent may later delete unused phase-4)
for n in 1 2 3 4; do
  if [[ ! -f "${TASK_DIR}/phase-${n}.md" ]]; then
    # Replace placeholder token for phase number
    sed "s/{{PHASE_N}}/${n}/g" "${PHASE_TPL}" > "${TASK_DIR}/phase-${n}.md"
  fi
done

# Create final-phase if missing
if [[ ! -f "${TASK_DIR}/final-phase.md" ]]; then
  cp "${FINAL_TPL}" "${TASK_DIR}/final-phase.md"
fi

# Validate required files exist
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
echo "Files created/verified:"
for f in "${required[@]}"; do
  echo "  - ${f}"
done
echo "Optional phase file present:"
echo "  - ${TASK_DIR}/phase-4.md"
