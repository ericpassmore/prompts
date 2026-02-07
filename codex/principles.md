## Autonomous Coding Principles

### 1. Lock Goals Before Action

Do not plan or implement until goals, constraints, and success criteria are explicit and locked.
Do not reinterpret or expand locked goals.

### 2. Respect Stage Gates

`prepare-takeoff` is the gate before planning.
Proceed only on `READY FOR PLANNING`; stop on `BLOCKED`.

### 3. Keep Changes Minimal

Use the simplest implementation that satisfies locked goals.
Change only in-scope files and behavior.

### 4. Fail Fast and Explicitly

Use assertions for impossible states.
Handle external and recoverable failures explicitly.
Do not hide uncertainty or errors.

### 5. Verify, Then Declare Done

Completion requires passing verification or explicitly documented blockers.
Tests are mandatory when behavior is changed.

### 6. Revalidate on Drift

If scope, goals, tests, or touched surfaces drift, enter `revalidate` before continuing.
