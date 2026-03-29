# Final Phase — Hardening, Verification, and Closeout

> Stage 4 completion source of truth:
> mark items as complete with `[x]`, or leave unchecked with `EVALUATED: <decision + reason>`.

### Documentation updates
- [x] Update `codex/codex-config.yaml` to document the owner/org token-env wrapper contract.
- [x] Update `codex/skills/land-the-plan/SKILL.md` to use wrapper-based PR fallback guidance.
- [x] Update `codex/prompts/self-improve-skills.md` to use wrapper-based issue creation guidance.
- [x] Update `codex/rules/git-safe.rules` to allow the wrapper scripts instead of the migrated raw `gh` entries.
- [ ] `/doc`, YAML contracts, README, and ADR updates EVALUATED: not-applicable because this change is limited to lifecycle config, scripts, rules, and prompts.

## Testing closeout
- [ ] Missing cases to add: live authenticated create/delete diagnostic exercise against a disposable test repository. EVALUATED: deferred because live GitHub mutation is intentionally manual-only.
- [ ] Coverage gaps: no end-to-end private-repo permission check was run in this sandbox. EVALUATED: deferred because the wrapper contract is verified locally and live auth flows require real credentials.

## Full verification
> Use the pinned commands in spec + `./codex/project-structure.md` + `./codex/codex-config.yaml`.
> Stage 4 requires explicit pass notation: `PASS`.

- [x] Lint: `not-configured` PASS
- [x] Build: `not-configured` PASS
- [x] Tests: `not-configured` PASS
- [x] Script syntax: `bash -n codex/scripts/gh-wrap.sh codex/scripts/gh-auth-check.sh` PASS
- [x] Ambient auth fallback probe: `GH_TOKEN=ambient GH_WRAP_DEBUG=1 ./codex/scripts/gh-wrap.sh pr view --repo ericpassmore/prompts --json number,url` PASS
- [x] Configured-but-unset wrapper probe: `GH_WRAP_DEBUG=1 ./codex/scripts/gh-wrap.sh pr create --repo example-owner/repo --title Test --body Test` PASS (exit code `4` with expected auth-block)
- [x] Diagnostic auth-block probe: `./codex/scripts/gh-auth-check.sh --repo example-owner/repo` PASS (exit code `4` with expected auth-block)
- [x] Wrapper migration scan: `rg -n "gh-wrap.sh|gh-auth-check.sh|gh pr create|gh issue create" codex/skills/land-the-plan/SKILL.md codex/prompts/self-improve-skills.md codex/rules/git-safe.rules` PASS
- [x] Raw gh rule removal check: `rg -n 'pattern = \["gh",' codex/rules/git-safe.rules` PASS (no matches)
- [x] Stage 3 validator: `./codex/scripts/prepare-phased-impl-validate.sh gh-wrapper-auth-routing` PASS

## Manual QA (if applicable)
- [x] Steps: review wrapper debug output and migrated skill/prompt/rule surfaces together.
- [x] Expected: ambient fallback remains unchanged for unmapped owners, mapped-but-unset owners hard-block clearly, and touched guidance points only reference wrappers.

## Code review checklist
- [ ] Correctness and edge cases EVALUATED: deferred to Stage 5 `revalidate` review gate.
- [ ] Error handling / failure modes EVALUATED: deferred to Stage 5 `revalidate` review gate.
- [ ] Security (secrets, injection, authz/authn) EVALUATED: deferred to Stage 5 `revalidate` review gate.
- [ ] Performance (DB queries, hot paths, batching) EVALUATED: not-applicable for small shell/config/rule changes.
- [ ] Maintainability (structure, naming, boundaries) EVALUATED: deferred to Stage 5 `revalidate` review gate.
- [ ] Consistency with repo conventions EVALUATED: deferred to Stage 5 `revalidate` review gate.
- [ ] Test quality and determinism EVALUATED: deferred to Stage 5 `revalidate` review gate.

## Release / rollout notes (if applicable)
- [x] Migration plan: land config, wrappers, skill/prompt text, and rule updates together so no stale raw `gh` guidance remains.
- [x] Feature flags: n/a.
- [x] Backout plan: revert touched config, scripts, skills, prompt text, and rules together if wrapper-based CLI auth routing is not desired.

## Outstanding issues (if any)
- None.
