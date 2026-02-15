# establish-goals

## Status

- Iteration: v0
- State: locked
- Task name (proposed, kebab-case): bug-fix-stale-path

## Request restatement

- Fix stale `CODEX_SCRIPTS_DIR` behavior in the path-resolution fast path.
- Revalidate scripts directory against bootstrap config before early return so exported values from other repos/worktrees are not incorrectly reused.
- Prevent lifecycle stage commands from running helpers out of a mismatched scripts directory.

## Context considered

- Repo/rules/skills consulted: `codex/AGENTS.md`, `codex/principles.md`, `codex/skills/establish-goals/SKILL.md`
- Relevant files (if any): `codex/scripts/read-codex-paths.sh`, `codex/scripts/resolve-codex-root.sh`, `codex/codex-config.yaml`
- Constraints (sandbox, commands, policy): ACAC lifecycle order and stage gates are mandatory; script behavior must remain fail-fast and backward-compatible with codex root resolution policy.

## Ambiguities

### Blocking (must resolve)

1. None identified.

### Non-blocking (can proceed with explicit assumptions)

1. "Re-validate against bootstrap" means environment fast-path must confirm scripts path coherence with resolved root/bootstrap metadata, not just check for one file.
2. Preserve performance intent of fast-path while preventing cross-repo/worktree stale-path acceptance.

## Questions for user

1. Please confirm these goals so I can lock and proceed.

## Assumptions (explicit; remove when confirmed)

1. The primary fix surface is `codex/scripts/read-codex-paths.sh`; `resolve-codex-root.sh` may only receive minimal supporting changes if required.
2. Existing root precedence (`./.codex`, `./codex`, `$HOME/.codex`) must remain unchanged.
3. No lifecycle stage/ verdict contract changes are allowed.

## Goals (1-20, verifiable)

1. Reproduce and document the stale fast-path risk where pre-exported `CODEX_SCRIPTS_DIR` can persist across repo/worktree boundaries.
2. Update path resolution logic so early return is allowed only when `CODEX_ROOT` and `CODEX_SCRIPTS_DIR` are both valid for the current repository/bootstrap context.
3. Ensure stale or mismatched scripts directories are rejected and replaced by correctly resolved bootstrap/fallback paths.
4. Preserve fail-fast behavior and existing codex root precedence order without introducing stage contract drift.
5. Keep changes minimal and localized to path-resolution scripts and task lifecycle artifacts.
6. Validate lifecycle continuity by running stage validators and recording evidence in task artifacts.

## Non-goals (explicit exclusions)

- No changes to lifecycle stage order, verdict vocabulary, or stage gate semantics.
- No broad refactor of unrelated codex scripts or skills outside path-resolution correctness scope.

## Success criteria (objective checks)

> Tie each criterion to a goal number when possible.

- [G1] Task artifacts include a concrete stale-path scenario and expected corrected behavior.
- [G2,G3] `read_codex_paths` no longer accepts stale `CODEX_SCRIPTS_DIR` solely because it contains `resolve-codex-root.sh`; it validates against current resolved root/bootstrap context.
- [G4] Root precedence and fail-fast behavior remain intact for valid and invalid configurations.
- [G5] Diff scope is limited to required script(s) and lifecycle task/goal files.
- [G6] Stage validation evidence is recorded and reaches revalidate verdict `READY TO LAND` without unresolved blockers.

## Risks / tradeoffs

- Tightening fast-path checks may add minor overhead versus prior shortcut; acceptable to prevent wrong-script execution.
- Overly strict validation could reject legitimate setups; mitigate by aligning checks with bootstrap-resolved root and existing fallback policy.

## Next action

- Goals approved and locked; proceed to `prepare-takeoff`.
- Handoff: `prepare-takeoff` owns task scaffolding and `spec.md` readiness content.
