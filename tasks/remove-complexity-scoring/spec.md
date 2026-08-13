# Remove Complexity Scoring

## Overview

Remove deterministic complexity scoring from active lifecycle instructions and executable machinery. Delegate goal and implementation-phase sizing to agent judgment while preserving historical records.

## Goal lock and ambiguity check

- Locked goals: `goals/remove-complexity-scoring/goals.v0.md`
- Goal state: locked and mechanically validated
- Ambiguity check: passed; the user confirmed that active surfaces are in scope and historical `goals/` and `tasks/` records are preserved.

## Goals

1. Add exactly `Use your judgment to scale the number of goals and implementation phases to the task’s complexity.` to `.codex/skills/prepare-phased-impl/SKILL.md`.
2. Remove the active complexity-scaling skill, scorer, signals template, and their active dependencies.
3. Verify no active surface depends on the removed machinery.

## Non-goals

- Rewrite or delete historical records under `goals/` or `tasks/`.
- Remove `establish-goals` or replace scoring with another deterministic rubric.

## Current behavior

- Stage 2 scaffolds `complexity-signals.json`.
- Stage 3 scores that file and enforces scorer-derived phase requirements.
- Other active skills, rules, scripts, and documentation reference the scoring workflow.

## Proposed behavior

- Agents use judgment to size goals and implementation phases.
- No active complexity skill, scorer, signals template, lock file, scaffold action, validation branch, prompt, rule, or documentation dependency remains.
- Historical task records remain untouched.

## Technical design

- Remove dedicated complexity assets.
- Simplify shared shell scripts by deleting scorer-specific arguments, creation paths, locks, output, and validation.
- Update active Markdown and rule files to remove scorer-specific instructions.
- Preserve unrelated behavior and existing unstaged user edits.

## Security, privacy, observability, API, UI, and schema impact

- None.

## Verification Commands

- Lint: `bash -n` on every modified active shell script.
- Build: `not-configured`.
- Test: run representative goal validation, task scaffolding, phase scaffolding, and phase validation fixtures in a temporary repository copy when practical.
- Search: `rg` active surfaces excluding `.git`, `goals/`, and `tasks/` for removed complexity identifiers.

## Acceptance criteria checklist

- [x] Exact judgment sentence exists in `prepare-phased-impl`.
- [x] Dedicated scoring skill, script, and signals template are absent.
- [x] Active references and executable dependencies are absent.
- [x] Historical records are preserved.
- [x] Relevant syntax and behavior checks pass.

## IN SCOPE

- Active files under `.codex/skills`, `.codex/scripts`, `.codex/tasks/_templates`, `.codex/rules`, `.codex/prompts`, and active repository documentation/configuration.
- New task artifacts for `remove-complexity-scoring`.

## OUT OF SCOPE

- Pre-existing historical records under `goals/` and `tasks/` other than this task.
- Pre-existing edits to `.codex/AGENTS.md` and deletion of `.codex/principles.md`, except adding the exact sentence only if required by an active-reference cleanup (not currently expected).

## Environment and governing context

- `CODEX_ROOT`: `/Users/eric/side-projects/prompts/.codex`
- `CODEX_SCRIPTS_DIR`: `/Users/eric/side-projects/prompts/.codex/scripts`
- Governing files: `.codex/AGENTS.md`, `.codex/rules/expand-task-spec.rules`, `.codex/rules/git-safe.rules`, and applicable lifecycle skills.
- Sandbox: workspace-write.
- Dirty-worktree decision: `continue`; preserve the user’s pre-existing `AGENTS.md` modification and `principles.md` deletion.

## Execution posture and change control

- Apply simplicity bias, surgical-change discipline, and fail-fast handling.
- Goals and constraints may change only with explicit user authority; drift causes `BLOCKED`.

## Readiness verdict

READY FOR PLANNING

## Implementation phase strategy
- Phase count: 3
- Sizing: agent judgment
- Active phases: 1..3
- No new scope introduced: required
