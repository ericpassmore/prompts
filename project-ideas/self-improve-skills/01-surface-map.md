# Surface Map

## Actors

- Executing agent: uses centralized skills while working in a task repository and observes failures, workarounds, or waste.
- Triage agent: reviews new issues, normalizes labels, clusters similar incidents, and escalates repeated patterns into parent issues.
- Skill maintainer: approves or implements changes to the centralized skills and rollout rules.

## Core Value Scenarios

### Scenario 1: Obvious Bug Fast Path

An executing agent hits an obvious skill or workflow defect, files an issue immediately in `ericpassmore/prompts` with a minimal repro and severity, then continues the task if safe.

### Scenario 2: Friction Signal Capture

An executing agent notices repeated bash runs, repeated permission escalations for the same command, or a block caused by missing access with no actionable resolution steps, and records the event as a workflow-quality issue rather than silently absorbing the cost.

### Scenario 3: Poor-Fit Skill Invocation

An executing agent discovers that a skill is being applied to work it should reject. The process captures that as an issue first, preserving the evidence needed to later add a rejection gate.

### Scenario 4: Repetition Detection

The triage agent finds multiple incidents with a shared signature and creates or updates a parent issue once the threshold is met.

### Scenario 5: Improvement Delivery

A maintainer or implementation agent converts a parent issue or confirmed defect into a proposed skill change, validates it, and rolls it out with traceable outcomes.

## Domain Objects

- Skill: reusable instructions, scripts, templates, and gates shared across repositories.
- Incident: a concrete observed failure, workaround, inefficiency, or poor-fit invocation.
- Evidence bundle: minimal context attached to an incident, including source repository, skill/stage, repro notes, and observable artifacts.
- Issue: the durable record in `ericpassmore/prompts`.
- Cluster: a grouped set of incidents sharing a failure signature or waste pattern.
- Parent issue: the aggregate improvement problem created once enough evidence accumulates.
- Proposed change: a specific modification to a skill, script, template, rule, or validation path.
- Rollout record: evidence that the change was validated and adopted.

## Integration Boundaries

- Central issue tracker: `ericpassmore/prompts`.
- Source task repositories where agents actually run skills.
- Local task artifacts such as task manifests, lifecycle files, generated plans, and command logs.
- GitHub issues and pull requests used for triage, parent issues, and rollout.

## Data Flows

1. Executing agent observes incident in a task repository.
2. Agent packages a minimum evidence bundle and files an issue in the central repository.
3. Triage agent labels and classifies the issue.
4. Triage agent clusters similar issues and creates or updates a parent issue when threshold conditions are met.
5. Improvement work translates parent issue or confirmed defect into a proposed skill change.
6. Validation confirms the change reduces the targeted failure or waste pattern.
7. Rollout publishes the change and records the expected verification signal.

## External System Interactions

- GitHub issue creation, labeling, linking, and parent issue management.
- GitHub pull request workflow for rolling out skill changes.
- Cross-repository references back to the task repository where the incident occurred.

## Identified Invariants

- Every improvement starts from a concrete issue, even when the eventual fix is process or policy oriented.
- Obvious bugs do not wait for batch analysis before issue creation.
- Source repository, skill name, and stage context remain attached to each incident.
- Parent issues do not replace child incident issues; they aggregate them.
- A proposed change requires validation and rollout evidence before the loop is considered closed.
