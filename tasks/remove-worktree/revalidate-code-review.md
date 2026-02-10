# Revalidate Code Review
- Task name: remove-worktree
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
- Generated at: 2026-02-10T21:28:16Z
- Base branch: main
- Diff mode: fallback
- Diff command: `git diff`
- Diff bytes: 23972

### Changed files
- `codex/rules/git-safe.rules`
- `codex/scripts/git-commit-preflight.sh`
- `codex/scripts/git-push-branch-safe.sh`
- `codex/scripts/prepare-takeoff-bootstrap.sh`
- `codex/scripts/prepare-takeoff-worktree.sh`
- `codex/skills/git-commit/SKILL.md`
- `codex/skills/land-the-plan/SKILL.md`
- `codex/skills/prepare-takeoff/SKILL.md`
- `goals/task-manifest.csv`

### Citation candidates (verify before use)
- `codex/rules/git-safe.rules:132-132`
- `codex/rules/git-safe.rules:134-134`
- `codex/rules/git-safe.rules:138-138`
- `codex/rules/git-safe.rules:245-245`
- `codex/rules/git-safe.rules:254-254`
- `codex/rules/git-safe.rules:263-263`
- `codex/rules/git-safe.rules:272-272`
- `codex/rules/git-safe.rules:275-275`
- `codex/rules/git-safe.rules:282-282`
- `codex/rules/git-safe.rules:285-285`
- `codex/rules/git-safe.rules:292-292`
- `codex/rules/git-safe.rules:295-295`
- `codex/scripts/git-commit-preflight.sh:13-16`
- `codex/scripts/git-commit-preflight.sh:18-18`
- `codex/scripts/git-push-branch-safe.sh:15-15`
- `codex/scripts/git-push-branch-safe.sh:26-26`
- `codex/scripts/git-push-branch-safe.sh:29-31`
- `codex/scripts/prepare-takeoff-bootstrap.sh:82-82`
- `codex/scripts/prepare-takeoff-worktree.sh:104-104`
- `codex/scripts/prepare-takeoff-worktree.sh:14-18`
- `codex/scripts/prepare-takeoff-worktree.sh:22-22`
- `codex/scripts/prepare-takeoff-worktree.sh:3-3`
- `codex/scripts/prepare-takeoff-worktree.sh:34-34`
- `codex/scripts/prepare-takeoff-worktree.sh:57-57`
- `codex/scripts/prepare-takeoff-worktree.sh:60-60`
- `codex/scripts/prepare-takeoff-worktree.sh:62-65`
- `codex/scripts/prepare-takeoff-worktree.sh:68-68`
- `codex/scripts/prepare-takeoff-worktree.sh:71-73`
- `codex/scripts/prepare-takeoff-worktree.sh:77-78`
- `codex/scripts/prepare-takeoff-worktree.sh:81-81`
- `codex/scripts/prepare-takeoff-worktree.sh:83-90`
- `codex/scripts/prepare-takeoff-worktree.sh:93-103`
- `codex/skills/git-commit/SKILL.md:199-201`
- `codex/skills/git-commit/SKILL.md:300-302`
- `codex/skills/land-the-plan/SKILL.md:10-10`
- `codex/skills/land-the-plan/SKILL.md:105-105`
- `codex/skills/land-the-plan/SKILL.md:110-110`
- `codex/skills/land-the-plan/SKILL.md:113-113`
- `codex/skills/land-the-plan/SKILL.md:151-151`
- `codex/skills/land-the-plan/SKILL.md:156-156`
- `codex/skills/land-the-plan/SKILL.md:16-16`
- `codex/skills/land-the-plan/SKILL.md:160-160`
- `codex/skills/land-the-plan/SKILL.md:179-179`
- `codex/skills/land-the-plan/SKILL.md:18-18`
- `codex/skills/land-the-plan/SKILL.md:193-193`
- `codex/skills/land-the-plan/SKILL.md:202-202`
- `codex/skills/land-the-plan/SKILL.md:208-208`
- `codex/skills/land-the-plan/SKILL.md:217-217`
- `codex/skills/land-the-plan/SKILL.md:75-75`
- `codex/skills/land-the-plan/SKILL.md:78-80`
- `codex/skills/prepare-takeoff/SKILL.md:105-105`
- `codex/skills/prepare-takeoff/SKILL.md:111-111`
- `codex/skills/prepare-takeoff/SKILL.md:117-117`
- `codex/skills/prepare-takeoff/SKILL.md:123-123`
- `codex/skills/prepare-takeoff/SKILL.md:126-131`
- `codex/skills/prepare-takeoff/SKILL.md:197-197`
- `codex/skills/prepare-takeoff/SKILL.md:208-208`
- `codex/skills/prepare-takeoff/SKILL.md:218-218`
- `codex/skills/prepare-takeoff/SKILL.md:97-97`
- `codex/skills/prepare-takeoff/SKILL.md:99-100`
- `goals/task-manifest.csv:3-3`
<!-- REVIEW-CONTEXT END -->

## Findings JSON
```json
[]
```

## Overall Correctness Verdict
- Verdict: patch is correct
- Confidence: 0.9
- Justification: The patch removes required worktree lifecycle operations while preserving stage verdict contracts and safety-prep behavior; no actionable regressions were identified in scope.
