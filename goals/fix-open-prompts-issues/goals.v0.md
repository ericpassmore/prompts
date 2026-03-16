# Goals Extract
- Task name: fix-open-prompts-issues
- Iteration: v0
- State: locked

## Goals (1-20, verifiable)

1. Fix `codex/scripts/resolve-codex-root.sh` so an explicitly exported `CODEX_ROOT` is honored when it exists and satisfies required paths, even when it is outside the repository-local or home fallback roots.
2. Fix the establish-goals extraction/validation flow so scaffolded goal section headers are parsed correctly and populated goals are preserved and validated without manual header normalization.
3. Fix `codex/skills/acac/SKILL.md` so the user approval gate for goals is ordered before the orchestrator treats `GOALS LOCKED` as satisfied.
4. Add an explicit self-improvement routing checkpoint to the relevant centralized workflow guidance so bugs or repeated friction in shared skills/scripts are routed to `self-improve-skills` promptly.
5. Fix the `land-the-plan` PR fallback flow so an existing PR for the head branch is reused or updated instead of failing on `gh pr create` alone.
6. Validate each implemented fix with direct evidence tied to the affected scripts/skills and update the corresponding GitHub issues based on the verified outcome.


## Non-goals (explicit exclusions)

- Redesigning unrelated lifecycle stages, telemetry, or issue triage policy beyond what is needed to resolve the current open issues.
- Broadening GitHub CLI permissions or fallback behavior beyond the narrow surfaces required by the existing open issues.


## Success criteria (objective checks)

> Tie each criterion to a goal number when possible.

- [G1] A reproducible check shows `resolve-codex-root.sh` accepts a valid explicit `CODEX_ROOT` outside the built-in root set instead of silently ignoring it.
- [G2] A reproducible check using scaffold-compatible establish-goals content shows `goals-extract.sh` preserves populated sections and `goals-validate.sh` passes without manual section-header renaming.
- [G3] `codex/skills/acac/SKILL.md` explicitly places user goal approval before the lock/handoff point and no longer implies `GOALS LOCKED` can occur first.
- [G4] The relevant workflow guidance explicitly tells agents to route centralized workflow defects/friction through `self-improve-skills` when observed.
- [G5] `codex/skills/land-the-plan/SKILL.md` defines an existing-PR update/reuse path for the fallback flow instead of only a create path.
- [G6] Validation evidence is recorded for the implemented changes, and the related open issues are updated to reflect the verified fix status.

