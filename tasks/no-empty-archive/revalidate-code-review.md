# Revalidate Code Review
- Task name: no-empty-archive
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
- Generated at: 2026-02-12T22:47:58Z
- Base branch: main
- Diff mode: fallback
- Diff command: `git diff`
- Diff bytes: 3817

### Changed files
- `codex/codex-config.yaml`
- `codex/scripts/prepare-phased-impl-archive.sh`
- `goals/task-manifest.csv`

### Citation candidates (verify before use)
- `codex/codex-config.yaml:10-10`
- `codex/codex-config.yaml:13-14`
- `codex/scripts/prepare-phased-impl-archive.sh:11-13`
- `codex/scripts/prepare-phased-impl-archive.sh:35-67`
- `codex/scripts/prepare-phased-impl-archive.sh:5-5`
- `codex/scripts/prepare-phased-impl-archive.sh:72-72`
- `codex/scripts/prepare-phased-impl-archive.sh:77-92`
- `goals/task-manifest.csv:5-5`
<!-- REVIEW-CONTEXT END -->

## Findings JSON
```json
[]
```

## Overall Correctness Verdict
- Verdict: patch is correct
- Confidence: 0.91
- Justification: The archive guard deterministically compares rendered phase templates and only skips archival when artifacts are template-only; substantive archive behavior remains intact and no actionable regressions were found.
