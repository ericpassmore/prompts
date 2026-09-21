# Fix Stale Scripts Dir Fast-Path Validation

## Stage status
- establish-goals verdict: `GOALS LOCKED` (`goals/bug-fix-stale-path/goals.v0.md`)
- prepare-takeoff verdict: `READY FOR PLANNING`
- prepare-phased-impl verdict: `READY FOR IMPLEMENTATION`
- implement verdict: `READY FOR REVERIFICATION`
- revalidate verdict: `READY TO LAND`
- Stage 2 evidence:
  - Bootstrap config refreshed: `codex/codex-config.yaml`
  - Task scaffold created: `tasks/bug-fix-stale-path/`
  - Safety prep executed: `./codex/scripts/prepare-takeoff-worktree.sh bug-fix-stale-path`

## Overview
Fix stale environment-path acceptance in codex path resolution so reused shell exports from other repos/worktrees cannot cause stage commands to execute helpers from the wrong scripts directory.

## Goals
1. Reproduce and document stale fast-path risk for pre-exported `CODEX_SCRIPTS_DIR`.
2. Ensure early return is permitted only when `CODEX_ROOT` and `CODEX_SCRIPTS_DIR` are valid for current repo/bootstrap context.
3. Reject stale/mismatched scripts dirs and resolve to correct bootstrap/fallback values.
4. Preserve root precedence and fail-fast behavior.
5. Keep change surface minimal.
6. Record validator-backed lifecycle evidence through revalidate.

## Non-goals
- Any lifecycle stage or verdict token changes.
- Broad refactor of unrelated codex scripts/skills.
- Unrelated behavior changes outside path-resolution correctness.

## Use cases / user stories
- As an agent, when shell env vars are reused across tasks, path resolution should still bind to the current repo’s codex scripts.
- As a maintainer, bootstrap config should remain authoritative instead of stale environment leftovers.
- As a reviewer, the fix should be minimal and verifiable with deterministic script checks.

## Current behavior
- Notes:
  - `read_codex_paths` currently has an environment fast-path.
  - It can return early without ensuring the scripts directory matches current bootstrap-resolved context.
  - In reused shells, this can preserve stale/mismatched `CODEX_SCRIPTS_DIR`.
- Key files:
  - `codex/scripts/read-codex-paths.sh`
  - `codex/scripts/resolve-codex-root.sh`
  - `codex/codex-config.yaml`

## Proposed behavior
- Behavior changes:
  - Tighten fast-path gating so env-based early return is allowed only when env paths align with current expected root/scripts values.
  - Preserve deterministic fallback to resolved root/bootstrap values when env paths are stale or mismatched.
- Edge cases:
  - Stale env paths that still exist on disk must be rejected if they do not match current repo/bootstrap context.
  - Missing/invalid bootstrap metadata must continue to fail fast or fallback per existing policy.

## Technical design
### Architecture / modules impacted
- `codex/scripts/read-codex-paths.sh`
- `codex/scripts/resolve-codex-root.sh` (only if minimal supporting guard is required)

### Stage 2 governing context
- Rules:
  - `codex/rules/expand-task-spec.rules`
  - `codex/rules/git-safe.rules`
- Skills:
  - `codex/skills/prepare-takeoff/SKILL.md`
  - `codex/skills/prepare-phased-impl/SKILL.md`
  - `codex/skills/implement/SKILL.md`
  - `codex/skills/revalidate/SKILL.md`
  - `codex/skills/land-the-plan/SKILL.md`
- Sandbox constraints:
  - Workspace-write filesystem sandbox
  - Network restricted

### API changes (if any)
- None.

### UI/UX changes (if any)
- None.

### Data model / schema changes (PostgreSQL)
- Migrations: none
- Backward compatibility: full
- Rollback: revert touched path-resolution script changes

## Security & privacy
- No secret handling changes.
- Reduces accidental execution against wrong helper directories.

## Observability (logs/metrics)
- `read_codex-paths.sh` output remains deterministic (`Resolved CODEX_ROOT`, `Resolved CODEX_SCRIPTS_DIR`).
- Task artifacts capture stale-path reproduction and corrected behavior evidence.

## Verification Commands
> Pin exact repo commands and include lifecycle validators.

- Lint:
  - `not-configured`
- Build:
  - `not-configured`
- Test:
  - `not-configured`
- Targeted checks:
  - `./codex/scripts/read-codex-paths.sh`
  - `CODEX_ROOT="$(pwd)/codex" CODEX_SCRIPTS_DIR="/Users/eric/.codex/scripts" bash -lc 'source codex/scripts/read-codex-paths.sh >/dev/null; printf "%s\n%s\n" "$CODEX_ROOT" "$CODEX_SCRIPTS_DIR"'`
  - `bash -n codex/scripts/read-codex-paths.sh codex/scripts/resolve-codex-root.sh`
  - `./codex/scripts/prepare-phased-impl-validate.sh bug-fix-stale-path`
  - `./codex/scripts/implement-validate.sh bug-fix-stale-path`
  - `./codex/scripts/revalidate-validate.sh bug-fix-stale-path`

## Test strategy
- Unit:
  - Script-level stale-env simulation checks for early-return acceptance/rejection.
- Integration:
  - Stage 3/4/5 validators with task artifacts.
- E2E / UI (if applicable):
  - n/a

## Acceptance criteria checklist
- [ ] Stale scripts-dir reproduction is documented.
- [ ] Early return requires current repo/bootstrap-consistent root/scripts paths.
- [ ] Mismatched scripts-dir falls back to correct current paths.
- [ ] Lifecycle validators pass and evidence is recorded.

## Ambiguity check
- Result: no unresolved blocking ambiguity for Stage 2.

## IN SCOPE
- Path-resolution correctness in `read-codex-paths.sh` and minimal supporting script guard(s).
- Task lifecycle artifacts for `bug-fix-stale-path`.

## OUT OF SCOPE
- Lifecycle contract changes.
- Unrelated script refactors.
- Product/application changes outside codex tooling behavior.

## Execution posture lock
- Simplicity bias: required.
- Surgical-change discipline: required.
- Fail-fast error handling: required.

## Change control
- Locked goals from `goals/bug-fix-stale-path/goals.v0.md` are immutable unless relocked.
- Any scope expansion or verification weakening requires revalidate routing first.

## Implementation phase strategy
- Complexity: 4
- Complexity scoring details: score=10; recommended-goals=2; forced-l1=true; signals=/Users/eric/.codex/worktrees/2994/prompts/tasks/bug-fix-stale-path/complexity-signals.json
- Active phases: 1..4
- No new scope introduced: required
