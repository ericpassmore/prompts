# Revalidate Code Review
- Task name: gh-wrapper-auth-routing
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
- Generated at: 2026-03-29T16:06:52Z
- Base branch: main
- Diff mode: fallback
- Diff command: `git diff`
- Diff bytes: 71014

### Changed files
- `codex/codex-config.yaml`
- `codex/prompts/self-improve-skills.md`
- `codex/rules/git-safe.rules`
- `codex/scripts/gh-auth-check.sh`
- `codex/scripts/gh-wrap.sh`
- `codex/skills/land-the-plan/SKILL.md`
- `goals/gh-wrapper-auth-routing/establish-goals.v0.md`
- `goals/gh-wrapper-auth-routing/goals.v0.md`
- `goals/task-manifest.csv`
- `tasks/gh-wrapper-auth-routing/.complexity-lock.json`
- `tasks/gh-wrapper-auth-routing/.scope-lock.md`
- `tasks/gh-wrapper-auth-routing/archive/prepare-phased-impl-9d32bc8/.scope-lock.md`
- `tasks/gh-wrapper-auth-routing/archive/prepare-phased-impl-9d32bc8/archive-metadata.md`
- `tasks/gh-wrapper-auth-routing/archive/prepare-phased-impl-9d32bc8/phase-1.md`
- `tasks/gh-wrapper-auth-routing/archive/prepare-phased-impl-9d32bc8/phase-2.md`
- `tasks/gh-wrapper-auth-routing/archive/prepare-phased-impl-9d32bc8/phase-3.md`
- `tasks/gh-wrapper-auth-routing/archive/prepare-phased-impl-9d32bc8/phase-4.md`
- `tasks/gh-wrapper-auth-routing/archive/prepare-phased-impl-9d32bc8/phase-5.md`
- `tasks/gh-wrapper-auth-routing/archive/prepare-phased-impl-9d32bc8/phase-6.md`
- `tasks/gh-wrapper-auth-routing/archive/prepare-phased-impl-9d32bc8/phase-7.md`
- `tasks/gh-wrapper-auth-routing/archive/prepare-phased-impl-9d32bc8/phase-8.md`
- `tasks/gh-wrapper-auth-routing/archive/prepare-phased-impl-9d32bc8/phase-plan.md`
- `tasks/gh-wrapper-auth-routing/complexity-signals.json`
- `tasks/gh-wrapper-auth-routing/final-phase.md`
- `tasks/gh-wrapper-auth-routing/lifecycle-state.md`
- `tasks/gh-wrapper-auth-routing/phase-1.md`
- `tasks/gh-wrapper-auth-routing/phase-2.md`
- `tasks/gh-wrapper-auth-routing/phase-3.md`
- `tasks/gh-wrapper-auth-routing/phase-plan.md`
- `tasks/gh-wrapper-auth-routing/revalidate-code-review.md`
- `tasks/gh-wrapper-auth-routing/risk-acceptance.md`
- `tasks/gh-wrapper-auth-routing/spec.md`

### Citation candidates (verify before use)
- `codex/codex-config.yaml:11-14`
- `codex/codex-config.yaml:30-31`
- `codex/codex-config.yaml:4-7`
- `codex/prompts/self-improve-skills.md:95-95`
- `codex/prompts/self-improve-skills.md:98-98`
- `codex/rules/git-safe.rules:121-121`
- `codex/rules/git-safe.rules:123-123`
- `codex/rules/git-safe.rules:125-125`
- `codex/rules/git-safe.rules:130-130`
- `codex/rules/git-safe.rules:132-132`
- `codex/rules/git-safe.rules:134-134`
- `codex/rules/git-safe.rules:139-139`
- `codex/rules/git-safe.rules:141-141`
- `codex/rules/git-safe.rules:143-143`
- `codex/rules/git-safe.rules:148-148`
- `codex/rules/git-safe.rules:150-150`
- `codex/rules/git-safe.rules:152-270`
- `codex/scripts/gh-auth-check.sh:1-208`
- `codex/scripts/gh-wrap.sh:1-254`
- `codex/skills/land-the-plan/SKILL.md:225-225`
- `codex/skills/land-the-plan/SKILL.md:231-231`
- `codex/skills/land-the-plan/SKILL.md:237-237`
- `codex/skills/land-the-plan/SKILL.md:240-243`
- `codex/skills/land-the-plan/SKILL.md:316-316`
- `codex/skills/land-the-plan/SKILL.md:334-334`
- `goals/gh-wrapper-auth-routing/establish-goals.v0.md:1-90`
- `goals/gh-wrapper-auth-routing/goals.v0.md:1-35`
- `goals/task-manifest.csv:18-18`
- `tasks/gh-wrapper-auth-routing/.complexity-lock.json:1-23`
- `tasks/gh-wrapper-auth-routing/.scope-lock.md:1-13`
- `tasks/gh-wrapper-auth-routing/archive/prepare-phased-impl-9d32bc8/.scope-lock.md:1-13`
- `tasks/gh-wrapper-auth-routing/archive/prepare-phased-impl-9d32bc8/archive-metadata.md:1-5`
- `tasks/gh-wrapper-auth-routing/archive/prepare-phased-impl-9d32bc8/phase-1.md:1-25`
- `tasks/gh-wrapper-auth-routing/archive/prepare-phased-impl-9d32bc8/phase-2.md:1-25`
- `tasks/gh-wrapper-auth-routing/archive/prepare-phased-impl-9d32bc8/phase-3.md:1-25`
- `tasks/gh-wrapper-auth-routing/archive/prepare-phased-impl-9d32bc8/phase-4.md:1-25`
- `tasks/gh-wrapper-auth-routing/archive/prepare-phased-impl-9d32bc8/phase-5.md:1-25`
- `tasks/gh-wrapper-auth-routing/archive/prepare-phased-impl-9d32bc8/phase-6.md:1-25`
- `tasks/gh-wrapper-auth-routing/archive/prepare-phased-impl-9d32bc8/phase-7.md:1-25`
- `tasks/gh-wrapper-auth-routing/archive/prepare-phased-impl-9d32bc8/phase-8.md:1-25`
- `tasks/gh-wrapper-auth-routing/archive/prepare-phased-impl-9d32bc8/phase-plan.md:1-14`
- `tasks/gh-wrapper-auth-routing/complexity-signals.json:1-24`
- `tasks/gh-wrapper-auth-routing/final-phase.md:1-51`
- `tasks/gh-wrapper-auth-routing/lifecycle-state.md:1-4`
- `tasks/gh-wrapper-auth-routing/phase-1.md:1-36`
- `tasks/gh-wrapper-auth-routing/phase-2.md:1-39`
- `tasks/gh-wrapper-auth-routing/phase-3.md:1-34`
- `tasks/gh-wrapper-auth-routing/phase-plan.md:1-14`
- `tasks/gh-wrapper-auth-routing/revalidate-code-review.md:1-130`
- `tasks/gh-wrapper-auth-routing/risk-acceptance.md:1-11`
- `tasks/gh-wrapper-auth-routing/spec.md:1-156`
<!-- REVIEW-CONTEXT END -->

## Findings JSON
```json
[]
```

## Overall Correctness Verdict
- Verdict: patch is correct
- Confidence: 0.91
- Justification: The patch keeps scope limited to the requested wrapper-auth routing surfaces, adds deterministic local checks for ambient fallback and configured-but-unset mappings, and updates the repo-owned rule/guidance surfaces to use the wrappers instead of raw `gh` commands.
