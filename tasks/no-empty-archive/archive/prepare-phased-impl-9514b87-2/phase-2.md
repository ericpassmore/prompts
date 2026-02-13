# Phase 2 — Validate Lifecycle Compatibility And Document Evidence

## Objective
Validate both guard branches (skip and archive) and capture Stage 4/5 evidence without expanding scope.

## Code areas impacted
- `tasks/no-empty-archive/phase-1.md`
- `tasks/no-empty-archive/phase-2.md`
- `tasks/no-empty-archive/final-phase.md`
- `tasks/no-empty-archive/revalidate.md`
- `tasks/no-empty-archive/revalidate-code-review.md`

## Work items
- [ ] Execute targeted archive commands to prove template-only no-op behavior.
- [ ] Execute targeted archive commands to prove substantive-edit archive behavior.
- [ ] Update final-phase verification/outstanding issues with truthful PASS evidence.
- [ ] Complete revalidate artifacts and ensure no actionable review findings.

## Deliverables
- Completed task artifacts with verification evidence and stage verdict traceability.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [ ] Stage 4 validator emits `READY FOR REVERIFICATION`.
- [ ] Revalidate artifacts satisfy `revalidate-code-review.sh` and `revalidate-validate.sh`.
- [ ] No scope drift from locked `IN SCOPE` / `OUT OF SCOPE`.

## Verification steps
List exact commands and expected results.
- [ ] Command: `./codex/scripts/prepare-phased-impl-validate.sh no-empty-archive`
  - Expected: `READY FOR IMPLEMENTATION`
- [ ] Command: `./codex/scripts/implement-validate.sh no-empty-archive`
  - Expected: `READY FOR REVERIFICATION`
- [ ] Command: `./codex/scripts/revalidate-validate.sh no-empty-archive`
  - Expected: `READY TO LAND`

## Risks and mitigations
- Risk: repository lacks configured lint/build/test tooling.
- Mitigation: use pinned `not-configured` command class entries consistently with existing repository policy.
