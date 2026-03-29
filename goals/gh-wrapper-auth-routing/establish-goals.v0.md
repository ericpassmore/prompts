# establish-goals

## Status

- Iteration: v0
- State: locked
- Task name (proposed, kebab-case): gh-wrapper-auth-routing

## Request restatement

- Implement the issue-38 resolution by replacing direct allowed `gh` command usage with wrapper scripts that own org-aware token selection for GitHub CLI flows, then open a PR to merge the fix into `main`.

## Context considered

- Repo/rules/skills consulted:
  - `codex/AGENTS.md`
  - `codex/skills/establish-goals/SKILL.md`
  - `codex/skills/prepare-takeoff/SKILL.md`
  - `codex/skills/prepare-phased-impl/SKILL.md`
  - `codex/skills/implement/SKILL.md`
  - `codex/skills/land-the-plan/SKILL.md`
- Relevant files (if any):
  - `codex/rules/git-safe.rules`
  - `codex/prompts/self-improve-skills.md`
  - `codex/skills/land-the-plan/SKILL.md`
  - `codex/codex-config.yaml`
  - new wrapper script surface under `codex/scripts/`
- Constraints (sandbox, commands, policy):
  - No source-code modification before goals are approved.
  - Stage order and verification requirements from `codex/AGENTS.md` are mandatory.
  - The user asked for wrapper-script remediation instead of more raw `gh` rules.

## Ambiguities

### Blocking (must resolve)

1. None.

### Non-blocking (can proceed with explicit assumptions)

1. The issue body typo `gh-wrap.sh edit` refers to `gh-wrap.sh pr edit`.
2. The issue body typo `gh-wrap.sh lable create` refers to `gh-wrap.sh label create`.
3. The owner/org token mapping can live in `codex/codex-config.yaml` without introducing secrets because it stores env-var names, not token values.
4. Verification can use shell-level wrapper probes plus repository validators because this repo does not expose a dedicated automated test harness for live GitHub auth flows.

## Questions for user

1. None.

## Assumptions (explicit; remove when confirmed)

1. Wrapper scripts should be the only repo-approved CLI surface for the listed GitHub operations.
2. Existing GitHub MCP behavior remains unchanged; only CLI fallback and explicit issue-flow usage move behind wrappers.
3. `gh-auth-check.sh` is manual-only and must not be invoked automatically by skills.

## Goals

1. Add a repo-level config contract in `codex/codex-config.yaml` for owner/org-specific GitHub CLI token-env selection that falls back to ambient `GH_TOKEN` when no mapping exists.
2. Add wrapper script support under `codex/scripts/` for the GitHub CLI command families requested in issue `#38`, plus a separate `gh-auth-check.sh` diagnostic surface.
3. Make the wrappers fail fast with a clear auth-block message when a configured alternate token env var is selected but unset.
4. Update workflow callsites and guidance so repo-controlled GitHub CLI usage references the wrappers instead of direct raw `gh` commands.
5. Replace raw `gh` allow rules in `codex/rules/git-safe.rules` with allow rules for the wrapper scripts only, covering the wrapper command surface requested in issue `#38`.
6. Add verification evidence showing the wrappers preserve default `GH_TOKEN` behavior when no mapping exists and correctly block when a configured mapped env var is missing.
7. Land the completed fix on a pushed branch and open a reviewer-ready pull request targeting `main`.

## Non-goals

- Changing GitHub MCP authentication behavior or permission routing.
- Adding automatic execution of the diagnostic auth check during normal agent flows.
- Implementing live integration tests that require real repository issue mutation across external GitHub repositories.

## Success criteria

> Tie each criterion to a goal number when possible.

- [G1] `codex/codex-config.yaml` documents a stable owner/org-to-token-env mapping contract, and no token secret values are stored in the file.
- [G2] New wrapper scripts exist under `codex/scripts/` for the requested GitHub CLI surfaces, including `gh-auth-check.sh`.
- [G3] Wrapper validation demonstrates: no mapping => ambient `GH_TOKEN` path remains usable; configured-but-unset mapping => explicit non-zero auth-block outcome with guidance.
- [G4] `codex/skills/land-the-plan/SKILL.md` and `codex/prompts/self-improve-skills.md` reference wrapper usage instead of raw direct `gh` invocations where this issue applies.
- [G5] `codex/rules/git-safe.rules` contains wrapper-script allow rules and no direct `gh` allow entries for the migrated command surface.
- [G6] Stage validation records the exact lint/build/test outcomes required by the repo contract, plus targeted wrapper checks tied to the config and auth-block behavior.
- [G7] A pull request to `main` exists for the implementation branch.

## Risks / tradeoffs

- Broad wrapper coverage can drift if the wrapper command surface is expanded beyond the actually needed workflow paths; keep the implementation minimal and traceable to issue `#38`.

## Next action

- Present the extracted goals for approval, then proceed to `prepare-takeoff` only after approval.
