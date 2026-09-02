#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODEX_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
FIXTURE_ROOT="$(mktemp -d /tmp/lifecycle-workflow-test.XXXXXX)"
trap 'rm -rf -- "${FIXTURE_ROOT}"' EXIT

configure_repo() {
  local repo="$1"
  git -C "${repo}" config user.email fixture@example.com
  git -C "${repo}" config user.name Fixture
  git -C "${repo}" config commit.gpgsign false
}

TASK_REPO="${FIXTURE_ROOT}/task-repo"
git init -b main "${TASK_REPO}" >/dev/null
configure_repo "${TASK_REPO}"
(
  cd "${TASK_REPO}"
  CODEX_ROOT="${CODEX_ROOT}" CODEX_SCRIPTS_DIR="${SCRIPT_DIR}" "${SCRIPT_DIR}/task-scaffold.sh" fixture-task
  [[ -f tasks/fixture-task/spec.md ]]
  [[ "$(find tasks/fixture-task -maxdepth 1 -type f | wc -l | tr -d ' ')" -eq 1 ]]

  printf 'base\n' > changed.txt
  git add changed.txt
  git commit -m base >/dev/null
  printf 'changed\n' > changed.txt
  CODEX_ROOT="${CODEX_ROOT}" CODEX_SCRIPTS_DIR="${SCRIPT_DIR}" "${SCRIPT_DIR}/code-review-validate.sh" fixture-review prepare main
  review=tasks/fixture-review/code-review.md
  sed -i.bak \
    -e 's/- Findings status: pending/- Findings status: none/' \
    -e 's/- Verdict: pending/- Verdict: patch is correct/' \
    -e 's/- Confidence: pending/- Confidence: 1/' \
    -e 's/- Justification:/- Justification: fixture review passed/' \
    "${review}"
  rm "${review}.bak"
  [[ "$(CODEX_ROOT="${CODEX_ROOT}" CODEX_SCRIPTS_DIR="${SCRIPT_DIR}" "${SCRIPT_DIR}/code-review-validate.sh" fixture-review validate main)" == "READY" ]]
)

REMOTE="${FIXTURE_ROOT}/remote.git"
MERGE_REPO="${FIXTURE_ROOT}/merge-repo"
git init --bare "${REMOTE}" >/dev/null
git init -b main "${MERGE_REPO}" >/dev/null
configure_repo "${MERGE_REPO}"
printf 'base\n' > "${MERGE_REPO}/shared.txt"
git -C "${MERGE_REPO}" add shared.txt
git -C "${MERGE_REPO}" commit -m base >/dev/null
git -C "${MERGE_REPO}" remote add origin "${REMOTE}"
git -C "${MERGE_REPO}" push -u origin main >/dev/null

git -C "${MERGE_REPO}" switch -c feature >/dev/null
printf 'feature\n' > "${MERGE_REPO}/feature.txt"
git -C "${MERGE_REPO}" add feature.txt
git -C "${MERGE_REPO}" commit -m feature >/dev/null
FAST_OUTPUT="$(cd "${MERGE_REPO}" && "${SCRIPT_DIR}/git-clean-merge-check.sh" main feature)"
[[ "${FAST_OUTPUT}" == *"Method: fast-forward"* ]]

git -C "${MERGE_REPO}" switch main >/dev/null
printf 'main-only\n' > "${MERGE_REPO}/main.txt"
git -C "${MERGE_REPO}" add main.txt
git -C "${MERGE_REPO}" commit -m main-change >/dev/null
git -C "${MERGE_REPO}" push origin main >/dev/null
ORT_OUTPUT="$(cd "${MERGE_REPO}" && "${SCRIPT_DIR}/git-clean-merge-check.sh" main feature)"
[[ "${ORT_OUTPUT}" == *"Method: ort"* ]]

git -C "${MERGE_REPO}" switch -c conflict HEAD~1 >/dev/null
printf 'feature-conflict\n' > "${MERGE_REPO}/shared.txt"
git -C "${MERGE_REPO}" add shared.txt
git -C "${MERGE_REPO}" commit -m feature-conflict >/dev/null
git -C "${MERGE_REPO}" switch main >/dev/null
printf 'main-conflict\n' > "${MERGE_REPO}/shared.txt"
git -C "${MERGE_REPO}" add shared.txt
git -C "${MERGE_REPO}" commit -m main-conflict >/dev/null
git -C "${MERGE_REPO}" push origin main >/dev/null

set +e
CONFLICT_OUTPUT="$(cd "${MERGE_REPO}" && "${SCRIPT_DIR}/git-clean-merge-check.sh" main conflict 2>&1)"
CONFLICT_STATUS=$?
set -e
[[ "${CONFLICT_STATUS}" -ne 0 ]]
[[ "${CONFLICT_OUTPUT}" == *"operator must resolve"* ]]

echo "LIFECYCLE WORKFLOW TESTS PASSED"
