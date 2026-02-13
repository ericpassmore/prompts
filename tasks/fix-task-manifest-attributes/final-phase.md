# Final Phase — Hardening, Verification, and Closeout

> Stage 4 completion source of truth:
> mark items as complete with `[x]`, or leave unchecked with `EVALUATED: <decision + reason>`.

### Documentation updates
- [x] Update `codex/skills/land-the-plan/SKILL.md` to require manifest update helper between commit and PR creation.
- [x] Add `codex/scripts/task-manifest-land-update.sh` with fail-fast manifest stamp + commit/push logic.
- [x] Add script allow-rules in `codex/rules/git-safe.rules` for home/canonical/repo-local paths.
- [ ] `/doc` audits and YAML contracts EVALUATED: not-applicable because this change is lifecycle script/rule/skill behavior only.

## Testing closeout
- [ ] Missing cases to add: shell integration test that exercises manifest update script against a temporary git repo. EVALUATED: deferred because repository has no shell test harness.
- [ ] Coverage gaps: no end-to-end `land-the-plan` execution test in this workspace. EVALUATED: deferred to future automation coverage.

## Full verification
> Use pinned commands from task spec and canonical repository files.
> Stage 4 requires explicit pass notation: `PASS`.

- [x] Lint: `not-configured` PASS
- [x] Build: `not-configured` PASS
- [x] Tests: `not-configured` PASS
- [x] Script syntax: `bash -n codex/scripts/task-manifest-land-update.sh` PASS
- [x] Landing flow placement: `rg -n "task-manifest-land-update|Step 3 — Update task manifest metadata|Step 4 — Resolve base branch" codex/skills/land-the-plan/SKILL.md` PASS
- [x] Sandbox rule coverage: `rg -n "task-manifest-land-update.sh" codex/rules/git-safe.rules` PASS
- [x] Stage 3 validator: `./codex/scripts/prepare-phased-impl-validate.sh fix-task-manifest-attributes` PASS

## Manual QA (if applicable)
- [x] Steps: inspect script and changed skill/rules to verify sequencing and fail-fast behavior.
- [x] Expected: script runs after commit and before PR in documented flow; rules permit script invocation.

## Code review checklist
- [ ] Correctness and edge cases EVALUATED: deferred to Stage 5 `revalidate` code review gate.
- [ ] Error handling / failure modes EVALUATED: deferred to Stage 5 `revalidate` code review gate.
- [ ] Security (secrets, injection, authz/authn) EVALUATED: deferred to Stage 5 `revalidate` code review gate.
- [ ] Performance (DB queries, hot paths, batching) EVALUATED: not-applicable for these workflow files.
- [ ] Maintainability (structure, naming, boundaries) EVALUATED: deferred to Stage 5 `revalidate` code review gate.
- [ ] Consistency with repo conventions EVALUATED: deferred to Stage 5 `revalidate` code review gate.
- [ ] Test quality and determinism EVALUATED: deferred to Stage 5 `revalidate` code review gate.

## Release / rollout notes (if applicable)
- [x] Migration plan: land script/skill/rules together so landing flow and command policy remain aligned.
- [x] Feature flags: n/a.
- [x] Backout plan: revert touched files if the manifest metadata commit/push step is not desired.

## Outstanding issues (if any)
- None.
