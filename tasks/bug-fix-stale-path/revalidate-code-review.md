# Revalidate Code Review
- Task name: bug-fix-stale-path
- Findings status: none

## Reviewer Prompt
You are acting as a reviewer for a proposed code change made by another engineer.
Focus on issues that impact correctness, performance, security, maintainability, or developer experience.
Flag only actionable issues introduced by the pull request.
When you flag an issue, provide a short, direct explanation and cite the affected file and line range.
Prioritize severe issues and avoid nit-level comments unless they block understanding of the diff.
After listing findings, produce an overall correctness verdict ("patch is correct" or "patch is incorrect") with a concise justification and a confidence score between 0 and 1.
Ensure that file citations and line numbers are exactly correct using the tools available; if they are incorrect your comments will be rejected.

## Output Schema
```json
[
  {
    "file": "path/to/file",
    "line_range": "10-25",
    "severity": "high",
    "explanation": "Short explanation."
  }
]
```

## Review Context (auto-generated)
<!-- REVIEW-CONTEXT START -->
- Generated at: 2026-02-15T14:57:06Z
- Base branch: main
- Diff mode: base-branch
- Diff command: `git diff main...HEAD`
- Diff bytes: 46595

### Changed files
- `codex/AGENTS.md`
- `codex/codex-config.yaml`
- `codex/rules/git-safe.rules`
- `codex/scripts/read-codex-paths.sh`
- `codex/scripts/resolve-codex-root.sh`
- `codex/skills/establish-goals/SKILL.md`
- `codex/skills/land-the-plan/SKILL.md`
- `codex/skills/revalidate/SKILL.md`
- `goals/improve-feb-15-2026/establish-goals.v0.md`
- `goals/improve-feb-15-2026/goals.v0.md`
- `goals/task-manifest.csv`
- `tasks/improve-feb-15-2026/.complexity-lock.json`
- `tasks/improve-feb-15-2026/.scope-lock.md`
- `tasks/improve-feb-15-2026/complexity-signals.json`
- `tasks/improve-feb-15-2026/final-phase.md`
- `tasks/improve-feb-15-2026/lifecycle-state.md`
- `tasks/improve-feb-15-2026/phase-1.md`
- `tasks/improve-feb-15-2026/phase-2.md`
- `tasks/improve-feb-15-2026/phase-3.md`
- `tasks/improve-feb-15-2026/phase-4.md`
- `tasks/improve-feb-15-2026/phase-plan.md`
- `tasks/improve-feb-15-2026/revalidate-code-review.md`
- `tasks/improve-feb-15-2026/revalidate.md`
- `tasks/improve-feb-15-2026/risk-acceptance.md`
- `tasks/improve-feb-15-2026/spec.md`

### Citation candidates (verify before use)
- `codex/AGENTS.md:25-37`
- `codex/AGENTS.md:76-86`
- `codex/codex-config.yaml:14-14`
- `codex/codex-config.yaml:17-18`
- `codex/rules/git-safe.rules:120-128`
- `codex/scripts/read-codex-paths.sh:24-37`
- `codex/scripts/resolve-codex-root.sh:23-37`
- `codex/scripts/resolve-codex-root.sh:40-40`
- `codex/skills/establish-goals/SKILL.md:293-293`
- `codex/skills/land-the-plan/SKILL.md:177-177`
- `codex/skills/land-the-plan/SKILL.md:179-179`
- `codex/skills/land-the-plan/SKILL.md:189-210`
- `codex/skills/land-the-plan/SKILL.md:253-255`
- `codex/skills/land-the-plan/SKILL.md:266-266`
- `codex/skills/land-the-plan/SKILL.md:277-277`
- `codex/skills/land-the-plan/SKILL.md:286-286`
- `codex/skills/revalidate/SKILL.md:56-56`
- `goals/improve-feb-15-2026/establish-goals.v0.md:1-79`
- `goals/improve-feb-15-2026/goals.v0.md:1-35`
- `goals/task-manifest.csv:11-11`
- `tasks/improve-feb-15-2026/.complexity-lock.json:1-23`
- `tasks/improve-feb-15-2026/.scope-lock.md:1-9`
- `tasks/improve-feb-15-2026/complexity-signals.json:1-24`
- `tasks/improve-feb-15-2026/final-phase.md:1-50`
- `tasks/improve-feb-15-2026/lifecycle-state.md:1-5`
- `tasks/improve-feb-15-2026/phase-1.md:1-36`
- `tasks/improve-feb-15-2026/phase-2.md:1-32`
- `tasks/improve-feb-15-2026/phase-3.md:1-36`
- `tasks/improve-feb-15-2026/phase-4.md:1-41`
- `tasks/improve-feb-15-2026/phase-plan.md:1-26`
- `tasks/improve-feb-15-2026/revalidate-code-review.md:1-64`
- `tasks/improve-feb-15-2026/revalidate.md:1-26`
- `tasks/improve-feb-15-2026/risk-acceptance.md:1-11`
- `tasks/improve-feb-15-2026/spec.md:1-153`
<!-- REVIEW-CONTEXT END -->

## Findings JSON
```json
[]
```

## Overall Correctness Verdict
- Verdict: patch is correct
- Confidence: 0.93
- Justification: The patch closes stale env fast-path acceptance by requiring expected root/scripts coherence before early return, while preserving bootstrap fallback behavior and fail-fast checks.
