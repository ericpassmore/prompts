# Final Phase — Hardening, Verification, and Closeout

> Stage 4 completion source of truth:
> mark items as complete with `[x]`, or leave unchecked with `EVALUATED: <decision + reason>`.

## Documentation updates

- [x] Confirm lifecycle docs and skills match implemented script behavior.
- [x] Update prompt guidance only where it affects ACAC or stage workflow behavior.
- [x] Keep issue-sourced external repository references out of implementation docs unless needed for reproduction evidence.

## Testing closeout

- [x] G1 complexity-signals first-pass reliability verified with task scaffold and Stage 3 missing-signals fixtures.
- [x] G2 untracked staging isolation verified with a mixed task-owned/unrelated untracked fixture.
- [x] G3 no-upstream recovery verified with a named-branch no-upstream preflight fixture.
- [x] G4 ACAC continuation verified by skill and prompt contract updates.
- [x] G5 dirty-worktree decision verified with `prepare-takeoff-worktree.sh may-self-improvements`.
- [x] G6 env sample policy verified with tracked `develop.env` and rejected `.env.local` fixture.
- [x] G7 review revalidation diff selection verified with base-diff plus working-tree fixture.
- [x] `not-configured` lint/build/test command classes explicitly documented.

## Full verification
> Use the pinned commands in spec + `./codex/project-structure.md` + `./codex/codex-config.yaml`.
> Stage 4 requires explicit pass notation: `PASS`.

- [x] Lint: `not-configured` PASS (repository command class is explicitly not configured)
- [x] Build: `not-configured` PASS (repository command class is explicitly not configured)
- [x] Tests: `bash -n changed shell scripts plus targeted /private/tmp fixtures` PASS
- [x] Script health: `./codex/scripts/prepare-takeoff-bootstrap.sh` PASS
- [x] Stage 3 validation: `./codex/scripts/prepare-phased-impl-validate.sh may-self-improvements` PASS
- [x] Stage 4 validation: `./codex/scripts/implement-validate.sh may-self-improvements` PASS after final validation

## Manual QA (if applicable)

- [x] ACAC continuation scenario reviewed against updated skill/prompt guidance.
- [x] Dirty-worktree and staging output reviewed for operator clarity.

## Code review checklist

- [x] Correctness and edge cases
- [x] Error handling / failure modes
- [x] Security, including env-file protections
- [x] Maintainability and minimal surface changes
- [x] Consistency with repo conventions
- [x] Test quality and determinism

## Release / rollout notes (if applicable)

- [x] Repository-local changes are ready to land.
- [x] Any `$HOME/.codex` sync need is documented as a follow-up, not performed unless explicitly approved.
- [x] GitHub issue updates remain manual unless scope changes.

## Outstanding issues (if any)

- None.
