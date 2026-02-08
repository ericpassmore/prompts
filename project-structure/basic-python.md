# Basic Python Project Structure

## Metadata
- Name: Basic Python
- Type: Single-package project structure
- Language/Runtime: Python 3.13
- Tooling: `uv`

## Objectives
- Keep application code in `src/`.
- Keep test suites in `tests/`.
- Keep documentation in `docs/`.

## Layout
```text
/
├── pyproject.toml
├── src/
├── tests/
└── docs/
```

## Actions
- Initialize project: `uv init`
- Install Python: `uv python install 3.13`
- Create venv: `uv venv`
- Initialize tooling: `uv add --dev ruff pytest`
- Add package: `uv add <pkg>`
- Run script: `uv run <script>` (Automatically uses the virtual environment)
- Lock deps: `uv lock`
- Place production modules and packages under `src/`.
- Add unit and integration tests under `tests/`.
- Maintain architecture and usage docs under `docs/`.

## Verification
- Sync: `uv sync`
- Lint: `uv run ruff check .`
- Format (optional): `uv run ruff format .`
- Build (interpreted build-equivalent): `uv run pytest -q`
- Test: `uv run pytest -q`

## Constraints
- Keep production code inside `src/`.
- Keep all tests inside `tests/`.
- Keep project and architecture docs inside `docs/`.

## Success Criteria
- `pyproject.toml` exists at repository root.
- Lint, build-equivalent, and test commands run successfully.
- `src/`, `tests/`, and `docs/` are present and used for their intended purpose.

## Non-Goals
