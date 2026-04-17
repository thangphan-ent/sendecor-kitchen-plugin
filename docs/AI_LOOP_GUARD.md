# AI LOOP GUARD — SENDECOR KITCHEN PLUGIN

## PURPOSE
This file defines the minimum protection rules to prevent:
- hallucination
- negative looping
- docs/code drift
- repeated patching without real progress

---

## 1. SOURCE OF TRUTH RULE

GitHub is the source of truth.

For code:
- editable source = `source/sendecor_kitchen.lua`
- deploy/plugin file = `plugin/sendecor_kitchen_plugin.lua`

Rules:
- Always inspect current source file before analysis
- Do not assume older chat context is still valid
- Do not trust docs over code when they conflict
- If docs and code differ, declare `STATE MISMATCH` immediately

---

## 2. FILE IDENTITY RULE

Before any patch:
- confirm which file is editable source
- confirm which file is deploy/plugin file
- confirm both files are synced or intentionally different

If file identity is unclear:
- STOP
- do not patch
- do not redesign
- audit first

---

## 3. DOCS VS CODE RULE

If docs describe features that do not exist in code:
- mark them as `PLANNED ONLY`
- do not reason as if they are implemented
- do not ask Claude to patch "existing logic" if that logic is not present

Never treat:
- old session notes
- old prompts
- old assumptions

as implementation evidence.

Only code in repo counts as implementation evidence.

---

## 4. LOOP STOP RULE

If the same bug/topic returns more than 2 times without new evidence:
- STOP patching
- re-open current source file
- rewrite root cause from code only
- reduce scope
- patch the smallest missing foundation first

Examples:
- "Run B rotation"
- "Run B orientation"
- "Run B axis"
- "Run B mirror"

These may be the same bug under different names.

---

## 5. MINIMAL PATCH RULE

All patches must be:
- minimal
- safe
- scoped
- reversible

Do NOT:
- redesign system
- introduce require()
- split into multiple files
- patch unrelated areas
- fake future features

---

## 6. PATCH GATE RULE

No patch is allowed unless all 5 items are defined:
- BUG
- ROOT CAUSE
- DONE WHEN
- DO NOT TOUCH
- REGRESSION CHECK

If one of these is missing:
- STOP
- refine task first

---

## 7. GPT ROLE RULE

GPT must:
- verify current code first
- detect docs/code mismatch
- define scope clearly
- reject patches that exceed scope
- review Claude output in:
  - Logic
  - Structure
  - Runtime

GPT must not:
- assume implementation exists without evidence
- approve vague progress claims
- continue a loop blindly

---

## 8. CLAUDE ROLE RULE

Claude must:
- patch only the current verified source
- follow the defined scope exactly
- avoid redesign
- return full updated file
- state clearly what was NOT added

Claude must not:
- infer missing systems from docs alone
- patch imaginary code paths
- expand scope silently

---

## 9. MIRROR RULE

If `source/sendecor_kitchen.lua` is patched and approved:
- mirror the same final content into `plugin/sendecor_kitchen_plugin.lua`

Do not allow silent divergence unless explicitly planned.

---

## 10. RECOVERY PRIORITY RULE

When project reality is behind docs:
build in this order:
1. source truth
2. foundation
3. placement
4. minimal geometry
5. axis logic
6. grouping / selection / highlight

Do not jump ahead.

---

## 11. FAILURE SIGNALS

The workflow is entering a dangerous loop if:
- same bug is discussed repeatedly with new names
- docs claim "DONE" but code does not contain the feature
- Claude patches without current source verification
- GPT approves without regression checks
- tasks remain vague across multiple rounds

If any of the above appears:
- return to audit mode immediately

---

## 12. CURRENT WORKING PRINCIPLE

Reality first.
Code first.
Small verified steps.
No hallucinated progress.
