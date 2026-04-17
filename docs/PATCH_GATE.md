# PATCH GATE — SENDECOR KITCHEN PLUGIN

No patch should begin until this template is fully filled.

---

## PATCH REQUEST TEMPLATE

### BUG
Describe the current bug in one sentence only.

### ROOT CAUSE
Describe the confirmed root cause from current code only.

### CURRENT EVIDENCE
List exact evidence from the current source file.

### DONE WHEN
Define observable completion criteria.

### DO NOT TOUCH
List the parts that must remain unchanged.

### REGRESSION CHECK
List what must still work after the patch.

### PATCH SCOPE
State the exact smallest scope of change.

---

## REQUIRED EXAMPLE

### BUG
Run B placement does not exist in current code.

### ROOT CAUSE
Current repo code only supports minimal Run A placement foundation.

### CURRENT EVIDENCE
- module data exists
- validation exists
- Run A placement exists
- no Run B placement function exists

### DONE WHEN
- Run B module list exists
- Run B placement function exists
- placements accumulate along +Y
- main() still runs safely

### DO NOT TOUCH
- config.xml
- main() global status
- single file structure
- no require()

### REGRESSION CHECK
- Run A placement still works
- plugin entry points still exist
- invalid module still skips safely

### PATCH SCOPE
Add only minimal Run B placement foundation.
No geometry rotation yet.
No grouping.
No UI.

---

## REJECTION RULES

Reject the patch request if:
- bug is vague
- root cause is not proven from code
- done condition is vague
- scope is too large
- task assumes non-existing systems are already implemented

---

## APPROVAL RULES

A patch is approved only if:
- current source was verified first
- task is small and concrete
- regression check is clear
- output can be reviewed in logic / structure / runtime
