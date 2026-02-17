---
name: product-idea
description: Structured refinement workflow for large, undefined product initiatives requiring ambiguity reduction before goal lock.
---

# Product Idea Refinement Skill

## Purpose

Transform a high-level product idea into a goal-lock-ready specification by:

* Reducing ambiguity
* Preventing premature commitment
* Detecting regulatory exposure
* Enforcing positive drift
* Producing durable artifacts

This skill precedes `establish-goals`.

Exit condition:

```
READY FOR GOAL LOCK
```

---

# Global Rules

## 1. No Implementation

During this skill:

* No code changes
* No implementation planning
* No irreversible architecture commitment
* No schema locking
* No vendor commitment

---

## 2. Refinement Loop Budget

* Maximum total refinement cycles: 20
* Each iteration must satisfy the ambiguity system requirements in Section 3
* If not -> force decision, convert uncertainty into an explicit assumption, or declare BLOCKED

Track cycle count in:

```
lifecycle-state.md
```

---

## 3. Ambiguity System (Global to All Phases)

Ambiguity must be tracked quantitatively.

All ambiguities must be logged in:

```
ambiguity-register.md
```

### Ambiguity Record Format

Each ambiguity must include:

* Category:

  * Domain
  * Technology
  * Regulatory
  * Integration
  * Data model
  * Testability
* Scope Impact (1-5)
* Systemic Risk (1-5)
* Regulatory Risk (1-5)
* Breadth of Surface (1-5)

### Ambiguity Score

Ambiguity Score = Scope x max(Systemic, Regulatory) x Breadth

The goal is not fewer ambiguities.
The goal is:

* Replace large, high-impact ambiguities with smaller, bounded ambiguities.

Each iteration must:

* Reduce total weighted ambiguity score
* OR
* Replace one high-score ambiguity with multiple low-score ambiguities.

---

## 4. Per-Iteration Baseline Alignment Gate

After each refinement iteration, audit alignment to the original baseline.

Minimum alignment check:

* Actor unchanged?
* Success metric unchanged?
* Scope unchanged?

If the alignment audit fails, refinement must pause.

If objective change is intentional, explicit re-baselining is required with:

* documented rationale
* updated success metric
* acknowledgment of prior objective retirement

Silent objective drift is prohibited.

---

## 5. Regulatory Prerequisite Check (Run At Skill Start)

`regulatory-surface-detection` must run before this skill.

At skill start, product-idea must scan:

```
project-ideas/<IDEA_NAME>/regulatory/
```

If required regulatory outputs are missing, inconclusive without exception, or stale, this skill is immediately `BLOCKED`.

---

# Artifact Structure

All artifacts stored under:

```
project-ideas/<IDEA_NAME>/
```

Required files:

```
00-baseline.md
01-surface-map.md
regulatory/regulatory-manifest.md
regulatory/02-regulatory-surface.md
regulatory/02b-regulatory-evaluation.md (when surface exists)
regulatory/regulatory-sources.md
regulatory/regulatory-capability-implications.md
regulatory/regulatory-exception.md (when bypass is used)
03a-model-exploration.md
03b-phase4-handoff.md
04a-capability-inventory.md
04b-objective-mapping.md
04b-capability-objective-matrix.csv (optional)
05-tradeoffs.md
06-phase-model.md
07-drift-audit.md
ambiguity-register.md
decision-log.md
lifecycle-state.md
```

---

# Phase 0 — Baseline Definition

## Artifact: 00-baseline.md

Must define:

* Problem statement (actor + pain/opportunity)
* Quantified success metric
* Non-goals
* Known constraints
* Initial ambiguity register

### Gate: Baseline Gate

Must pass:

* Success measurable
* Non-goals defined
* Ambiguities scored

---

# Phase 1 — Surface Mapping

## Artifact: 01-surface-map.md

Must define:

* Actors
* Core value scenarios
* Domain objects
* Integration boundaries
* Data flows
* External system interactions
* Identified invariants

Ambiguity register updated.

### Gate: Surface Integrity Gate

Must pass:

* No undefined surfaces
* Ambiguity reduced or decomposed
* No silent scope expansion

---

# Phase 2 — Regulatory Prerequisite Intake (Mandatory)

Regulatory analysis is produced by `regulatory-surface-detection` before this skill runs.

Read outputs only from:

`project-ideas/<IDEA_NAME>/regulatory/`

Required output contract:

