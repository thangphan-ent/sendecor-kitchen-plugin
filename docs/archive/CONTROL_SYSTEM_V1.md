# ⚠️ ARCHIVED — DO NOT USE

This control system is deprecated.

It is kept for reference only.

DO NOT use this file for:
- prompt generation
- execution
- control decisions

Active control system:
→ docs/CONTROL_SYSTEM.md

---
# CONTROL SYSTEM V1 — SENDECOR KITCHEN PLUGIN

---

## 1. PURPOSE

This document defines a lightweight control system to manage GPT + Claude workflow.

Goal:
- Prevent wrong task execution
- Avoid context drift
- Reduce error loops
- Keep system stable during long sessions

---

## 2. CORE PRINCIPLE

DO NOT let any AI act without control.

Workflow must always be:

User → GPT (Control) → Claude (Execution) → GPT (Review) → GitHub

---

## 3. AI ROLE DEFINITION

### GPT (CONTROL LAYER)

Responsible for:
- Task classification
- Decision making
- Prompt generation
- Output review
- Risk control

GPT must NOT:
- Write final production code (Claude does this)
- Skip classification step
- Send unclear task to Claude

---

### CLAUDE (EXECUTION LAYER)

Responsible for:
- Writing code
- Applying patches
- Implementing features

Claude must:
- Follow prompt strictly
- Not redesign system
- Not refactor beyond task

---

### GITHUB (SOURCE OF TRUTH)

- Only store verified code
- Never store unreviewed output
- Maintain stable versions

---

## 4. TASK CLASSIFICATION (MANDATORY)

Every task MUST be classified before execution.

### TYPE 1 — PATCH
Fix bug or incorrect behavior

Keywords:
- fix
- error
- wrong
- not working

---

### TYPE 2 — BUILD
Add new feature or capability

Keywords:
- add
- create
- support
- implement

---

### TYPE 3 — REVIEW
Analyze system or code

Keywords:
- review
- analyze
- check
- evaluate

---

### TYPE 4 — TEST
Find edge cases or risks

Keywords:
- test
- edge case
- failure
- scenario

---

### TYPE 5 — BLOCK
Do NOT proceed

Conditions:
- Missing code
- Missing context
- Mixed task types
- Unclear objective

---

## 5. SESSION TYPES

Each session MUST have ONE purpose only.

### PATCH SESSION
- Use for bug fixing only
- Minimal safe change
- No feature addition

---

### BUILD SESSION
- Use for new feature
- Keep existing structure
- No redesign

---

### REVIEW SESSION
- No coding
- Only analysis

---

### TEST SESSION
- No code change
- Only risk detection

---

## 6. GPT GATE CHECK (BEFORE CLAUDE)

GPT must verify:

1. Task type is clear
2. Only ONE objective exists
3. Context is sufficient
4. Code is provided if needed
5. Rules are clearly defined
6. Risk is understood

If ANY condition fails → BLOCK

---

## 7. STOP RULES

STOP immediately if:

- Task mixes PATCH + BUILD
- No full code but attempting patch
- Error is assumption, not real behavior
- Claude output not reviewed yet
- Session becomes too long / confusing

---

## 8. EXECUTION FLOW

### STANDARD FLOW

1. User request
2. GPT classify task
3. GPT apply gate check
4. GPT generate Claude prompt
5. Claude executes
6. GPT reviews output
7. If valid → update GitHub

---

## 9. REVIEW REQUIREMENT

ALWAYS review before:

- Updating GitHub
- Continuing next task
- Applying multiple patches

---

## 10. TEST REQUIREMENT

Use TEST SESSION when:

- Placement logic changes
- Run A / Run B logic changes
- Corner / sequence logic changes
- Dimension / layout constraints involved

---

## 11. GITHUB RULES

- Only verified code is committed
- Always keep working version
- Do NOT overwrite blindly
- Maintain rollback ability

---

## 12. PRACTICAL RULES FOR SENDECOR

### CRITICAL AREAS (Require Review First)

- Run B logic
- Corner / Void logic
- Sequence (Void → Wall → Tall)
- Placement chain

---

### SAFE AREAS

- UI tweaks
- Debug prints
- Minor geometry fix

---

## 13. QUICK USAGE TEMPLATE

### GPT OUTPUT FORMAT

Task type:
<type>

Why:
<reason>

Risks:
<risk>

Next step:
<action>

Claude prompt:
<generated prompt>

---

## 14. FINAL NOTE

This system is intentionally SIMPLE.

It does NOT:
- change plugin architecture
- slow down development
- add heavy process

It ONLY:
- prevents mistakes
- improves consistency
- protects project stability

---

END OF FILE
