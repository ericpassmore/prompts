# Revalidate
- Task name: bug-fix-stale-path
- Trigger source: ready-for-reverification
- Trigger evidence: Stage 4 validator emitted `READY FOR REVERIFICATION` after stale-path resolver fix and verification checks.
- Final verdict: READY TO LAND

## Locked upstream context (read-only)
- Goals artifact: `goals/bug-fix-stale-path/goals.v0.md` (`GOALS LOCKED`)
- Prepare-takeoff outputs: `tasks/bug-fix-stale-path/spec.md`, `codex/codex-config.yaml`, `codex/project-structure.md`

## Drift and integrity reassessment
- Goals/constraints integrity: pass
- Scope/surface adherence: pass
- Verification stability: pass
- Progress budget evidence: pass
- Implementation/reverification consistency: pass

## Reverification findings
1. `read_codex_paths` now validates env fast-path values against expected current root/scripts context before early return.
2. Stale/mismatched scripts-dir env values are replaced with current expected paths.
3. `resolve_codex_root` no longer accepts explicit `CODEX_ROOT` values outside allowed roots for current repository context.
4. Validator checks and stale-env simulation evidence pass; no unresolved actionable findings.

## Next action
- Execute `land-the-plan` after gate confirmation.
