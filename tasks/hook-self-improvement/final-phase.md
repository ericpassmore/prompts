# Final Phase — Hardening, Verification, and Closeout

> Stage 4 completion source of truth:
> mark items as complete with `[x]`, or leave unchecked with `EVALUATED: <decision + reason>`.

### Documentation updates
- [x] Update `codex/AGENTS.md` with a self-improvement incident-routing subsection for `acac` and `product-idea`.
- [ ] `/doc` audit and updates EVALUATED: not-applicable because this change only updates repository workflow contract text in `codex/AGENTS.md`.
- [ ] YAML documentation contracts (`/doc/**/*.yaml`) EVALUATED: not-applicable because no API or schema contract exists for this change.
- [ ] README updates EVALUATED: not-applicable because the requested behavior is scoped to `codex/AGENTS.md`.
- [ ] ADRs (if any) EVALUATED: not-applicable because this is a surgical workflow-rule insertion, not a durable architecture decision.
- [ ] Inline docs/comments EVALUATED: not-applicable because the requested behavior is already expressed in the contract text itself.

## Testing closeout
- [ ] Missing cases to add: none beyond existing targeted contract review. EVALUATED: repository has no automation harness for AGENTS contract text.
- [ ] Coverage gaps: no automated test runner exists for AGENTS contract semantics. EVALUATED: accepted under the repository's `not-configured` verification baseline.

## Full verification
> Use the pinned commands in spec + `./codex/project-structure.md` + `./codex/codex-config.yaml`.
> Stage 4 requires explicit pass notation: `PASS`.

- [x] Lint: `not-configured` PASS
- [x] Build: `not-configured` PASS
- [x] Tests: `not-configured` PASS
- [x] Prompt routing check: `rg -n "self-improve-skills|acac|product-idea" codex/AGENTS.md` PASS
- [x] Surgical diff review: `git diff -- codex/AGENTS.md` PASS
- [x] Stage 3 validator: `./codex/scripts/prepare-phased-impl-validate.sh hook-self-improvement` PASS

## Manual QA (if applicable)
- [x] Steps: inspect the inserted subsection in `codex/AGENTS.md` and confirm it points only to `Prompt: self-improve-skills` and preserves stage-gate language.
- [x] Expected: the rule activates prompt routing for qualifying ACAC or product-idea incidents without altering lifecycle verdicts or scope controls.

## Principles review
- [x] Lock Goals Before Action: goals were approved and locked before `codex/AGENTS.md` was edited.
- [x] Respect Stage Gates: the change preserves lifecycle order and explicitly states that prompt activation does not relax stage gates.
- [x] Keep Changes Minimal: the implementation is a single new subsection in `codex/AGENTS.md` plus required task artifacts.
- [x] Fail Fast and Explicitly: the wording routes qualifying incidents to an existing prompt instead of leaving activation implicit.
- [x] Verify, Then Declare Done: verification evidence is recorded here and with the Stage 3 validator before Stage 4 completion.
- [x] Detect Drift and Stop: no scope expansion occurred beyond the locked `codex/AGENTS.md` routing rule and required task artifacts.

## Code review checklist
- [ ] Correctness and edge cases EVALUATED: reviewed directly against the locked goals and limited to qualifying `self-improve-skills` incidents.
- [ ] Error handling / failure modes EVALUATED: the rule is explicit that prompt activation does not alter lifecycle requirements.
- [ ] Security (secrets, injection, authz/authn) EVALUATED: not-applicable for a local markdown contract change.
- [ ] Performance (DB queries, hot paths, batching) EVALUATED: not-applicable for a local markdown contract change.
- [ ] Maintainability (structure, naming, boundaries) EVALUATED: the new subsection sits near the top-level contract rules and references the existing prompt asset directly.
- [ ] Consistency with repo conventions EVALUATED: the change uses existing naming (`acac`, `product-idea`, `Prompt: ...`) and keeps behavior in `codex/AGENTS.md`.
- [ ] Test quality and determinism EVALUATED: bounded by the repository's `not-configured` verification baseline and targeted contract checks.

## Release / rollout notes (if applicable)
- [x] Migration plan: land the `codex/AGENTS.md` wording together with the task artifacts so the contract and evidence stay aligned.
- [x] Feature flags: n/a.
- [x] Backout plan: revert the inserted subsection in `codex/AGENTS.md` if the routing rule proves too broad or too narrow.

## Outstanding issues (if any)
- None.
