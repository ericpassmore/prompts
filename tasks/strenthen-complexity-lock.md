# Strengthen Complexity Lock Validation

## Overview
Harden Stage 3 validation so incomplete complexity lock metadata cannot bypass drift hard gates.

## Goals
- Block validation when `.complexity-lock.json` omits required metadata fields.
- Enforce lock metadata integrity for selected signals path and content hash.
- Keep existing range/phase checks intact.

## Non-goals
- Changes to scoring formulas or stage verdict vocabulary.
- Broad refactors outside Stage 3 validator lock handling.

## Use cases / user stories
- As an operator, if lock metadata is edited/truncated, validation must fail explicitly and route to `revalidate`.

## Current behavior
- Notes: validator falls back when `selected_signals_path` is missing and skips content drift checks when `selected_signals_sha256` is absent.
- Key files:
  - `codex/scripts/prepare-phased-impl-validate.sh`
  - `codex/scripts/prepare-phased-impl-scaffold.sh`

## Proposed behavior
- Behavior changes:
  - `prepare-phased-impl-validate.sh` emits `BLOCKED` when lock metadata is incomplete.
  - No fallback to task complexity signals when lock exists but path metadata is missing.
  - Content drift check requires non-empty lock hash metadata.
- Edge cases:
  - Missing lock file remains blocked with remediation.
  - Invalid/partial lock metadata blocks before drift checks proceed.

## Technical design
### Architecture / modules impacted
- `codex/scripts/prepare-phased-impl-validate.sh`

### API changes (if any)
None.

### UI/UX changes (if any)
None.

### Data model / schema changes (PostgreSQL)
- Migrations: None.
- Backward compatibility: N/A.
- Rollback: Revert validator change.

## Security & privacy
No secrets or auth paths changed.

## Observability (logs/metrics)
Validation output includes explicit lock-metadata blocker messages.

## Verification Commands
> Pin the exact commands discovered for this repo (also update `./codex/project-structure.md` and `./codex/codex-config.yaml`).

- Lint:
  - `bash -n codex/scripts/prepare-phased-impl-validate.sh`
- Build:
  - `bash -n codex/scripts/prepare-phased-impl-scaffold.sh`
- Test:
  - `./codex/scripts/prepare-phased-impl-validate.sh strenthen-complexity-lock`

## Test strategy
- Unit: script-level path/metadata assertions.
- Integration: scaffold lock, then validate with complete and truncated lock metadata.
- E2E / UI (if applicable): N/A.

## Acceptance criteria checklist
- [ ] Validator blocks on missing `selected_signals_path`.
- [ ] Validator blocks on missing `selected_signals_sha256`.
- [ ] Existing range checks still operate.

## IN SCOPE
- Stage 3 validator complexity lock metadata enforcement.
- Task artifacts required to run Stage 3/Stage 4 validators.

## OUT OF SCOPE
- Complexity scorer level mapping changes.
- Non-validation runtime behavior changes.

## Stage 2 readiness
- Goal lock assertion: goals are locked in `goals/strenthen-complexity-lock/goals.v0.md`.
- Ambiguity check: passed; no blocking ambiguity remains.
- Governing rules: `codex/rules/expand-task-spec.rules`, `codex/rules/git-safe.rules`.
- Execution posture: simplicity bias, surgical changes, fail-fast enforcement.
- Change control: goal/scope changes require re-lock/revalidate.
- Verdict: READY FOR PLANNING

## Implementation phase strategy
- Complexity: scored:L2 (focused)
- Complexity scoring details: score=8; recommended-goals=4; forced-l1=false; signals=/Users/eric/.codex/worktrees/c1bd/prompts/tasks/strenthen-complexity-lock/complexity-signals.json
- Active phases: 1..3
- No new scope introduced: required
