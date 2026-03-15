# Final Phase — Hardening, Verification, and Closeout

> Stage 4 completion source of truth:
> mark items as complete with `[x]`, or leave unchecked with `EVALUATED: <decision + reason>`.

### Documentation updates

* [x] Update the repository-local process assets that implement the issue-first workflow and triage guidance.

* [ ] `/doc` audit and updates EVALUATED: expected not-applicable unless implementation introduces `/doc` assets, which are not currently planned.

  * [ ] Enumerate documentation artifacts under `/doc` that are impacted by this change (API behavior, auth, error contracts, examples, migrations, ops notes). EVALUATED: not-applicable because this rollout stays within `codex/prompts/` and `codex/rules/`.
  * [ ] Update affected docs and ensure cross-links remain valid (README ↔ docs ↔ ADRs/runbooks). EVALUATED: not-applicable because no `/doc` artifacts were introduced or changed.

* [ ] YAML documentation contracts (`/doc/**/*.yaml`) EVALUATED: not-applicable unless implementation creates an API-like contract surface outside the currently planned prompt/rules assets.

  * [ ] Discover all YAML documentation files under `/doc` (recursive) and update any impacted by the change: EVALUATED: not-applicable because no YAML contract surface is involved in this workflow.

    * [ ] endpoint definitions, request/response schemas, auth schemes, error models EVALUATED: not-applicable because no API contract changed.
    * [ ] examples (happy path + common failures) EVALUATED: not-applicable because no YAML examples are used for these process assets.
  * [ ] If a YAML contract/spec is required for this change but no matching file exists yet: EVALUATED: not-applicable because the rollout does not require YAML contract/spec assets.

    * [ ] Create an initial YAML spec in `/doc/` using the repo’s conventions (OpenAPI/AsyncAPI/etc. as applicable) EVALUATED: not-applicable because no API/schema surface is in scope.
    * [ ] Include minimum viable metadata (`info`, `servers`/environment targets, `securitySchemes` where relevant) plus at least one representative operation and shared error schema(s) EVALUATED: not-applicable because no YAML spec is required.

* [ ] README updates EVALUATED: defer unless the first-rollout process assets need a repository entry point outside `codex/prompts/`.

  * [ ] Add or refresh a single “Documentation” section linking to `/doc/` and any key YAML specs within it. EVALUATED: deferred because this rollout stays within `codex/prompts/` and `codex/rules/`.
  * [ ] Include local validation/viewing instructions if the repo has them (lint/validate/render command). EVALUATED: deferred because no README documentation surface was changed.

* [ ] ADRs (if any) EVALUATED: not-applicable unless implementation introduces a durable architecture decision beyond the locked process/rules scope.

  * [ ] Add/update an ADR when the change introduces a durable architectural decision (contract format, versioning policy, auth strategy, error envelope standardization). EVALUATED: not-applicable because no new architecture decision was introduced.

* [ ] Inline docs/comments EVALUATED: update only if implementation adds non-obvious rule or prompt logic that benefits from concise inline explanation.

  * [ ] Update inline comments/docstrings only where they add implementation clarity without duplicating the YAML contracts. EVALUATED: not-applicable because the prompt/rules changes are self-explanatory without inline comments.

## Testing closeout
- [ ] Missing cases to add: process-asset consistency checks and narrow rule-change validation for `gh issue create`. EVALUATED: deferred because this repository does not have a dedicated automated harness for prompt/rules asset tests.
- [ ] Coverage gaps: no full GitHub network execution is expected in sandbox; rely on config/rules inspection plus validator evidence unless escalated later. EVALUATED: accepted because network execution is outside the current sandbox and not required to validate the repository changes.

## Full verification
> Use the pinned commands in spec + `./codex/project-structure.md` + `./codex/codex-config.yaml`.
> Stage 4 requires explicit pass notation: `PASS`.

- [x] Lint: `not-configured` PASS
- [x] Build: `not-configured` PASS
- [x] Tests: `not-configured` PASS
- [x] Stage 3 validator: `./codex/scripts/prepare-phased-impl-validate.sh self-improve-skills` PASS
- [x] Rules scan: `rg -n "gh\", \"issue\", \"create|ericpassmore/prompts" codex/rules/*.rules codex/prompts/*.md` PASS
- [x] Process asset review: `sed -n '1,260p' codex/prompts/self-improve-skills.md` and `sed -n '1,260p' codex/prompts/self-improve-skills-triage.md` PASS

## Manual QA (if applicable)
- [x] Steps: manually review the issue-first workflow, triage prompt, and rules change together for traceability to locked goals.
- [x] Expected: each incident class is covered, triage and parent escalation are explicit, and `gh issue create` enablement is documented narrowly for `ericpassmore/prompts`.

## Code review checklist
- [ ] Correctness and edge cases EVALUATED: deferred to `land-the-plan`, where Stage 5 handles code review.
- [ ] Error handling / failure modes EVALUATED: deferred to `land-the-plan`, where Stage 5 handles code review.
- [ ] Security (secrets, injection, authz/authn) EVALUATED: deferred to `land-the-plan`, where Stage 5 handles code review.
- [ ] Performance (DB queries, hot paths, batching) EVALUATED: not-applicable for prompt/rules-only changes beyond keeping the rule scope narrow.
- [ ] Maintainability (structure, naming, boundaries) EVALUATED: satisfied by limiting the rollout to two prompt assets and one rules change; final review deferred to Stage 5.
- [ ] Consistency with repo conventions EVALUATED: satisfied by matching existing `codex/prompts/` and `git-safe.rules` patterns; final review deferred to Stage 5.
- [ ] Test quality and determinism EVALUATED: bounded by the repository’s `not-configured` verification baseline; final review deferred to Stage 5.

## Release / rollout notes (if applicable)
- [x] Migration plan: land the process assets and the narrow rules change in one reviewable change set.
- [x] Feature flags: not-applicable.
- [x] Backout plan: revert the prompt assets and the `gh issue create` rule entry if rollout feedback shows misuse or drift.

## Outstanding issues (if any)
For each issue include severity + repro + suggested fix.
- None.
