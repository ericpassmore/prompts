# Revalidate
- Task name: fix-task-manifest-attributes
- Trigger source: ready-for-reverification
- Trigger evidence: Stage 4 validator emitted `READY FOR REVERIFICATION` after landing script, skill, and rule updates plus targeted verification checks.
- Final verdict: READY TO LAND

## Locked upstream context (read-only)
- Goals artifact: `goals/fix-task-manifest-attributes/goals.v0.md` (`GOALS LOCKED`)
- Prepare-takeoff outputs: `tasks/fix-task-manifest-attributes/spec.md`, `codex/codex-config.yaml`, `codex/project-structure.md`

## Drift and integrity reassessment
- Goals/constraints integrity: pass
- Scope/surface adherence: pass
- Verification stability: pass
- Progress budget evidence: pass
- Implementation/reverification consistency: pass

## Reverification findings
1. `land-the-plan` now requires `task-manifest-land-update.sh` between `git-commit` and PR creation.
2. New helper script updates `goals/task-manifest.csv` row metadata for current task and performs commit/push behavior.
3. `git-safe.rules` includes trusted script allow-rules for home/canonical/repo-local paths.
4. Revalidate code review reports no actionable findings and verdict `patch is correct`.

## Next action
- Execute `land-the-plan` using the updated manifest step before PR creation.
