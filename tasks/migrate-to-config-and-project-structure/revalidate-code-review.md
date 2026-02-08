# Revalidate Code Review
- Task name: migrate-to-config-and-project-structure
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
- Generated at: 2026-02-08T05:06:36Z
- Base branch: main
- Diff mode: fallback
- Diff command: `git diff`
- Diff bytes: 26097

### Changed files
- `codex/AGENTS.md`
- `codex/codex-commands.md`
- `codex/prompts/expand-task-spec.md`
- `codex/scripts/prepare-takeoff-bootstrap.sh`
- `codex/scripts/read-codex-paths.sh`
- `codex/scripts/resolve-codex-root.sh`
- `codex/scripts/revalidate-code-review.sh`
- `codex/skills/code-review/SKILL.md`
- `codex/skills/implement/SKILL.md`
- `codex/skills/land-the-plan/SKILL.md`
- `codex/skills/prepare-phased-impl/SKILL.md`
- `codex/skills/prepare-takeoff/SKILL.md`
- `codex/skills/revalidate/SKILL.md`
- `codex/tasks/_templates/final-phase.template.md`
- `codex/tasks/_templates/spec.template.md`

### Citation candidates (verify before use)
- `codex/AGENTS.md:55-55`
- `codex/AGENTS.md:85-85`
- `codex/codex-commands.md:0-0`
- `codex/prompts/expand-task-spec.md:25-30`
- `codex/prompts/expand-task-spec.md:52-52`
- `codex/scripts/prepare-takeoff-bootstrap.sh:101-102`
- `codex/scripts/prepare-takeoff-bootstrap.sh:12-15`
- `codex/scripts/prepare-takeoff-bootstrap.sh:17-25`
- `codex/scripts/prepare-takeoff-bootstrap.sh:27-27`
- `codex/scripts/prepare-takeoff-bootstrap.sh:30-32`
- `codex/scripts/prepare-takeoff-bootstrap.sh:34-35`
- `codex/scripts/prepare-takeoff-bootstrap.sh:40-41`
- `codex/scripts/prepare-takeoff-bootstrap.sh:45-45`
- `codex/scripts/prepare-takeoff-bootstrap.sh:49-49`
- `codex/scripts/prepare-takeoff-bootstrap.sh:52-57`
- `codex/scripts/prepare-takeoff-bootstrap.sh:63-63`
- `codex/scripts/prepare-takeoff-bootstrap.sh:66-66`
- `codex/scripts/prepare-takeoff-bootstrap.sh:68-68`
- `codex/scripts/prepare-takeoff-bootstrap.sh:74-76`
- `codex/scripts/prepare-takeoff-bootstrap.sh:79-80`
- `codex/scripts/prepare-takeoff-bootstrap.sh:82-82`
- `codex/scripts/prepare-takeoff-bootstrap.sh:86-87`
- `codex/scripts/prepare-takeoff-bootstrap.sh:9-10`
- `codex/scripts/prepare-takeoff-bootstrap.sh:91-95`
- `codex/scripts/prepare-takeoff-bootstrap.sh:97-97`
- `codex/scripts/read-codex-paths.sh:12-17`
- `codex/scripts/read-codex-paths.sh:19-20`
- `codex/scripts/read-codex-paths.sh:25-41`
- `codex/scripts/read-codex-paths.sh:46-46`
- `codex/scripts/read-codex-paths.sh:48-49`
- `codex/scripts/read-codex-paths.sh:52-52`
- `codex/scripts/read-codex-paths.sh:57-57`
- `codex/scripts/read-codex-paths.sh:6-7`
- `codex/scripts/resolve-codex-root.sh:12-12`
- `codex/scripts/revalidate-code-review.sh:42-43`
- `codex/scripts/revalidate-code-review.sh:54-83`
- `codex/scripts/revalidate-code-review.sh:9-12`
- `codex/skills/code-review/SKILL.md:49-49`
- `codex/skills/implement/SKILL.md:137-137`
- `codex/skills/implement/SKILL.md:22-22`
- `codex/skills/implement/SKILL.md:46-46`
- `codex/skills/land-the-plan/SKILL.md:181-181`
- `codex/skills/land-the-plan/SKILL.md:35-35`
- `codex/skills/land-the-plan/SKILL.md:51-52`
- `codex/skills/prepare-phased-impl/SKILL.md:41-41`
- `codex/skills/prepare-takeoff/SKILL.md:103-103`
- `codex/skills/prepare-takeoff/SKILL.md:19-19`
- `codex/skills/prepare-takeoff/SKILL.md:196-197`
- `codex/skills/prepare-takeoff/SKILL.md:212-212`
- `codex/skills/prepare-takeoff/SKILL.md:216-216`
- `codex/skills/prepare-takeoff/SKILL.md:220-220`
- `codex/skills/prepare-takeoff/SKILL.md:45-48`
- `codex/skills/prepare-takeoff/SKILL.md:51-51`
- `codex/skills/prepare-takeoff/SKILL.md:70-70`
- `codex/skills/revalidate/SKILL.md:123-123`
- `codex/skills/revalidate/SKILL.md:42-42`
- `codex/skills/revalidate/SKILL.md:97-97`
- `codex/tasks/_templates/final-phase.template.md:42-42`
- `codex/tasks/_templates/spec.template.md:38-38`
<!-- REVIEW-CONTEXT END -->

## Findings JSON
```json
[]
```

## Overall Correctness Verdict
- Verdict: patch is correct
- Confidence: 0.86
- Justification: No actionable correctness, security, or maintainability regressions were identified in the migration diff; staged behavior remains consistent with the locked goals and lifecycle constraints.
