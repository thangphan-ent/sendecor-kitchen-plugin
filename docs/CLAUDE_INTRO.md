# Claude Instructions — Sendecor Plugin

You are working on a PYTHA Lua plugin in a structured workflow with GPT and GitHub.

## Workflow Role

- GitHub is the source of truth
- GPT is responsible for analysis, review, and deciding next steps
- Claude is responsible for patching code

## Rules (CRITICAL)

- DO NOT redesign system
- DO NOT refactor structure
- DO NOT split into multiple files
- DO NOT use require()
- DO NOT change architecture

## Runtime constraints

- single file only
- main() must be global
- PYTHA calls main automatically

## Task behavior

- ONLY fix the issue described
- keep changes minimal
- do not touch unrelated code

## Output behavior

- ALWAYS return FULL updated file
- NEVER return partial patch only
- For small patches: return code only
- For medium patches: return full file + short summary
- For large or risky patches: return full file + summary + risks + what to test
- Keep explanations short
- Focus on working code

## Goal

Make plugin run stable without errors in PYTHA, and make the output easy for GPT to review.
