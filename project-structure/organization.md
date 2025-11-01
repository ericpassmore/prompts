* Uses **consistent hierarchical Markdown** for easy parsing.
* Includes **root-level structure** (for monorepo setup).
* Normalizes naming (`frontend`, not `frontent`).
* Clearly defines expectations for each directory.
* Adds a **`common`** workspace definition for shared types, utils, and RPC calls.
* Removes human-oriented commentary and replaces it with **instructional imperatives** suitable for automation.

---

# 🧩 Project Organization

This document defines the canonical file structure for **Node.js + TypeScript** monorepos using **Bun** as the package manager.
It supports two main project types:

* **Backend** — HTTP API service using **Express**
* **Frontend** — Web application using **SvelteKit 5** and **Vite**
* **Common** — Shared logic, types, and RPC definitions between backend and frontend

All three are managed as **Bun workspaces** under `/packages`.

---

## Root Layout

```
/
├── package.json         # Root package definition (workspaces, scripts)
├── tsconfig.json        # Base TypeScript configuration
├── bun.lockb            # Bun lock file
├── README.md
└── packages/
    ├── backend/
    ├── common/
    └── frontend/
```

Each workspace may extend the root configuration with its own `package.json` and `tsconfig.json`.

---

## 🧠 Common (`/packages/common/`)

Shared TypeScript code used by both backend and frontend.

### Structure

```
/packages/common/
├── src/
│   ├── types/           # Shared type definitions and Zod schemas
│   ├── rpc/             # RPC message definitions and interfaces
│   ├── utils/           # Common helpers (formatting, conversions, etc.)
│   └── index.ts         # Public exports for the common package
├── tests/               # Unit tests for shared utilities
└── tsconfig.json
```

### Guidelines

* All shared code must be **pure and framework-agnostic**.
* Use **Zod** for schema validation to ensure parity between backend and frontend.
* No direct database or environment access.
* Provide stable exports for type reuse (`import { X } from "@common"`).

---

## ⚙️ Backend (`/packages/backend/`)

An **Express-based HTTP API** implemented in TypeScript.

### Structure

```
/packages/backend/
├── src/
│   ├── index.ts           # Entry point for the API server
│   ├── routes/            # HTTP route definitions
│   ├── controllers/       # Request handling and business logic orchestration
│   ├── services/          # Database and external service integrations
│   ├── util/              # Logging, diagnostics, and shared helpers
│   └── types/             # Local types and interfaces
├── tests/
│   ├── unit/              # Fast tests with mocks
│   └── integration/       # Real DB or network-dependent tests
└── tsconfig.json
```

### Responsibilities

#### Routes

* Define HTTP entrypoints (e.g., `/api/v1/users`).
* Extract headers, params, and body data.
* Forward requests to controllers.
* Avoid database logic or complex validation.

#### Controllers

* Validate and sanitize input (use Zod schemas).
* Coordinate service calls.
* Implement business logic.
* Offload heavy tasks to async queues if needed.
* Do not directly query the database—use services.

#### Services

* Implement logic for persistent objects and integrations.
* Use **Drizzle ORM** for database interactions.
* Encapsulate complex flows (e.g., `AssetService.createOrGetToken()`).
* Handle 3rd-party APIs (CoinMarketCap, Vaulta blockchain, Moralis, etc.).
* Always enforce soft-delete and validation policies.

#### Utils

* Provide logging (via **Pino**) and general-purpose utilities.
* Include structured diagnostics for debugging.

#### Index

* Server startup script.
* Handles Express configuration, middleware, and graceful shutdown (`onServerStop`).

#### Tests

* Use **Vitest** for all tests.
* Unit tests mock all external dependencies.
* Integration tests run with a real database or network.

#### Types

* Use `.d.ts` declaration files for global types.
* No runtime imports are needed; these are consumed at transpile time.

---

## 🌐 Frontend (`/packages/frontend/`)

A **SvelteKit 5** web application built with **Vite**.

### Structure

```
/packages/frontend/
├── src/
│   ├── lib/
│   │   ├── components/   # Reusable UI components
│   │   ├── server/       # Global state, API clients
│   │   ├── utils/        # Helper functions
│   │   └── types/        # Frontend-specific types
│   └── routes/           # SvelteKit routes (file-based)
├── tests/
│   ├── mock/             # Mock API and DB responses
│   ├── data/             # Static data for tests
│   ├── e2e/              # End-to-end tests using Puppeteer
│   ├── db/               # DB-dependent tests (non-mocked)
│   └── unit/             # Logic-level tests
├── app.html              # Application shell
└── tsconfig.json
```

### Guidelines

* Use Vite for builds and testing (`bun test` → Vitest).
* Keep business logic in `/lib/server` or `/lib/utils`, not inside components.
* Use Zod schemas from `@common` to validate API data.
* Store global state via Svelte stores or context APIs.
* Prefer composition over inheritance for UI components.

---

## 🧩 Workspace Conventions

* All packages are versioned together; no independent publishing.
* Use **Bun workspaces** to link internal packages (`common → backend`, `common → frontend`).
* Each workspace includes:

  * `build` script (transpile with `tsc`)
  * `test` script (run via `vitest`)
  * `lint` script (if ESLint configured)
* Root-level scripts should delegate to each workspace via `bun run -w`.

---

## ✅ Summary

| Package      | Purpose                | Key Tools                      |
| ------------ | ---------------------- | ------------------------------ |
| **backend**  | Express API            | Node.js 24, Drizzle, Pino, Zod |
| **frontend** | SvelteKit app          | Svelte 5, Vite, Vitest         |
| **common**   | Shared types and logic | TypeScript, Zod                |
| **root**     | Monorepo orchestration | Bun, TypeScript, Vitest        |

