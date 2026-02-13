---
name: complexity-scaling
description: Score task complexity deterministically and derive bounded goals/phases using enforceable JSON signals.
---

# SKILL: complexity-scaling

## Purpose

Provide deterministic complexity scoring and bounded recommendations that are resistant to subjective interpretation and easy gaming.

Hard global bounds:

- Goals: `1..20`
- Phases: `1..12`

Executable implementation:

- `codex/scripts/complexity-score.sh`

## Input Schema

Signals are passed as JSON (see `codex/tasks/_templates/complexity-signals.template.json`).

Required keys:

- `scope`: `0|2|4`
- `behavior`: `0|2|4`
- `dependency`: `0|2|4`
- `uncertainty`: `0|2|4`
- `verification`: `0|2|4`
- `evidence.scope`: trimmed non-empty string containing `files=` and `surface=`
- `evidence.behavior`: trimmed non-empty string
- `evidence.dependency`: trimmed non-empty string containing `interfaces=` (or `interfaces=none`)
- `evidence.uncertainty`: trimmed non-empty string
- `evidence.verification`: trimmed non-empty string containing `checks=`
- `evidence.guardrails`: trimmed non-empty string
- `guardrails.no_schema_or_api_contract_change`: boolean
- `guardrails.no_new_external_dependencies`: boolean
- `guardrails.localized_surface`: boolean
- `guardrails.reversible_with_straightforward_verification`: boolean

Optional keys:

- `overrides.goals`: integer `1..20`
- `overrides.phases`: integer `1..12`
- `overrides.reason`: required trimmed non-empty string when any override is set

## Signal Rubric (0/2/4 only)

1. Scope:
- `0`: single file/function
- `2`: multi-file, one subsystem
- `4`: cross-domain or cross-service

2. Behavior:
- `0`: no user-visible change
- `2`: one workflow change
- `4`: broad behavior or contract change

3. Dependency:
- `0`: no interface/dependency changes
- `2`: one interface/dependency touched
- `4`: multiple interfaces coordinated

4. Uncertainty:
- `0`: known implementation pattern
- `2`: partial ambiguity or migration risk
- `4`: high ambiguity or failure-sensitive path

5. Verification:
- `0`: narrow verification in one test area
- `2`: multi-layer validation required
- `4`: full lint/build/test plus integration coverage

## Level Mapping

Total score = sum of five signals (`0..20`).

| Level | Score | Goals range | Phases range |
| --- | --- | --- | --- |
| L1 `surgical` | `0..4` | `1..3` | `1..1` |
| L2 `focused` | `5..8` | `3..5` | `2..4` |
| L3 `multi-surface` | `9..12` | `5..8` | `4..6` |
| L4 `cross-system` | `13..16` | `8..13` | `6..9` |
| L5 `program` | `17..20` | `13..20` | `9..12` |

## Forced L1 Rule (Anti-gaming)

Force L1 only when all guardrails are true:

- `no_schema_or_api_contract_change`
- `no_new_external_dependencies`
- `localized_surface`
- `reversible_with_straightforward_verification`

Consistency gate:

- when forced L1 is active, each signal (`scope`, `behavior`, `dependency`, `uncertainty`, `verification`) must be `<=2`
- if any signal is `4`, the signals file is invalid and must be rejected

## Deterministic Count Formula

1. Midpoint (integer floor):
- goals midpoint = `floor((goals_min + goals_max)/2)`
- phases midpoint = `floor((phases_min + phases_max)/2)`

2. Split adjustments:
- `goals_adjust = (+1 if uncertainty=4) + (+1 if dependency=4) - (1 if uncertainty=0 and dependency=0 and verification=0)`
- `phases_adjust = (+1 if uncertainty=4) + (+1 if dependency=4) + (+1 if verification=4) - (1 if uncertainty=0 and dependency=0 and verification=0)`

3. Base recommendation:
- `base_goals = clamp(goals_midpoint + goals_adjust, goals_min, goals_max)`
- `base_phases = clamp(phases_midpoint + phases_adjust, phases_min, phases_max)`

4. Overrides:
- if provided, `overrides.goals` and `overrides.phases` replace base recommendations
- `overrides.reason` is required whenever either override is provided
- override usage must be surfaced in markdown output with the reason
- reject overrides outside global bounds

## Guardrail Operational Definitions

- `no_schema_or_api_contract_change`:
  - no DB migrations/schema changes
  - no public API signature changes
  - no message format/config schema changes
- `no_new_external_dependencies`:
  - no new external services, packages, or integration points
- `localized_surface`:
  - bounded file surface in one subsystem
  - supported by `evidence.scope` (`files=`, `surface=`)
- `reversible_with_straightforward_verification`:
  - rollback is straightforward
  - validation is bounded and explicit
  - supported by `evidence.verification` (`checks=`)

## Tie-break and Determinism Rules

- Only `{0,2,4}` scores are valid.
- Evidence lines are trimmed before validation.
- Midpoints use integer floor.
- Adjustment rules above are the only permitted modifiers.
- No free-form range nudging is allowed outside formula + overrides.

## Commands

Shell output:

```bash
./codex/scripts/complexity-score.sh ./tasks/<task>/complexity-signals.json --format shell
```

JSON output:

```bash
./codex/scripts/complexity-score.sh ./tasks/<task>/complexity-signals.json --format json
```

Markdown summary:

```bash
./codex/scripts/complexity-score.sh ./tasks/<task>/complexity-signals.json --format markdown
```

## Integration

- Stage 3 scaffolding may pass `@<signals-json-path>` to `prepare-phased-impl-scaffold.sh`.
- Optional Stage 1 validation may pass the same signals file as a third argument to `goals-validate.sh` to enforce level-specific goal ranges.
