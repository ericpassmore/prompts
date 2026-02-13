# Final Phase — Hardening, Verification, and Closeout

> Stage 4 completion source of truth:
> mark items as complete with `[x]`, or leave unchecked with `EVALUATED: <decision + reason>`.

### Documentation updates
- [x] Update `codex/skills/land-the-plan/SKILL.md` to replace `gh pr create` command usage with GitHub MCP prompt flow.
- [x] Update `codex/scripts/project-init.sh` PR handoff behavior to output MCP prompt context.
- [x] Update `codex/rules/git-safe.rules` to remove `gh pr` allow rules.
- [ ] `/doc` audits and YAML contracts EVALUATED: not-applicable because this change affects lifecycle scripts/rules/skills only.

## Testing closeout
- [ ] Missing cases to add: shell-level integration test for MCP prompt payload rendering in `project-init.sh`. EVALUATED: deferred because repository has no shell test harness.
- [ ] Coverage gaps: no end-to-end PR creation check in sandboxed environment. EVALUATED: deferred because networked PR operations are intentionally out of scope.

## Full verification
> Use pinned commands from task spec and canonical repository files.
> Stage 4 requires explicit pass notation: `PASS`.

- [x] Lint: `not-configured` PASS
- [x] Build: `not-configured` PASS
- [x] Tests: `not-configured` PASS
- [x] Targeted scan: `rg -n "gh pr create|gh pr edit|gh pr view|gh pr merge|GitHub MCP|MCP" codex/skills/land-the-plan/SKILL.md codex/rules/git-safe.rules codex/scripts/project-init.sh` PASS
- [x] Allow-rule removal check: `rg -n "pattern = \[\"gh\", \"pr\"" codex/rules/git-safe.rules` PASS (no matches)
- [x] Script syntax: `bash -n codex/scripts/project-init.sh` PASS
- [x] Stage 3 validator: `./codex/scripts/prepare-phased-impl-validate.sh move-pr-to-mcp` PASS

## Manual QA (if applicable)
- [x] Steps: review touched files to confirm PR command paths were replaced by MCP prompt text.
- [x] Expected: no `gh pr` command execution path remains in requested surfaces.

## Code review checklist
- [ ] Correctness and edge cases EVALUATED: deferred to Stage 5 `revalidate` review gate.
- [ ] Error handling / failure modes EVALUATED: deferred to Stage 5 `revalidate` review gate.
- [ ] Security (secrets, injection, authz/authn) EVALUATED: deferred to Stage 5 `revalidate` review gate.
- [ ] Performance (DB queries, hot paths, batching) EVALUATED: not-applicable for script/markdown policy updates.
- [ ] Maintainability (structure, naming, boundaries) EVALUATED: deferred to Stage 5 `revalidate` review gate.
- [ ] Consistency with repo conventions EVALUATED: deferred to Stage 5 `revalidate` review gate.
- [ ] Test quality and determinism EVALUATED: deferred to Stage 5 `revalidate` review gate.

## Release / rollout notes (if applicable)
- [x] Migration plan: land skill/rule/script updates together so no stale `gh pr` execution path remains.
- [x] Feature flags: n/a.
- [x] Backout plan: revert touched files if MCP prompt handoff is not desired.

## Outstanding issues (if any)
- None.
