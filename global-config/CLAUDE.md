# CLAUDE.md — Global Configuration
# วางไฟล์นี้ที่: ~/.claude/CLAUDE.md
# Claude Code จะอ่านไฟล์นี้ทุก session โดยอัตโนมัติ

---

## 🤖 Model Strategy (Sonnet + Opus Advisor)

### Default Model
ใช้ **Sonnet** เป็น default สำหรับงานทั่วไป

### เมื่อไหร่ให้สลับไป Opus (advisor / opusplan)
- วางแผน architecture หรือออกแบบระบบใหม่
- debug ปัญหาซับซ้อนที่เชื่อมหลาย file หรือหลาย service
- review code ก่อน deploy หรือก่อน commit สำคัญ
- งานที่เกี่ยวกับ security, authentication, authorization
- ตัดสินใจเลือก pattern หรือ library ที่ส่งผลระยะยาว

### เมื่อไหร่ให้ใช้ Sonnet (executor)
- implement feature ตาม plan ที่วางไว้แล้ว
- refactor ที่ scope ชัดเจนและจำกัด
- เขียน test จาก spec ที่มีอยู่แล้ว
- แก้ bug ที่รู้สาเหตุชัดเจนแล้ว

### เมื่อไหร่ให้ใช้ Haiku
- แก้ typo, rename variable, จัด format
- งานซ้ำๆ ที่ไม่ต้องคิด เช่น generate boilerplate ง่ายๆ
- ค้นหาหรือสรุปข้อมูลสั้นๆ

### วิธีสลับ model ใน Claude Code
```
/model opus        ← สลับไป Opus สำหรับ session นี้
/model sonnet      ← กลับมา Sonnet
/advisor           ← เปิด Opus ไว้เป็น advisor ตลอด session
opusplan           ← Opus วางแผน → Sonnet execute อัตโนมัติ
```

---

## 🧠 วิธีทำงานร่วมกัน (Working Style)

### อธิบายก่อนทำเสมอ
ก่อนลงมือเขียน code หรือแก้ไขไฟล์ ให้อธิบายก่อนว่า:
1. เข้าใจ task ว่าอะไร
2. จะทำอะไรบ้าง (plan)
3. มีความเสี่ยงหรือ side effect อะไรมั้ย

รอให้ confirm ก่อนค่อยทำ ยกเว้น task เล็กมากที่ชัดเจน

### ทำทีละขั้น
สำหรับงาน maintenance หรืองานที่กระทบระบบที่ใช้งานอยู่ ให้แบ่งเป็น step เล็กๆ แล้วรอ confirm ทีละ step

### Debug — หา root cause ก่อน
เวลา debug ให้อธิบาย root cause ให้ชัดก่อนเสมอ ไม่ใช่แค่แก้อาการ ให้บอกว่า:
- สาเหตุที่แท้จริงคืออะไร
- fix นี้แก้ที่ต้นเหตุหรือแค่อาการ
- มีจุดอื่นที่อาจเกิดปัญหาเดียวกันมั้ย

---

## 📝 Code Style & Comments

### Comment ภาษาไทย
เขียน comment อธิบายแต่ละส่วนเป็นภาษาไทย เพื่อให้เข้าใจง่ายตอน review:

```python
# ตรวจสอบว่า user มีสิทธิ์เข้าถึง resource นี้มั้ย
def check_permission(user_id, resource_id):
    ...

# คำนวณราคารวมหลังหักส่วนลดและภาษี
def calculate_total(items, discount, tax_rate):
    ...
```

### สิ่งที่ควรมี comment เสมอ
- function/method ที่ logic ซับซ้อนกว่า 10 บรรทัด
- การตัดสินใจที่ไม่ obvious (เช่น ทำไมถึงเลือก approach นี้)
- workaround หรือ hotfix ที่ดูแปลก ให้อธิบายว่าทำไม
- business logic สำคัญ

### สิ่งที่ไม่ต้อง comment
- สิ่งที่ code อ่านออกเองอยู่แล้ว เช่น `i += 1  # เพิ่ม i ขึ้น 1`

