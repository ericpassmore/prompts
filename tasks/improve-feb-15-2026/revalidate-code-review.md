# Revalidate Code Review
- Task name: improve-feb-15-2026
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
- Generated at: 2026-02-15T14:35:53Z
- Base branch: main
- Diff mode: fallback
- Diff command: `git diff`
- Diff bytes: 5894

### Changed files
- `codex/AGENTS.md`
- `codex/codex-config.yaml`
- `codex/scripts/read-codex-paths.sh`
- `codex/scripts/resolve-codex-root.sh`
- `codex/skills/establish-goals/SKILL.md`
- `codex/skills/revalidate/SKILL.md`
- `goals/task-manifest.csv`

### Citation candidates (verify before use)
- `codex/AGENTS.md:25-37`
- `codex/AGENTS.md:76-86`
- `codex/codex-config.yaml:14-14`
- `codex/codex-config.yaml:17-18`
- `codex/scripts/read-codex-paths.sh:24-37`
- `codex/scripts/resolve-codex-root.sh:23-37`
- `codex/scripts/resolve-codex-root.sh:40-40`
- `codex/skills/establish-goals/SKILL.md:293-293`
- `codex/skills/revalidate/SKILL.md:56-56`
- `goals/task-manifest.csv:11-11`
<!-- REVIEW-CONTEXT END -->

## Findings JSON
```json
[]
```

## Overall Correctness Verdict
- Verdict: patch is correct
- Confidence: 0.92
- Justification: Changes preserve lifecycle stage/verdict behavior, resolve two concrete contract inconsistencies, and introduce only validated fast-path optimizations without weakening fallback or fail-fast rules.
