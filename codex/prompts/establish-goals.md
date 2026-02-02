# Prompt: establish-goals (isolated execution)

You are executing the `establish-goals` lifecycle stage ONLY.

You MUST NOT:

- plan implementation
- prepare phases
- write or modify source code
- proceed to any other lifecycle stage

---

## Hard stop rule (mandatory)

If the current iteration produces **ZERO goals**, you MUST:

- mark the iteration as `blocked`
- ask only the blocking clarification questions
- STOP execution immediately

Do NOT proceed to `prepare-takeoff`, `prepare-phased-impl`, or implementation.

---

## Inputs

- User request: {{USER_REQUEST}}
- Task name (kebab-case, required): {{TASK_NAME_IN_KEBAB_CASE}}
- Iteration version: {{ITERATION}} (v0, v1, v2, …)

---

## Required templates

You MUST use these templates as the starting structure:

- `./.codex/goals/establish-goals.template.md`
- `./.codex/goals/goal.template.md` (optional helper)
- `./.codex/goals/establish-goals.checklist.md`

---

## Output locations (mandatory)

For this iteration, write **both** files:

- `./.codex/goals/{{TASK_NAME_IN_KEBAB_CASE}}/establish-goals.{{ITERATION}}.md`
- `./.codex/goals/{{TASK_NAME_IN_KEBAB_CASE}}/goals.{{ITERATION}}.md`

---

## establish-goals.{{ITERATION}}.md requirements

Start from `establish-goals.template.md` and populate:

- Request restatement
- Context considered (only what you actually inspected)
- Ambiguities (blocking vs non-blocking)
- Questions for user (blocking first)
- Assumptions (explicit; remove once confirmed)
- Goals (0–5, verifiable)
- Non-goals (explicit exclusions)
- Success criteria (objective, tied to goals)
- Risks / tradeoffs
- Next action

Set:

- Iteration: {{ITERATION}}
- State: draft | blocked | ready-for-confirmation | locked

---

## goals.{{ITERATION}}.md requirements (normalized extract)

This file MUST contain **only**:

- Task name
- Iteration
- State
- Goals (0–5)
- Non-goals
- Success criteria

No ambiguities, questions, or commentary belong here.

---

## Checklist enforcement

Before finalizing outputs:

- Run through `establish-goals.checklist.md`
- Any unmet checklist item MUST be reflected in:
  - Ambiguities, Risks, or Next action

---

## Iteration model

You MAY iterate:

1. Draft goals
2. Ask user questions
3. Produce next iteration (v1, v2, …)

Iteration numbering is **strictly linear**: v0 → v1 → v2.

---

## Final rule

If Goals count == 0:

- State MUST be `blocked`
- Ask blocking questions only
- STOP
