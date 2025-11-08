# Monorepo Automation Guide

## Root
### Objectives
- Maintain Bun workspace configuration in `package.json` covering `packages/common`, `packages/backend`, and `packages/frontend`.
- Extend TypeScript project references in `tsconfig.json` to include each workspace.
- Share compiler defaults through `tsconfig.base.json` and depend on the `@jobtracker/common` workspace package.
- Keep lint, build, test scripts orchestrated via root `bun run --filter` commands.

### Layout
```
/
├── package.json
├── tsconfig.json
├── tsconfig.base.json
├── eslint.config.js
├── README.md
└── packages/
    ├── backend/
    ├── common/
    └── frontend/
```

## Common (`/packages/common`)
### Objectives
- Centralize shared types, schemas, and utilities consumed by backend and frontend.
- Keep implementations framework-agnostic and pure.
- Expose exports through `@jobtracker/common` and ensure Zod schemas mirror runtime contracts.

### Layout
```
/packages/common/
├── package.json
├── tsconfig.json
├── src/
│   ├── index.ts
│   ├── types/
│   ├── rpc/
│   └── utils/
└── tests/
```

### Actions
- Define Zod schemas in `src/types` and `src/rpc`.
- Publish helper utilities through `src/utils/index.ts`.
- Export the public surface from `src/index.ts` only.
- Add Vitest units in `tests/` and target pure functions.

## Backend (`/packages/backend`)
### Objectives
- Deliver an Express API server compiled with TypeScript.
- Structure HTTP logic into routes, controllers, services, and utilities.
- Depend on shared contracts from `@jobtracker/common` and log with Pino.

### Layout
```
/packages/backend/
├── package.json
├── tsconfig.json
├── src/
│   ├── index.ts
│   ├── routes/
│   ├── controllers/
│   ├── services/
│   ├── util/
│   └── types/
└── tests/
    ├── unit/
    └── integration/
```

### Actions
- Register HTTP endpoints in `src/routes` and forward to controllers.
- Validate inbound payloads inside controllers using Zod schemas from `@jobtracker/common`.
- Offload persistence and integrations to service classes within `src/services`.
- Emit structured logs via `src/util/logger.ts` and Pino.
- Store ambient types inside `src/types` as `.d.ts` declaration files.
- Cover controllers with Vitest unit tests and real integrations under `tests/integration`.

## Frontend (`/packages/frontend`)
### Objectives
- Provide a SvelteKit 5 application backed by Vite.
- Encapsulate business logic inside `src/lib/server` and `src/lib/utils`.
- Consume shared schemas from `@jobtracker/common` for data validation.

### Layout
```
/packages/frontend/
├── package.json
├── tsconfig.json
├── svelte.config.js
├── vite.config.ts
├── app.html
├── src/
│   ├── lib/
│   │   ├── components/
│   │   ├── server/
│   │   ├── utils/
│   │   └── types/
│   └── routes/
└── tests/
    ├── mock/
    ├── data/
    ├── e2e/
    ├── db/
    └── unit/
```

### Testing Layout
```
packages/frontend/
  src/
    lib/
      components/
        MyComponent.svelte
  tests/
    components/
      Host.svelte
    setupTests.ts
    unit/
      MyComponent.spec.ts
  vite.config.ts
  vitest.config.ts
  package.json
```

### Actions
- Author Svelte components under `src/lib/components` and compose them in routes.
- Implement server interactions inside `src/lib/server` using shared RPC contracts.
- Place shared client helpers under `src/lib/utils` and reuse across routes.
- Store SvelteKit route handlers and pages under `src/routes`.
- Maintain Vitest suites segmented by purpose within `tests/` subdirectories.
- Follow the jsdom/Vitest workflow described in `packages/frontend/docs/SvelteComponentTesting.md` when testing Svelte components.

## Conventions
### Build And Test
- Invoke `bun install` once to link workspaces.
- Run `bun run build` to compile all packages in dependency order.
- Run `bun run test` to execute Vitest for every workspace.
- Run `bun run lint` to enforce linting across the monorepo.

### Dependency Management
- Prefer workspace references (`workspace:*`) when linking internal packages.
- Pin external dependencies with caret ranges for semver compatibility.
- Store shared tooling (TypeScript, ESLint, Vitest) in the root `devDependencies`.
- Keep runtime-only dependencies localized to their owning workspace.

### Coding Standards
- Enforce strict TypeScript settings inherited from `tsconfig.base.json`.
- Keep shared modules free from side effects to maximize reuse.
- Apply declarative logging with Pino and avoid `console.log` statements.
- Require Zod validation for any inbound or outbound payload.
