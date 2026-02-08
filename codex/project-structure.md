# Codex Lifecycle Repository Structure

## Metadata
- Name: Prompts Codex Workspace
- Type: Documentation and automation repository for staged Codex execution
- Language/Runtime: Bash + Markdown
- Primary Tooling: Git, ripgrep (`rg`), repository-local Codex scripts

## Objectives
- Keep lifecycle governance and stage skills under `codex/`.
- Keep reusable project structure examples under `project-structure/`.
- Keep task execution artifacts under `tasks/` and goal artifacts under `goals/`.
- Keep stage operations script-driven with deterministic command resolution.

## Layout
```text
/
├── codex/
│   ├── AGENTS.md
│   ├── codex-config.yaml
│   ├── project-structure.md
│   ├── goals/
│   ├── prompts/
│   ├── rules/
│   ├── scripts/
│   ├── skills/
│   └── tasks/_templates/
├── project-structure/
├── goals/
├── tasks/
├── scripts/
└── sync-codex-to-git.sh
```

## Actions
- Manage lifecycle contract and invariants in `codex/AGENTS.md`.
- Update skill workflows in `codex/skills/*/SKILL.md`.
- Update stage automation and validators in `codex/scripts/*.sh`.
- Maintain canonical codex settings in `codex/codex-config.yaml`.
- Keep this repository structure reference current in `codex/project-structure.md`.
- Scaffold task artifacts via `./codex/scripts/task-scaffold.sh <task-name>`.

## Verification
- Lint: `not-configured`
- Build: `not-configured`
- Test: `not-configured`
- Script health: `./codex/scripts/prepare-takeoff-bootstrap.sh`
- Stage 3 plan validation: `./codex/scripts/prepare-phased-impl-validate.sh <task-name>`
- Stage 4 implementation validation: `./codex/scripts/implement-validate.sh <task-name>`

## Constraints
- `codex/project-structure.md` is required; execution aborts when missing.
- `codex/codex-config.yaml` is the canonical source for code-review base branch and bootstrap metadata.
- Lifecycle stages must follow the ordered gate contract defined in `codex/AGENTS.md`.
- Command references in task specs must be pinned and traceable to canonical repository records.

## Success Criteria
- Core codex assets (`AGENTS.md`, `codex-config.yaml`, `project-structure.md`, `scripts/`, `skills/`) exist and remain internally consistent.
- Stage scripts can resolve `CODEX_ROOT` and `CODEX_SCRIPTS_DIR` through canonical config.
- Task artifacts can be scaffolded and validated by stage scripts without legacy manifest dependencies.

## Non-Goals
- Defining application runtime architecture beyond codex lifecycle assets.
- Managing deployment infrastructure, CI hosting, or external service topology.