* `project-ideas/<IDEA_NAME>/regulatory/regulatory-manifest.md`
* `project-ideas/<IDEA_NAME>/regulatory/02-regulatory-surface.md`
* `project-ideas/<IDEA_NAME>/regulatory/02b-regulatory-evaluation.md` (when surface exists)
* `project-ideas/<IDEA_NAME>/regulatory/regulatory-sources.md`
* `project-ideas/<IDEA_NAME>/regulatory/regulatory-capability-implications.md`

Manifest must include:

* `status`: `SURFACE_FOUND | NO_SURFACE | INCONCLUSIVE | EXCEPTION_APPROVED`
* jurisdictions
* regulator(s)
* confidence level
* `generated_at`
* `expires_at` (RFC 3339 UTC timestamp)
* 2 sentence scope description
* input fingerprint (hash of baseline/problem statement + scope)

Blocking rule:

* If manifest missing: `BLOCKED`
* If manifest `INCONCLUSIVE` and no valid exception: `BLOCKED`
* If manifest is stale (`input fingerprint` mismatch or current time >= `expires_at`): `BLOCKED`
* If exception exists and is valid: continue with explicit risk flag

Exception file for bypass:

* `project-ideas/<IDEA_NAME>/regulatory/regulatory-exception.md`

Exception must include:

* rationale
* scope
* owner
* expiry date
* accepted risks
* mitigation plan

### Gate: Regulatory Intake Gate

Must pass:

* Output contract present and readable from the deterministic regulatory path
* Manifest status is valid for progression (`SURFACE_FOUND | NO_SURFACE | EXCEPTION_APPROVED`)
* Manifest fingerprint matches current baseline/problem statement + scope
* Lightweight drift check passes (`generated_at`, `expires_at`, `status`, and 2 sentence scope description present and current)
* If exception is used, explicit risk flag recorded in `decision-log.md`

---

# Phase 3A — Model & Technology Exploration for Pragmatic Clarity

Artifact: `03a-model-exploration.md`

Purpose:

* Use technology exploration to inform a pragmatic approach.
* Rethink overly ambiguous framing before capability mapping starts.

Technology selection is exploratory at this stage and must remain reversible.

Must include:

* Competing domain models
* Technology stack candidates
* Tradeoff matrix
* Broken assumptions
* Risk surfaces
* Notes on ambiguity reduction or decomposition from exploration outcomes

### Gate: Pragmatic Exploration Gate

Must pass:

* Ambiguity reduced or decomposed with explicit evidence
* Assumptions logged
* No silent scope expansion
* No irreversible commitment introduced

---

# Phase 3B — Explicit Phase 4 Handoff

Artifact: `03b-phase4-handoff.md`

Purpose:

* Convert model exploration into explicit inputs for Phase 4A and Phase 4B.

Must include:

* Translation of each model candidate into capability implications
* Model impact expression on four objective axes:
  * Workflow Explicitness
  * Economic Posture
  * Technology Complexity
  * Cultural Specificity
* Candidate recommendation status per model option: carry-forward or prune
* Rationale for each carry-forward or prune decision

Prune/carry-forward rule:

* A model candidate may be pruned only with explicit rationale tied to objective fit, risk, or feasibility.
* At least one carry-forward candidate must remain to seed Phase 4 artifacts.
* Pruned candidates must retain a brief risk note to avoid repeating invalid paths.

### Gate: Handoff Readiness Gate

Must pass:

* Every model candidate translated into capability implications
* Every model candidate expressed against the four objective axes
* Carry-forward/prune decisions are explicit and justified
* Phase 4 inputs are complete and actionable

---

# Phase 4A — Capability Inventory

Artifact: `04a-capability-inventory.md`

Purpose:

* Establish a complete, reviewable capability inventory before objective scoring.

Required inputs:

* Baseline objective set and success metrics
* Latest ambiguity register
* Surface map and core value scenarios
* Regulatory prerequisite outputs from `project-ideas/<IDEA_NAME>/regulatory/`, or valid exception with explicit risk flag

For each capability, define a capability card:

* capability_id
* Actor and journey step
* Input surface
* Output surface
* Invariant
* Failure condition
* Success signal
* Estimated implementation weight (S/M/L)

### Gate: Capability Coverage Gate

Must pass:

* Core value scenarios are covered by named capabilities
* Capability IDs are unique and stable for downstream mapping
* Every capability has observable success and explicit failure condition
* No high-risk surface remains uncataloged

---

# Phase 4B — Objective Mapping and Axis Vector Scoring

Artifact: `04b-objective-mapping.md`

Optional companion artifact: `04b-capability-objective-matrix.csv`

