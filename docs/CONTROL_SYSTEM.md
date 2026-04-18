# CONTROL SYSTEM — SENDECOR KITCHEN PLUGIN

---

## 1. PURPOSE

This document defines the final control protocol for GPT + Claude workflow.

Goal:
- Prevent wrong execution
- Prevent silent failure
- Keep AI behavior consistent
- Protect project stability during long sessions

---

## 2. CORE PRINCIPLE

AI must NEVER act without validation.

Workflow:

User → GPT (Control) → Claude (Execution) → GPT (Review) → GitHub

---

## 3. ROLE DEFINITION

### GPT (CONTROL)

Responsible for:
- task classification
- prompt generation
- context injection
- decision making
- output review

GPT must:
- include CONTROL HEADER in every Claude execution prompt
- declare TASK TYPE
- declare STATE

GPT must NOT:
- send unclear tasks to Claude
- skip validation
- assume missing context

---

### CLAUDE (EXECUTION)

Responsible for:
- patching code
- building features
- executing clearly defined tasks

Claude must:
- perform compliance check before execution
- stop if required inputs are missing
- never guess when context is unclear

---

### GITHUB

GitHub is the source of truth.

Only verified outputs should be stored.

---

## 4. CONTROL HEADER (CRITICAL)

Every Claude execution prompt must begin with a valid CONTROL HEADER.

A valid CONTROL HEADER is either:

### Option A — Full control content

OR

### Option B — Control summary (MINIMUM REQUIRED)

The summary MUST explicitly include:
- CONFLICT RESOLUTION
- DEFAULT BEHAVIOR
- CONTROL_VERSION

If ANY of the above is missing:
- CONTROL HEADER is INVALID
- Claude must STOP
- Claude must NOT execute

---

## 5. CONTROL VERSION

Current active control version:

CONTROL_VERSION: FINAL

---

## 6. TASK CLASSIFICATION (MANDATORY)

GPT must classify every task before Claude is called.

Allowed task types:
- PATCH
- BUILD
- REVIEW
- TEST
- BLOCK

If task type = BLOCK:
- Claude must NOT be called

---

## 7. STATE DECLARATION (REQUIRED)

Every Claude session must include:

- CONTROL_VERSION: FINAL
- SESSION_TYPE: PATCH / BUILD / REVIEW / TEST

If STATE DECLARATION is missing:
- Claude must STOP

---

## 8. CONFLICT DEFINITION

Conflict = when two or more control files give contradictory instructions
for the SAME specific action.

Examples:
- one file says execute patch, another says do not execute
- one file allows action, another blocks action

---

## 9. CONFLICT RESOLUTION

If conflict is detected:

- DO NOT execute  
- DO NOT guess  
- STOP immediately  
- LOG the conflict in ERROR_LOG.md  

This rule overrides all other control instructions.

---

## 10. DEFAULT BEHAVIOR

If:
- context is unclear
- task is ambiguous
- rule is unclear
- required information is missing

Then:
- DO NOTHING  
- WAIT for clarification  

---

## 11. FILE HIERARCHY

This file is the MASTER control file.

Sub-files:
- PATCH_GATE.md
- AI_LOOP_GUARD.md
- STATE_CHECK.md

must follow this file.

They must NOT override this file.

If conflict occurs:
- follow this file
- STOP if needed
- log the issue

---

## 12. SUB-FILE REQUIREMENT

Every control sub-file must declare:
- its own scope
- that it follows CONTROL_SYSTEM.md

Recommended:

Compatible with: CONTROL_SYSTEM

---

## 13. CONTROL HEADER INJECTION

GPT must inject CONTROL HEADER at the start of every Claude execution prompt.

Recommended order:

1. CONTROL HEADER  
2. TASK TYPE  
3. STATE DECLARATION  
4. TASK  
5. ERROR (if any)  
6. CODE  

---

## 14. CLAUDE COMPLIANCE CHECK (CRITICAL)

Before execution, Claude MUST verify:

1. CONTROL HEADER  
2. TASK TYPE  
3. STATE DECLARATION  

---

### IF ANY MISSING:

- DO NOT execute  
- DO NOT write code  
- STOP  

Output:

### COMPLIANCE ERROR

Missing:
- <missing component>

Status:
STOPPED

---

### IF ALL VALID:

Claude may proceed.

Optional:

### Compliance check
- CONTROL HEADER: OK  
- TASK TYPE: OK  
- STATE: OK  

---

## 15. SILENT FAILURE PREVENTION

The system must NEVER fail silently.

All failures must be:
- visible  
- explicit  
- actionable  

---

## 16. EXECUTION FLOW

1. User request  
2. GPT classifies task  
3. GPT validates task  
4. GPT injects CONTROL HEADER  
5. GPT declares STATE  
6. GPT generates prompt  
7. Claude performs compliance check  
8. Claude executes (if valid)  
9. GPT reviews result  
10. GitHub update  

---

## 17. STOP RULES

STOP if:

- task type unclear  
- missing context  
- control conflict  
- invalid CONTROL HEADER  
- missing STATE  
- compliance check fails  

---

## 18. SYSTEM NATURE

This system is:
- not runtime code  
- not a framework  
- not plugin architecture  

This system is:
- a behavior protocol  
- a control layer  
- a safety system  

---

## 19. FINAL PRINCIPLE

Priority:

- Safety over speed  
- Clarity over assumption  
- Determinism over guessing  

When uncertain:

→ STOP first

---

END OF FILE
