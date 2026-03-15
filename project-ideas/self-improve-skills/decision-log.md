# Decision Log

## D1: Central Tracker

- Decision: all incidents are filed in `ericpassmore/prompts` even when observed in other repositories.
- Rationale: the skills are centralized shared resources, so improvement evidence should accumulate in one place.

## D2: Fast-Path Bug Handling

- Decision: obvious bugs and confirmed defects are filed immediately with minimal repro and severity, and work continues if safe.
- Rationale: waiting for perfect analysis causes silent workarounds and lost evidence.

## D3: Immediate Filing For Noticed Inefficiency

- Decision: inefficiencies are filed when noticed instead of batching them locally.
- Rationale: the user explicitly prefers capture first and later clustering/analysis over delayed reporting.

## D4: Issue First For Poor-Fit Skill Calls

- Decision: poor-fit skill invocations produce issues before any rejection gate is added to the skill itself.
- Rationale: rejection logic should be evidence-backed rather than speculative.

## D5: Default Evidence Assumption

- Decision: start with evidence available to any executing agent without extra infrastructure: source repository, skill/stage, short repro, observed command or failure pattern, and links to task artifacts when available.
- Rationale: the user did not specify a broader evidence system and low-friction intake is required.

## D6: Parent-Issue Threshold Default

- Decision: a parent issue becomes actionable when at least three related incident issues occur within 30 days or the same signature appears in at least two repositories.
- Rationale: this gives the triage agent a bounded threshold while preserving cross-repository sensitivity.
