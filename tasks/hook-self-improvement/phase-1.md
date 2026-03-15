# Phase 1 — Add Prompt Activation Rule

## Objective
Add one explicit `codex/AGENTS.md` instruction that routes qualifying ACAC or product-idea incidents to `Prompt: self-improve-skills` without changing lifecycle-stage behavior.

## Code areas impacted
- `codex/AGENTS.md`

## Work items
- [x] Choose the narrowest contract section in `codex/AGENTS.md` for the new routing rule.
- [x] Add wording that references ACAC and product-idea explicitly and points to `codex/prompts/self-improve-skills.md`.
- [x] Ensure the wording states that prompt activation does not bypass stage gates or authorize unrelated scope expansion.

## Deliverables
- Updated `codex/AGENTS.md` with the new prompt-activation rule in Section 1.2.

## Gate (must pass before proceeding)
Phase 1 passes only when the diff is limited to the requested contract wording and the added rule is traceable to Goals 1-2.
- [x] `codex/AGENTS.md` contains the new routing rule and no unrelated contract edits.

## Verification steps
List exact commands and expected results.
- [x] Command: `rg -n "self-improve-skills|acac|product-idea" codex/AGENTS.md`
  - Expected: shows the new routing rule alongside the relevant existing terms.
- [x] Command: `git diff -- codex/AGENTS.md`
  - Expected: shows one surgical contract edit with no unrelated file-surface expansion.

## Risks and mitigations
- Risk: wording is too broad and triggers self-improvement routing for normal task friction.
- Mitigation: anchor the rule to the incident classes already defined by `codex/prompts/self-improve-skills.md`.
