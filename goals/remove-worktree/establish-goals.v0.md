# establish-goals

## Status

- Iteration: v0
- State: locked
- Task name (proposed, kebab-case): remove-worktree

## Request restatement

- Remove lifecycle behavior that creates, initializes, switches, or manages git worktrees.
- Keep the agent model as starting inside an already-managed worktree.
- Update scripts and skills so Stage 2 uses only safe preparation actions (for example prune and safety checks) instead of worktree setup.

## Context considered

- Repo/rules/skills consulted: `codex/AGENTS.md`, `codex/skills/acac/SKILL.md`, `codex/skills/establish-goals/SKILL.md`
- Relevant files (if any): none yet (goal-setting only)
- Constraints (sandbox, commands, policy): follow ACAC stage order and goal-lock gate before planning or implementation

## Ambiguities

### Blocking (must resolve)

1. None identified.

### Non-blocking (can proceed with explicit assumptions)

1. "Remove worktree creation or management" applies to both shell scripts and skill documentation that currently instruct those actions.
2. Existing script names can remain if behavior is changed and references are updated consistently.

## Questions for user

1. Please confirm these goals as written so I can lock them and continue downstream stages.

## Assumptions (explicit; remove when confirmed)

1. The change should preserve current ACAC stage order and verdict contracts.
2. "Worktree management" includes creation, switching/handoff, and cleanup/relinquish requirements specific to worktrees.

## Goals

> If ambiguity is blocking, it is valid to have 0 goals.

1. Update lifecycle scripts so no stage requires creating, initializing, or switching to a new git worktree.
2. Update relevant skill docs and stage gates to remove worktree creation/management requirements and state that execution starts in an existing worktree.
3. Preserve safe Stage 2 preparation behavior by retaining or adding non-worktree prep actions (for example prune and safety checks) where needed.
4. Keep script and document references internally consistent so no required stage points to removed/obsolete worktree actions.

## Non-goals

- Re-architecting the full ACAC lifecycle or changing stage verdict names/order.
- Modifying unrelated task artifacts outside what is needed for this worktree-policy change.

## Success criteria

> Tie each criterion to a goal number when possible.

- [G1] No required stage script path or validator-enforced behavior creates or switches to a new worktree.
- [G2] `prepare-takeoff` and `land-the-plan` skill docs no longer require worktree creation/release steps and explicitly assume execution starts inside an existing worktree.
- [G3] Stage 2 prep still includes actionable safety preparation (prune/check) without managing worktree lifecycle.
- [G4] Cross-references in scripts/skills/stage outputs are updated so stage flow remains mechanically valid.

## Risks / tradeoffs

- Existing scripts with "worktree" in filename may remain for compatibility, which could be confusing unless behavior and documentation are explicit.

## Next action

- Goals approved and locked; proceed to `prepare-takeoff`.
- Handoff: `prepare-takeoff` owns task scaffolding and `spec.md` readiness content.
