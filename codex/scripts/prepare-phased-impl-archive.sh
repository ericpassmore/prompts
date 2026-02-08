#!/usr/bin/env bash
set -euo pipefail

TASK_NAME="${1:-}"
ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
TASK_DIR="${ROOT_DIR}/tasks/${TASK_NAME}"
PHASE_PLAN_FILE="${TASK_DIR}/phase-plan.md"
SCOPE_LOCK_FILE="${TASK_DIR}/.scope-lock.md"

usage() {
  echo "Usage (canonical): ./.codex/scripts/prepare-phased-impl-archive.sh <task-name>"
  echo "Usage (repo-local fallback): ./codex/scripts/prepare-phased-impl-archive.sh <task-name>"
  echo "Usage (home fallback): ${HOME}/.codex/scripts/prepare-phased-impl-archive.sh <task-name>"
}

if [[ -z "${TASK_NAME}" ]]; then
  usage
  exit 2
fi

if [[ ! "${TASK_NAME}" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "Abort: task-name must be kebab-case using lowercase letters, digits, and hyphens only."
  exit 2
fi

if [[ ! -d "${TASK_DIR}" ]]; then
  echo "Abort: missing task directory ${TASK_DIR}"
  exit 1
fi

shopt -s nullglob
phase_files=( "${TASK_DIR}"/phase-[0-9]*.md )
shopt -u nullglob

if [[ ! -f "${PHASE_PLAN_FILE}" && ! -f "${SCOPE_LOCK_FILE}" && "${#phase_files[@]}" -eq 0 ]]; then
  echo "No Stage 3 artifacts found for archive in ${TASK_DIR}"
  exit 0
fi

short_hash="$(git rev-parse --short HEAD)"
archive_base="${TASK_DIR}/archive/prepare-phased-impl-${short_hash}"
archive_dir="${archive_base}"
suffix=1
while [[ -e "${archive_dir}" ]]; do
  archive_dir="${archive_base}-${suffix}"
  suffix=$((suffix + 1))
done

mkdir -p "${archive_dir}"

if [[ -f "${PHASE_PLAN_FILE}" ]]; then
  mv "${PHASE_PLAN_FILE}" "${archive_dir}/phase-plan.md"
fi

if [[ -f "${SCOPE_LOCK_FILE}" ]]; then
  mv "${SCOPE_LOCK_FILE}" "${archive_dir}/.scope-lock.md"
fi

for phase_file in "${phase_files[@]}"; do
  mv "${phase_file}" "${archive_dir}/$(basename "${phase_file}")"
done

{
  echo "# Stage 3 Archive Metadata"
  echo "- Task name: ${TASK_NAME}"
  echo "- Archive GUID: ${short_hash}"
  echo "- Archive directory: ${archive_dir}"
  echo "- Archived by: prepare-phased-impl-archive.sh"
} > "${archive_dir}/archive-metadata.md"

echo "Archived prior Stage 3 artifacts to ${archive_dir}"
