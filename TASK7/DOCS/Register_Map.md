# <img src="https://img.icons8.com/color/48/000000/1-circle.png" width="28"/> Register Map

- **Base Address:** `0x00400040`
- **Bus Width:** 32-bit, word-aligned
- **Addressing:** Base + Offset

---

## Register Summary

| Offset Address | Absolute Address | Register | R/W | Description |
|---------------|------------------|----------|-----|-------------|
| 0x00 | 0x400040 | CTRL | R/W | Enable PWM output |
| 0x04 | 0x400044 | PERIOD | R/W | Sets PWM period |
| 0x08 | 0x400048 | DUTY | R/W | Sets PWM duty cycle |
| 0x0C | 0x40004C | STATUS | R | PWM enable status |

---

# CTRL : Control Register (Offset 0x00)

- **Address:** `0x00400040`
- **Access:** Read / Write
- **Reset Value:** `0x00000000`

| Bits | Field | R/W | Reset | Description |
|------|-------|-----|-------|-------------|
| 0 | EN | R/W | 0 | Enables PWM output when set to 1 |
| 31:1 | Reserved | - | 0 | Reserved |

> **Note:** Writing **EN = 1** starts PWM generation. Writing **EN = 0** immediately disables PWM output.

---

# PERIOD : Period Register (Offset 0x04)

- **Address:** `0x00400044`
- **Access:** Read / Write
- **Reset Value:** `0x00000000`

| Bits | Field | R/W | Reset | Description |
|------|-------|-----|-------|-------------|
| 31:0 | PERIOD | R/W | 0 | Number of clock cycles in one PWM period |

> **Note:** Larger PERIOD values generate lower PWM frequencies.

---

# DUTY : Duty Cycle Register (Offset 0x08)

- **Address:** `0x00400048`
- **Access:** Read / Write
- **Reset Value:** `0x00000000`

| Bits | Field | R/W | Reset | Description |
|------|-------|-----|-------|-------------|
| 31:0 | DUTY | R/W | 0 | Number of clock cycles PWM output remains HIGH |

> **Note:** DUTY should normally be less than or equal to PERIOD. If DUTY equals PERIOD, the PWM output remains HIGH for the entire period.

---

# STATUS : Status Register (Offset 0x0C)

- **Address:** `0x0040004C`
- **Access:** Read Only
- **Reset Value:** `0x00000000`

| Bits | Field | R/W | Reset | Description |
|------|-------|-----|-------|-------------|
| 0 | EN_STATUS | R | 0 | Reflects current PWM enable state |
| 31:1 | Reserved | - | 0 | Reserved |

> **Note:** STATUS[0] reflects the current state of the PWM enable bit. A value of **1** indicates PWM generation is active.

---

# Register Programming Sequence

The PWM IP is configured through the following sequence:

1. Write the desired PWM period to the **PERIOD** register.
2. Write the desired duty cycle to the **DUTY** register.
3. Enable PWM by writing **1** to the **CTRL** register.
4. Read the **STATUS** register to verify that PWM output is enabled.

---

# Example Register Configuration

```c
IO_OUT(IO_PWM_PERIOD,100);   // PWM period
IO_OUT(IO_PWM_DUTY,40);      // 40% duty cycle
IO_OUT(IO_PWM_CTRL,1);       // Enable PWM
```

The above configuration generates a PWM waveform with:

- **Period:** 100 clock cycles
- **Duty Cycle:** 40 clock cycles HIGH
- **Output:** Enabled
