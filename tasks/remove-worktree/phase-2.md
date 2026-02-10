# Phase 2 — Align Skills And Stage Gates To Existing-Worktree Execution

## Objective
Update lifecycle skill instructions so no stage requires worktree create/switch/release and Stage 2 explicitly assumes an existing worktree.

## Code areas impacted
- `codex/skills/prepare-takeoff/SKILL.md`
- `codex/skills/land-the-plan/SKILL.md`
- `codex/skills/git-commit/SKILL.md`

## Work items
- [x] Replace Stage 2 "create isolated git worktree" instructions with safety-prep instructions.
- [x] Update Stage 2 gates, constraints, and required outputs to remove worktree-creation requirements.
- [x] Remove landing-stage instructions that release task-specific worktree resources.
- [x] Remove landing-stage requirement that active branch must be non-empty and non-protected.
- [x] Update git-commit skill guidance so detached `HEAD` mode is accepted.
- [x] Keep lifecycle verdict contract and stage ordering unchanged.

## Deliverables
- Updated `prepare-takeoff` skill with existing-worktree assumption and safety-prep step.
- Updated `land-the-plan` skill with clean closeout language that does not manage worktree resources and accepts detached `HEAD`.
- Updated `git-commit` skill guidance for detached `HEAD` preflight/push behavior.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] Skill docs no longer instruct worktree creation or release operations.
- [x] Stage gates remain coherent and continue to enforce safety/verification requirements.
- [x] Landing/commit docs no longer require a non-empty non-protected active branch.

## Verification steps
List exact commands and expected results.
- [x] Command: `rg -n "Create Isolated Git Worktree|worktree created|release task-specific worktree|worktree resources" codex/skills/prepare-takeoff/SKILL.md codex/skills/land-the-plan/SKILL.md`
  - Expected: no required stage action references worktree lifecycle management.
  - Result: PASS
- [x] Command: `rg -n "READY FOR PLANNING|READY TO LAND|LANDED" codex/skills/prepare-takeoff/SKILL.md codex/skills/land-the-plan/SKILL.md`
  - Expected: verdict names remain unchanged.
  - Result: PASS
- [x] Command: `rg -n "non-empty and is not main or master|Abort if branch is empty|detached" codex/skills/land-the-plan/SKILL.md codex/skills/git-commit/SKILL.md`
  - Expected: docs explicitly allow detached `HEAD` and remove non-empty non-protected branch requirement.
  - Result: PASS

## Risks and mitigations
- Risk: removing worktree language could accidentally remove other required closeout steps.
- Mitigation: keep PR and verification gates intact while editing only worktree-related requirements.