### Code Quality
- ใช้ชื่อตัวแปรและ function ที่สื่อความหมาย ไม่ใช้ชื่อย่อที่เข้าใจยาก
- หลีกเลี่ยง magic number — ใช้ constant ที่มีชื่อแทน
- function ควรทำสิ่งเดียว (single responsibility)
- ถ้า function ยาวเกิน 50 บรรทัด ให้แนะนำว่าควร refactor มั้ย

---

## 🌐 Stack & Technology

### แนวทางการเลือก Stack
ปรับตาม project ที่ทำงานอยู่ แต่ถ้าไม่มี constraint ให้ prefer:

**Backend / Web Server**
- Python + FastAPI (modern, async, type-safe)
- Node.js + Express หรือ Fastify (ถ้า project เป็น JS)

**Frontend / Web App**
- Next.js (full-stack JS, ตลาดงานใหญ่)
- HTML/CSS/Vanilla JS สำหรับงานเล็กหรือ static

**Database**
- PostgreSQL เป็น default สำหรับ relational data
- SQLite สำหรับ development local หรือ project เล็ก

**ของเก่าที่บริษัทใช้**
ถ้า project ใช้ stack เก่า (เช่น PHP, jQuery, legacy Python) ให้ทำงานตาม stack นั้น ไม่ต้องพยายามเปลี่ยน แต่แนะนำ improvement ได้ถ้าถาม

---

## 🔒 Security Rules

งานที่เกี่ยวข้องกับส่วนต่อไปนี้ ให้ใช้ Opus review เสมอ:
- Authentication / Authorization
- Password hashing / Token management
- SQL queries (ระวัง SQL injection)
- File upload / User input validation
- Environment variables และ secrets

### ห้ามทำเด็ดขาด
- hardcode password, API key, หรือ secret ใน code
- log ข้อมูล sensitive เช่น password หรือ token
- trust user input โดยไม่ validate ก่อน

---

## ⚠️ Safety Rules (สำคัญมาก)

### ต้อง Confirm ก่อนทำ
- **ลบไฟล์หรือ directory** — ห้ามลบโดยไม่ถามก่อน
- **Overwrite ไฟล์ที่มีอยู่แล้ว** — บอกก่อนเสมอว่าจะ overwrite
- **Run database migration** — ต้องบอกผลกระทบและรอ confirm
- **แก้ไข config file** เช่น .env, docker-compose, nginx config
- **Install dependency ใหม่** — บอกก่อนว่าจะ install อะไรและทำไม

### งาน Maintenance — Extra Careful
ถ้า context บอกว่าเป็น production หรือระบบที่ใช้งานจริง ให้ระมัดระวังเป็นพิเศษ แนะนำ backup ก่อนทำการเปลี่ยนแปลงสำคัญ

---

## 🧪 Testing

### เมื่อไหร่ให้เขียน test
- feature ใหม่ที่ logic ซับซ้อน
- bug fix — เขียน test ที่ reproduce bug ก่อน แล้วค่อยแก้
- function ที่ถูกเรียกใช้จากหลายที่

### เมื่อไหร่ไม่ต้องเขียน (ถ้าไม่ได้ถาม)
- boilerplate หรือ scaffold code
- งาน prototype หรือ POC

### Test Framework
ใช้ตามที่ project กำหนด ถ้าไม่มี:
- Python → pytest
- JavaScript → Jest หรือ Vitest

---

## 📁 Git Convention

### Commit Message (Conventional Commits)
```
feat: เพิ่ม login ด้วย Google OAuth
fix: แก้ bug การคำนวณภาษีเมื่อ discount เป็น 0
refactor: แยก payment logic ออกมาเป็น service แยก
docs: อัปเดต README วิธีติดตั้ง
chore: อัปเดต dependency
```

### ก่อน commit
ถ้าถามให้ช่วย commit ให้ summarize การเปลี่ยนแปลงและเสนอ commit message ให้เลือกก่อน

---

## 📌 หมายเหตุ

ไฟล์นี้เป็น global config — ถ้า project ไหนมี CLAUDE.md ของตัวเอง
ให้ใช้ project-level config เป็นหลัก และ merge กับ global นี้
