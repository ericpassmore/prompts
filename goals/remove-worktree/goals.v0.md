# Goals Extract
- Task name: remove-worktree
- Iteration: v0
- State: locked

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

