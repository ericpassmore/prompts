# Goals Extract
- Task name: hook-self-improvement
- Iteration: v0
- State: locked

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

