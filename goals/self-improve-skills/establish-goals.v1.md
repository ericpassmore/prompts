# establish-goals

## Status

- Iteration: v1
- State: locked
- Task name (proposed, kebab-case): self-improve-skills

## Request restatement

- Develop a concrete process for refining and improving centralized skills used by agents across repositories.
- Start the improvement loop with GitHub issue capture in `ericpassmore/prompts`, especially for obvious bugs, confirmed defects, repeated bash runs, repeated permission escalations for the same command, and blocks caused by lack of access without actionable resolution steps.
- Ensure the process includes straightforward handling for obvious issues, automated triage and clustering, and a full path from issue to skill change, validation, and rollout.
- Include the rule change needed to allow `gh issue create` against `ericpassmore/prompts`.

## Context considered

- Repo/rules/skills consulted: `codex/AGENTS.md`, `codex/codex-config.yaml`, `$product-idea` skill, `$regulatory-surface-detection` skill, `$establish-goals` skill, `$complexity-scaling` skill
- Relevant files (if any): `project-ideas/self-improve-skills/*`, especially `00-baseline.md`, `01-surface-map.md`, `04a-capability-inventory.md`, `04b-objective-mapping.md`, `06-phase-model.md`, and regulatory intake outputs under `project-ideas/self-improve-skills/regulatory/`
- Constraints (sandbox, commands, policy): stage order is mandatory; goal lock must occur before planning or implementation; establish-goals artifacts must be script-backed; the skills are centralized but improvement evidence is recorded in `ericpassmore/prompts`; first-rollout operation must be able to create issues in the central repository

## Ambiguities

### Blocking (must resolve)

1. None identified.

### Non-blocking (can proceed with explicit assumptions)

1. The user did not choose a final packaging surface, so the first implementation should default to repository-local process assets in `ericpassmore/prompts` rather than immediately becoming a new reusable skill.
2. The exact clustering threshold was not specified beyond "enough evidence has accumulated", so the initial implementation may use the bounded default established during idea refinement and make that threshold adjustable later.

## Questions for user

1. Please confirm these revised goals so I can lock them and hand off to `prepare-takeoff`.

## Assumptions (explicit; remove when confirmed)

1. The first implementation will land as repository-local process documentation plus supporting issue-management assets in `ericpassmore/prompts`, with later promotion to a reusable skill only if that proves necessary.
2. A minimal evidence bundle is sufficient for initial issue filing: source repository, skill or stage, incident type, short repro or observation, and any directly relevant task artifact references.
3. Parent issue escalation can start with a deterministic default threshold and be refined later from observed clustering quality.
4. Allowing `gh issue create` for `ericpassmore/prompts` is treated as in-scope operational enablement for the issue-first process.

## Goals (1-20, verifiable)

1. Define a repository-local process specification for skill improvement that requires every concrete skill or workflow incident to begin with a GitHub issue in `ericpassmore/prompts`.
2. Define explicit issue-intake triggers and minimum required issue fields for at least these cases: obvious bugs, confirmed defects, repeated bash runs, repeated permission escalations for the same command, blocks caused by lack of access without actionable resolution steps, and poor-fit skill invocation.
3. Define a fast-path workflow for obvious bugs and confirmed defects that files an issue immediately with minimal repro and severity guidance, while allowing work to continue when safe.
4. Define an automated triage and clustering process that classifies child issues, preserves cross-repository provenance, and creates or updates parent issues only after a stated evidence threshold is met.
5. Define an end-to-end improvement loop from issue capture to proposed skill change, validation, and rollout, with clear ownership and expected verification evidence at each transition.
6. Define the primary and secondary process metrics so rework reduction is measurable, including late goal changes, post-lock drift, repeated similar tasks, and a secondary goals-to-PR timing metric.
7. Deliver the process in durable repository assets that are sufficient for downstream implementation and use, without requiring heavyweight telemetry or cross-repository infrastructure before first rollout.
8. Update the relevant local rules or command-approval configuration so `["gh", "issue", "create"]` is allowed for creating issues in `ericpassmore/prompts` as part of the process.

## Non-goals (explicit exclusions)

- Building a telemetry-heavy analytics platform before the basic issue-first process exists.
- Redesigning the entire skill framework or changing lifecycle stage contracts unrelated to this process.
- Adding rejection logic to every poor-fit skill path before incident evidence has been captured.

## Success criteria (objective checks)

> Tie each criterion to a goal number when possible.

- [G1] A durable process artifact exists in the repository and states that concrete skill/process incidents begin with issue capture in `ericpassmore/prompts`.
- [G2] The process names the required intake triggers and minimum issue fields for each required incident class.
- [G3] The process includes an explicit fast path for obvious bugs and confirmed defects, including immediate filing expectations and continue-if-safe guidance.
- [G4] The process defines child issue triage, clustering rules, provenance requirements, and parent-issue escalation conditions.
- [G5] The process defines a traceable path from issue to proposed change to validation to rollout, with named evidence expectations.
- [G6] The process defines objective metrics for rework reduction and secondary throughput measurement.
- [G7] The chosen first-rollout assets are bounded, repository-local, and do not depend on heavyweight new infrastructure.
- [G8] The repository rules or approval configuration explicitly permit `gh issue create` use for `ericpassmore/prompts`, and the change is documented in the delivered process assets.

## Risks / tradeoffs

- If the initial process assets are too lightweight, agents may file low-signal issues; mitigation is to keep the intake minimal but put normalization and clustering in the triage layer.
- If the initial scope tries to solve packaging, automation, and cross-repository reuse all at once, implementation may sprawl; mitigation is to keep the first rollout repository-local and evidence-driven.
- Expanding command permission scope can be over-broad if not documented narrowly; mitigation is to scope the change specifically to the required GitHub issue creation workflow.

## Next action

- Goals approved and locked; proceed to `prepare-takeoff`.
- Handoff: `prepare-takeoff` owns task scaffolding and `spec.md` readiness content.
