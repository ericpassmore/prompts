# Final Phase — Hardening, Verification, and Closeout

> Stage 4 completion source of truth:
> mark items as complete with `[x]`, or leave unchecked with `EVALUATED: <decision + reason>`.

### Documentation updates

* [x] Update the affected workflow and process documentation in `codex/skills/` and `codex/prompts/` so the fixed behavior is explicit.

* [ ] `/doc` audit and updates EVALUATED: not-applicable because this task changes repository-local codex assets only and this repository has no `/doc` surface for these workflows.

  * [ ] Enumerate documentation artifacts under `/doc` that are impacted by this change (API behavior, auth, error contracts, examples, migrations, ops notes). EVALUATED: not-applicable because no `/doc` artifacts are in scope.
  * [ ] Update affected docs and ensure cross-links remain valid (README ↔ docs ↔ ADRs/runbooks). EVALUATED: not-applicable because no `/doc` or README entry point changed.

* [ ] YAML documentation contracts (`/doc/**/*.yaml`) EVALUATED: not-applicable because no API/schema contract is involved.

  * [ ] Discover all YAML documentation files under `/doc` (recursive) and update any impacted by the change: EVALUATED: not-applicable because this task does not touch a YAML contract surface.

    * [ ] endpoint definitions, request/response schemas, auth schemes, error models EVALUATED: not-applicable.
    * [ ] examples (happy path + common failures) EVALUATED: not-applicable.
  * [ ] If a YAML contract/spec is required for this change but no matching file exists yet: EVALUATED: not-applicable because no YAML contract is required.

    * [ ] Create an initial YAML spec in `/doc/` using the repo’s conventions (OpenAPI/AsyncAPI/etc. as applicable) EVALUATED: not-applicable.
    * [ ] Include minimum viable metadata (`info`, `servers`/environment targets, `securitySchemes` where relevant) plus at least one representative operation and shared error schema(s) EVALUATED: not-applicable.

* [ ] README updates EVALUATED: not-applicable because the changes stay within codex-local scripts, skills, prompts, and rules.

  * [ ] Add or refresh a single “Documentation” section linking to `/doc/` and any key YAML specs within it. EVALUATED: not-applicable.
  * [ ] Include local validation/viewing instructions if the repo has them (lint/validate/render command). EVALUATED: not-applicable.

* [ ] ADRs (if any) EVALUATED: not-applicable because the task fixes existing workflow defects without introducing a new architecture decision.

  * [ ] Add/update an ADR when the change introduces a durable architectural decision (contract format, versioning policy, auth strategy, error envelope standardization). EVALUATED: not-applicable.

* [ ] Inline docs/comments EVALUATED: not-applicable because the changed shell logic and skill instructions remain clear without new inline comments.

  * [ ] Update inline comments/docstrings only where they add implementation clarity without duplicating the YAML contracts. EVALUATED: not-applicable.

## Testing closeout
- [ ] Missing cases to add: automated CLI fallback integration for `gh pr view`/`gh pr edit` against a real repository. EVALUATED: deferred because network-backed PR mutation is outside the local validator surface for this repo.
- [ ] Coverage gaps: no end-to-end PR fallback execution against GitHub was run locally; verification is bounded to skill/rule contract inspection and issue updates. EVALUATED: accepted because the task changes the repository contract surface, not a live GitHub integration harness.

## Full verification
> Use the pinned commands in spec + `./codex/project-structure.md` + `./codex/codex-config.yaml`.
> Stage 4 requires explicit pass notation: `PASS`.

- [x] Lint: `not-configured` PASS
- [x] Build: `not-configured` PASS
- [x] Tests: `not-configured` PASS
- [x] Script syntax: `bash -n codex/scripts/resolve-codex-root.sh codex/scripts/goals-extract.sh codex/scripts/goals-validate.sh` PASS
- [x] Explicit repo-root fast path: `CODEX_ROOT="/Users/eric/.codex/worktrees/d105/prompts/codex" ./codex/scripts/resolve-codex-root.sh scripts codex-config.yaml project-structure.md` PASS
- [x] Explicit non-default root fast path: `TMP_ROOT="$(mktemp -d)" && mkdir -p "$TMP_ROOT/scripts" && touch "$TMP_ROOT/codex-config.yaml" "$TMP_ROOT/project-structure.md" && CODEX_ROOT="$TMP_ROOT" ./codex/scripts/resolve-codex-root.sh scripts codex-config.yaml project-structure.md` PASS
- [x] Goals extraction: `./codex/scripts/goals-extract.sh fix-open-prompts-issues v0` PASS
- [x] Goals validation: `./codex/scripts/goals-validate.sh fix-open-prompts-issues v0` PASS
- [x] Stage 3 validator: `./codex/scripts/prepare-phased-impl-validate.sh fix-open-prompts-issues` PASS
- [x] Workflow/rule scan: `rg -n "ready for user review|After approval|self-improve-skills|GitHub MCP|gh pr view|gh pr edit|existing PR" codex/skills/acac/SKILL.md codex/prompts/self-improve-skills.md codex/skills/land-the-plan/SKILL.md codex/rules/git-safe.rules` PASS

## Manual QA (if applicable)
- [x] Steps: review the changed scripts and guidance together to confirm each open issue has a direct fix and validation signal.
- [x] Expected: explicit `CODEX_ROOT` works, scaffold-style goals headers validate, ACAC approval order is correct, self-improvement routing is explicit, and the PR fallback contract supports existing PR reuse/update.

## Code review checklist
- [x] Correctness and edge cases
- [x] Error handling / failure modes
- [x] Security (secrets, injection, authz/authn)
- [ ] Performance (DB queries, hot paths, batching) EVALUATED: not-applicable because the task changes shell/path logic and markdown contract text only.
- [x] Maintainability (structure, naming, boundaries)
- [x] Consistency with repo conventions
- [x] Test quality and determinism

## Release / rollout notes (if applicable)
- [x] Migration plan: land the script, skill, prompt, and rule updates together so the documented workflow and allowed fallback commands stay aligned.
- [x] Feature flags: not-applicable.
- [x] Backout plan: revert the affected script, skill, prompt, and rule edits and reopen the related GitHub issues if any validation signal regresses.

## Outstanding issues (if any)
For each issue include severity + repro + suggested fix.
- None.
