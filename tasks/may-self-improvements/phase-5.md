# Phase 5 — No-Upstream Landing Recovery

## Objective

Implement G3 by handling named branches without upstream before commit preflight causes a late landing block.

## Code areas impacted
- `codex/scripts/git-commit-preflight.sh`
- `codex/scripts/git-push-branch-safe.sh`
- `codex/scripts/git-land-branch-safe.sh`
- `codex/skills/git-commit/SKILL.md`
- `codex/skills/land-the-plan/SKILL.md`
- `codex/rules/git-safe.rules`

## Work items
- [ ] Locate the current no-upstream hard block and its caller sequence.
- [ ] Decide whether safe upstream push or dedicated landing-branch creation is the correct recovery path.
- [ ] Move detection earlier in landing guidance so recovery happens before commit preflight.
- [ ] Add verification for a named branch with no upstream.

## Deliverables
- Landing/git-commit workflow detects no-upstream state before late preflight failure.
- Safe recovery path is explicit and conservative.
- G3 verification evidence is recorded.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [ ] A named branch without upstream gets actionable recovery before commit preflight blocks.
- [ ] Recovery does not push unexpected branches or bypass divergence checks.
- [ ] Branch safety rules remain explicit.

## Verification steps
List exact commands and expected results.
- [ ] Command: `./codex/scripts/git-commit-preflight.sh`
  - Expected: no-upstream behavior is either pre-remediated by the workflow or fails with precise safe recovery instructions.
- [ ] Command: `rg -n "upstream|git push -u|no upstream|preflight" codex/scripts codex/skills`
  - Expected: no-upstream handling is discoverable in scripts and skill guidance.

## Risks and mitigations
- Risk: automatically pushing upstream could surprise the operator.
- Mitigation: require explicit branch identity checks and preserve safe push wrappers.
