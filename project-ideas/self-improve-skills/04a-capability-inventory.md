# Capability Inventory

## C1: Incident Intake

- capability_id: `C1`
- Actor and journey step: executing agent at first observation of a defect, workaround, block, or inefficiency
- Input surface: observed incident in any repository using centralized skills
- Output surface: child issue in `ericpassmore/prompts`
- Invariant: every improvement begins with a concrete issue
- Failure condition: incident is worked around or forgotten without issue capture
- Success signal: issue exists with source repository, skill or stage, and minimal repro
- Estimated implementation weight: `M`

## C2: Fast-Path Obvious Bug Filing

- capability_id: `C2`
- Actor and journey step: executing agent when the problem is an obvious bug or confirmed defect
- Input surface: reproducible defect with minimal evidence
- Output surface: issue filed immediately with severity label and repro
- Invariant: obvious bugs are not delayed for later analysis
- Failure condition: obvious bug waits for batch triage and recurrence data is lost
- Success signal: issue filed in the same session as the observation
- Estimated implementation weight: `S`

## C3: Evidence Normalization

- capability_id: `C3`
- Actor and journey step: executing agent during issue creation
- Input surface: local context such as task artifacts, command failures, or stage references
- Output surface: normalized evidence bundle attached to the issue
- Invariant: cross-repository provenance is preserved
- Failure condition: issue lacks enough context to reproduce or cluster
- Success signal: issue contains source repository, skill or stage, observation, and resolution state
- Estimated implementation weight: `M`

## C4: Automated Triage

- capability_id: `C4`
- Actor and journey step: triage agent after issue creation
- Input surface: newly created child issue
- Output surface: labels, severity normalization, category assignment, and signature extraction
- Invariant: triage is consistent across repositories
- Failure condition: issues remain unlabeled or inconsistently classified
- Success signal: new issues receive normalized metadata within the triage window
- Estimated implementation weight: `M`

## C5: Cluster Detection And Parent Escalation

- capability_id: `C5`
- Actor and journey step: triage agent during periodic analysis or event-driven review
- Input surface: related child issues and their signatures
- Output surface: new or updated parent issue with linked child incidents
- Invariant: parent issues aggregate but do not replace child incidents
- Failure condition: repeated incidents stay fragmented or parent issues are created from noisy matches
- Success signal: parent issue appears only after evidence threshold is met and links all known child issues
- Estimated implementation weight: `M`

## C6: Improvement Proposal Routing

- capability_id: `C6`
- Actor and journey step: maintainer or implementation agent after confirmed defect or actionable parent issue
- Input surface: child or parent issue with bounded problem statement
- Output surface: proposed skill change scoped to the identified problem
- Invariant: changes map back to concrete incident evidence
- Failure condition: fixes are speculative or not tied to observed failures
- Success signal: proposed change cites the triggering issue set and expected improvement signal
- Estimated implementation weight: `M`

## C7: Validation And Rollout

- capability_id: `C7`
- Actor and journey step: maintainer before and after landing a skill change
- Input surface: proposed change plus target metric or incident pattern
- Output surface: validation result, rollout record, and expected follow-up checks
- Invariant: improvement loop is not closed until validation evidence exists
- Failure condition: skill changes land without evidence they address the captured problem
- Success signal: rollout record names the validation method and expected reduction signal
- Estimated implementation weight: `M`
