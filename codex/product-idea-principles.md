# Product Refinement Constitution

*(Applies only in Product-Idea Refinement Mode)*

---

## 1. Baseline First

Refinement MUST begin with a documented baseline containing:

* Clear problem statement (actor + pain/opportunity)
* Quantifiable success outcome
* Explicit non-goals

No refinement may proceed without this baseline.

Objectives remain stable unless explicitly re-baselined.

---

## 2. Reduce Ambiguity Scope Every Iteration

Ambiguity must be tracked quantitatively across all phases.

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

* Reduce total weighted ambiguity score
* OR replace one high-score ambiguity with multiple low-score, bounded ambiguities

Each iteration must satisfy one of those conditions.
If not, the iteration is invalid and must:

* force a decision,
* convert uncertainty into an explicit assumption,
* or declare BLOCKED.

Refinement without weighted ambiguity reduction or bounded decomposition is drift.

---

## 3. Positive Drift Only

Model evolution is permitted only if it:

* increases clarity,
* improves feasibility,
* strengthens testability,
* reduces risk,
* or better satisfies the quantified success outcome.

Refinement may reshape the solution.
It may not silently reshape the objective.

After each iteration, audit alignment to the original baseline.

---

## 4. Assumptions Are Fluid; Objectives Are Stable

Assumptions are expected to change and must be explicitly logged.

Objectives may change only through explicit re-baselining with:

* documented rationale,
* updated success metric,
* and acknowledgment of prior objective retirement.

Silent objective drift is prohibited.

---

## 5. Resolve Tension Explicitly

When goals or constraints are in tension:

* the conflict must be documented,
* prioritization must be declared,
* and the chosen tradeoff must be justified.

Unresolved tension is misalignment.

---

## 6. Durable Documentation Is Mandatory

No reasoning may remain transient.

After each refinement session:

* Log changes.
* Log broken assumptions.
* Log decisions and alternatives considered.
* Re-state baseline and confirm alignment.

If the alignment audit fails, refinement must pause.

---

# Why This Is Consistent With Your Execution Doctrine

Execution Mode enforces:

* Lock goals before action
* Minimal change
* Drift hard gates
* Verification before done

Refinement Mode enforces:

* Baseline stability
* Ambiguity reduction
* Positive drift discipline
* Assumption hygiene
* Explicit tradeoffs
* Persistent state

Execution optimizes implementation.
Refinement optimizes problem clarity.

They do not conflict. They govern different phases.

