# Migrate Codex Commands Manifest To Config And Project Structure

## Stage status
- establish-goals verdict: `GOALS LOCKED` (`goals/migrate-to-config-and-project-structure/goals.v0.md`)
- prepare-takeoff verdict: `READY FOR PLANNING`
- prepare-phased-impl verdict: `READY FOR IMPLEMENTATION`
- implement verdict: `READY FOR REVERIFICATION`
- Stage 2 evidence:
  - Bootstrap config updated: `codex/codex-config.yaml`
  - Task scaffold created: `tasks/migrate-to-config-and-project-structure/`
  - Worktree created: `/Users/eric/workspace/prompts/codex-migrate-to-config-and-project-structure/migrate-to-config-and-project-structure`

## Overview
Replace legacy `codex/codex-commands.md` usage with two canonical files:
- `codex/project-structure.md` (repository-specific project structure + verification command source)
- `codex/codex-config.yaml` (codex configuration including Code Review base branch and repository notes)

All skills and scripts that currently reference `codex-commands.md` must be reviewed and migrated. Execution must fail fast when `codex/project-structure.md` is missing.

## Goals
1. Remove `codex/codex-commands.md` from active use and replace with `codex/project-structure.md` and `codex/codex-config.yaml`.
2. Define and execute a complete migration inventory for every skill and every script that references `codex-commands.md`.
3. Add hard-gate behavior: if `codex/project-structure.md` is missing, execution aborts with explicit `BLOCKED` reason.
4. Preserve lifecycle-stage behavior and verification traceability after migration.

## Non-goals
- Reworking lifecycle semantics beyond this config/source-of-truth migration.
- Refactoring unrelated scripts, prompts, templates, or docs that do not reference `codex-commands.md`.
- Changing repository tooling stack outside what is required to relocate command/config sources.

## Use cases / user stories
- As a stage runner, I need deterministic config lookup without relying on `codex-commands.md`.
- As a reviewer, I need code-review base branch and repo notes in `codex/codex-config.yaml`.
- As an agent, I need repository command and structure guidance from `codex/project-structure.md`.
- As a validator, I need immediate abort behavior when `codex/project-structure.md` is absent.

## Current behavior
- Notes:
  - `codex-commands.md` is treated as the central manifest for command pinning and bootstrap metadata.
  - Stage skills, templates, prompts, and scripts directly reference `codex-commands.md`.
  - `prepare-takeoff-bootstrap.sh` bootstraps root `./codex-commands.md` from codex-local/home fallbacks.
- Key files:
  - `codex/codex-commands.md`
  - `codex/scripts/read-codex-paths.sh`
  - `codex/scripts/prepare-takeoff-bootstrap.sh`
  - `codex/scripts/revalidate-code-review.sh`
  - `codex/skills/prepare-takeoff/SKILL.md`
  - `codex/skills/prepare-phased-impl/SKILL.md`
  - `codex/skills/implement/SKILL.md`
  - `codex/skills/revalidate/SKILL.md`
  - `codex/skills/land-the-plan/SKILL.md`
  - `codex/skills/code-review/SKILL.md`
  - `codex/tasks/_templates/spec.template.md`
  - `codex/tasks/_templates/final-phase.template.md`
  - `codex/prompts/expand-task-spec.md`
  - `codex/AGENTS.md`

## Proposed behavior
- Behavior changes:
  - Canonical file 1: `codex/project-structure.md` becomes required and authoritative for repository structure and command guidance.
  - Canonical file 2: `codex/codex-config.yaml` becomes required and authoritative for codex config values (including code-review base branch and notes).
  - Direct references to `codex-commands.md` are replaced by:
    - `codex/codex-config.yaml` for config lookups (for example base branch, CODEX_ROOT/CODEX_SCRIPTS_DIR metadata if retained)
    - `codex/project-structure.md` for structure/command guidance references
  - `codex/codex-commands.md` is deleted after all references are migrated.
  - Runtime precondition: if `codex/project-structure.md` is missing, scripts/skills that require it abort immediately.
- Edge cases:
  - If only one new canonical file exists, migration is incomplete and validation fails.
  - If references remain in archived or deprecated content, they must be explicitly marked as historical/deprecated.
  - Any script fallback path logic must continue to resolve `.codex`, `codex`, and `$HOME/.codex` consistently.

