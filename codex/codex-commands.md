# Codex Commands Manifest

This file pins the canonical verification commands for this repository so they do not drift.

## Node / TypeScript (npm or bun)

- Package manager:
  - Preferred: <bun|npm>
  - Lockfile: <bun.lockb|package-lock.json|pnpm-lock.yaml|yarn.lock>

- Lint:
  - Command: <bun run lint | npm run lint | not-configured>

- Build:
  - Command: <bun run build | npm run build | not-configured>

- Test:
  - Command: <bun run test | npm run test | vitest run | not-configured>

## Python (uv)

- Sync:
  - Command: <uv sync>

- Lint:
  - Command: <uv run ruff check . | uv run black . | not-configured>

- Format (optional):
  - Command: <uv run ruff format . | uv run black . | not-configured>

- Test:
  - Command: <uv run pytest -q | not-configured>

## Notes

- Update this manifest only when the repository’s canonical commands change.
- Tasks must also copy the chosen commands into `/tasks/<task-name>/spec.md` under “Verification Commands”.
