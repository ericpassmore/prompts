# Revalidate
- Task name: move-pr-to-mcp
- Trigger source: ready-for-reverification
- Trigger evidence: Stage 4 validator emitted `READY FOR REVERIFICATION` after requested MCP migration updates and targeted verification checks.
- Final verdict: READY TO LAND

## Locked upstream context (read-only)
- Goals artifact: `goals/move-pr-to-mcp/goals.v0.md` (`GOALS LOCKED`)
- Prepare-takeoff outputs: `tasks/move-pr-to-mcp/spec.md`, `codex/codex-config.yaml`, `codex/project-structure.md`

## Drift and integrity reassessment
- Goals/constraints integrity: pass
- Scope/surface adherence: pass
- Verification stability: pass
- Progress budget evidence: pass
- Implementation/reverification consistency: pass

## Reverification findings
1. `land-the-plan` Step 6 now requires GitHub MCP prompt flow for PR create/update instead of `gh pr create`.
2. `git-safe.rules` no longer includes `gh pr` allowlist entries.
3. `project-init.sh` no longer requires `gh` and now emits MCP prompt payload details for PR handoff.
4. Revalidate code review reports no actionable findings and verdict `patch is correct`.

## Next action
- Execute `land-the-plan` after push/PR handoff using GitHub MCP.
