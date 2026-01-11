---
name: expand-task-spec
description: Expand a short change request into a full spec, phased plan, and phased implementation with gates, verification, and code review.
---

# Purpose

Convert a short description of desired modifications into:
1) a complete product specification
2) a phased execution plan with gates
3) implementation executed phase-by-phase with verification, lint/build/test, and code review

This skill produces artifacts under `/tasks/<task-name>/` and implements changes in the codebase.

# Inputs expected from user

- A short list of desired changes (bullet points are fine)
- (Optional) constraints: backwards compatibility, performance, security, rollout expectations
- (Optional) target surfaces: API routes, UI pages, DB schema, background jobs, CLI
- (Optional) acceptance criteria if already known

If the user does not provide a task name, derive one (kebab-case) from the request.

# Output artifacts (mandatory)

Create these files:

1) `/tasks/<task-name>/spec.md`
2) `/tasks/<task-name>/phase-1.md`
3) `/tasks/<task-name>/phase-2.md`
4) `/tasks/<task-name>/phase-3.md`
5) `/tasks/<task-name>/phase-4.md` (only if needed)
6) `/tasks/<task-name>/final-phase.md`

# Toolchain discovery (mandatory)

Before writing specs or making code changes, determine the toolchain and commands.

## Step A — Identify stack

1) If any of these exist, treat as Node/TS:
   - `package.json`
   - `bun.lockb`, `package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`
   - `vite.config.*`, `svelte.config.*`, `vitest.config.*`
   - `tsconfig.json`

2) If any of these exist, treat as Python:
   - `pyproject.toml`
   - `uv.lock`
   - `.python-version`

3) If both Node and Python exist, treat as polyrepo/monorepo:
   - Determine primary target by the user request (UI/API vs data/agent pipeline), and document the decision in the spec.

## Step B — Determine package runner (Node only)

- If `bun.lockb` exists, prefer `bun` (unless repo docs mandate npm).
- Else prefer `npm`.

Record chosen runner in `/tasks/<task-name>/spec.md` under “Build & Tooling”.

## Step C — Determine canonical commands

### Node/TS command selection (prefer scripts when present)

Read `package.json` scripts. Choose commands in this order:

- Lint:
  1) `bun run lint` / `npm run lint` if script exists
  2) else `bun run check` / `npm run check` if script exists
  3) else mark lint as “not configured” and propose adding it in Final Phase

- Build:
  1) `bun run build` / `npm run build` if script exists
  2) else (SvelteKit): `bun run build` / `npm run build` is still standard; if missing, document and propose adding

- Tests:
  1) `bun run test` / `npm test` / `npm run test` if script exists
  2) else if `vitest` is present and no script exists, propose adding `test` script using `vitest run` in Final Phase
  3) never invent a test runner other than Vitest unless repo indicates otherwise

### Python command selection (uv-first)

- Sync/install:
  - `uv sync`

- Lint/format:
  Prefer project-defined tasks in docs; otherwise:
  - If `ruff` is configured in `pyproject.toml`: `uv run ruff check .`
  - If `ruff format` configured: `uv run ruff format .`
  - If `black` configured: `uv run black .`
  If none are configured: document “lint not configured” and propose adding in Final Phase.

- Tests:
  - If `pytest` is configured: `uv run pytest -q`
  - If no test runner configured: document and propose adding in Final Phase.

Record chosen commands in `/tasks/<task-name>/spec.md` under “Verification Commands”.

# Working approach (mandatory, in order)

## Step 0 — Initial code reconnaissance + clarifying questions

1) Identify entry points and relevant modules/files:
   - For SvelteKit: `src/routes`, `src/lib`, hooks, endpoints, server routes.
   - For Express: server entry, routers, middleware, DB access layer.
   - For Python: `src/`, package modules, CLI entry points, pipelines, mem0 config.
   - For Postgres: migrations folder, schema tooling, query layer.

2) Ask clarifying questions BEFORE writing the spec if any are unclear:
   - Intended user-facing behavior (exactly what changes)
   - Acceptance criteria (testable statements)
   - Out-of-scope items
   - Backwards compatibility / migration expectations
   - Security/privacy constraints (PII, tokens, env variables)
   - Performance constraints (e.g. query latency, batch sizes)
   - Operational concerns (rollout, feature flag, migration strategy)

3) After user answers, inspect more code as needed to resolve scope and design decisions.

## Step 1 — Write `/tasks/<task-name>/spec.md`

The spec must include:

- Overview
- Goals
- Non-goals
- Use cases / user stories
- Current behavior (as implemented today; cite key files/functions)
- Proposed behavior (clear, testable)
- Technical design
  - Node/TS: modules impacted, API routes, UI pages/components, error handling, type changes
  - Python: modules impacted, data flow, mem0 integration points, polars pipelines, error handling
- Data model / schema changes (Postgres)
  - tables/columns/indexes, migration plan, backward compatibility
- Security & privacy considerations
- Observability considerations (logging/metrics where relevant)
- Verification commands (from toolchain discovery)
- Test strategy (unit/integration/e2e) with concrete targets
- Acceptance criteria checklist (explicit, verifiable)

## Step 2 — Write phased plans `/tasks/<task-name>/phase-<n>.md`

Split work into 1–4 phases. Each phase file must include:

- Objective
- Code areas impacted (paths, modules)
- Work items (bulleted, implementable)
- Deliverables (what will exist after phase)
- Gate (objective pass/fail criteria)
- Verification steps (exact commands, expected outcomes)
- Risks and mitigations

Phasing guidance:

- Phase 1: scaffolding + tests + interfaces + migrations scaffolds (low risk)
- Phase 2: core implementation
- Phase 3: integration (UI/API/DB wiring; cross-module)
- Phase 4 (optional): hardening/perf/edge cases/cleanup

## Step 3 — Write `/tasks/<task-name>/final-phase.md`

Must include:

- Documentation updates (README, ADRs, usage docs, in-code docstrings)
- Final testing tasks and missing coverage items
- Required verification commands (lint/build/test) and expected results
- Manual QA steps (if applicable)
- Code review checklist (security, correctness, performance, maintainability)
- Release/rollout notes (if applicable)

## Step 4 — Execute work phase-by-phase

For each phase in order:

1) Implement the phase work items.
2) Run the phase verification steps.
3) Confirm the Gate is satisfied (explicitly).
4) Only then proceed to the next phase.

If a gate fails:
- Stop, diagnose, fix, re-run verification until gate passes.

## Step 5 — Full verification + code review

After completing phases:

1) Run lint
2) Run build (if applicable to the stack)
3) Run tests
4) Perform a code review pass:
   - correctness, types, error handling
   - security (secrets, env usage, injection risks)
   - performance (hot paths, DB queries, batching)
   - style/conventions (repo patterns)
   - test coverage vs acceptance criteria
5) Fix issues found, or record them in `/tasks/<task-name>/final-phase.md` with severity and next steps.

# Safety and repository hygiene

- Do not introduce secrets into code or commits.
- Prefer adding env var references (document required env vars).
- For Postgres changes, use migrations if the repo uses them.
- Follow existing conventions for formatting, typing, and folder structure.
- Avoid unrelated refactors unless required; if done, document in the spec.

# Completion definition

Complete only when:

- All required task files exist under `/tasks/<task-name>/`
- All phase gates have passed
- Lint/build/tests pass OR failures are documented as explicit blockers
- A final code review has been performed and issues addressed or recorded
