# SESSION WORKFLOW V4 — FINAL

## OVERVIEW

This file defines the official session workflow for SENDECOR KITCHEN PLUGIN.

This workflow ensures:
- no premature analysis
- controlled execution
- safe interaction between GPT and Claude
- GitHub-first discipline

---

## STATE MACHINE

### STATES

- IDLE
- LOCKED
- PARTIAL
- READY_FOR_GPT_REVIEW
- READY_FOR_CLAUDE
- EXECUTION
- READY_TO_CLOSE

---

### TRANSITIONS

IDLE → LOCKED  
User types "Mở phiên"

LOCKED → PARTIAL  
At least 1 input received

PARTIAL → READY_FOR_GPT_REVIEW  
All required inputs received and validated

READY_FOR_GPT_REVIEW → READY_FOR_CLAUDE  
GPT confirms prompt is safe

READY_FOR_CLAUDE → EXECUTION  
User sends prompt to Claude

EXECUTION → READY_TO_CLOSE  
Claude result received and validated

READY_TO_CLOSE → IDLE  
User types "Đóng phiên"

---

## REQUIRED INPUTS

1. PROJECT_CONTEXT.md  
2. TASK.md  
3. ERROR LOG (or N/A)  
4. FULL CURRENT LUA FILE  

---

## ERROR LOG RULE

- Debug task → REQUIRED  
- Feature / Review → may use N/A  

---

## LOCK RULE

If state ≠ READY_FOR_GPT_REVIEW:

DO NOT:
- analyze deeply
- create patch
- send to Claude

Return:
INVALID SESSION — DO NOT EXECUTE

---

## READY FOR CLAUDE CONDITIONS

All must be true:

- task clearly defined  
- no conflict between TASK and CODE  
- patch is minimal  
- single file constraint respected  

---

## MID-SESSION UPDATE

If new Lua file is sent:

- reset state to PARTIAL  
- revalidate all inputs  

---

## BULK INPUT RULE

If user provides all inputs in one message:

→ directly go to READY_FOR_GPT_REVIEW

---

## SYSTEM ROLES

- GitHub = source of truth  
- GPT = analysis / decision / control  
- Claude = execution  

---

## OUTPUT RULE

GPT must always return:

- SESSION STATUS  
- CHECKLIST  
- VALIDATION  
- NEXT STEP  

---

## SAFETY MESSAGE

If invalid:

INVALID SESSION — DO NOT EXECUTE
