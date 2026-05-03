# Final Phase — Hardening, Verification, and Closeout

> Stage 4 completion source of truth:
> mark items as complete with `[x]`, or leave unchecked with `EVALUATED: <decision + reason>`.

### Documentation updates

* [ ] `/doc` audit and updates: EVALUATED: not-applicable; no `/doc` artifact is in locked scope for this lifecycle-instruction repository change.
* [ ] YAML documentation contracts (`/doc/**/*.yaml`): EVALUATED: not-applicable; no YAML documentation contracts are in locked scope.
* [ ] README updates: EVALUATED: not-applicable; README changes are outside locked scope.
* [ ] ADRs (if any): EVALUATED: not-applicable; no durable architectural decision or ADR surface is in locked scope.
* [x] Inline docs/comments: updated skill/prompt/helper guidance where needed; no extra comments were required beyond helper usage text.

## Testing closeout
- [x] Missing cases to add: none for locked scope; targeted syntax and search checks cover the changed shell helpers and instruction surfaces.
- [x] Coverage gaps: repository lint/build/test are `not-configured` in `codex/project-structure.md`; targeted checks and lifecycle validators provide task evidence.

## Full verification
> Use the pinned commands in spec + `./codex/project-structure.md` + `./codex/codex-config.yaml`.
> Stage 4 requires explicit pass notation: `PASS`.

- [x] Lint: `not-configured` PASS
- [x] Build: `not-configured` PASS
- [x] Tests: `not-configured` PASS
- [x] Targeted: `bash -n codex/scripts/git-track-safe-untracked.sh codex/scripts/git-commit-preflight.sh codex/scripts/git-pull-ff-only-safe.sh codex/scripts/git-diff-unstaged-skip-binary.sh codex/scripts/git-resolve-head-branch-safe.sh codex/scripts/git-commit-safe.sh codex/scripts/git-stage-safe.sh` PASS
- [x] Targeted: `rg -n "developement\\.env" codex/skills/git-commit/SKILL.md codex/scripts/git-track-safe-untracked.sh` PASS (no matches)
- [x] Targeted: `rg -n "development\\.env" codex/skills/git-commit/SKILL.md codex/scripts/git-track-safe-untracked.sh` PASS
- [x] Targeted: `rg -n "git (branch|status|fetch|pull|push|diff|rev-parse|rev-list|ls-files|add|rm|worktree|commit|checkout|switch|ls-remote)" codex/skills codex/prompts` PASS (no matches)
- [x] Targeted: `rg -n "\`git [^\`]+\`|Run: \`git|raw \`git|git push -u origin" codex/skills codex/prompts` PASS (no matches)
- [x] Targeted: `rg -n "GitHub MCP|MCP GitHub|Codex MCP GitHub" codex/skills codex/prompts codex/rules/git-safe.rules` PASS (remaining matches are prohibitions only)
- [x] Lifecycle: `./codex/scripts/implement-validate.sh git-wrapper-only` PASS

## Manual QA (if applicable)
- [ ] Steps: EVALUATED: not-applicable; no UI or manual runtime workflow is in locked scope.
- [ ] Expected: EVALUATED: not-applicable.

## Code review checklist
- [x] Correctness and edge cases
- [x] Error handling / failure modes
- [x] Security (secrets, injection, authz/authn)
- [ ] Performance (DB queries, hot paths, batching): EVALUATED: not-applicable; no runtime hot path, DB, or batching behavior changed.
- [x] Maintainability (structure, naming, boundaries)
- [x] Consistency with repo conventions
- [x] Test quality and determinism

## Release / rollout notes (if applicable)
- [ ] Migration plan: EVALUATED: not-applicable.
- [ ] Feature flags: EVALUATED: not-applicable.
- [x] Backout plan: revert in-scope skill/prompt/helper/rule and lifecycle artifact changes together.

## Outstanding issues (if any)
- None.
