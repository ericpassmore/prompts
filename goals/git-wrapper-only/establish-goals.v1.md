# establish-goals

## Status

- Iteration: v1
- State: locked
- Task name (proposed, kebab-case): git-wrapper-only

## Request restatement

- Update the Codex lifecycle skills so git operations are routed through approved git wrapper/helper scripts instead of direct raw git command instructions, correct the `git-commit` development environment exception spelling from `developement.env` to `development.env`, and ensure the workflow does not use the Codex MCP GitHub service.

## Context considered

- Repo/rules/skills consulted: `AGENTS.md` contract from the user message, `codex/skills/acac/SKILL.md`, `codex/skills/establish-goals/SKILL.md`, `codex/rules/git-safe.rules`.
- Relevant files (if any): `codex/skills/git-commit/SKILL.md`, `codex/skills/land-the-plan/SKILL.md`, `codex/skills/prepare-takeoff/SKILL.md`, `codex/skills/code-review/SKILL.md`, `codex/prompts/gitpull.md`, `codex/scripts/git-track-safe-untracked.sh`.
- Constraints (sandbox, commands, policy): ACAC lifecycle order is mandatory; no implementation planning or source edits before goal approval and lock; downstream verification must include lint, build, and test command classes from repo/task records; changes must stay limited to the requested git wrapper guidance, `development.env` exception correction, and exclusion of Codex MCP GitHub service usage.

## Ambiguities

### Blocking (must resolve)

1. None.

### Non-blocking (can proceed with explicit assumptions)

1. "Git wrapper script" refers to the repository's approved git helper/wrapper script surface under `codex/scripts/` and its bootstrap-resolved equivalents, not GitHub-only `gh-wrap.sh`.
2. Raw git commands inside the wrapper/helper shell scripts themselves may remain when they implement the wrapper behavior; the requested restriction applies to skill/prompt instructions that tell agents what to run directly.

## Questions for user

1. Please approve these goals as written, or request specific edits before lock.

## Assumptions (explicit; remove when confirmed)

1. The implementation should update both documentation/instruction surfaces and any helper policy needed to keep the `development.env` exception behavior consistent.
2. The implementation should not redesign the git workflow or broaden supported git operations beyond the existing approved helper/wrapper surface unless required to remove raw git instructions from skills.

## Goals (1-20, verifiable)

1. Update lifecycle skill and prompt instructions so agent-facing git operations use the approved git wrapper/helper scripts instead of instructing direct raw `git ...` command execution.
2. Preserve legitimate raw git usage inside repository-owned shell helper scripts where those scripts implement the approved wrapper/helper behavior.
3. Correct the `git-commit` environment-file exception spelling from `developement.env` to `development.env` in the `git-commit` skill and supporting helper behavior.
4. Keep the change scope limited to the git wrapper guidance and `development.env` exception correction.
5. Verify the updated instructions and helper behavior with repo/task-approved lint, build, and test command classes, or document explicit blockers if any class is unavailable.
6. Ensure the updated workflow does not instruct or require agents to use the Codex MCP GitHub service.

## Non-goals (explicit exclusions)

- Do not redesign the ACAC lifecycle or stage gate contract.
- Do not add unrelated git or GitHub workflows.
- Do not change token handling, GitHub auth routing, or PR creation behavior except where wording must avoid direct raw git instructions.
- Do not use the Codex MCP GitHub service for this task or make it part of the updated workflow.
- Do not alter unrelated task artifacts or historical goal iterations.

## Success criteria (objective checks)

> Tie each criterion to a goal number when possible.

- [G1] Agent-facing skill/prompt text no longer directs users or agents to run raw `git ...` commands where an approved wrapper/helper path should be used.
- [G2] Shell helper scripts that implement git wrapper behavior still perform their internal git operations and continue to fail fast on unsafe states.
- [G3] No `developement.env` references remain in the in-scope current skill/helper surfaces; the allowed example-file exception is spelled `development.env`.
- [G4] The diff is limited to in-scope instruction/helper files and required lifecycle artifacts for this task.
- [G5] Verification records include lint, build, and test outcomes from approved repo/task command records, or explicit blocker documentation for unavailable commands.
- [G6] In-scope workflow instructions contain no requirement to use the Codex MCP GitHub service, and this task is completed without using that service.

## Risks / tradeoffs

- Replacing direct command examples with wrapper references may require adding or clarifying wrapper capabilities if an existing skill currently depends on a direct git operation with no equivalent helper.
- The historical misspelling may be relied on by existing local files; the change intentionally standardizes the exception to `development.env`.

## Next action

- GOALS LOCKED. Handoff: prepare-takeoff owns task scaffolding and `spec.md` readiness content.
