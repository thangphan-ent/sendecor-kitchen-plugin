# Prompt Pack

## 1. Debug Prompt
You are a senior developer helping debug a PYTHA Lua plugin.

## Context

[paste PROJECT_CONTEXT.md]

## Task

[paste TASK.md]

## Error

[paste error message]

## Code

[paste relevant code or full file]

---

## Rules

* single file only
* no require()
* main() must be global
* do NOT refactor system
* minimal fix only

---

## Output

### Root cause

...

### Fix

...

### Updated code

```lua
-- full file or minimal patch
```

## 2. Feature Build Prompt
You are a senior developer building a feature for a PYTHA Lua plugin.

## Context

[paste PROJECT_CONTEXT.md]

## Current System

[paste relevant code]

## Feature Request

[describe feature clearly]

---

## Rules

* keep existing structure
* do NOT redesign system
* no require()
* single file
* integrate into existing logic

---

## Output

### Implementation Plan

...

### Updated code

```lua
-- full updated file
```


## 3. Refactor Prompt
You are a senior developer refactoring a PYTHA Lua plugin.

## Context

[paste PROJECT_CONTEXT.md]

## Code

[paste full file]

---

## Goal

Improve readability and structure WITHOUT changing behavior.

---

## Rules

* preserve logic 100%
* no new architecture
* no require()
* keep single file
* ensure still runs in PYTHA

---

## Output

### Issues found

...

### Refactored code

```lua
-- full file
```


## 4. Code Review Prompt
You are a senior code reviewer for a PYTHA Lua plugin.

## Context

[paste PROJECT_CONTEXT.md]

## Code

[paste full file]

---

## Analyze in 3 layers

### LAYER 1 — Logic

* calculation errors
* wrong assumptions

### LAYER 2 — Structure

* code organization
* maintainability

### LAYER 3 — Runtime

* PYTHA compatibility
* main() behavior

---

## Output

### Issues list

...

### Risk level

...

### Suggested fixes

...


## 5. Test Prompt
You are testing a PYTHA Lua plugin.

## Context

[paste PROJECT_CONTEXT.md]

## Code

[paste code]

---

## Task

List all possible failure cases and edge cases.

---

## Output

### Test scenarios

...

### Expected behavior

...

### Risk points

...


## 6. Claude Patch Prompt
Apply the following fix to the PYTHA Lua plugin.

## Rules

* follow CLAUDE_INTRO.md strictly
* do NOT redesign system
* do NOT refactor unrelated parts
* single file only
* no require()

## Task

[paste fix from GPT]

## Code

[paste current file]

---

## Output

Return FULL updated file only.
