# SENDECOR KITCHEN PLUGIN — PROJECT CONTEXT (SINGLE SOURCE)

---

## 1. PROJECT STATUS

- Layout Engine: RUNNING
- Geometry: STABLE (base / tall / wall)
- Grouping: DONE
- Selection system: DONE
- Highlight system: OPTIONAL
- System stage: INTERACTIVE DEBUG

---

## 2. ARCHITECTURE (LOCKED)

CFG → MODULES → RUNTIME → PLACEMENT → GEOMETRY → GROUPING → MAIN

### RULES (STRICT)

- Single file ONLY
- NO require()
- NO multi-file
- NO large refactor
- ONLY minimal safe patch
- Claude must return FULL FILE

---

## 3. COORDINATE SYSTEM

- X = horizontal (Run direction)
- Y = depth (front = 0)
- Z = height

### GLOBAL RULE

ALL modules MUST align:
- front_y = 0

---

## 4. RUN A (MAIN LINE)

### ORDER (LOCKED)

FRIDGE 820 → DRAWER 930 → SINK 485 → CORNER 680

### BEHAVIOR

- Built along +X
- CORNER = VOID (no cabinet)
- CORNER is anchor for Run B

---

## 5. RUN B (SECOND LINE)

### CURRENT STATE

- Starts from Run A corner
- Currently still linear (X direction)
- NOT yet true L-shape

---

### TARGET ORDER (CRITICAL)

runB_void → wall_2d → tall_mw

---

### ELEMENT RULES

#### 1. runB_void
- type = void
- width = filler_w (default 50)
- MUST always reserve layout space
- debug block optional

#### 2. wall_2d
- MUST belong to Run B (NOT Run A)
- positioned after void
- height = wall_h
- depth = wall_depth

#### 3. tall_mw
- final element of Run B
- full height cabinet

---

### CRITICAL LOGIC

- Run B starts at:
  corner.x + corner.width

- placement is cumulative:
  current_x_b += module.width

---

## 6. WALL SYSTEM

### CURRENT

- wall_2d still referencing Run A (sink)

### TARGET

- wall MUST move into Run B system
- no dependency on Run A

---

## 7. VOID SYSTEM

### Run A Corner
- type = void
- used as transition only

### Run B Void
- type = void
- acts as spacer (parametric future)
- MUST exist even if hidden

---

## 8. GEOMETRY RULES

### BASE
- toe kick included
- door = front_y - door_thickness

### TALL
- split upper / lower door
- divider at wall_h

### WALL
- flap door
- internal shelf
- full width

---

## 9. DEBUG FLAGS

- show_corner_void_block
- show_runB_void_block
- enable_highlight

---

## 10. CURRENT LIMITATIONS

1. Run B NOT true L-shape
2. Wall still tied to Run A (incorrect)
3. Void chưa fully parametric
4. No corner rotation system

---

## 11. NEXT DEVELOPMENT TARGET

### PHASE 1 (NOW)
- Fix Run B order:
  runB_void → wall_2d → tall_mw

### PHASE 2
- Convert Run B → TRUE L-SHAPE (Z axis)
- Introduce corner anchor logic

### PHASE 3
- Parametric spacing system (void = variable)
- Dynamic layout scaling

---

## 12. WORKFLOW

- GitHub = SOURCE OF TRUTH
- GPT = analysis + planning
- Claude = code patching

---

## 13. SYSTEM GOAL

Build a stable kitchen generator:
- Layout correct
- Geometry clean
- Expandable (modules, spacing, AI)

---

END OF CONTEXT