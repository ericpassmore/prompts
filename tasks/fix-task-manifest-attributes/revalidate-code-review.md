# Revalidate Code Review
- Task name: fix-task-manifest-attributes
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
- Generated at: 2026-02-13T22:06:40Z
- Base branch: main
- Diff mode: fallback
- Diff command: `git diff`
- Diff bytes: 8082

### Changed files
- `codex/codex-config.yaml`
- `codex/rules/git-safe.rules`
- `codex/skills/land-the-plan/SKILL.md`
- `goals/task-manifest.csv`

### Citation candidates (verify before use)
- `codex/codex-config.yaml:13-13`
- `codex/codex-config.yaml:16-17`
- `codex/rules/git-safe.rules:321-347`
- `codex/skills/land-the-plan/SKILL.md:131-149`
- `codex/skills/land-the-plan/SKILL.md:154-154`
- `codex/skills/land-the-plan/SKILL.md:168-168`
- `codex/skills/land-the-plan/SKILL.md:177-177`
- `codex/skills/land-the-plan/SKILL.md:18-18`
- `codex/skills/land-the-plan/SKILL.md:192-192`
- `codex/skills/land-the-plan/SKILL.md:203-203`
- `codex/skills/land-the-plan/SKILL.md:215-215`
- `codex/skills/land-the-plan/SKILL.md:228-235`
- `codex/skills/land-the-plan/SKILL.md:241-241`
- `codex/skills/land-the-plan/SKILL.md:253-253`
- `goals/task-manifest.csv:6-8`
<!-- REVIEW-CONTEXT END -->

## Findings JSON
```json
[]
```

## Overall Correctness Verdict
- Verdict: patch is correct
- Confidence: 0.93
- Justification: The patch adds a fail-fast helper script for task-manifest metadata stamping/commit/push, places it in the landing flow between commit and PR creation, and adds matching trusted rule entries without expanding scope beyond requested surfaces.
