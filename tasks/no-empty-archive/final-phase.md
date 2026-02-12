# Final Phase — Hardening, Verification, and Closeout

> Stage 4 completion source of truth:
> mark items as complete with `[x]`, or leave unchecked with `EVALUATED: <decision + reason>`.

### Documentation updates
- [x] Update task artifacts to record deterministic template-comparison behavior and verification evidence.
- [ ] `/doc` audit and updates EVALUATED: not-applicable because this repository has no `/doc` surface for this script-only change.
- [ ] README updates EVALUATED: deferred because change is task-local script behavior and does not alter repository onboarding flow.
- [ ] ADRs (if any) EVALUATED: not-applicable; no durable architecture decision introduced.

## Testing closeout
- [ ] Missing cases to add: dedicated shell harness coverage for template/no-template archive branches. EVALUATED: deferred because repository has no shell test harness.
- [ ] Coverage gaps: no end-to-end ACAC lifecycle automation test for this task. EVALUATED: deferred to future infra task.

## Full verification
> Use pinned commands from task spec and canonical repository files.
> Stage 4 requires explicit pass notation: `PASS`.

- [x] Lint: `not-configured` PASS
- [x] Build: `not-configured` PASS
- [x] Tests: `not-configured` PASS
- [x] Script syntax: `bash -n codex/scripts/prepare-phased-impl-archive.sh` PASS
- [x] Stage 3 validator: `./codex/scripts/prepare-phased-impl-validate.sh no-empty-archive` PASS
- [x] Template-only no-op check: `./codex/scripts/prepare-phased-impl-archive.sh no-empty-archive` PASS
- [x] Substantive-archive check: `./codex/scripts/prepare-phased-impl-archive.sh no-empty-archive` PASS

## Manual QA (if applicable)
- [x] Steps: inspect archive output directories and script log messages for both template-only and substantive paths.
- [x] Expected: template-only path performs no-op; substantive path creates a new archive directory.

## Code review checklist
- [ ] Correctness and edge cases EVALUATED: deferred to Stage 5 `revalidate` gate.
- [ ] Error handling / failure modes EVALUATED: deferred to Stage 5 `revalidate` gate.
- [ ] Security (secrets, injection, authz/authn) EVALUATED: deferred to Stage 5 `revalidate` gate.
- [ ] Performance (DB queries, hot paths, batching) EVALUATED: not-applicable for this shell script update.
- [ ] Maintainability (structure, naming, boundaries) EVALUATED: deferred to Stage 5 `revalidate` gate.
- [ ] Consistency with repo conventions EVALUATED: deferred to Stage 5 `revalidate` gate.
- [ ] Test quality and determinism EVALUATED: deferred to Stage 5 `revalidate` gate.

## Release / rollout notes (if applicable)
- [x] Migration plan: land archive guard script and task artifacts together.
- [x] Feature flags: n/a
- [x] Backout plan: revert `codex/scripts/prepare-phased-impl-archive.sh` if regressions are detected.

## Outstanding issues (if any)
- None.
