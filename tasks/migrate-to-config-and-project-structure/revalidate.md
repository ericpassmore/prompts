# Revalidate
- Task name: migrate-to-config-and-project-structure
- Trigger source: ready-for-reverification
- Trigger evidence: Stage 4 validator emitted `READY FOR REVERIFICATION` and Stage 3 landing prerequisites are now satisfied (`Stage 3 runs: 2`, `Drift revalidation count: 1`).
- Final verdict: READY TO LAND

## Locked upstream context (read-only)
- Goals artifact: `goals/migrate-to-config-and-project-structure/goals.v0.md` (`GOALS LOCKED`)
- Prepare-takeoff outputs: `tasks/migrate-to-config-and-project-structure/spec.md`, `codex/codex-config.yaml`, `codex/project-structure.md`

## Drift and integrity reassessment
- Goals/constraints integrity: pass
- Scope/surface adherence: pass
- Verification stability: pass
- Progress budget evidence: pass
- Implementation/reverification consistency: pass

## Reverification findings
1. Stage 3 lifecycle prerequisites for landing are satisfied (`Stage 3 runs: 2`, `Drift revalidation count: 1`).
2. Code-review status is `none` with verdict `patch is correct`; no open actionable findings remain.

## Next action
- Execute direct reverification validation and hand off to `land-the-plan`.
