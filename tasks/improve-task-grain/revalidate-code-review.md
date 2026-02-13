# Revalidate Code Review
- Task name: improve-task-grain
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
- Generated at: 2026-02-13T05:11:53Z
- Base branch: main
- Diff mode: fallback
- Diff command: `git diff`
- Diff bytes: 14180

### Changed files
- `codex/codex-config.yaml`
- `codex/scripts/complexity-score.sh`
- `codex/scripts/goals-scaffold.sh`
- `codex/scripts/prepare-phased-impl-validate.sh`
- `goals/task-manifest.csv`

### Citation candidates (verify before use)
- `codex/codex-config.yaml:12-12`
- `codex/codex-config.yaml:15-16`
- `codex/scripts/complexity-score.sh:185-187`
- `codex/scripts/complexity-score.sh:191-191`
- `codex/scripts/complexity-score.sh:193-193`
- `codex/scripts/complexity-score.sh:195-195`
- `codex/scripts/complexity-score.sh:197-197`
- `codex/scripts/complexity-score.sh:199-199`
- `codex/scripts/complexity-score.sh:250-251`
- `codex/scripts/complexity-score.sh:259-260`
- `codex/scripts/complexity-score.sh:32-33`
- `codex/scripts/goals-scaffold.sh:109-109`
- `codex/scripts/goals-scaffold.sh:113-113`
- `codex/scripts/goals-scaffold.sh:121-121`
- `codex/scripts/goals-scaffold.sh:123-124`
- `codex/scripts/goals-scaffold.sh:138-145`
- `codex/scripts/goals-scaffold.sh:148-148`
- `codex/scripts/goals-scaffold.sh:151-152`
- `codex/scripts/goals-scaffold.sh:155-155`
- `codex/scripts/goals-scaffold.sh:44-51`
- `codex/scripts/goals-scaffold.sh:70-70`
- `codex/scripts/goals-scaffold.sh:72-73`
- `codex/scripts/goals-scaffold.sh:81-82`
- `codex/scripts/goals-scaffold.sh:84-86`
- `codex/scripts/prepare-phased-impl-validate.sh:13-16`
- `codex/scripts/prepare-phased-impl-validate.sh:168-222`
- `codex/scripts/prepare-phased-impl-validate.sh:227-243`
- `codex/scripts/prepare-phased-impl-validate.sh:46-80`
- `codex/scripts/prepare-phased-impl-validate.sh:7-7`
- `goals/task-manifest.csv:1-7`
<!-- REVIEW-CONTEXT END -->

## Findings JSON
```json
[]
```

## Overall Correctness Verdict
- Verdict: patch is correct
- Confidence: 0.93
- Justification: The patch cleanly adds manifest grain fields with required defaults, updates complexity mapping to the requested L1-L5 ranges, and enforces complexity-scored goal/phase cardinality in Stage 3 validation while keeping changes localized to requested script surfaces and lifecycle artifacts.
