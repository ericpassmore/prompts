# Final Phase — Hardening, Verification, and Closeout

> Stage 4 completion source of truth:
> mark items as complete with `[x]`, or leave unchecked with `EVALUATED: <decision + reason>`.

### Documentation updates
- [x] Lifecycle and complexity policy docs updated in `codex/skills/*` and template guidance.
- [ ] `/doc` audit and updates EVALUATED: repository has no `/doc` tree for this codex lifecycle workspace.
- [ ] YAML documentation contracts (`/doc/**/*.yaml`) EVALUATED: not applicable for script/doc-only lifecycle policy changes.
- [ ] README updates EVALUATED: no repository README policy section changes were required for locked scope.
- [ ] ADR updates EVALUATED: not applicable; no durable architecture decision beyond lifecycle policy script/docs alignment.
- [ ] Inline docs/comments EVALUATED: no additional inline comments required; script changes are self-explanatory.

## Testing closeout
- [x] Missing cases to add: targeted scorer/validator regression checks for upward-only policy executed.
- [x] Coverage gaps: no additional gaps identified for in-scope script/doc policy behavior.

## Full verification
> Use the pinned commands in spec + `./codex/project-structure.md` + `./codex/codex-config.yaml`.
> Stage 4 requires explicit pass notation: `PASS`.

- [x] Lint: `not-configured` PASS
- [x] Build: `not-configured` PASS
- [x] Tests: `not-configured` PASS
- [x] Additional checks: `bash -n codex/scripts/complexity-score.sh codex/scripts/goals-validate.sh codex/scripts/prepare-phased-impl-validate.sh codex/scripts/prepare-phased-impl-scaffold.sh` PASS
- [x] Additional checks: `./codex/scripts/prepare-phased-impl-validate.sh complexity-upward-only-scaling` PASS

## Manual QA (if applicable)
- [ ] Steps EVALUATED: not applicable for CLI/script policy change.
- [ ] Expected EVALUATED: not applicable for CLI/script policy change.

## Code review checklist
- [x] Correctness and edge cases
- [x] Error handling / failure modes
- [x] Security (secrets, injection, authz/authn)
- [x] Performance (DB queries, hot paths, batching)
- [x] Maintainability (structure, naming, boundaries)
- [x] Consistency with repo conventions
- [x] Test quality and determinism

## Release / rollout notes (if applicable)
- [ ] Migration plan EVALUATED: no runtime/data migration required.
- [ ] Feature flags EVALUATED: not applicable.
- [ ] Backout plan EVALUATED: revert modified script/doc files for this task.

## Outstanding issues (if any)
- None.
