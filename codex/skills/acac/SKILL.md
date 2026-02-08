---
name: acac
description: Orchestrate the full Autonomous Coding Agent Contract from a #ACAC request by proposing task name, locking goals with user approval, then running downstream stages in order until LANDED or BLOCKED.
---

# SKILL: acac

## Purpose

Run the Autonomous Coding Agent Contract as an end-to-end orchestrator:

`establish-goals` -> `prepare-takeoff` -> `prepare-phased-impl` -> `implement` -> `revalidate` -> `land-the-plan`

This skill coordinates stage entry/exit and user approvals. Stage mechanics remain owned by the individual stage skills.

## Trigger contract

- Use this skill when the first non-empty line of the request is exactly `#ACAC`.
- Matching is strict and case-sensitive.

## Inputs

- Request body after `#ACAC`.
- Optional task name in kebab-case.

## Principles compliance (mandatory)

### 1. Lock Goals Before Action

- Do not run planning or implementation stages before `establish-goals` emits `GOALS LOCKED`.
- Do not proceed downstream until the user explicitly approves extracted goals.
- Do not reinterpret, expand, or relax locked goals, constraints, or success criteria.

### 2. Respect Stage Gates

- Treat each stage verdict as authoritative.
- Advance only on the stage-success verdict defined in `codex/AGENTS.md`.
- On any non-success verdict, stop progression immediately.

### 3. Keep Changes Minimal

- Apply simplicity bias and surgical-change discipline from `prepare-takeoff` onward.
- Keep execution strictly within the active stage scope and approved file surfaces.
- Do not introduce unrelated work while orchestrating stages.

### 4. Fail Fast and Explicitly

- If required inputs, artifacts, or preconditions are missing, stop and report the precise blocker.
- Do not guess through ambiguous or contradictory state; ask clarifying questions.
- Report failures with concrete evidence (stage, command/output context, and blocking condition).

### 5. Verify, Then Declare Done

- Completion is valid only when the lifecycle reaches `LANDED` or an explicit `BLOCKED` outcome is recorded.
- Never bypass stage validators or reverification requirements.
- Treat verification as mandatory when behavior changes, including `lint`, `build`, and `test` as defined by task/repo records.

### 6. Revalidate on Drift

- If scope, goals, touched surfaces, verification plan, or completion criteria drift, route to `revalidate` before continuing.
- Treat drift as a hard gate and enforce loop-prevention limits (`N=45m`, `M=5`, `K=2` no-evidence cycles).
- Continue only when `revalidate` emits a valid next-step verdict.

## Orchestration workflow

### Step 1 - Confirm task identity

- If a task name is missing, propose one derived from request intent.
- Ask the user to confirm or modify the proposed task name.
- Do not start lifecycle stages until task name is confirmed.

### Step 2 - Run establish-goals

- Execute: `Run $establish-goals for <task-name>`.
- If verdict is `BLOCKED`, stop and report blockers.
- If verdict is `GOALS LOCKED`, continue.

### Step 3 - Goals review gate (mandatory)

- Present the extracted goals from `goals/<task-name>/goals.vN.md`.
- Ask user to approve goals before downstream execution.
- If edits are requested, return to `establish-goals` iteration flow until `GOALS LOCKED` and approved.

### Step 4 - Run prepare-takeoff

- Execute: `Run $prepare-takeoff for <task-name>`.
- Continue only on `READY FOR PLANNING`.
- On `BLOCKED`, stop and report blockers.

### Step 5 - Run prepare-phased-impl

- Execute: `Run $prepare-phased-impl for <task-name>`.
- Continue only on `READY FOR IMPLEMENTATION`.
- On `BLOCKED`, stop and report blockers.

### Step 6 - Run implement

- Execute: `Run $implement for <task-name>`.
- Continue only on `READY FOR REVERIFICATION`.
- On `BLOCKED`, stop and report blockers.

### Step 7 - Run revalidate

- Execute: `Run $revalidate for <task-name>`.
- If verdict is `READY TO REPLAN`, restart from Step 5 (`prepare-phased-impl`) and continue forward again.
- If verdict is `READY TO LAND`, continue to Step 8.
- If verdict is `BLOCKED`, stop and report blockers.

### Drift handling at any stage (hard gate)

- If drift is detected before terminal completion, enter `revalidate` immediately.
- Do not continue normal stage progression until `revalidate` returns the allowed next verdict.

### Step 8 - Run land-the-plan

- Execute: `Run $land-the-plan for <task-name>`.
- Terminal outcomes:
  - `LANDED`: complete.
  - `BLOCKED`: stop and report blockers.

## Clarification rule

- Ask concise clarifying questions whenever ambiguity prevents:
  - reliable task naming
  - goals quality/verification
  - unblocked stage progression

## Status reporting

At each stage boundary, report:

- stage name
- terminal verdict
- next action (`continue`, `replan`, or `stop`)

## Guardrails

- Enforce lifecycle order from `codex/AGENTS.md`.
- Never skip required user goal approval.
- Never continue after a `BLOCKED` verdict.
- Respect all stage-local constraints and script requirements from each stage skill.
