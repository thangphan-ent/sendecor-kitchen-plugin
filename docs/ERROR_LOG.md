# ERROR LOG — SENDECOR KITCHEN PLUGIN

---

## RULE

- ONLY log REAL errors from PYTHA or runtime
- DO NOT log assumptions
- EACH error = 1 entry
- KEEP SHORT + CLEAR

---

## FORMAT

[DATE] — [TYPE] — [MODULE]

DESCRIPTION:
<what happened>

EXPECTED:
<what should happen>

ACTUAL:
<what actually happened>

STATUS:
OPEN / FIXED

---

## LOGS

---

### [2026-04-16] — LOGIC — RUN B ORDER

DESCRIPTION:
Run B order is incorrect. wall_2d is not part of Run B sequence.

EXPECTED:
runB_void → wall_2d → tall_mw

ACTUAL:
runB_void → tall_mw  
wall_2d is built separately using Run A reference (sink)

STATUS:
OPEN

---

### [2026-04-16] — STRUCTURE — WALL DEPENDENCY

DESCRIPTION:
wall_2d is anchored to Run A (sink module)

EXPECTED:
wall_2d should belong to Run B and be placed sequentially

ACTUAL:
wall uses:
ref = placed.runA["sink"]

STATUS:
OPEN

---

### [2026-04-16] — LAYOUT — RUN B NOT L-SHAPE

DESCRIPTION:
Run B is still linear along X axis

EXPECTED:
Run B should form L-shape (rotate along Z axis from corner)

ACTUAL:
Run B extends straight along X

STATUS:
OPEN

---

### [2026-04-16] — DEBUG — VOID HANDLING

DESCRIPTION:
runB_void sometimes only used for debug block, not true layout spacer

EXPECTED:
void must ALWAYS reserve layout width

ACTUAL:
behavior depends on show_runB_void_block flag

STATUS:
OPEN

---

## NOTES

- All errors above are blocking correct kitchen layout
- MUST fix Run B before implementing L-shape
- DO NOT attempt geometry changes before placement is correct

---

END OF LOG