Purpose:

* Map inventoried capabilities to objectives and quantify support/conflict before Phase 5.

For each objective, define an objective card:

* objective_id
* Desired outcome (one sentence)
* Success measurements (2-3 measurable KPIs)
* Axis vector:
  * Workflow Explicitness (-2 to +2)
  * Economic Posture (-2 to +2)
  * Technology Complexity (-2 to +2)
  * Cultural Specificity (-2 to +2)
* Force (1-5)
* Non-negotiable flag (yes/no)

For each capability, record objective mapping fields:

* Objective links (supports/conflicts/neutral per objective_id)
* Axis effect vector on the same four axes (-2 to +2)
* support_score per mapped objective (-2 to +2)
* Weighted contribution: support_score x objective_force

Mapping method:

* Score each capability against each mapped objective with support_score (-2 to +2).
* Compute weighted contribution: support_score x objective_force.
* Flag cross-purpose candidates where one capability strongly supports one objective and strongly conflicts with another in overlapping scope.
* Record option per flagged candidate: keep, split, defer, or redesign.

Outputs to Phase 5:

* Ranked conflict list (capability_id, objective pair, rationale)
* Objective-capability matrix with weighted contributions
* Proposed structural splits (default flow vs exception flow, locale split, or scale split)
* Decision candidates with risk and KPI impact

### Gate: Mapping Sufficiency Gate

Must pass:

* Every objective maps to one or more capabilities
* Every core capability maps to one or more objectives
* High-tension pairs have explicit options and decision path
* Non-negotiable objectives preserved across candidate paths
* No unmapped high-risk capability remains

---

# Phase 5 — Tradeoffs & Tension Resolution

Artifact: `05-tradeoffs.md`

### Objective Tension Taxonomy (Reusable)

For each objective, define an objective card:

* Desired outcome (one sentence)
* Success measurements (2-3 measurable KPIs)
* Primary axis: Workflow Explicitness (-2 to +2)
* Secondary axes:
  * Economic Posture (-2 low-cost/access to +2 resilience/compliance at higher cost)
  * Technology Complexity (-2 simple stack to +2 distributed/high-scale architecture)
  * Cultural Specificity (-2 uniform global behavior to +2 locale-specific behavior/rules)
* Force (1-5): how strongly this objective pushes design
* Scope overlap (0-1): actor/journey/market overlap with compared objective

Cross-purpose tension exists when primary-axis directions oppose and both objectives have non-trivial force in overlapping scope.

Use this comparison score:

Tension Score = sum(axis_weight x abs(delta_per_axis)) x scope_overlap x min(force_a, force_b)

Higher score means explicit prioritization and structural split are required.

Must include:

* Conflicting objectives and constraints
* Objective cards for each conflicting objective
* Cross-purpose assessment on primary and secondary axes
* Tension Score and rationale
* Priority decision
* Justification
* Risk impact

### Gate: Consistency Gate

Must pass:

* Tensions resolved
* Success metric unchanged
* No contradictory priorities

---

# Phase 6 — Phase Model

Artifact: `06-phase-model.md`

Must define:

* Phase boundaries
* Risk reduction per phase
* Verification points
* Revalidation checkpoints

(No economic model required.)

### Gate: Feasibility Gate

Must pass:

* Phase 1 reduces largest ambiguity cluster
* Each phase independently verifiable
* No irreversible commitments embedded

---

# Phase 7 — Drift Audit

Artifact: `07-drift-audit.md`

Must include:

* Restated baseline
* Summary of changes
* Ambiguity score delta
* Alignment check:

  * Actor unchanged?
  * Success metric unchanged?
  * Scope unchanged?

If objective changed -> explicit re-baselining is required with:

* documented rationale
* updated success metric
* acknowledgment of prior objective retirement

---

# Final Gate — Goal Lock Readiness

Must pass:

* Ambiguity reduced to bounded level
* Remaining ambiguities small and documented
* Capabilities testable
* Regulatory evaluation complete
* Tensions resolved
* Phase model defined
* Drift audit passed

Emit:

```
READY FOR GOAL LOCK
```

Then transition to `establish-goals`.

---

# Behavioral Requirements

* Assumptions must be logged when changed
* Broken assumptions must be recorded
* Every iteration must update ambiguity register
* No reasoning remains transient
* Misalignment is treated as failure

---

# Summary

This skill enforces:

* Positive drift
* Quantified ambiguity reduction
* Proportionate regulatory rigor
* Bounded exploration
* Durable documentation
* Structured exit to goal lock
