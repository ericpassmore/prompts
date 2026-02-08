# Final Phase — Hardening, Verification, and Closeout

> Stage 4 completion source of truth:
> mark items as complete with `[x]`, or leave unchecked with `EVALUATED: <decision + reason>`.

### Documentation updates

* [x] Codex documentation migration
  * [x] Update references in `codex/AGENTS.md`, templates, prompts, and skill docs to new canonical files.
  * [x] Ensure no active instructions direct agents to use `codex-commands.md`.

* [x] `codex/project-structure.md` quality gate
  * [x] Verify file exists and follows the same section pattern used by existing `project-structure/*.md` examples.
  * [x] Verify document is repository-specific and includes canonical verification guidance.

* [x] `codex/codex-config.yaml` quality gate
  * [x] Verify file exists and contains required Code Review base branch and Notes semantics.
  * [x] Verify wording remains aligned with task/spec verification guidance.

## Testing closeout
- [ ] Missing cases to add: script-level guard tests for missing `codex/project-structure.md`. EVALUATED: deferred because this repository has no dedicated automated shell test harness yet.
- [ ] Coverage gaps: fallback path resolution behavior after manifest migration. EVALUATED: deferred pending future shell-test framework adoption.

## Full verification
> Use pinned commands from task spec and new canonical files.
> Stage 4 requires explicit pass notation: `PASS`.

- [x] Lint: `not-configured` PASS
- [x] Build: `not-configured` PASS
- [x] Tests: `not-configured` PASS
- [x] Migration scan: `rg -n "codex-commands\\.md" codex` PASS
- [x] Required files: `test -f codex/project-structure.md && test -f codex/codex-config.yaml` PASS

## Manual QA (if applicable)
- [x] Steps: run stage bootstrap/path-resolution scripts in a clean branch.
- [x] Expected: scripts resolve new canonical files and abort with explicit `BLOCKED` when `codex/project-structure.md` is absent.

## Code review checklist
- [ ] Correctness and edge cases EVALUATED: deferred to Stage 5 `revalidate` code-review gate.
- [ ] Error handling / failure modes EVALUATED: deferred to Stage 5 `revalidate` code-review gate.
- [ ] Security (secrets, injection, authz/authn) EVALUATED: deferred to Stage 5 `revalidate` code-review gate.
- [ ] Performance (DB queries, hot paths, batching) EVALUATED: deferred to Stage 5 `revalidate` code-review gate.
- [ ] Maintainability (structure, naming, boundaries) EVALUATED: deferred to Stage 5 `revalidate` code-review gate.
- [ ] Consistency with repo conventions EVALUATED: deferred to Stage 5 `revalidate` code-review gate.
- [ ] Test quality and determinism EVALUATED: deferred to Stage 5 `revalidate` code-review gate.

## Release / rollout notes (if applicable)
- [x] Migration plan: merge script/skill updates before deleting legacy manifest.
- [x] Feature flags: n/a
- [x] Backout plan: reintroduce `codex/codex-commands.md` references only if new canonical config path fails and hotfix is required.

## Outstanding issues (if any)
For each issue include severity + repro + suggested fix.
- None.
