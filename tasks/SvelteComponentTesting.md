# Testing Svelte 5 Components with Vitest & Testing Library

This guide shows a clean, repeatable setup to test **Svelte 5** components using **Vitest**, **jsdom**, and **@testing-library/svelte**. It includes a working `vitest.config.ts`, a `setupTests.ts`, scripts, and example tests (including how to listen for custom events in Svelte 5).

---

## 1) Install Dev Dependencies

From your **frontend package** (e.g. `packages/frontend`):

```bash
# bun
bun add -d vitest jsdom @testing-library/svelte @testing-library/jest-dom

# or pnpm
pnpm add -D vitest jsdom @testing-library/svelte @testing-library/jest-dom

# or yarn
yarn add -D vitest jsdom @testing-library/svelte @testing-library/jest-dom
```

Keep `vite`, `@sveltejs/kit`, and `svelte` on compatible, current versions in your workspace.

---

## 2) Split Vite & Vitest Configs

> Avoid type collisions by keeping `vite.config.ts` “pure Vite” and placing test config in `vitest.config.ts`.

### `vite.config.ts`

```ts
import { sveltekit } from "@sveltejs/kit/vite";
import { defineConfig } from "vite";

export default defineConfig({
  plugins: [sveltekit()],
});
```

### `vitest.config.ts`

```ts
import { sveltekit } from "@sveltejs/kit/vite";
import { defineConfig } from "vitest/config";

export default defineConfig({
  plugins: [sveltekit()],
  test: {
    environment: "jsdom",
    globals: true,
    setupFiles: ["./tests/setupTests.ts"],
    css: true,
  },
  // Force browser build of Svelte during tests, prevents “mount() not available” SSR errors
  resolve: {
    conditions: ["browser"],
  },
  // Optional extra guard:
  // define: { "import.meta.env.SSR": "false" },
});
```

---

## 3) Create a Test Setup File

Registers matchers and adds any SvelteKit shims your components may use.

### `tests/setupTests.ts`

**Option A (simple):**

```ts
import "@testing-library/jest-dom/vitest";
import { vi } from "vitest";

vi.mock("$app/environment", () => ({
  browser: true,
  dev: true,
  building: false,
  version: "test",
}));
```

**Option B (explicit matcher extension):**

```ts
import { expect, vi } from "vitest";
import * as matchers from "@testing-library/jest-dom/matchers";
expect.extend(matchers);

vi.mock("$app/environment", () => ({
  browser: true,
  dev: true,
  building: false,
  version: "test",
}));
```

Either option is fine—use one, not both.

---

## 4) Add Test Scripts

In your **frontend package.json**:

```json
{
  "scripts": {
    "test": "vitest --config ./vitest.config.ts --environment=jsdom",
    "test:run": "vitest run --config ./vitest.config.ts --environment=jsdom",
    "test:ui": "vitest --ui --config ./vitest.config.ts --environment=jsdom"
  }
}
```

> Run tests from the package with `bun run test` (or `pnpm test`, `yarn test`).

---

## 5) Authoring Tests

### Minimal component test

```ts
/** @vitest-environment jsdom */
import { render, screen } from "@testing-library/svelte";
import MyComponent from "$lib/components/MyComponent.svelte";
import { describe, it, expect } from "vitest";

describe("<MyComponent>", () => {
  it("renders content", () => {
    render(MyComponent, { props: { label: "Hello" } });
    expect(screen.getByText("Hello")).toBeInTheDocument();
  });
});
```

### Interactions

Prefer `userEvent` for realistic interactions (optional):

```bash
bun add -d @testing-library/user-event
```

```ts
import userEvent from "@testing-library/user-event";
await userEvent.click(screen.getByRole("button", { name: /save/i }));
```

---

## 6) Custom Events in Svelte 5 Tests

Svelte 5 removed `component.$on(...)`. Custom events (from `createEventDispatcher`) fire on the **component’s host element**. There are two solid ways to test them:

### A) Use a Host Wrapper (recommended)

Wrap the component in a tiny Svelte file that listens to `on:someEvent` and renders a sentinel:

**`tests/components/Host.svelte`**

```svelte
<script lang="ts">
  import Child from "$lib/components/Child.svelte";
  export let props: Record<string, unknown> = {};
  let toggled = false;
</script>

<Child {...props} on:toggleForm={() => (toggled = true)} />
{#if toggled}<span data-testid="toggled">toggled</span>{/if}
```

**Spec**

```ts
import { render, screen, fireEvent } from "@testing-library/svelte";
import Host from "../components/Host.svelte";
import { it, expect } from "vitest";

it("fires toggleForm", async () => {
  render(Host, {
    props: {
      props: {
        /* Child props here */
      },
    },
  });

  await fireEvent.click(screen.getByText("Add a job"));
  expect(await screen.findByTestId("toggled")).toBeInTheDocument();
});
```

### B) Listen on the Host DOM Node

Attach a listener to the host element and wait for the event:

```ts
import { render, screen, fireEvent } from "@testing-library/svelte";
import Child from "$lib/components/Child.svelte";

const { container } = render(Child, {
  props: {
    /* ... */
  },
});
const host = container.firstElementChild as HTMLElement;

const eventPromise = new Promise<void>((resolve) => {
  host.addEventListener("toggleForm", () => resolve(), { once: true });
});

await fireEvent.click(screen.getByText("Add a job"));
await eventPromise; // resolves when event fires
```

If you see timeouts, prefer the **Host Wrapper** pattern—it mirrors real parent usage and is less brittle.

---

## 7) Common Errors & Fixes

- **`document is not defined`**
  Vitest is using the Node environment. Ensure:

  - `environment: "jsdom"` in `vitest.config.ts` **and/or** the CLI flag `--environment=jsdom`.
  - Optionally add `/** @vitest-environment jsdom */` at the top of the spec.

- **`mount(...) is not available on the server`** / Svelte SSR build leaking into tests
  Add to `vitest.config.ts`:

  ```ts
  resolve: { conditions: ["browser"] },
  // optionally:
  // define: { "import.meta.env.SSR": "false" },
  ```

- **`Invalid Chai property: toBeInTheDocument`**
  Jest-DOM matchers not registered. In `tests/setupTests.ts` either:

  ```ts
  import "@testing-library/jest-dom/vitest";
  ```

  **or**

  ```ts
  import { expect } from "vitest";
  import * as matchers from "@testing-library/jest-dom/matchers";
  expect.extend(matchers);
  ```

- **`vi is not defined` in setup**
  Add `import { vi } from "vitest";` at the top of `setupTests.ts`.

- **`No overload matches this call` around `plugins: [sveltekit()]`**
  You imported `defineConfig` from the wrong module.

  - In `vite.config.ts`: `import { defineConfig } from "vite";`
  - In `vitest.config.ts`: `import { defineConfig } from "vitest/config";`

- **Multiple Vite versions** causing type errors
  Ensure only one `vite` is installed/hoisted. If needed, clear and reinstall.

---

## 8) Optional: Types for IDE Comfort

In `tsconfig.json` (frontend package):

```json
{
  "compilerOptions": {
    "types": ["vitest/globals", "@testing-library/jest-dom"]
  }
}
```

---

## 9) Quick Directory Layout

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

---

## 10) Sanity Checks

- Add a “jsdom sanity” spec:

  ```ts
  /** @vitest-environment jsdom */
  import { test, expect } from "vitest";
  test("has document", () => {
    const el = document.createElement("div");
    expect(el).toBeInstanceOf(HTMLDivElement);
  });
  ```

- Run:

  ```bash
  bun run test
  ```
