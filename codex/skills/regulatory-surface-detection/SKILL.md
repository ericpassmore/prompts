---
name: regulatory-surface-detection
description: Produce deterministic regulatory-surface outputs as a prerequisite input for product-idea refinement.
---

# Regulatory Surface Detection Skill

## Purpose

Run regulatory analysis before `product-idea` and publish deterministic outputs that `product-idea` can gate on.

## Run Order

This skill must run before:

`codex/skills/product-idea/SKILL.md`

## Output Directory (Deterministic)

Write all outputs to:

`project-ideas/<IDEA_NAME>/regulatory/`

## Required Output Contract

* `project-ideas/<IDEA_NAME>/regulatory/regulatory-manifest.md`
* `project-ideas/<IDEA_NAME>/regulatory/02-regulatory-surface.md`
* `project-ideas/<IDEA_NAME>/regulatory/02b-regulatory-evaluation.md` (when surface exists)
* `project-ideas/<IDEA_NAME>/regulatory/regulatory-sources.md`
* `project-ideas/<IDEA_NAME>/regulatory/regulatory-capability-implications.md`

## Manifest Requirements

`regulatory-manifest.md` must include:

* `status`: `SURFACE_FOUND | NO_SURFACE | INCONCLUSIVE | EXCEPTION_APPROVED`
* jurisdictions
* regulator(s)
* confidence level
* `generated_at`
* `expires_at` (RFC 3339 UTC timestamp)
* 2 sentence scope description
* `input_fingerprint` (hash of baseline/problem statement + scope)

Status semantics:

* `SURFACE_FOUND`: regulatory surface exists; `02b-regulatory-evaluation.md` is required.
* `NO_SURFACE`: no regulatory surface identified from available evidence.
* `INCONCLUSIVE`: evidence is insufficient to conclude.
* `EXCEPTION_APPROVED`: bypass accepted through explicit exception documentation. `expires_at` must not exceed exception expiry.

## Required Exception File (Bypass Path)

File:

`project-ideas/<IDEA_NAME>/regulatory/regulatory-exception.md`

Required fields:

* rationale
* scope
* owner
* expiry date
* accepted risks
* mitigation plan

## Workflow

1. Determine whether a regulatory surface exists for current scope and jurisdictions.
2. If surface exists, produce explicit regulator/obligation/penalty analysis.
3. Record source evidence in `regulatory-sources.md`.
4. Translate regulatory conclusions into system implications in `regulatory-capability-implications.md`.
5. Emit `regulatory-manifest.md` with status and fingerprint for downstream gate checks.
6. If analysis is inconclusive and a valid exception exists, set manifest `status` to `EXCEPTION_APPROVED` and reference `regulatory-exception.md`.
7. If inconclusive and no valid exception exists, stop with `BLOCKED`.

## Gate

This skill is complete only when either:

* all required outputs for the status are written, or
* it emits `BLOCKED` with explicit reasons.
