# Final Phase — Hardening, Verification, and Closeout

> Stage 4 completion source of truth:
> mark items as complete with `[x]`, or leave unchecked with `EVALUATED: <decision + reason>`.

### Documentation updates
- [x] Update task planning and verification artifacts for this change.
- [ ] `/doc` audit and updates EVALUATED: not-applicable because this repository has no `/doc` surface for these script and task-artifact changes.
- [ ] README updates EVALUATED: deferred because behavior changes are lifecycle-internal and already captured in task artifacts.
- [ ] ADRs (if any) EVALUATED: not-applicable because no durable architecture decision was introduced.

## Testing closeout
- [ ] Missing cases to add: dedicated shell harness coverage for manifest migration and complexity-range boundary checks. EVALUATED: deferred because repository has no shell test harness.
- [ ] Coverage gaps: no end-to-end lifecycle automation test for this specific task path. EVALUATED: deferred to future infra work.

## Full verification
> Use pinned commands from task spec and canonical repository files.
> Stage 4 requires explicit pass notation: `PASS`.

- [x] Lint: `not-configured` PASS
- [x] Build: `not-configured` PASS
- [x] Tests: `not-configured` PASS
- [x] Script syntax: `bash -n codex/scripts/goals-scaffold.sh codex/scripts/prepare-phased-impl-validate.sh codex/scripts/complexity-score.sh` PASS
- [x] Complexity mapping check: `./codex/scripts/complexity-score.sh tasks/improve-task-grain/complexity-signals.json --format json` PASS
- [x] Stage 3 validator: `./codex/scripts/prepare-phased-impl-validate.sh improve-task-grain` PASS
- [x] Manifest schema check: `rg -n "^number,taskname,first_create_date,first_create_hhmmss,first_create_git_hash$" goals/task-manifest.csv` PASS

## Manual QA (if applicable)
- [x] Steps: inspect changed scripts and manifest output for requested defaults, ordering keys, and complexity-gated validation behavior.
- [x] Expected: manifest includes new columns with defaults; Stage 3 validation enforces complexity ranges and requested global bounds.

## Code review checklist
- [ ] Correctness and edge cases EVALUATED: deferred to Stage 5 `revalidate` code-review gate.
- [ ] Error handling / failure modes EVALUATED: deferred to Stage 5 `revalidate` code-review gate.
- [ ] Security (secrets, injection, authz/authn) EVALUATED: deferred to Stage 5 `revalidate` code-review gate.
- [ ] Performance (DB queries, hot paths, batching) EVALUATED: not-applicable for these shell scripts and lifecycle artifacts.
- [ ] Maintainability (structure, naming, boundaries) EVALUATED: deferred to Stage 5 `revalidate` code-review gate.
- [ ] Consistency with repo conventions EVALUATED: deferred to Stage 5 `revalidate` code-review gate.
- [ ] Test quality and determinism EVALUATED: deferred to Stage 5 `revalidate` code-review gate.

## Release / rollout notes (if applicable)
- [x] Migration plan: land manifest/script/task changes together so Stage 3 behavior and manifest schema remain aligned.
- [x] Feature flags: n/a
- [x] Backout plan: revert touched script and artifact files if regressions are found.

## Outstanding issues (if any)
- None.
