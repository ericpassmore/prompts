# Revalidate Code Review
- Task name: may-self-improvements
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
- Generated at: 2026-05-04T00:01:41Z
- Base branch: main
- Diff mode: working-tree
- Diff command: `git diff --cached && git diff`
- Diff bytes: 21438

### Changed files
- `codex/codex-config.yaml`
- `codex/project-structure.md`
- `codex/prompts/acac.md`
- `codex/scripts/git-commit-preflight.sh`
- `codex/scripts/git-stage-safe.sh`
- `codex/scripts/git-track-safe-untracked.sh`
- `codex/scripts/prepare-phased-impl-scaffold.sh`
- `codex/scripts/prepare-takeoff-worktree.sh`
- `codex/scripts/revalidate-code-review.sh`
- `codex/scripts/task-scaffold.sh`
- `codex/skills/acac/SKILL.md`
- `codex/skills/complexity-scaling/SKILL.md`
- `codex/skills/git-commit/SKILL.md`
- `codex/skills/land-the-plan/SKILL.md`
- `codex/skills/prepare-phased-impl/SKILL.md`
- `codex/skills/prepare-takeoff/SKILL.md`
- `goals/task-manifest.csv`

### Citation candidates (verify before use)
- `codex/codex-config.yaml:34-35`
- `codex/codex-config.yaml:8-12`
- `codex/project-structure.md:42-42`
- `codex/prompts/acac.md:9-10`
- `codex/scripts/git-commit-preflight.sh:28-28`
- `codex/scripts/git-stage-safe.sh:16-61`
- `codex/scripts/git-track-safe-untracked.sh:11-28`
- `codex/scripts/git-track-safe-untracked.sh:176-180`
- `codex/scripts/git-track-safe-untracked.sh:238-238`
- `codex/scripts/git-track-safe-untracked.sh:240-240`
- `codex/scripts/git-track-safe-untracked.sh:31-99`
- `codex/scripts/prepare-phased-impl-scaffold.sh:135-143`
- `codex/scripts/prepare-takeoff-worktree.sh:104-104`
- `codex/scripts/revalidate-code-review.sh:114-118`
- `codex/scripts/revalidate-code-review.sh:120-120`
- `codex/scripts/revalidate-code-review.sh:97-112`
- `codex/scripts/task-scaffold.sh:61-61`
- `codex/scripts/task-scaffold.sh:96-102`
- `codex/skills/acac/SKILL.md:137-138`
- `codex/skills/acac/SKILL.md:90-90`
- `codex/skills/complexity-scaling/SKILL.md:23-23`
- `codex/skills/git-commit/SKILL.md:228-228`
- `codex/skills/git-commit/SKILL.md:232-232`
- `codex/skills/git-commit/SKILL.md:251-251`
- `codex/skills/git-commit/SKILL.md:265-265`
- `codex/skills/git-commit/SKILL.md:27-27`
- `codex/skills/git-commit/SKILL.md:29-29`
- `codex/skills/git-commit/SKILL.md:301-301`
- `codex/skills/git-commit/SKILL.md:32-32`
- `codex/skills/git-commit/SKILL.md:34-34`
- `codex/skills/git-commit/SKILL.md:45-45`
- `codex/skills/land-the-plan/SKILL.md:145-146`
- `codex/skills/prepare-phased-impl/SKILL.md:118-118`
- `codex/skills/prepare-takeoff/SKILL.md:131-131`
- `codex/skills/prepare-takeoff/SKILL.md:220-220`
- `goals/task-manifest.csv:19-20`
<!-- REVIEW-CONTEXT END -->

## Findings JSON
```json
[]
```

## Overall Correctness Verdict
- Verdict: patch is correct
- Confidence: 0.88
- Justification: The changes preserve the locked lifecycle scope, add conservative git safety checks, and targeted fixtures verified the changed shell-script behavior. No actionable correctness, security, or maintainability regression was found in the reviewed diff.
