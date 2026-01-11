#!/usr/bin/env bash
set -euo pipefail

conflicts="$(git diff --name-only --diff-filter=U)"
if [ -n "$conflicts" ]; then
  echo "Abort: merge conflicts/unmerged paths detected:"
  echo "$conflicts"
  exit 1
fi