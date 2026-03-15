# Input Distillation

## Input Corpus Index

- Considered: direct user request in this thread to use `$product-idea` for a process that refines and improves centralized skills.
- Considered: follow-up clarifications defining actor, success metrics, issue triggers, fast-path bug handling, clustering expectations, and improvement rollout expectations.
- Ignored: the example list as goal statements. The user explicitly marked those examples as context rather than locked goals.
- No external conversation corpus directory was used. `docs/idea/self-improve-skills/` does not exist in this repository.

## Extracted Candidate Objectives

- Create a repeatable process that captures skill and workflow failures as GitHub issues in `ericpassmore/prompts`.
- Make issue capture immediate and low-friction for obvious bugs, confirmed defects, repeated bash runs, repeated permission escalations for the same command, and blocks caused by missing access without actionable resolution steps.
- Reduce rework in downstream task execution by improving skills earlier and more systematically.
- Add an automated triage and clustering loop that groups repeated incidents, prioritizes them, and opens parent issues once evidence crosses a defined threshold.
- Define a path from issue capture to proposed skill change, validation, and rollout.

## Extracted Candidate Constraints And Non-Goals

- The process serves any agent using these centralized skills across multiple repositories, not only one local repository.
- The central issue tracker remains `ericpassmore/prompts` even when incidents originate in other repositories.
- Fast-path capture matters more than perfect first-pass analysis for obvious bugs.
- Poor-fit skill invocation should file an issue first before adding rejection logic.
- Full evidence collection requirements are not yet known and must be scoped to avoid high-friction intake.

## Extracted Scenarios And Assumptions

- Scenario: an agent works around a broken script or template mismatch and should file an issue before the workaround becomes normal behavior.
- Scenario: an agent repeats bash script runs or permission escalations because the workflow is underspecified or brittle.
- Scenario: a skill is invoked for work it should reject, such as using `implement` for regulatory fit.
- Scenario: multiple issues with similar signatures accumulate across repositories and need clustering into a parent problem.
- Assumption: default evidence can start from agent-visible artifacts without requiring full telemetry infrastructure.
- Assumption: parent-issue action thresholds can be defined operationally even before historical metrics exist.

## Extracted Risks And Unresolved Questions

- Evidence collection can become too heavy and discourage issue filing if the minimum payload is not small.
- Automated clustering can produce noisy parent issues if signatures are too broad.
- Cross-repository provenance must be retained or the central issue tracker will lose context.
- Open question resolved by assumption: preferred output surface was unspecified, so the idea should be capable of later landing as a repo process document plus supporting GitHub workflow assets.

## Signal-To-Noise Summary And Confidence Notes

- High-confidence signals: issue-first intake, fast-path bug handling, automated triage, clustering, parent issues, and rollout path.
- Medium-confidence signals: default evidence bundle and exact clustering thresholds. These need pragmatic initial defaults with later tuning.
- Low-confidence signals: the final packaging format of the process. Treat packaging as a later implementation choice, not a baseline objective.
