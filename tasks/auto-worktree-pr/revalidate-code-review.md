# Revalidate Code Review
- Task name: auto-worktree-pr
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
- Generated at: 2026-02-10T22:05:54Z
- Base branch: main
- Diff mode: fallback
- Diff command: `git diff`
- Diff bytes: 12840

### Changed files
- `codex/rules/git-safe.rules`
- `codex/scripts/git-commit-preflight.sh`
- `codex/skills/git-commit/SKILL.md`
- `codex/skills/land-the-plan/SKILL.md`
- `goals/task-manifest.csv`

### Citation candidates (verify before use)
- `codex/rules/git-safe.rules:203-212`
- `codex/rules/git-safe.rules:289-297`
- `codex/rules/git-safe.rules:29-56`
- `codex/rules/git-safe.rules:307-315`
- `codex/rules/git-safe.rules:325-333`
- `codex/scripts/git-commit-preflight.sh:20-26`
- `codex/skills/git-commit/SKILL.md:201-201`
- `codex/skills/git-commit/SKILL.md:304-304`
- `codex/skills/land-the-plan/SKILL.md:10-10`
- `codex/skills/land-the-plan/SKILL.md:114-114`
- `codex/skills/land-the-plan/SKILL.md:121-121`
- `codex/skills/land-the-plan/SKILL.md:123-123`
- `codex/skills/land-the-plan/SKILL.md:128-128`
- `codex/skills/land-the-plan/SKILL.md:133-133`
- `codex/skills/land-the-plan/SKILL.md:168-182`
- `codex/skills/land-the-plan/SKILL.md:18-18`
- `codex/skills/land-the-plan/SKILL.md:184-184`
- `codex/skills/land-the-plan/SKILL.md:193-193`
- `codex/skills/land-the-plan/SKILL.md:195-195`
- `codex/skills/land-the-plan/SKILL.md:205-205`
- `codex/skills/land-the-plan/SKILL.md:207-207`
- `codex/skills/land-the-plan/SKILL.md:209-209`
- `codex/skills/land-the-plan/SKILL.md:218-227`
- `codex/skills/land-the-plan/SKILL.md:233-233`
- `codex/skills/land-the-plan/SKILL.md:237-237`
- `codex/skills/land-the-plan/SKILL.md:242-242`
- `codex/skills/land-the-plan/SKILL.md:252-252`
- `codex/skills/land-the-plan/SKILL.md:31-31`
- `codex/skills/land-the-plan/SKILL.md:79-96`
- `goals/task-manifest.csv:3-4`
<!-- REVIEW-CONTEXT END -->

## Findings JSON
```json
[]
```

## Overall Correctness Verdict
- Verdict: patch is correct
- Confidence: 0.91
- Justification: Detached-head landing now uses explicit fetch/collision/create checks, Stage 6 documents push/PR/merge flow, and git-commit secret/binary protections remain present in skill/script policy surfaces reviewed in scope.
