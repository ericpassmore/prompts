# Revalidate Code Review
- Task name: move-pr-to-mcp
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
- Generated at: 2026-02-13T04:38:33Z
- Base branch: main
- Diff mode: fallback
- Diff command: `git diff`
- Diff bytes: 6191

### Changed files
- `codex/codex-config.yaml`
- `codex/rules/git-safe.rules`
- `codex/scripts/project-init.sh`
- `codex/skills/land-the-plan/SKILL.md`
- `goals/task-manifest.csv`

### Citation candidates (verify before use)
- `codex/codex-config.yaml:11-11`
- `codex/codex-config.yaml:14-15`
- `codex/rules/git-safe.rules:169-169`
- `codex/scripts/project-init.sh:314-314`
- `codex/scripts/project-init.sh:334-343`
- `codex/scripts/project-init.sh:358-358`
- `codex/skills/land-the-plan/SKILL.md:159-159`
- `codex/skills/land-the-plan/SKILL.md:161-162`
- `codex/skills/land-the-plan/SKILL.md:164-170`
- `codex/skills/land-the-plan/SKILL.md:172-172`
- `codex/skills/land-the-plan/SKILL.md:213-213`
- `codex/skills/land-the-plan/SKILL.md:223-223`
- `goals/task-manifest.csv:6-6`
<!-- REVIEW-CONTEXT END -->

## Findings JSON
```json
[]
```

## Overall Correctness Verdict
- Verdict: patch is correct
- Confidence: 0.94
- Justification: The patch cleanly replaces `gh pr` execution paths in requested surfaces with explicit GitHub MCP prompt handoff, removes matching `gh pr` allow rules from git-safe policy, and keeps scope limited to requested files plus lifecycle artifacts.
