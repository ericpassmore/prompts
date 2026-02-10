---
name: git-commit
description: Draft a commit message, run safety checks, and commit to git.
---

# Generating Commit Messages

**This skill must be used for every single commit**

## Shared Configuration and Reusable Scripts

### .env File Patterns

**Used by:** Protect Sensitive Data, Commit

#### Policy: env-like files (forbidden to stage/commit)

Treat any file matching **any** of these globs as an env file:

* `.env`
* `.env.*` (example: `.env.local`, `.env.production`)
* `*.env` (example: `test.env`, `production.env`)
* `*.env.*` (example: `test.env.example`, `production.env.bak`)

**Rule:** Env-like files may be appended to locally but must never be staged or committed.

#### Explicit exception: allowed example file

The following file is allowed to be tracked and committed as an example/template:

* `developement.env`

When filtering env-like files, exclude anything matching the env-like globs **unless** the path is exactly `developement.env`

#### `.gitignore` implementation

```gitignore
# Ignore env files
.env
.env.*
*.env
*.env.*

# Exception: allow this example file to be committed
!developement.env
```

---

### Forbidden Directories

**Used by:** Track Files, Protect Sensitive Data

**Never add files within these directories (case-sensitive paths, treat as directory prefixes):**

* `node_modules/`
* `.venv/`
* `venv/`
* `.pytest_cache/`
* `.mypy_cache/`
* `.ruff_cache/`
* `.cache/`
* `dist/`
* `build/`
* `bin/`
* `out/`
* `target/`

**Never** add this file 
* `.DS_Store` 

**Rule:** Always add patterns for these to `.gitignore` if not already present.

---

### Vendor Lockfiles

**Used by:** Track Files, Commit

**Allowed lockfiles (examples; case-sensitive filenames):**

* `package-lock.json`
* `pnpm-lock.yaml`
* `yarn.lock`
* `bun.lockb`
* `Cargo.lock`
* `poetry.lock`
* `uv.lock`
* `Pipfile.lock`

**Rule:** Vendor lockfiles are allowed and may be staged/committed when they reflect intended dependency changes.

---

### Image File Definitions

**Used by:** Track Files

**Image extensions (case-insensitive):**

* `.jpg`, `.jpeg`, `.png`, `.gif`, `.svg`

**Constraints:**

* Always ok to add **five or fewer image files** when **each file is under 1Mb**
* Request explicit permission to add:

  * any image file **greater than 1Mb**, or
  * **more than five** image files

---

### Video and Audio File Definitions

**Used by:** Track Files

**Video/Audio extensions (case-insensitive):**

* `.mp4`, `.mp3`

**Constraints:**

* Never add:

  * any video/audio file

---

### Non-Media Binary File Patterns

**Used by:** Track Files

**Non-media binary extensions (case-insensitive), excluding allowed Image and Video/Audio definitions:**

* `.psd`, `.zip`, `.dll`, `.exe`, `.zstd`, `.gz`, `.pdf`

**Rule:** Never add these files.

---

### Compiled and Cached Output Patterns

**Used by:** Protect Sensitive Data, Track Files

**Never add / always ignore patterns:**

* Python cache/bytecode:

  * `__pycache__/`, `*.pyc`, `*.pyo`
* Common build artifacts (files):

  * `*.o`, `*.class`

**Rule:** Always add patterns to `.gitignore` if not already present.

---

### Script: Diff Staged Files Only (Skip Binary)

**Used by:** Protect Sensitive Data, Commit

Run the trusted helper script:

```bash
/Users/eric/.codex/scripts/git-diff-staged-skip-binary.sh
```

### Script: Commit Preflight

**Used by:** Update Branch

Run the trusted helper script:

```bash
/Users/eric/.codex/scripts/git-commit-preflight.sh
```

### Script: Track Safe Untracked Files

**Used by:** Track Files

Run the trusted helper script:

```bash
/Users/eric/.codex/scripts/git-track-safe-untracked.sh
```

---

## Mandatory Processes

### Update Branch

**Before Track Files Step**

1. **Always** run **Script: Commit Preflight**.
2. The preflight script must:
   * abort when merge conflicts/unmerged paths are present
   * accept detached `HEAD` state and report explicit detached-mode behavior
   * when on a named branch, abort when no upstream is configured
   * when on a named branch, run `git pull --ff-only` and classify pull failures:
     * upstream/reference issues (`couldn't find remote ref`, `no such ref`, `no tracking information`)
     * all other failures as manual-intervention required

---

### Track Files

**Before the Add Step**

1. **Always** run **Script: Track Safe Untracked Files**.
2. The tracking script must:
   * read untracked files from `git ls-files -o --exclude-standard`
   * add eligible files as intent-to-add via `git add -N`
   * skip files matching **.env File Patterns**, **Forbidden Directories**, **Compiled and Cached Output Patterns**, **Non-Media Binary File Patterns**, and tar archives
   * enforce media rules from **Image File Definitions** and **Video and Audio File Definitions**
   * if permission-required images are reported, ask the user before adding any of those files
   * preserve the exception: `developement.env` is allowed
3. **Always** run **Protect Sensitive Data** after tracking untracked files.

---


### Protect Sensitive Data

**Use to resolve sensitive data**

1. Follow **.env File Patterns** rules:

   * `.env` files may be appended to locally but must never be staged or committed.
   * Exception: `developement.env` is allowed to be tracked and committed as an example file.
2. **Always** inspect changes for secrets using:

   * `git diff` (unstaged changes)
   * Script: Diff Staged Files Only (Skip Binary) (staged and intent-to-add changes)
3. **Never** remove any lines from files matching **.env File Patterns**
4. **Always** remove secrets from code or configuration files:

   * Create concise variable name using `[A-Z_]`
   * Append a line to the end of `.env`:

     * Format: `NAME=SECRET`
   * Replace the secret in the code/config file with a reference to the variable name (implementation depends on language/runtime)
5. **Always** add patterns to `.gitignore` to skip:

   * all entries in **Forbidden Directories**
   * all patterns in **Compiled and Cached Output Patterns**
   * all patterns in **.env File Patterns**
6. Write helper code as needed to provide access to the secret (example: load env var, config binding).
7. When these steps do not resolve sensitive data, take the following recovery steps:

   * do not track the file
   * run `git rm --cached <file>`
   * add the file pattern to `.gitignore`

---

### Commit

**Before any `git commit` command**

1. **Always** run **Script: Diff Staged Files Only (Skip Binary)** to review staged changes on non-binary files
2. **Always** analyze the staged changes output from the diff script
3. **Always** generate a commit message following the format below
4. **Never** commit secrets or sensitive data
5. **Never** commit files matching **.env File Patterns**
  - Exception: `developement.env` is allowed to be tracked and committed as an example file
6. **Allowed** vendor lockfiles per **Vendor Lockfiles**

---

## Required Commit Message Format

### Summary Line

* Under 72 characters
* Use present tense imperative mood
* Be specific and descriptive

### Best Practices

* Use clear, concise language that describes changes
* Use present tense — “Add feature” not “Added feature”
* Start summary with an action verb — Add, Update, Fix, Remove, etc.
* Be specific about what components/files were affected
* Do not use punctuation 

### Example Good Commit Message

```
Refactor authentication system for better organization of code
```

---

### Sync

**Final Step, After any `git commit` command**

1. **Always** push commit(s) to origin using one of:
   * named branch mode: `git push origin <current-branch-name>`
   * detached `HEAD` mode: `git push origin HEAD:<target-branch-name>`
2. **Always** summarize the messages from git and report to the user
