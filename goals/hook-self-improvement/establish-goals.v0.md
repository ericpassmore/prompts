# establish-goals

## Status

- Iteration: v0
- State: locked
- Task name (proposed, kebab-case): hook-self-improvement

## Request restatement

- Make one minimal change in `codex/AGENTS.md` so ACAC-driven or product-idea-driven work appropriately activates `Prompt: self-improve-skills` when that prompt's incident conditions are encountered, then review the change against `codex/principles.md`.

## Context considered

- Repo/rules/skills consulted:
  - `codex/AGENTS.md`
  - `codex/principles.md`
  - `/Users/eric/.codex/skills/acac/SKILL.md`
  - `/Users/eric/.codex/skills/establish-goals/SKILL.md`
  - `/Users/eric/.codex/skills/product-idea/SKILL.md`
- Relevant files (if any):
  - `codex/prompts/self-improve-skills.md`
  - `goals/self-improve-skills/goals.v1.md`
  - `tasks/self-improve-skills/spec.md`
- Constraints (sandbox, commands, policy):
  - Must follow ACAC stage order and stop after establish-goals until user approves extracted goals.
  - Change must stay surgical and limited to the requested `codex/AGENTS.md` behavior.
  - Review must be grounded in `codex/principles.md`.

## Ambiguities

### Blocking (must resolve)

1. None.

### Non-blocking (can proceed with explicit assumptions)

1. "Appropriately activates" means adding explicit guidance in `codex/AGENTS.md` that routes qualifying ACAC or product-idea incidents to `codex/prompts/self-improve-skills.md`, not changing the prompt body itself.
2. The requested review can be satisfied by validating the final wording against the six principles in `codex/principles.md` rather than by creating a separate review artifact unless a downstream stage requires one.

## Questions for user

1. None.

## Assumptions (explicit; remove when confirmed)

1. The active task name is `hook-self-improvement`, as provided in the ACAC request header.
2. The minimal acceptable implementation surface is `codex/AGENTS.md` only unless verification or task-artifact updates are mechanically required by downstream stages.

## Goals (1-20, verifiable)

1. Add explicit `codex/AGENTS.md` guidance that makes `codex/prompts/self-improve-skills.md` the activation path when an ACAC or product-idea run encounters the kind of centralized-skill or workflow incident described by that prompt.
2. Keep the implementation surgical by preserving existing lifecycle-stage contracts and limiting behavioral change to the new prompt-activation guidance.
3. Verify the resulting change with the repository's pinned command classes recorded for this repo, including the applicable lint/build/test status or explicit `not-configured` evidence required by the lifecycle contract.
4. Review the final wording against `codex/principles.md` and confirm whether the change aligns with `Lock Goals Before Action`, `Keep Changes Minimal`, `Fail Fast and Explicitly`, and the remaining repository principles without introducing drift.

## Non-goals (explicit exclusions)

- Editing `codex/prompts/self-improve-skills.md`, `codex/prompts/self-improve-skills-triage.md`, or any centralized skill body as part of this task.
- Expanding ACAC or product-idea behavior beyond prompt activation guidance for self-improvement incidents.

## Success criteria (objective checks)

> Tie each criterion to a goal number when possible.

- [G1] `codex/AGENTS.md` contains a new, explicit instruction that ties qualifying ACAC or product-idea incidents to `codex/prompts/self-improve-skills.md`.
- [G2] The diff is limited to the minimum files needed for the requested behavior and does not alter lifecycle verdicts or unrelated contract sections.
- [G3] Stage 4 records verification evidence using the repo's pinned command classes, with truthful pass or `not-configured` outcomes.
- [G4] The final handoff includes a principles review that explains whether the change aligns with each principle in `codex/principles.md` and identifies any residual risk.

## Risks / tradeoffs

- If the activation wording is too broad, it could turn normal task work into unnecessary self-improvement routing; if it is too narrow, the prompt will remain dormant in cases the user expects it to cover.

## Next action

- Goals approved and locked. Handoff: `prepare-takeoff` owns task scaffolding and `spec.md` readiness content.
