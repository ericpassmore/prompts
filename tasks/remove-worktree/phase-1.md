# Phase 1 — Remove Script-Level Worktree Lifecycle Actions

## Objective
Remove required worktree create/switch behavior from Stage 2 script surfaces and replace it with safe prep behavior.

## Code areas impacted
- `codex/scripts/prepare-takeoff-worktree.sh`
- `codex/scripts/prepare-takeoff-bootstrap.sh`
- `codex/scripts/git-commit-preflight.sh`
- `codex/scripts/git-push-branch-safe.sh`
- `codex/rules/git-safe.rules`

## Work items
- [x] Convert `prepare-takeoff-worktree.sh` to safety-prep behavior only (no `git worktree add/remove`).
- [x] Update bootstrap required-file checks to align with the updated Stage 2 script behavior.
- [x] Update commit/push helper scripts to accept detached `HEAD` where branch-based assumptions previously blocked execution.
- [x] Update `git-safe.rules` entries that currently authorize worktree creation/release helpers.

## Deliverables
- Updated Stage 2 helper script that performs prune/safety checks in the current worktree.
- Updated bootstrap script requirements that no longer encode worktree creation semantics.
- Updated commit/push helper scripts to support detached `HEAD` flow.
- Updated safety-rule allowlist aligned with new behavior.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] No script path in this phase calls `git worktree add` or requires switching to another worktree.
- [x] Stage 2 helper script exits successfully from current worktree context.
- [x] Detached `HEAD` no longer fails commit preflight/push-helper checks by default.

## Verification steps
List exact commands and expected results.
- [x] Command: `rg -n "git worktree add|git worktree remove" codex/scripts/prepare-takeoff-worktree.sh codex/scripts/prepare-takeoff-bootstrap.sh codex/rules/git-safe.rules`
  - Expected: no create/remove call sites remain in active Stage 2 flow.
  - Result: PASS
- [x] Command: `./codex/scripts/prepare-takeoff-worktree.sh remove-worktree`
  - Expected: exits `0` and prints safety-prep summary for current worktree.
  - Result: PASS
- [x] Command: `./codex/scripts/git-commit-preflight.sh`
  - Expected: in detached `HEAD`, exits `0` with detached-mode notice.
  - Result: PASS

## Risks and mitigations
- Risk: keeping legacy script filename while changing behavior may confuse operators.
- Mitigation: update usage/help text and skill documentation in later phases.
