# Final Phase — Hardening, Verification, and Closeout

## Documentation updates

- [x] Confirm active documentation reflects judgment-based goal and phase sizing.
- [ ] README, API, schema, UI, migration, and rollout documentation EVALUATED: not-applicable; this changes only Codex lifecycle instructions and scripts.

## Testing closeout

- [x] Check modified shell syntax.
- [x] Exercise representative non-scored lifecycle workflows.
- [x] Confirm active-reference search is clean.

## Full verification

- [x] Lint: `bash -n .codex/scripts/goals-validate.sh .codex/scripts/task-scaffold.sh .codex/scripts/prepare-phased-impl-scaffold.sh .codex/scripts/prepare-phased-impl-validate.sh` PASS
- [x] Build: `not-configured` PASS
- [x] Tests: `./.codex/scripts/goals-validate.sh remove-complexity-scoring v0 && ./.codex/scripts/prepare-phased-impl-validate.sh remove-complexity-scoring` PASS; isolated fixture also covered task scaffolding, two-phase planning, absence checks, and invalid-input rejection.

## Manual QA

- [x] Inspect final diff and verify pre-existing historical records were not changed.
- [x] Verify the exact requested sentence appears once in the active `prepare-phased-impl` skill.

## Code review checklist

- [x] Correctness and edge cases
- [x] Failure modes
- [x] Maintainability and repository consistency
- [x] Test quality and determinism

## Release / rollout notes

- [ ] Deployment or migration EVALUATED: not-applicable; repository and personal Codex roots were updated directly.
- [x] Backout is a git revert of repository changes plus restoring synchronized personal-root files from the prior repository revision.

## Outstanding issues

- None.
