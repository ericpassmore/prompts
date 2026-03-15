# Revalidate Code Review
- Task name: self-improve-skills
- Findings status: complete

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
- Generated at: 2026-03-15T03:37:29Z
- Base branch: qa
- Diff mode: base-branch
- Diff command: `git diff qa...HEAD`
- Diff bytes: 33944

### Changed files
- `codex/product-idea-principles.md`
- `codex/scripts/product-idea-regulatory-intake-validate.sh`
- `codex/scripts/product-idea-scope-fingerprint.sh`
- `codex/skills/product-idea/SKILL.md`
- `codex/skills/regulatory-surface-detection/SKILL.md`

### Citation candidates (verify before use)
- `codex/product-idea-principles.md:1-150`
- `codex/scripts/product-idea-regulatory-intake-validate.sh:1-195`
- `codex/scripts/product-idea-scope-fingerprint.sh:1-56`
- `codex/skills/product-idea/SKILL.md:1-695`
- `codex/skills/regulatory-surface-detection/SKILL.md:1-82`
<!-- REVIEW-CONTEXT END -->

## Findings JSON
```json
[
  {
    "file": "codex/product-idea-principles.md",
    "line_range": "1-150",
    "severity": "high",
    "explanation": "The base diff used for landing (`qa...HEAD`) already includes unrelated committed work on the current `product-idea` branch, so a PR from this branch would not be scoped to the locked `self-improve-skills` task. Landing from the current branch would mix unrelated changes into the review surface."
  }
]
```

## Overall Correctness Verdict
- Verdict: patch is incorrect
- Confidence: 0.95
- Justification: The task implementation itself is coherent, but the current landing diff is not reviewer-ready because the active branch already contains unrelated committed changes outside the locked task scope while the current task changes are still uncommitted. A truthful Stage 5 handoff requires an isolated review surface first.
