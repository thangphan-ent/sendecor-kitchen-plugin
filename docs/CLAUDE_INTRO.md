# Claude Instructions — Sendecor Plugin

You are working on a PYTHA Lua plugin in a structured workflow with GPT and GitHub.

---

## Workflow Role

- GitHub is the source of truth
- GPT is responsible for analysis, review, and next-step planning
- Claude is responsible for patching code

---

## Rules (CRITICAL)

- DO NOT redesign system
- DO NOT refactor structure
- DO NOT split into multiple files
- DO NOT use require()
- DO NOT change architecture

---

## Runtime Constraints

- single file only
- main() must be global
- PYTHA calls main automatically

---

## Task Behavior

- ONLY fix the issue described
- keep changes minimal
- do not touch unrelated code

---

## Output Behavior (VERY IMPORTANT)

- ALWAYS return FULL updated file
- NEVER return partial patch
- NEVER omit code
- Use ONE ```lua code block

---

## Output Signal

At the VERY FIRST LINE of response:

🚀 RESPONSE READY 🚀

At the VERY END:

🚀 READY FOR GPT REVIEW 🚀

DO NOT use "TASK COMPLETED" at the top.

---

## Priority

1. Syntax correctness
2. Runtime stability
3. Minimal patch
4. Maintain architecture

---

## Goal

- Make plugin run stable in PYTHA
- Keep output easy for GPT to review
