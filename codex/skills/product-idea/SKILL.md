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
* Must reduce weighted ambiguity within 2 consecutive cycles
* If not → force decision or declare BLOCKED

Track cycle count in:

```
lifecycle-state.md
```

---

## 3. Ambiguity Scoring System

All ambiguities must be logged in:

```
ambiguity-register.md
```

Each ambiguity includes:

* Category:

  * Domain
  * Technology
  * Regulatory
  * Integration
  * Data
  * Testability
  * Economic
* Scope Impact (1–5)
* Systemic Risk (1–5)
* Regulatory Risk (1–5)
* Breadth (1–5)

### Score Formula

```
Score = Scope × max(Systemic, Regulatory) × Breadth
```

Goal:

* Reduce total weighted ambiguity
  OR
* Replace large ambiguities with smaller bounded ones

Ambiguity must trend downward across cycles.

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
02-regulatory-surface.md
02b-regulatory-evaluation.md (if needed)
03-model-hypotheses.md
04-capabilities.md
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

# Phase 2 — Regulatory Surface Detection (Mandatory)

## Phase 2A — Regulatory Existence

Artifact: `02-regulatory-surface.md`

Determine:

* Jurisdictions involved
* Activity classification
* Is there statutory authority?
* Is there enforcement?
* Are there codified penalties?

Research attempts allowed: max 2.

If no statutory authority found after 2 attempts:

* Conclude: No regulatory surface
* Log assumption
* Assign minimal ambiguity score
* Proceed

If regulatory surface exists:

* Identify economic exposure level:

  * Low
  * Medium
  * High (multi-million revenue or material exposure)

If High → Regulatory ambiguity multiplier = 2×

---

## Phase 2B — Regulatory Evaluation (If YES)

Artifact: `02b-regulatory-evaluation.md`

Must define:

* Regulator(s)
* Statutory references
* Penalty classes
* Compliance obligations
* Reporting cadence
* Audit requirements
* Retention obligations
* Liability chain
* System capability implications

Include:

Recommended Research Sources:

* Official government code databases
* Regulator enforcement guidance
* Industry compliance summaries
* Legal advisory publications

### Gate: Regulatory Sufficiency Gate

Must pass:

* Regulator clearly identified
* Enforcement defined
* Penalties known
* Obligations enumerated
* Ambiguity bounded

Failure → BLOCKED

---

# Phase 3 — Model & Technology Exploration

Technology selection allowed.

Artifact: `03-model-hypotheses.md`

Must include:

* Competing domain models
* Technology stack candidates
* Tradeoff matrix
* Broken assumptions
* Risk surfaces

### Gate: Positive Drift Gate

Must pass:

* Ambiguity reduced
* Assumptions logged
* No silent scope expansion

---

# Phase 4 — Capability Definition

Artifact: `04-capabilities.md`

Each capability must define:

* Input surface
* Output surface
* Invariant
* Failure condition
* Measurable success signal

### Gate: Testability Gate

Must pass:

* All capabilities observable
* Core value scenarios covered
* No untestable behavior
* Ambiguity trending downward

---

# Phase 5 — Tradeoffs & Tension Resolution

Artifact: `05-tradeoffs.md`

Must include:

* Conflicting goals
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

If objective changed → explicit re-baselining required.

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
