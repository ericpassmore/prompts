# Final Phase — Hardening, Verification, and Closeout

> Stage 4 completion source of truth:
> mark items as complete with `[x]`, or leave unchecked with `EVALUATED: <decision + reason>`.

### Documentation updates
- [x] Update governance artifacts and task lifecycle docs for principles alignment + speedup work.
- [ ] `/doc` audit and updates EVALUATED: not-applicable because this repository does not use `/doc` for these lifecycle script/contract changes.
- [ ] YAML documentation contracts (`/doc/**/*.yaml`) EVALUATED: not-applicable because no API/schema contract surface changed.
- [ ] README updates EVALUATED: deferred because behavior changes are internal to `codex` governance and scripts.
- [ ] ADRs (if any) EVALUATED: not-applicable because no durable architecture decision was introduced.
- [x] Inline docs/comments updated only where clarity was needed for fast-path behavior.

## Testing closeout
- [ ] Missing cases to add: dedicated shell harness tests for `resolve-codex-root.sh` and `read-codex-paths.sh` fast-path branches. EVALUATED: deferred because repository has no shell test harness.
- [ ] Coverage gaps: no end-to-end lifecycle automation test in this sandbox for all stage transitions. EVALUATED: deferred to future infra task.

## Full verification
> Use pinned commands from task spec and canonical repository files.
> Stage 4 requires explicit pass notation: `PASS`.

- [x] Lint: `not-configured` PASS
- [x] Build: `not-configured` PASS
- [x] Tests: `not-configured` PASS
- [x] Stage 3 validator: `./codex/scripts/prepare-phased-impl-validate.sh improve-feb-15-2026` PASS
- [x] Consistency scan: `rg -n "goals exist \(1-10\)|Section 8|GOALS LOCKED|READY FOR PLANNING|READY FOR IMPLEMENTATION|READY FOR REVERIFICATION|READY TO REPLAN|READY TO LAND|LANDED|BLOCKED" codex/AGENTS.md codex/skills/**/SKILL.md` PASS
- [x] Script resolution check: `./codex/scripts/resolve-codex-root.sh scripts codex-config.yaml project-structure.md` PASS
- [x] Script resolution check: `./codex/scripts/read-codex-paths.sh` PASS
- [x] Script syntax: `bash -n codex/scripts/resolve-codex-root.sh codex/scripts/read-codex-paths.sh` PASS

## Manual QA (if applicable)
- [x] Steps: manually reviewed diffs in `codex/AGENTS.md`, affected skills, and path-resolution scripts for contract preservation.
- [x] Expected: stage order and verdict tokens unchanged; mismatch references removed; path resolution still resolves `./codex` in this repository.

## Code review checklist
- [ ] Correctness and edge cases EVALUATED: deferred to Stage 5 `revalidate` code-review gate.
- [ ] Error handling / failure modes EVALUATED: deferred to Stage 5 `revalidate` code-review gate.
- [ ] Security (secrets, injection, authz/authn) EVALUATED: deferred to Stage 5 `revalidate` code-review gate.
- [ ] Performance (DB queries, hot paths, batching) EVALUATED: addressed by script fast-path change; final review deferred to Stage 5 gate.
- [ ] Maintainability (structure, naming, boundaries) EVALUATED: improved by consistency fixes; final review deferred to Stage 5 gate.
- [ ] Consistency with repo conventions EVALUATED: improved; final review deferred to Stage 5 gate.
- [ ] Test quality and determinism EVALUATED: deferred to Stage 5 `revalidate` gate.

## Release / rollout notes (if applicable)
- [x] Migration plan: land AGENTS/skills/script/task-artifact updates together.
- [x] Feature flags: n/a.
- [x] Backout plan: revert touched governance/script/task files if regressions are found.

## Outstanding issues (if any)
- None.
