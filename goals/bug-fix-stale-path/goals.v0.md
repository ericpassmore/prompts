# Goals Extract
- Task name: bug-fix-stale-path
- Iteration: v0
- State: locked

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

