# TASK — SENDECOR KITCHEN PLUGIN

---

## 1. CURRENT OBJECTIVE

Fix Run B structure to match correct kitchen logic and prepare for L-shape conversion.

---

## 2. REQUIRED CHANGE (CRITICAL)

### Update Run B order to:

runB_void → wall_2d → tall_mw

---

## 3. CURRENT PROBLEM

- wall_2d is NOT part of Run B sequence
- wall is still anchored to Run A (sink) → WRONG
- Run B layout is not logically correct
- System not ready for L-shape conversion

---

## 4. TARGET BEHAVIOR

### 4.1 runB_void
- MUST be first element in Run B
- ALWAYS reserve layout space
- Debug block optional (controlled by CFG)

---

### 4.2 wall_2d
- MUST belong to Run B
- MUST be placed AFTER runB_void
- MUST NOT depend on Run A
- Use placement from Run B system

---

### 4.3 tall_mw
- MUST be placed AFTER wall_2d
- Use existing tall geometry
- No change in geometry logic

---

## 5. IMPLEMENTATION RULES (STRICT)

- DO NOT refactor architecture
- DO NOT split file
- DO NOT introduce require()
- DO NOT change geometry system
- ONLY update placement logic + main loop if needed
- KEEP system stable

---

## 6. PATCH SCOPE

Claude MUST update:

### A. placement.build_layout()
- Add wall_2d into Run B sequence
- Remove dependency on Run A (sink)
- Ensure order:
  runB_void → wall_2d → tall_mw

---

### B. main()
- Ensure wall_2d is built under Run B (NOT wall loop)
- Remove old wall loop if no longer needed OR keep but not used

---

## 7. OUTPUT REQUIREMENT

Claude MUST:

- Return FULL FILE
- No partial patch
- No missing code
- No explanation (or minimal)
- Code MUST run in PYTHA without error

---

## 8. VALIDATION CHECK (VERY IMPORTANT)

After patch, system must satisfy:

- Run B order is correct
- wall_2d appears in correct position
- No overlap between modules
- No runtime error
- Grouping still works
- select_module() still works

---

## 9. NEXT STEP (DO NOT IMPLEMENT YET)

After this task:

→ Convert Run B into TRUE L-SHAPE (Z axis)

---

END OF TASK