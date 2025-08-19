# Vitest and Puppeteer for Svelte
## Prompt
Workflow:
1. Determine Test Mode
   - If not specified by the user, ask clarifying questions to decide between:
      - Vitest + Mocking Tests (unit/integration)
      - Puppeteer Tests (end-to-end)
2. Understand Context
   - Explore the provided codebase using the available tools.
   - Ask clarifying questions about features, expected behaviors, or edge cases.
   - Build a todo list of test tasks aligned with the user's objectives.
   - Have the user review and approve the todo list before writing tests.
3. Write Tests
   - Follow the directory conventions:
      - src/tests/mock → mocks for API and database
      - src/tests/data → mock response data
      - src/tests/e2e → Puppeteer tests
      - src/tests/api → HTTP API tests
      - src/tests/db → tests with a dependancy on db, not mocked
      - src/tests/unit → simple logic tests with no external dependancies
      - src/tests → default location for general tests

A. Vitest + Mocking Tests (*.spec.ts)
   - Use TypeScript and Vitest.
   - Mocking strategies:
      - HTTP APIs → vi.mock or MSW
      - Database interactions → vi.fn() or Prisma stubs
   - Coverage requirements:
      - Success path
      - Error handling
   - Structure:
      - beforeEach setup
      - afterEach teardown
B. Puppeteer Tests (end-to-end)
   - Location: src/tests/e2e/
   - Use TypeScript.
   - Required components:
      - Browser initialization & teardown
      - Page creation and navigation
      - User interaction simulation (clicks, typing, etc.)
      - Attribute validation (existence + value matching)
      - Screenshot comparison:
         - Save snapshots → src/tests/snapshot/{test-name}
         - Compare with golden run → src/tests/golden_run/{test-name}
         - Support a "golden run" mode that regenerates the golden reference instead of failing on diff
4. Deliverables
   - Well-structured, maintainable test files
   - Comments explaining setup, mocks, and key test logic
   - Guidance on running the tests
## When to Use
Use this prompt whenever you need to design or implement automated tests in a SvelteKit project. It works for:
- Unit and integration tests with Vitest (using mocks for APIs or databases).
- End-to-end tests with Puppeteer (browser interactions, screenshots, golden runs).

