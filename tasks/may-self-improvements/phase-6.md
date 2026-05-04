# Phase 6 — Repository-Aware Env Sample Policy

## Objective

Implement G6 by replacing brittle env-example filename assumptions with repository-aware detection or configuration.

## Code areas impacted
- `codex/skills/git-commit/SKILL.md`
- `codex/skills/land-the-plan/SKILL.md`
- `codex/scripts/git-commit-preflight.sh`
- `codex/scripts/git-stage-safe.sh`
- `codex/codex-config.yaml`

## Work items
- [ ] Locate the hardcoded env sample filename policy and affected safety checks.
- [ ] Define a conservative repository-aware policy for tracked env sample files.
- [ ] Ensure real secret files remain blocked or require explicit review.
- [ ] Add verification for tracked `develop.env`-style sample files and unsafe env files.

## Deliverables
- Tracked env sample files can be reviewed and committed when allowed by repository state or config.
- Unsafe env files remain protected.
- G6 verification evidence is recorded.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [ ] Policy accepts legitimate tracked sample env filenames without relying on `developement.env`.
- [ ] Policy rejects or escalates untracked or secret-bearing env files.
- [ ] Error messages reference the actual path and reason.

## Verification steps
List exact commands and expected results.
- [ ] Command: `rg -n "developement.env|develop.env|env" codex/skills codex/scripts codex/codex-config.yaml`
  - Expected: hardcoded mismatch is removed or replaced with repository-aware policy.
- [ ] Command: `./codex/scripts/git-commit-preflight.sh`
  - Expected: env sample handling is explicit and does not weaken secret protections.

## Risks and mitigations
- Risk: broad env-file allowance could leak secrets.
- Mitigation: only allow tracked/configured sample files and keep explicit review requirements.
