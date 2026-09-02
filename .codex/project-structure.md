# Codex Lifecycle Repository

This Bash-and-Markdown repository stores reusable Codex governance under `.codex/`, locked goals under `goals/`, and task specs under `tasks/`.

## Workflow

`establish-goals` → `implement` → `land-the-plan`

`code-review` is independently reusable and mandatory during landing.

## Active structure

```text
.codex/
├── AGENTS.md
├── codex-config.yaml
├── goals/                 # goal templates and checklist
├── prompts/
├── rules/
├── scripts/
├── skills/
└── tasks/_templates/      # concise task spec template
goals/                     # immutable goal iterations + manifest
tasks/                     # task specs and review evidence
```

## Canonical commands

- Bootstrap implementation: `./.codex/scripts/implement-bootstrap.sh`
- Scaffold task spec: `./.codex/scripts/task-scaffold.sh <task>`
- Check worktree: `./.codex/scripts/implement-preflight.sh <task> [expected-branch]`
- Prepare review: `./.codex/scripts/code-review-validate.sh <task> prepare [base]`
- Validate review: `./.codex/scripts/code-review-validate.sh <task> validate [base]`
- Check mergeability: `./.codex/scripts/git-clean-merge-check.sh <base> [head]`

## Repository validation

- Lint: `not-configured`
- Build: `not-configured`
- Test: `not-configured`
- Shell changes: run `bash -n` on every modified script.

Task specs must pin the repository's actual lint, build, and test commands. Landing runs all three, performs code review, and verifies clean mergeability before PR creation.

## Constraints

- Resolve Codex assets from `./.codex`, `./codex`, then `$HOME/.codex`.
- Keep goals locked and changes within declared scope.
- Never auto-resolve merge conflicts.
- Preserve historical task and goal records.
