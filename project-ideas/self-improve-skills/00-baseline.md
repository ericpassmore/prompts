# Baseline

## Problem Statement

Agents using centralized skills across repositories encounter defects, workarounds, poor-fit skill calls, and repeated low-value steps, but those failures are not captured early enough or consistently enough to reduce future rework.

## Quantified Success Metric

Primary success metric:

- Reduce rework in skill-driven task execution, measured by:
- lower rate of goals modified after the implementation stage starts
- lower rate of goal drift detected after goals are locked
- lower count of repeat tasks with materially similar goals that indicate successive attempts without closure

Secondary success metric:

- Reduce median time from goals locked to GitHub pull request creation for tasks using the improved skills.

## Non-Goals

- Do not redesign the entire skill framework in one pass.
- Do not require perfect root-cause analysis before filing an issue.
- Do not introduce heavyweight telemetry or mandatory infrastructure outside what agents can already observe.
- Do not centralize all remediation into one massive umbrella issue without preserving concrete incident records.
- Do not block ongoing task execution when an issue can be filed and work can continue safely.

## Known Constraints

- Skills are centralized resources used by agents operating in other repositories.
- Improvement signals must be captured in `ericpassmore/prompts` even when incidents originate elsewhere.
- Obvious bugs need a straightforward fast path.
- Poor-fit skill execution should first result in issue capture, with rejection logic added later from evidence.
- Evidence intake must be small enough that agents actually use it.

## Initial Ambiguity Register Summary

- The minimum evidence bundle is not fully specified.
- The exact threshold for clustering and parent-issue action is not user-specified.
- The eventual implementation surface is not locked beyond needing a process that can later translate into repository artifacts and automation.
