# Goals Extract
- Task name: self-improve-skills
- Iteration: v1
- State: locked

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

