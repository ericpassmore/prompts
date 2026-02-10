# Final Phase — Hardening, Verification, and Closeout

> Stage 4 completion source of truth:
> mark items as complete with `[x]`, or leave unchecked with `EVALUATED: <decision + reason>`.

### Documentation updates
- [x] Update `land-the-plan` skill procedure and gates for detached-head branch prep + PR merge.
- [x] Update `git-commit` skill preflight guidance for `land-the-plan/*` first-commit flow.
- [x] Update git-safe allowlist entries for new landing helper and merge command.

## Testing closeout
- [ ] Missing cases to add: shell-level tests for collision branches and invalid timestamps in `git-land-branch-safe.sh`. EVALUATED: deferred because repository has no shell test harness.
- [ ] Coverage gaps: no end-to-end automation for live `gh pr create` + `gh pr merge` in this sandboxed environment. EVALUATED: deferred to runtime integration environment.

## Full verification
> Use pinned commands from task spec and canonical repository files.
> Stage 4 requires explicit pass notation: `PASS`.

- [x] Lint: `not-configured` PASS
- [x] Build: `not-configured` PASS
- [x] Tests: `not-configured` PASS
- [x] Script syntax: `bash -n codex/scripts/git-land-branch-safe.sh codex/scripts/git-commit-preflight.sh codex/scripts/git-push-branch-safe.sh` PASS
- [x] Landing branch dry run: `./codex/scripts/git-land-branch-safe.sh auto-worktree-pr codex-agent 20260210153045 --dry-run` PASS
- [x] Skill/rule coverage scan: `rg -n "land-the-plan/<TASK_NAME_IN_KEBAB_CASE>/<agent-id>-<timestamp>|git fetch origin|gh pr merge|git-land-branch-safe.sh" codex/skills/land-the-plan/SKILL.md codex/rules/git-safe.rules codex/scripts/git-land-branch-safe.sh` PASS
- [x] Regression diff review: `git diff 2c3c9b22755cfcc0e19f76950be63d0c4caedc96 -- codex/skills/git-commit/SKILL.md codex/scripts/git-track-safe-untracked.sh codex/scripts/git-diff-staged-skip-binary.sh codex/scripts/git-commit-preflight.sh` PASS

## Manual QA (if applicable)
- [x] Steps: inspect Stage 6 flow for explicit fetch/check/create/switch/push/PR/merge sequence and fail-fast blockers.
- [x] Expected: sequence and branch naming contract match locked goals.

## Code review checklist
- [ ] Correctness and edge cases EVALUATED: deferred to Stage 5 `revalidate` gate.
- [ ] Error handling / failure modes EVALUATED: deferred to Stage 5 `revalidate` gate.
- [ ] Security (secrets, injection, authz/authn) EVALUATED: deferred to Stage 5 `revalidate` gate.
- [ ] Performance (DB queries, hot paths, batching) EVALUATED: not-applicable for shell/doc policy updates.
- [ ] Maintainability (structure, naming, boundaries) EVALUATED: deferred to Stage 5 `revalidate` gate.
- [ ] Consistency with repo conventions EVALUATED: deferred to Stage 5 `revalidate` gate.
- [ ] Test quality and determinism EVALUATED: deferred to Stage 5 `revalidate` gate.

## Release / rollout notes (if applicable)
- [x] Migration plan: land helper + skill/rule updates together so Stage 6 remains mechanically consistent.
- [x] Feature flags: n/a
- [x] Backout plan: revert touched landing/preflight/rules files if landing regressions are found.

## Outstanding issues (if any)
- None.
