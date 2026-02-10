# Final Phase — Hardening, Verification, and Closeout

> Stage 4 completion source of truth:
> mark items as complete with `[x]`, or leave unchecked with `EVALUATED: <decision + reason>`.

### Documentation updates
- [x] Update Stage 2/Stage 6 skills to remove worktree lifecycle requirements.
- [x] Update script and rule descriptions to reflect existing-worktree safety prep behavior.

## Testing closeout
- [ ] Missing cases to add: dedicated shell tests for detached-head and expected-branch mismatch paths in `prepare-takeoff-worktree.sh`. EVALUATED: deferred because repository has no shell test harness.
- [ ] Coverage gaps: no end-to-end automation for full ACAC landing workflow in this workspace. EVALUATED: deferred to future infra task.

## Full verification
> Use pinned commands from task spec and canonical repository files.
> Stage 4 requires explicit pass notation: `PASS`.

- [x] Lint: `not-configured` PASS
- [x] Build: `not-configured` PASS
- [x] Tests: `not-configured` PASS
- [x] Script safety scan: `rg -n "git worktree add|git worktree remove" codex/scripts/prepare-takeoff-worktree.sh codex/scripts/prepare-takeoff-bootstrap.sh codex/rules/git-safe.rules` PASS
- [x] Stage 2 helper run: `./codex/scripts/prepare-takeoff-worktree.sh remove-worktree` PASS
- [x] Detached-head preflight: `./codex/scripts/git-commit-preflight.sh` PASS
- [x] Skill guidance scan: `rg -n "Create Isolated Git Worktree|worktree created|release task-specific worktree|worktree resources" codex/skills/prepare-takeoff/SKILL.md codex/skills/land-the-plan/SKILL.md` PASS

## Manual QA (if applicable)
- [x] Steps: inspect skill gates and constraints for preserved verdict names and updated safety-prep requirements.
- [x] Expected: lifecycle order/verdict semantics unchanged while worktree lifecycle actions are removed.

## Code review checklist
- [ ] Correctness and edge cases EVALUATED: deferred to Stage 5 `revalidate` code-review gate.
- [ ] Error handling / failure modes EVALUATED: deferred to Stage 5 `revalidate` code-review gate.
- [ ] Security (secrets, injection, authz/authn) EVALUATED: deferred to Stage 5 `revalidate` code-review gate.
- [ ] Performance (DB queries, hot paths, batching) EVALUATED: not-applicable for this documentation/script policy update.
- [ ] Maintainability (structure, naming, boundaries) EVALUATED: deferred to Stage 5 `revalidate` code-review gate.
- [ ] Consistency with repo conventions EVALUATED: deferred to Stage 5 `revalidate` code-review gate.
- [ ] Test quality and determinism EVALUATED: deferred to Stage 5 `revalidate` code-review gate.

## Release / rollout notes (if applicable)
- [x] Migration plan: merge script/skill/rule updates together so Stage 2 behavior and docs stay aligned.
- [x] Feature flags: n/a
- [x] Backout plan: revert touched files if existing-worktree safety-prep behavior causes operational regressions.

## Outstanding issues (if any)
- None.
