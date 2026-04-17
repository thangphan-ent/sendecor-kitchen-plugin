# STATE CHECK — SENDECOR KITCHEN PLUGIN

Use this file at the beginning of every new work session.

---

## 1. CURRENT VERIFIED SOURCE

Editable source:
- `source/sendecor_kitchen.lua`

Deploy/plugin file:
- `plugin/sendecor_kitchen_plugin.lua`

Current rule:
- source is edited first
- plugin file is mirrored after approval

---

## 2. CURRENT VERIFIED CODE STATUS

Verified implementation currently in repo:
- single file structure
- global `main()`
- global `main_run()`
- global `edit_cabinet(...)`
- no `require()`
- minimal module data layer
- module validation
- minimal Run A placement
- placement debug output
- simple block generation

Not yet implemented:
- Run B placement
- corner anchor logic
- axis="y" geometry support
- detailed geometry builders
- grouping
- selection
- highlight

---

## 3. DOCS / CODE RELATION

Status:
- docs may contain planned or older design-state items
- code is the implementation truth
- if conflict exists, follow code

Current known mismatch:
- older docs may describe a more advanced kitchen system than the repo actually contains

---

## 4. CURRENT DEVELOPMENT PHASE

Current phase:
- Recovery Mode

Completed:
- Recovery Step 1

Next expected:
- Recovery Step 2 = Run B placement foundation

---

## 5. SESSION START CHECKLIST

Before doing any task, confirm:
- [ ] current source file opened
- [ ] plugin file identity confirmed
- [ ] docs/code mismatch checked
- [ ] current task is specific
- [ ] done condition is specific
- [ ] regression check exists

If any box is not confirmed:
- stop and audit first

---

## 6. SESSION NOTE TEMPLATE

Date:
Current task:
Current verified source:
Known mismatch:
Patch allowed:
Blocked by:
Next smallest safe step:
