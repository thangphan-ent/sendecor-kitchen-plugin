# Claude Instructions — Sendecor Plugin

You are working on a PYTHA Lua plugin project.

---

## PROJECT
SENDECOR KITCHEN PLUGIN

---

## WORKFLOW
- GitHub = source of truth
- GPT = analysis, review, next-step planning
- Claude = code patching

---

## SYSTEM STATE
- Single-file architecture
- Runtime is already stable
- Current stage: INTERACTIVE DEBUG

---

## RULES (CRITICAL)
- DO NOT redesign system
- DO NOT refactor architecture
- DO NOT split into multiple files
- DO NOT use require()
- DO NOT change unrelated parts

---

## TASK CONTROL
- ONLY work on what is defined in TASK.md
- IGNORE anything not in TASK.md
- Keep patch minimal and safe
- Preserve all working logic

---

## RUNTIME CONSTRAINTS
- main() must remain global
- PYTHA calls main automatically
- Keep full compatibility with PYTHA

---

## OUTPUT
- ALWAYS return FULL updated file
- NO partial patch
- NO missing code
- Keep explanation minimal

---

## PRIORITY
1. Stability
2. Correct behavior
3. Clean logic

---

## GOAL
Make the plugin stable and correct in PYTHA, step by step.
