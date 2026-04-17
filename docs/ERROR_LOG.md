# ERROR LOG — SENDECOR KITCHEN PLUGIN

---

## GIẢI THÍCH (VI)

- File này dùng để ghi lại các lỗi THỰC TẾ trong hệ thống (logic, layout, runtime)
- Mỗi lỗi phải rõ ràng: xảy ra cái gì, mong muốn gì, thực tế ra sao
- Đây là "nguồn sự thật" để GPT quyết định bước tiếp theo
- Claude chỉ được fix dựa trên các lỗi đã ghi tại đây

---

## RULE

- ONLY log REAL errors from PYTHA or runtime  
  → Chỉ ghi lỗi thực sự xảy ra, không suy đoán  

- DO NOT log assumptions  
  → Không ghi giả định hoặc nghi ngờ  

- EACH error = 1 entry  
  → Mỗi lỗi là 1 block riêng biệt  

- KEEP SHORT + CLEAR  
  → Ngắn gọn, rõ ràng, dễ đọc  

---

## FORMAT

[DATE] — [TYPE] — [MODULE]

DESCRIPTION:
<what happened>  
→ Mô tả lỗi xảy ra  

EXPECTED:
<what should happen>  
→ Hành vi đúng mong muốn  

ACTUAL:
<what actually happened>  
→ Kết quả thực tế  

STATUS:
OPEN / FIXED  
→ OPEN: chưa xử lý  
→ FIXED: đã xác nhận sửa xong  

---

## LOGS

---

### [2026-04-16] — LOGIC — RUN B SEQUENCE

DESCRIPTION:
Run B sequence is not fully consistent as a unified placement chain.

EXPECTED:
All Run B elements must follow a strict ordered sequence (void → wall → tall).

ACTUAL:
wall_2d is not always treated as part of the same sequential flow.

STATUS:
OPEN

---

### [2026-04-16] — STRUCTURE — WALL DEPENDENCY

DESCRIPTION:
wall_2d still depends on Run A reference logic instead of being owned by Run B.

EXPECTED:
wall_2d must belong to Run B placement system and follow its flow.

ACTUAL:
wall_2d placement still uses cross-run reference (Run A anchor).

STATUS:
OPEN

---

### [2026-04-16] — LAYOUT — CORNER / VOID LOGIC

DESCRIPTION:
Void behavior at corner is not fully stable as layout spacing logic.

EXPECTED:
Void must always act as real layout spacer and define Run A ↔ Run B transition.

ACTUAL:
Void behavior is still partially dependent on debug flags / temporary handling.

STATUS:
OPEN

---

### [2026-04-16] — GEOMETRY — RUN B ROTATION

DESCRIPTION:
Run B modules are not rotated correctly relative to the L-shape corner.

EXPECTED:
Modules must rotate correctly (90°) at the corner to form proper L-shape kitchen.

ACTUAL:
Modules appear unrotated or facing incorrect direction.

STATUS:
OPEN

---

### [2026-04-16] — GEOMETRY — RUN B ORIENTATION

DESCRIPTION:
Run B layout direction is correct, but geometry logic still behaves like Run A.

EXPECTED:
Run B geometry must follow Y-axis orientation logic.

ACTUAL:
Modules in Run B still use X-axis style geometry.

STATUS:
OPEN

---

### [2026-04-16] — LAYOUT — RUN B AXIS DIRECTION

DESCRIPTION:
Previous issue reported Run B extending along X axis.

EXPECTED:
Run B must extend along Y axis.

ACTUAL:
Recent verified state confirms Run B axis direction is already corrected.

STATUS:
FIXED

---

### [2026-04-16] — RUNTIME — CORE SYSTEM STABILITY

DESCRIPTION:
Core systems (runtime, grouping, selection, highlight) were unstable in earlier phases.

EXPECTED:
System should run stable in PYTHA.

ACTUAL:
Recent sessions confirm runtime is stable with no crash.

STATUS:
FIXED

---

## PRIORITY (CURRENT)

1. wall_2d dependency cleanup  
2. stable Run B sequence  
3. corner / void behavior  
4. Run B rotation  
5. Run B geometry orientation  

---

## NOTES

- DO NOT reopen axis direction issue unless regression appears  
- FIX placement logic BEFORE geometry refinement  
- KEEP all fixes minimal (single file, no refactor)  

---

END OF LOG
