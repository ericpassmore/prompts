# Final Phase — Hardening, Verification, and Closeout

> Stage 4 completion source of truth:
> mark items as complete with `[x]`, or leave unchecked with `EVALUATED: <decision + reason>`.

### Documentation updates
- [x] Update task lifecycle artifacts for stale-path bug fix and verification evidence.
- [ ] `/doc` audit and updates EVALUATED: not-applicable because this repository does not maintain `/doc` for these lifecycle script changes.
- [ ] YAML documentation contracts (`/doc/**/*.yaml`) EVALUATED: not-applicable because no API/schema contracts changed.
- [ ] README updates EVALUATED: deferred; change is internal to codex path-resolution scripts.
- [ ] ADRs (if any) EVALUATED: not-applicable because no long-lived architecture policy changed.
- [x] Inline script comments updated where fast-path behavior needs clarification.

## Testing closeout
- [ ] Missing cases to add: dedicated shell test harness for stale-env resolution scenarios. EVALUATED: deferred because repository has no script test harness.
- [ ] Coverage gaps: no full multi-repo environment integration test in sandbox. EVALUATED: deferred to future infra task.

## Full verification
> Use pinned commands from task spec and canonical repository files.
> Stage 4 requires explicit pass notation: `PASS`.

- [x] Lint: `not-configured` PASS
- [x] Build: `not-configured` PASS
- [x] Tests: `not-configured` PASS
- [x] Stage 3 validator: `./codex/scripts/prepare-phased-impl-validate.sh bug-fix-stale-path` PASS
- [x] Script syntax: `bash -n codex/scripts/read-codex-paths.sh codex/scripts/resolve-codex-root.sh` PASS
- [x] Resolver check: `./codex/scripts/read-codex-paths.sh` PASS
- [x] Stale scripts-dir simulation: `CODEX_ROOT="$(pwd)/codex" CODEX_SCRIPTS_DIR="/Users/eric/.codex/scripts" bash -lc 'source codex/scripts/read-codex-paths.sh >/dev/null; printf "CODEX_ROOT=%s\nCODEX_SCRIPTS_DIR=%s\n" "$CODEX_ROOT" "$CODEX_SCRIPTS_DIR"'` PASS
- [x] Stale explicit root simulation: `CODEX_ROOT="/Users/eric/side-projects/prompts/codex" ./codex/scripts/resolve-codex-root.sh scripts codex-config.yaml project-structure.md` PASS

## Manual QA (if applicable)
- [x] Steps: reviewed resolver diffs and command outputs to confirm stale env values no longer bypass current expected root/scripts values.
- [x] Expected: current repo/worktree paths are exported even when stale env values are pre-set.

## Code review checklist
- [ ] Correctness and edge cases EVALUATED: deferred to Stage 5 `revalidate` code-review gate.
- [ ] Error handling / failure modes EVALUATED: deferred to Stage 5 `revalidate` code-review gate.
- [ ] Security (secrets, injection, authz/authn) EVALUATED: not-applicable for local path-resolution-only changes.
- [ ] Performance (DB queries, hot paths, batching) EVALUATED: fast-path retained with stricter validity checks.
- [ ] Maintainability (structure, naming, boundaries) EVALUATED: improved via explicit expected-root/scripts checks.
- [ ] Consistency with repo conventions EVALUATED: deferred to Stage 5 `revalidate` code-review gate.
- [ ] Test quality and determinism EVALUATED: deferred to Stage 5 `revalidate` code-review gate.

## Release / rollout notes (if applicable)
- [x] Migration plan: land resolver script updates and task artifacts together.
- [x] Feature flags: n/a.
- [x] Backout plan: revert touched resolver scripts and task artifacts.

## Outstanding issues (if any)
- None.
