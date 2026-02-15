# Phase 1 — Consistency Audit Baseline

## Objective
Produce a concrete principles-to-artifacts consistency audit for `./codex` and identify exact mismatch/redundancy targets before edits.

## Code areas impacted
- `tasks/improve-feb-15-2026/spec.md`
- `tasks/improve-feb-15-2026/phase-1.md`

## Work items
- [x] Map each principle in `codex/principles.md` to enforcing sections in `codex/AGENTS.md`, skills, and scripts.
- [x] Record concrete inconsistencies and duplication hotspots with file references.
- [x] Confirm fixes stay within locked scope and preserve stage/verdict behavior.

## Deliverables
- Written audit summary in this phase file with references.
- Confirmed in-scope edit list for later phases.

## Gate (must pass before proceeding)
Define objective pass/fail criteria.
- [x] At least two concrete, file-referenced inconsistency/redundancy findings are captured and approved for implementation.

## Verification steps
List exact commands and expected results.
- [x] Command: `rg -n "1-10|1-20|Section 8|READY FOR|BLOCKED|./.codex|./codex" codex/AGENTS.md codex/skills/**/SKILL.md codex/scripts/*.sh`
  - Expected: Findings list provides actionable edit targets without stage contract violations.
  - Result: PASS (`1-10` mismatch and stale `Section 8` reference identified; no stage contract token drift identified).

## Risks and mitigations
- Risk: Over-auditing broadens scope.
- Mitigation: Restrict findings to principle consistency, speedup, and instruction trimming only.

## Audit findings
- Finding 1: `codex/skills/establish-goals/SKILL.md` has inconsistent goal-count contract (`1-20` in most sections, but success condition says `goals exist (1-10)`).
- Finding 2: `codex/skills/revalidate/SKILL.md` references `codex/AGENTS.md Section 8`, but current `codex/AGENTS.md` has 7 sections.
- Finding 3: Root-resolution guidance is repeated with mixed emphasis; clarify `./codex` repo reality while preserving fallback behavior.
