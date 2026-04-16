# PROJECT CONTEXT — SENDECOR KITCHEN PLUGIN

---

## 1. PROJECT OVERVIEW

Plugin for generating kitchen cabinets in PYTHA using Lua.

System builds:
- Base cabinets
- Tall cabinets
- Wall cabinets

Layout:
- L-shape kitchen (Run A + Run B)

---

## 2. CURRENT SYSTEM STATUS

### Core
- Layout Engine: DONE
- Grouping: DONE
- Selection (select_module): DONE
- Highlight system: DONE
- Runtime: STABLE (no crash)

### Placement
- Run A: extends along X axis → ✅ CORRECT
- Run B: extends along Y axis → ✅ CORRECT

### Geometry
- Run A: correct
- Run B: ❌ NOT rotated (still uses X-axis logic)

---

## 3. ARCHITECTURE (LOCKED)

1. CFG
2. modules
3. runtime (rt)
4. placement
5. geometry (base / tall / wall)
6. grouping
7. main()

---

## 4. CURRENT LAYOUT LOGIC

### Run A
- Direction: +X
- Sequence:
  fridge → drawer → sink → corner

### Run B
- Anchor: end of corner (Run A)
- Direction: +Y
- Sequence:
  runB_void → wall_2d → tall_mw

---

## 5. PLACEMENT RULES

- Run A:
  - X accumulates using module.width
  - Y = front_y + depth

- Run B:
  - X is fixed at corner anchor
  - Y accumulates using module.width
  - front_y shifts per module

- void:
  - always reserves layout space
  - debug block optional

---

## 6. GEOMETRY RULES (CURRENT)

### Default (Run A)
- width → X direction
- depth → Y direction

### Missing (Run B)
- ❌ No axis handling yet
- ❌ Geometry still assumes X-axis

---

## 7. CURRENT PROBLEM

Run B placement is correct, but geometry is not rotated.

Result:
- Modules overlap incorrectly in spatial logic
- System is NOT a true L-shape

---

## 8. TARGET STATE

- Run A: unchanged
- Run B:
  - modules extend along Y axis
  - depth extrudes along X axis
  - true L-shape achieved

---

## 9. ACTIVE RULES (CRITICAL)

- SINGLE FILE ONLY
- NO require()
- DO NOT refactor architecture
- DO NOT modify geometry logic beyond minimal patch
- ALWAYS prefer stability over features

---

## 10. COMPLETED MILESTONES

- Layout Engine V1
- Grouping system
- Selection system
- Highlight system
- Run B placement conversion (X → Y)

---

## 11. NEXT DEVELOPMENT STEP

Fix geometry orientation for Run B:
- Add axis="y" support in builders
- Apply ONLY to Run B
- Keep Run A unchanged

---

## 12. KNOWN LIMITATIONS

- No axis abstraction in geometry
- No true L-shape rendering yet
- Highlight assumes X-axis (may be incorrect for Run B)

---
