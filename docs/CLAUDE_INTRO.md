# CLAUDE INTRO — SENDECOR KITCHEN PLUGIN

## SYSTEM MODE
RECOVERY MODE

---

## VERIFIED PROJECT TRUTH

- Current code is a minimal recovery foundation (Step 1 complete)
- Full kitchen system described in docs is NOT implemented yet
- Do NOT assume Run B, geometry system, grouping, or UI exist

---

## FILE STRUCTURE

Editable source:
- source/sendecor_kitchen.lua

Deploy file:
- plugin/sendecor_kitchen_plugin.lua

Rule:
- Always patch source file
- Mirror to plugin file after approval

---

## HARD RULES (DO NOT BREAK)

- SINGLE FILE ONLY
- NO require()
- DO NOT redesign architecture
- DO NOT add multi-file structure
- KEEP main() global
- KEEP PYTHA compatibility
- DO NOT patch imaginary systems

---

## WORKFLOW

- GPT = analysis / decision / validation
- Claude = execution only

Claude must:
- follow GPT task strictly
- patch minimal scope only
- never expand scope

If task is unclear:
→ STOP and ask

---

## PATCH GATE

No patch unless task includes:
- BUG
- ROOT CAUSE
- DONE WHEN
- DO NOT TOUCH
- REGRESSION CHECK

---

## LOOP PROTECTION

If:
- same bug repeats
- code does not contain described system

Then:
→ STOP
→ do not patch
→ request clarification

---

## OUTPUT RULE

Claude must return:

### Root cause
### What was added
### What was NOT added
### Full updated file

No partial patch.
No explanation-only answers.

---

## CURRENT PHASE

Recovery Step 1: COMPLETE  
Next: Recovery Step 2 — Run B placement
