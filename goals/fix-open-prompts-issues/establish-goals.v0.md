# establish-goals

## Status

- Iteration: v0
- State: locked
- Task name (proposed, kebab-case): fix-open-prompts-issues

## Request restatement

- Fix the currently open repo-backed issues in `ericpassmore/prompts`, validate the fixes, and update the issue state based on the validated results.

## Context considered

- Repo/rules/skills consulted:
  - `AGENTS.md`
  - `codex/skills/establish-goals/SKILL.md`
  - `codex/skills/implement/SKILL.md`
  - `codex/skills/land-the-plan/SKILL.md`
- Relevant files (if any):
  - `codex/scripts/resolve-codex-root.sh`
  - `codex/scripts/goals-extract.sh`
  - `codex/scripts/goals-validate.sh`
  - `codex/goals/establish-goals.template.md`
  - `codex/skills/acac/SKILL.md`
  - `codex/skills/land-the-plan/SKILL.md`
  - GitHub issues `#15`, `#16`, `#27`, `#28`, `#29`, `#30`, `#31`
- Constraints (sandbox, commands, policy):
  - Must follow the repo lifecycle contract before implementation.
  - Must keep scope limited to the currently open issue surfaces and their verification.
  - Must validate fixes with the repo's pinned verification approach before claiming completion.
  - GitHub issue access may require elevated permissions via `gh issue`.

## Ambiguities

### Blocking (must resolve)

1. None.

### Non-blocking (can proceed with explicit assumptions)

1. Treat issue `#30` as corroborating evidence for the same defect family as `#27`/`#31`, not as a separate code change target.
2. Treat issue closure and issue comments as part of validation/handoff after code fixes are verified.

## Questions for user

1. User approved the proposed goals and task name.

## Assumptions (explicit; remove when confirmed)

1. The open issues to fix in this task are `#15`, `#16`, `#27/#30/#31`, `#28`, and `#29`.
2. Repo verification may be command-based rather than a formal automated test suite, but validation evidence still must be concrete and reproducible.

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

## Risks / tradeoffs

- Bundling several issue surfaces into one task increases coordination cost, so scope must stay tightly limited to the currently open defects/friction items.

## Next action

- Goals approved and locked. Handoff: `prepare-takeoff` owns task scaffolding and `spec.md` readiness content.
