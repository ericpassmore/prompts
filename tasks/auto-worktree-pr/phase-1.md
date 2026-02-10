# Phase 1 — Implement Detached-HEAD Landing Branch Safety

## Objective
Add fail-fast script-level support for detached-HEAD landing branch preparation and commit preflight compatibility for first-use landing branches.

## Code areas impacted
- `codex/scripts/git-commit-preflight.sh`
- `codex/scripts/git-push-branch-safe.sh`
- `codex/scripts/git-land-branch-safe.sh`

## Work items
- [x] Add a helper script to build and validate detached-head landing branches.
- [x] Enforce fetch + local/remote branch non-existence checks before branch creation.
- [x] Ensure commit preflight allows a newly created landing branch without upstream while keeping fail-fast behavior elsewhere.

## Deliverables
- New script for detached-head landing branch preparation.
- Updated preflight behavior that supports land-the-plan branch bootstrap.
- Updated usage/docs in touched scripts.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] Detached-head helper exits 0 only when branch is safely created and switched.
- [x] Helper aborts on invalid branch names or collisions.
- [x] Preflight behavior is explicit for no-upstream landing branches.

## Verification steps
List exact commands and expected results.
- [x] Command: `./codex/scripts/git-land-branch-safe.sh auto-worktree-pr codex-agent 20260210153045 --dry-run`
  - Expected: prints resolved branch and safety checks without mutating git refs.
  - Result: PASS (`Landing branch: land-the-plan/auto-worktree-pr/codex-agent-20260210153045`)
- [x] Command: `rg -n "detached HEAD|no upstream|land-the-plan/" codex/scripts/git-commit-preflight.sh codex/scripts/git-land-branch-safe.sh`
  - Expected: explicit, fail-fast branch-prep/preflight handling is present.
  - Result: PASS

## Risks and mitigations
- Risk: Relaxing no-upstream preflight too broadly could weaken branch hygiene.
- Mitigation: Exception is scoped to `land-the-plan/*` branch namespace.
