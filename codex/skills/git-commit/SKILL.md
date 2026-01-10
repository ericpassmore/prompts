---
name: git-commit
description: Draft a commit message, run safety checks, and commit to git.
---

# Generating Commit Messages

**This skill must be used for every single commit**

## Shared Configuration and Reusable Scripts

### .env File Patterns

**Used by:** Protect Sensitive Data, Commit
**Rule:** `.env` files may be appended to locally but must never be staged or committed.

#### Ignore env files
.env
.env.*
^(?!developement\.env$).+\.env$
^(?!developement\.env$).+\.env.*$

#### Exception: allow this example file to be committed
developement.env

#### Code Block `.gitignore`

```
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
* `.DS_Store` (file; include here for convenience)
* `dist/`
* `build/`
* `bin/`
* `out/`
* `target/`

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

```bash
# Staged files only (NUL-delimited, safe for spaces)
git diff --cached --name-only -z \
| while IFS= read -r -d '' f; do
    # Skip if Git considers it binary in the index vs HEAD
    if git diff --cached --numstat -- "$f" | awk 'NR==1{exit !($1=="-" && $2=="-")}'; then
      echo "Skipping binary: $f"
      continue
    fi

    # Show text diff for this file
    git diff --cached -- "$f"
  done
```

---

## Mandatory Processes

### Update Branch

**Before Track Files Step**

1. **Always** run `git status --porcelain | grep -q . && abort` abort on any dirty state.

   * Messaging: Inform the user aborted due to dirty state
   * Messaging: Provide the user with a summarized list of dirty files derived from `git status --porcelain`
2. **Always** run `git branch --show-current` to get the current branch
3. **Always** abort and stop immediately when the branch name is empty; inform the user aborting due to empty branch name
4. **Always** abort and stop immediately when the branch name is `main` or `master`
5. **Always** run the script below to get a clean working tree

   * `git pull --ff-only origin <branch> || abort`
   * abort and inform the user when `git pull` fails

---

### Track Files

**Before the Add Step**

1. **Always** find untracked files using `git ls-files -o --exclude-standard`
2. **Always** add eligible untracked files to git as an intent-to-add:
   * before running `git add -N`, filter out files matching **.env File Patterns** and **Forbidden Directories**
   * Exception: `developement.env` is allowed to be tracked and committed as an example file
   * using `git add -N <file_name>`
3. Apply media rules using the shared definitions:

   * **Image File Definitions**
   * **Video and Audio File Definitions**
4. **Never** add files within **Forbidden Directories**
5. **Never** add compiled or cached outputs matching **Compiled and Cached Output Patterns**
6. **Never** add non-media binary files matching **Non-Media Binary File Patterns**
7. **Allowed** vendor lockfiles per **Vendor Lockfiles**
8. **Never** add tar archives
9. **Always** run **Protect Sensitive Data** after tracking untracked files.

---


### Protect Sensitive Data

**Use to resolve sensitive data**

1. Follow **.env File Patterns** rules:

   * `.env` files may be appended to locally but must never be staged or committed.
   * Exception: `development.env` is allowed to be tracked and committed as an example file.
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

### Example Good Commit Message

```
Refactor authentication system for better organization of code.
```

---

### Sync

**Final Step, After any `git commit` command**

1. **Always** run `git push origin <current-branch-name>`
2. **Always** summarize the messages from git and report to the user
