# Ambiguity Register

| ID | Ambiguity | Category | Scope Impact | Systemic Risk | Regulatory Risk | Breadth | Score | Current Handling |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A1 | Minimum evidence bundle for issue filing | Testability | 4 | 4 | 1 | 5 | 80 | Bound by a low-friction default bundle and leave future tuning to rollout feedback. |
| A2 | Threshold for clustering incidents into parent issues | Integration | 3 | 4 | 1 | 4 | 48 | Start with a count-and-time-window threshold and revise after observing noise level. |
| A3 | Which inefficiencies justify immediate issue filing versus later analysis | Domain | 3 | 3 | 1 | 4 | 36 | File immediately when noticed, then rely on triage labels to separate defect, friction, and analysis-only patterns. |
| A4 | Final delivery surface for the process | Technology | 2 | 2 | 1 | 3 | 12 | Treat as implementation detail; preserve process design independent of packaging. |

## Notes

- Ambiguity has been reduced from open-ended process design to bounded operational questions around intake and clustering thresholds.
- No remaining ambiguity changes the core actor, scope, or success metric.
