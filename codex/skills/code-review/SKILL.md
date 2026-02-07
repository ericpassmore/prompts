---
name: code-review
description: Produce actionable review findings for a proposed change with exact file/line citations, severity, and correctness verdict.
---

# SKILL: code-review

## Intent

Perform a focused review of code changes for correctness, performance, security, maintainability, and developer experience.

## Scope

- Review only actionable issues introduced by the proposed change.
- Prioritize severe issues.
- Avoid nit-only comments unless they block understanding.

## Reviewer prompt (authoritative)

You are acting as a reviewer for a proposed code change made by another engineer.
Focus on issues that impact correctness, performance, security, maintainability, or developer experience.
Flag only actionable issues introduced by the pull request.
When you flag an issue, provide a short, direct explanation and cite the affected file and line range.
Prioritize severe issues and avoid nit-level comments unless they block understanding of the diff.
After listing findings, produce an overall correctness verdict ("patch is correct" or "patch is incorrect") with a concise justification and a confidence score between 0 and 1.
Ensure that file citations and line numbers are exactly correct using the tools available; if they are incorrect your comments will be rejected.

## Findings schema (authoritative)

```json
{
  "type": "array",
  "items": {
    "type": "object",
    "properties": {
      "file": { "type": "string", "description": "The affected file path" },
      "line_range": { "type": "string", "description": "The affected line range (e.g., '10-25')" },
      "severity": { "type": "string", "enum": ["low", "medium", "high"] },
      "explanation": { "type": "string", "description": "A short, direct explanation of the issue" }
    },
    "required": ["file", "line_range", "severity", "explanation"]
  },
  "description": "A list of actionable code review findings."
}
```

## Diff source policy

- Preferred diff source: `git diff <BASE_BRANCH>...HEAD`, where `<BASE_BRANCH>` comes from `codex-commands.md`.
- Fallback base branch: `main`.
- If the preferred diff errors or is empty, fallback to `git diff`.

## Scripted workflow

Use:

```bash
<CODEX_SCRIPTS_DIR>/revalidate-code-review.sh <TASK_NAME_IN_KEBAB_CASE> [base-branch]
```

This script:

- creates/updates `./tasks/<TASK_NAME_IN_KEBAB_CASE>/revalidate-code-review.md`
- captures diff context and citation candidates
- validates findings status and required review outputs

## Success conditions

- findings are documented with exact file/line citations
- correctness verdict is present
- confidence score in `[0,1]` is present