## Technical design
### Architecture / modules impacted
- Skill docs to review and migrate:
  - `codex/skills/prepare-takeoff/SKILL.md`
  - `codex/skills/prepare-phased-impl/SKILL.md`
  - `codex/skills/implement/SKILL.md`
  - `codex/skills/revalidate/SKILL.md`
  - `codex/skills/land-the-plan/SKILL.md`
  - `codex/skills/code-review/SKILL.md`
- Scripts to review and migrate:
  - `codex/scripts/read-codex-paths.sh`
  - `codex/scripts/prepare-takeoff-bootstrap.sh`
  - `codex/scripts/revalidate-code-review.sh`
  - `codex/scripts/resolve-codex-root.sh` (reference text/comments)
- Additional references to migrate for consistency:
  - `codex/tasks/_templates/spec.template.md`
  - `codex/tasks/_templates/final-phase.template.md`
  - `codex/prompts/expand-task-spec.md`
  - `codex/AGENTS.md`

### Replacement mapping contract
- Use `codex/codex-config.yaml` when the reference is about:
  - code review base branch
  - codex bootstrap/path metadata
  - repo-level codex operational notes
- Use `codex/project-structure.md` when the reference is about:
  - canonical repository structure
  - canonical lint/build/test command guidance
  - required project layout/constraints

### Required `codex/codex-config.yaml` content (minimum)
The spec requires this semantic content to exist in `codex/codex-config.yaml`:
- Code Review base branch: `<main>`
- Notes:
  - update only when canonical commands change
  - tasks copy chosen commands into `/tasks/<task-name>/spec.md` under Verification Commands

### Hard gate requirement
Add mandatory preflight in migrated scripts/entrypoints:
- Condition: `codex/project-structure.md` missing
- Result: abort immediately with `BLOCKED` and explicit missing-path reason
- Minimum enforcement surfaces:
  - bootstrap/config path resolution script(s)
  - any stage script that consumes canonical commands/structure

### API changes (if any)
- None.

### UI/UX changes (if any)
- None.

### Data model / schema changes (PostgreSQL)
- Migrations: none
- Backward compatibility: n/a
- Rollback: restore `codex/codex-commands.md` references if migration is reverted

## Security & privacy
- No secret material is introduced.
- Migration must avoid embedding credentials or environment secrets in `codex/codex-config.yaml`.
- Keep path resolution deterministic to avoid accidental reads outside approved codex roots.

## Observability (logs/metrics)
- Scripts should emit explicit abort messages for missing `codex/project-structure.md`.
- Validation output should state remaining legacy references when present.

## Verification Commands
> Pin the exact commands discovered for this repo (also update canonical config docs).

- Lint:
  - `not-configured` (no repository-wide lint runner discovered)
- Build:
  - `not-configured` (no repository-wide build runner discovered)
- Test:
  - `not-configured` (no repository-wide test runner discovered)
- Migration integrity checks:
  - `rg -n "codex-commands\\.md" codex`
  - `test -f codex/project-structure.md`
  - `test -f codex/codex-config.yaml`

## Test strategy
- Unit:
  - Validate migrated shell scripts fail fast when `codex/project-structure.md` is absent.
- Integration:
  - Run stage bootstrap/validation scripts and confirm they read new canonical files.
- E2E / UI (if applicable):
  - n/a

## Acceptance criteria checklist
- [ ] `codex/codex-config.yaml` exists and includes required Code Review + Notes semantics.
- [ ] `codex/project-structure.md` exists in repository-specific structure format.
- [ ] `codex/codex-commands.md` is removed from active use and deleted.
- [ ] Every skill file with prior `codex-commands.md` references is migrated to the correct replacement source.
- [ ] Every script file with prior `codex-commands.md` references is migrated to the correct replacement source.
- [ ] Runtime abort is enforced when `codex/project-structure.md` is missing.
- [ ] Repository scan shows no unintended `codex-commands.md` references in active lifecycle assets.

## IN SCOPE
- Replacing `codex/codex-commands.md` usage with `codex/codex-config.yaml` and `codex/project-structure.md`.
- Updating all impacted skills and scripts.
- Updating directly coupled prompts/templates/rules documentation where references exist.
- Enforcing missing `codex/project-structure.md` abort behavior.

## OUT OF SCOPE
- Introducing unrelated lifecycle process changes.
- Reorganizing non-codex repository directories.
- Adding new language/toolchain infrastructure unrelated to this migration.

## Implementation phase strategy
- Complexity: medium
- Active phases: 1..3
- No new scope introduced: required
