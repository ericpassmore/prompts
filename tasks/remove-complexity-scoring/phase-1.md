# Phase 1 — Remove Dedicated Complexity Assets

## Objective

Delete the active complexity skill, scorer, signals template, and active rule/prompt surfaces dedicated to scoring.

## Code areas impacted

- `.codex/skills/complexity-scaling/`
- `.codex/scripts/complexity-score.sh`
- `.codex/tasks/_templates/complexity-signals.template.json`
- Complexity-specific active rules and prompts discovered by repository search

## Work items

- [x] Remove dedicated scoring assets.
- [x] Remove obsolete active rule/prompt entries that exist only to authorize or describe scoring.

## Deliverables

- Dedicated deterministic complexity-scoring assets are absent.

## Gate (must pass before proceeding)

- [x] Removed paths no longer exist and unrelated active files remain intact.

## Verification steps

- [x] Command: `test ! -e .codex/scripts/complexity-score.sh && test ! -e .codex/skills/complexity-scaling && test ! -e .codex/tasks/_templates/complexity-signals.template.json`
  - Expected: exit status 0.

## Risks and mitigations

- Risk: removing an apparently dedicated rule block damages adjacent rule syntax.
- Mitigation: inspect boundaries and validate the remaining rule file structurally.
