# establish-goals

## Status

- Iteration: v0
- State: locked
- Task name (proposed, kebab-case): auto-worktree-pr

## Request restatement

- Update Stage 6 (`land-the-plan`) git safety and landing flow for detached `HEAD` execution.
- In detached `HEAD`, construct landing branch `land-the-plan/<taskname>/<agent-id>-<timestamp>`, then commit on that branch via the `git-commit` skill.
- Landing flow must include `git fetch origin`, branch non-existence checks, branch creation/switch, push, PR creation, and PR merge into `codex-config.yaml:base_branch`.
- Review current changes against commit `2c3c9b22755cfcc0e19f76950be63d0c4caedc96` and verify `git-commit` protections for secrets and binary files were not lost.

## Context considered

- Repo/rules/skills consulted:
  - `codex/AGENTS.md`
  - `codex/skills/acac/SKILL.md`
  - `codex/skills/land-the-plan/SKILL.md`
  - `codex/skills/git-commit/SKILL.md`
  - `codex/rules/git-safe.rules`
- Relevant files (if any):
  - `codex/scripts/git-commit-preflight.sh`
  - `codex/scripts/git-push-branch-safe.sh`
  - `codex/scripts/git-track-safe-untracked.sh`
  - `codex/scripts/git-diff-staged-skip-binary.sh`
- Constraints (sandbox, commands, policy):
  - Workspace-write sandbox
  - No destructive git operations
  - Lifecycle stage gate and verdict contracts are mandatory

## Ambiguities

### Blocking (must resolve)

1. None.

### Non-blocking (can proceed with explicit assumptions)

1. `agent-id` is sourced deterministically from local runtime identity with a fallback (`codex-agent`) when unavailable.
2. Timestamp format is UTC and branch-safe (digits only).
3. PR merge strategy defaults to non-rebase merge unless repository policy overrides at runtime.

## Questions for user

1. None; request provides sufficient implementation detail.

## Assumptions (explicit; remove when confirmed)

1. The request itself serves as goals approval for this ACAC run.
2. Repository policy permits adding Stage 6 helper-script support for branch preparation and PR merge command policy entries.

## Goals (0–5, verifiable)

> If ambiguity is blocking, it is valid to have 0 goals.

1. `land-the-plan` defines and enforces detached-`HEAD` landing branch creation using `land-the-plan/<task>/<agent-id>-<timestamp>`.
2. Landing flow explicitly includes `git fetch origin`, local/remote branch collision checks, branch create/switch, commit via `git-commit`, push, PR creation, and PR merge to configured base branch.
3. Supporting scripts/rules are updated so the new flow is executable under repository git-safe policy without bypassing existing safety controls.
4. A regression check against `2c3c9b22755cfcc0e19f76950be63d0c4caedc96..HEAD` confirms secret/binary protections in `git-commit` remain intact (or documents actionable fixes if not).

## Non-goals (explicit exclusions)

- Reworking the full ACAC lifecycle order or verdict taxonomy.
- Refactoring unrelated scripts/skills outside detached-head landing and requested safety checks.

## Success criteria (objective checks)

> Tie each criterion to a goal number when possible.

- [G1] Stage 6 skill text and helper logic resolve a detached-head landing branch with required naming components (`task`, `agent-id`, `timestamp`).
- [G2] Stage 6 procedure documents and/or scripts encode all required git/PR/merge steps in order with fail-fast blockers on collision/invalid state.
- [G3] `git-safe.rules` allowlist includes new required commands/helper paths used by the updated landing flow.
- [G4] Review evidence (diff + script/skill audit) explicitly confirms secret/binary commit protections remain present in `git-commit` workflow.

## Risks / tradeoffs

- Introducing stricter branch-prep checks can block landing when repository state is inconsistent; this is intentional fail-fast behavior.

## Next action

- Goals locked; proceed to `prepare-takeoff` and task scaffolding.
