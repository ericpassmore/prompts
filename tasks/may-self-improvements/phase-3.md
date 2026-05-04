# Phase 3 — ACAC Continuation and Dirty Worktree Surfacing

## Objective

Implement G4 and G5 by aligning ACAC orchestration with stage-success continuation and surfacing dirty-worktree risk before downstream work can hide it.

## Code areas impacted
- `codex/skills/acac/SKILL.md`
- `codex/skills/prepare-takeoff/SKILL.md`
- `codex/scripts/prepare-takeoff-worktree.sh`
- `codex/prompts/acac.md`
- `codex/AGENTS.md`

## Work items
- [ ] Clarify that successful Stage 2 must continue to Stage 3 during an ACAC run unless a real gate stops progression.
- [ ] Ensure dirty worktree status is explicitly recorded as a decision point before downstream progression.
- [ ] Preserve existing ACAC user-approval gate for goal lock.
- [ ] Add or update validation notes for expected ACAC continuation behavior.

## Deliverables
- ACAC orchestration instructions no longer permit a final early stop after successful Stage 2.
- Stage 2 safety prep output or spec requirements force a dirty-state decision.
- G4 and G5 verification evidence is recorded.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [ ] ACAC docs/skills state the exact continue/stop behavior after `READY FOR PLANNING`.
- [ ] Dirty worktree observations require an explicit continue/isolate/stop decision.
- [ ] No weakening of stage gates or goal approval occurs.

## Verification steps
List exact commands and expected results.
- [ ] Command: `rg -n "READY FOR PLANNING|dirty|worktree|continue|stop" codex/skills/acac/SKILL.md codex/skills/prepare-takeoff/SKILL.md codex/scripts/prepare-takeoff-worktree.sh codex/prompts/acac.md`
  - Expected: updated instructions and script behavior are discoverable.
- [ ] Command: `./codex/scripts/prepare-takeoff-bootstrap.sh`
  - Expected: exits 0.

## Risks and mitigations
- Risk: forcing dirty-worktree prompts could block harmless task artifacts.
- Mitigation: distinguish pre-existing unrelated changes from current task/bootstrap artifacts.
