---
name: establish-goals
description: Clarify a coding request and lock explicit, verifiable goals before implementation. Use when intent, scope, constraints, or success criteria are not already confirmed.
---

# Establish Goals

## Outcome

Produce a user-approved `goals.vN.md` containing 1–20 goals, non-goals, and mapped success criteria. End with `GOALS LOCKED` or `BLOCKED`.

## Rules

- Ask only questions that change goals, scope, constraints, or success criteria.
- Do not plan or implement before approval.
- State assumptions; never hide ambiguity.
- Keep prior iterations immutable.
- Use repository scripts for goal artifacts and validation.

## Flow

1. Confirm a stable kebab-case task name.
2. Run `<CODEX_SCRIPTS_DIR>/codex-config-bootstrap-sync.sh apply`.
3. Create `v0` with `goals-scaffold.sh`, or advance an existing draft with `goals-next-iteration.sh`.
4. Populate `goals/<task>/establish-goals.vN.md` with the request, blocking questions, assumptions, goals, non-goals, success criteria, and state.
5. Run `goals-extract.sh <task> vN` and `goals-validate.sh <task> vN`.
6. Present the normalized goals. Revise through a new iteration until the user explicitly approves them.
7. Set the approved iteration to `locked`, extract and validate again, then emit `GOALS LOCKED`.

Resolve `CODEX_SCRIPTS_DIR` from `./.codex/scripts`, `./codex/scripts`, then `$HOME/.codex/scripts`. If scripts, templates, a verifiable goal, or user approval are unavailable, emit `BLOCKED` with the precise missing input.

## Exit

`GOALS LOCKED` requires a locked artifact, at least one verifiable goal, mapped success criteria, and passing validation. Hand the locked goals directly to `implement`.
