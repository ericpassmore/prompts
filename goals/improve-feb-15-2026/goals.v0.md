# Goals Extract
- Task name: improve-feb-15-2026
- Iteration: v0
- State: locked

## Goals (1-20, verifiable)

1. Produce a traceable consistency audit mapping principles in `codex/principles.md` to `codex/AGENTS.md`, stage skills, and enforcing scripts, with explicit mismatch findings.
2. Update `codex/AGENTS.md` and only necessary `./codex` artifacts so every principle is reflected consistently without changing lifecycle stages or verdict contracts.
3. Preserve lifecycle behavior by keeping stage order and allowed verdicts unchanged across all modified artifacts.
4. Implement low-risk speed improvements in governance/scripts (for example path-resolution reuse, reduced redundant checks, or reduced duplicated stage text) with no semantic contract change.
5. Consolidate redundant instruction text where duplication currently increases maintenance or execution friction, while retaining required hard gates.
6. Clarify codex-root resolution guidance so this repo’s `./codex` layout is explicit and compatible with existing multi-root fallback behavior.
7. Revalidate changes with required lint/build/test command classes as pinned by repository/task records and stage validators.
8. Deliver updated task artifacts (`spec.md`, phase plan docs, revalidation docs, final-phase ledger) with complete traceability from goals to implementation and verification.


## Non-goals (explicit exclusions)

- Introducing new lifecycle stages, removing existing stages, or renaming verdict tokens.
- Expanding scope into non-`./codex` product behavior changes unrelated to governance/agent-contract alignment.


## Success criteria (objective checks)

> Tie each criterion to a goal number when possible.

- [G1] A written mapping exists in task artifacts showing each principle and where it is enforced, plus any resolved gaps.
- [G2,G3] Modified `codex/AGENTS.md` and related artifacts retain the exact stage sequence and verdict vocabulary already defined.
- [G4] At least one measurable workflow simplification is applied (for example fewer duplicated instruction blocks or fewer redundant path-resolution operations) and documented.
- [G5] Redundant instructions in modified files are reduced without removing required hard-gate constraints.
- [G6] Updated documentation/instructions explicitly describe `./codex` usage for this repo while preserving fallback compatibility.
- [G7] Stage-required verification records include lint/build/test outcomes (or explicit blocker evidence if any command class cannot run).
- [G8] Task lifecycle documents are complete and consistent with implemented changes and verification evidence.

