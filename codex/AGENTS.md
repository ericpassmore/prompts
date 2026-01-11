# Codex Project Instructions

This repository contains Codex configuration artifacts for safe git workflows:
- Rules files that gate shell command execution
- Reusable prompts
- Skills (e.g., git-commit)
- Small helper scripts that replace unsafe shell pipelines

## Repository layout

- ./scripts
  - git-check-conflicts.sh
    - Detects merge conflicts (unmerged paths) and exits non-zero if found.
  - git-diff-staged-skip-binary.sh
    - Prints staged diffs for text files only; skips binaries.

- ./rules
  - git-safe.rules
    - Auto-allow list for safe git commands and approved helper scripts.

- ./prompts
  - gitpull.md
    - Prompt template for safe fast-forward pull behavior.

- ./skills
  - git-commit/
    - SKILL.md: canonical “git commit + safety checks + push” procedure.

## Safety and execution rules

1. Do not run compound shell pipelines (pipes, && chains, while loops) inline.
   Use the approved scripts in ./scripts instead.

2. Do not stage or commit real environment files.
   Only the template file `developement.env` may be tracked/committed.
   All other env-like files (`.env`, `.env.*`, `*.env`, `*.env.*`) must never be staged or committed.

3. Only run commands that are:
   - explicitly covered by ./rules/git-safe.rules, or
   - the approved scripts in ./scripts.

## Preferred commands

- Conflict detection:
  - Prefer: ./scripts/git-check-conflicts.sh
  - Avoid: git diff --name-only --diff-filter=U | grep ...

- Staged diff inspection:
  - Prefer: ./scripts/git-diff-staged-skip-binary.sh
  - Avoid: inline bash pipelines with awk/while loops

## Validation

- If scripts change:
  - Ensure they are executable and run without error in a typical repo.
  - Optional: run shellcheck if available.

- If rules change:
  - Use `codex execpolicy check` to verify expected commands are allowed.
