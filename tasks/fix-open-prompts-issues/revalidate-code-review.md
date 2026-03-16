# Revalidate Code Review
- Task name: fix-open-prompts-issues
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
- Generated at: 2026-03-16T04:09:20Z
- Base branch: main
- Diff mode: fallback
- Diff command: `git diff`
- Diff bytes: 13124

### Changed files
- `codex/codex-config.yaml`
- `codex/prompts/self-improve-skills.md`
- `codex/rules/git-safe.rules`
- `codex/scripts/goals-extract.sh`
- `codex/scripts/goals-validate.sh`
- `codex/scripts/resolve-codex-root.sh`
- `codex/skills/acac/SKILL.md`
- `codex/skills/land-the-plan/SKILL.md`
- `goals/task-manifest.csv`

### Citation candidates (verify before use)
- `codex/codex-config.yaml:20-20`
- `codex/codex-config.yaml:23-24`
- `codex/prompts/self-improve-skills.md:21-26`
- `codex/rules/git-safe.rules:129-146`
- `codex/scripts/goals-extract.sh:29-37`
- `codex/scripts/goals-extract.sh:44-44`
- `codex/scripts/goals-extract.sh:46-46`
- `codex/scripts/goals-extract.sh:48-48`
- `codex/scripts/goals-validate.sh:29-41`
- `codex/scripts/resolve-codex-root.sh:16-16`
- `codex/scripts/resolve-codex-root.sh:30-33`
- `codex/scripts/resolve-codex-root.sh:37-39`
- `codex/skills/acac/SKILL.md:103-108`
- `codex/skills/acac/SKILL.md:30-30`
- `codex/skills/acac/SKILL.md:75-76`
- `codex/skills/acac/SKILL.md:81-83`
- `codex/skills/land-the-plan/SKILL.md:219-219`
- `codex/skills/land-the-plan/SKILL.md:221-228`
- `codex/skills/land-the-plan/SKILL.md:234-242`
- `codex/skills/land-the-plan/SKILL.md:301-301`
- `codex/skills/land-the-plan/SKILL.md:316-316`
- `codex/skills/land-the-plan/SKILL.md:333-333`
- `goals/task-manifest.csv:15-17`
<!-- REVIEW-CONTEXT END -->

## Findings JSON
```json
[]
```

## Overall Correctness Verdict
- Verdict: patch is correct
- Confidence: 0.90
- Justification: The changes are narrowly scoped to the reported defects, the script behavior is covered by direct command probes, and the workflow/rule updates stay aligned with the documented landing contract.
