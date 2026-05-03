#!/usr/bin/env bash
set -euo pipefail

git diff --name-only -z \
| while IFS= read -r -d '' f; do
    if git diff --numstat -- "$f" | awk 'NR==1{exit !($1=="-" && $2=="-")}'; then
      echo "Skipping binary: $f"
      continue
    fi

    git diff -- "$f"
  done
