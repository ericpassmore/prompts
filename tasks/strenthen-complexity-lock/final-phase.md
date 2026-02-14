# Final Phase — Hardening, Verification, and Closeout

> Stage 4 completion source of truth:
> mark items as complete with `[x]`, or leave unchecked with `EVALUATED: <decision + reason>`.

### Documentation updates
- [x] `/doc` audit and updates EVALUATED: not-applicable; no `/doc` artifacts impacted by this script-only change.
- [x] YAML documentation contracts (`/doc/**/*.yaml`) EVALUATED: not-applicable; no API/schema contract changes.
- [x] README updates EVALUATED: deferred; no user-facing behavior contract changed.
- [x] ADRs (if any) EVALUATED: not-applicable; no architectural decision introduced.
- [x] Inline docs/comments EVALUATED: complete; validator messages were updated inline.

## Testing closeout
- [x] Missing cases to add: none beyond lock-metadata negative test added to command evidence.
- [x] Coverage gaps: none known for changed logic path.

## Full verification
> Use the pinned commands in spec + `./codex/project-structure.md` + `./codex/codex-config.yaml`.
> Stage 4 requires explicit pass notation: `PASS`.

- [x] Lint: `bash -n codex/scripts/prepare-phased-impl-validate.sh` PASS
- [x] Build: `bash -n codex/scripts/prepare-phased-impl-scaffold.sh` PASS
- [x] Tests: `LOCK=tasks/strenthen-complexity-lock/.complexity-lock.json; BAK=/tmp/strenthen-complexity-lock.test.backup.json; TR=/tmp/strenthen-complexity-lock.test.truncated.json; cp "$LOCK" "$BAK"; jq '{ranges: .ranges}' "$BAK" > "$TR"; cp "$TR" "$LOCK"; OUT=$(./codex/scripts/prepare-phased-impl-validate.sh strenthen-complexity-lock 2>&1 || true); cp "$BAK" "$LOCK"; printf '%s\n' "$OUT"; printf '%s' "$OUT" | rg "missing 'selected_signals_path'" >/dev/null && printf '%s' "$OUT" | rg "missing 'selected_signals_sha256'" >/dev/null` PASS

## Manual QA (if applicable)
- [x] Steps: run validator with complete lock and truncated lock.
- [x] Expected: complete lock returns `READY FOR IMPLEMENTATION`; truncated lock returns `BLOCKED`.

## Code review checklist
- [x] Correctness and edge cases
- [x] Error handling / failure modes
- [x] Security (secrets, injection, authz/authn) EVALUATED: not-applicable for local shell script changes.
- [x] Performance (DB queries, hot paths, batching) EVALUATED: not-applicable for this change.
- [x] Maintainability (structure, naming, boundaries)
- [x] Consistency with repo conventions
- [x] Test quality and determinism

## Release / rollout notes (if applicable)
- [x] Migration plan: none.
- [x] Feature flags: none.
- [x] Backout plan: revert `codex/scripts/prepare-phased-impl-validate.sh`.

## Outstanding issues (if any)
For each issue include severity + repro + suggested fix.
- None.
