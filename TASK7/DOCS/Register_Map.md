# <img src="https://img.icons8.com/color/48/000000/1-circle.png" width="28"/> Register Map

The PWM IP is implemented as a memory-mapped peripheral. Software configures the PWM output by accessing four 32-bit registers through the processor's memory bus.

- **Base Address:** `0x00400040`
- **Bus Width:** 32-bit (word-aligned)
- **Addressing Scheme:** Base Address + Register Offset

---

## Register Summary

| Offset | Absolute Address | Register | R/W | Description |
|:------:|:----------------:|:--------:|:---:|-------------|
| `0x00` | `0x400040` | CTRL | R/W | PWM enable control register |
| `0x04` | `0x400044` | PERIOD | R/W | PWM period register |
| `0x08` | `0x400048` | DUTY | R/W | PWM duty cycle register |
| `0x0C` | `0x40004C` | STATUS | R | PWM status register |

---

# CTRL : Control Register (Offset 0x00)

- **Address:** `0x00400040`
- **Access:** Read / Write
- **Reset Value:** `0x00000000`

| Bits | Field | R/W | Reset | Description |
|:---:|:------|:---:|:-----:|-------------|
| 0 | EN | R/W | 0 | Enables PWM output when set to 1 |
| 31:1 | Reserved | — | 0 | Reserved |

> **Note:**  
> Writing **EN = 1** enables PWM waveform generation.  
> Writing **EN = 0** immediately disables the PWM output.

---

# PERIOD : Period Register (Offset 0x04)

- **Address:** `0x00400044`
- **Access:** Read / Write
- **Reset Value:** `0x00000000`

| Bits | Field | R/W | Reset | Description |
|:---:|:------|:---:|:-----:|-------------|
| 31:0 | PERIOD | R/W | 0 | Specifies the maximum counter value before the PWM counter resets |

> **Note:**  
> Increasing the PERIOD value decreases the PWM output frequency.

---

# DUTY : Duty Cycle Register (Offset 0x08)

- **Address:** `0x00400048`
- **Access:** Read / Write
- **Reset Value:** `0x00000000`

| Bits | Field | R/W | Reset | Description |
|:---:|:------|:---:|:-----:|-------------|
| 31:0 | DUTY | R/W | 0 | Number of clock cycles for which the PWM output remains HIGH |

> **Note:**  
> The DUTY value should not exceed the PERIOD value.  
> If **DUTY ≥ PERIOD**, the PWM output remains HIGH throughout the entire PWM period.

---

# STATUS : Status Register (Offset 0x0C)

- **Address:** `0x0040004C`
- **Access:** Read Only
- **Reset Value:** `0x00000000`

| Bits | Field | R/W | Reset | Description |
|:---:|:------|:---:|:-----:|-------------|
| 0 | EN | R | 0 | Reflects the current value of CTRL[0] (PWM Enable) |
| 31:1 | Reserved | — | 0 | Reserved |

> **Note:**  
> STATUS[0] reflects whether PWM generation is currently enabled.

---

# PWM Frequency

The PWM frequency depends on the programmed PERIOD register.

```text
PWM Frequency = System Clock / PERIOD
```

Example:

| System Clock | PERIOD | PWM Frequency |
|--------------|--------|---------------|
| 12 MHz | 100 | 120 kHz |
| 12 MHz | 1000 | 12 kHz |
| 12 MHz | 10000 | 1.2 kHz |

---

# Duty Cycle Calculation

The duty cycle is determined by comparing the internal counter with the DUTY register.

```text
Duty Cycle (%) = (DUTY / PERIOD) × 100
```

Example:

| PERIOD | DUTY | Duty Cycle |
|---------|------|------------|
| 100 | 25 | 25% |
| 100 | 40 | 40% |
| 100 | 50 | 50% |
| 100 | 75 | 75% |
| 100 | 100 | 100% |

---

# Register Programming Sequence

The PWM controller is programmed using the following sequence:

1. Write the desired PWM period to the **PERIOD** register.
2. Write the desired duty cycle to the **DUTY** register.
3. Enable PWM by writing **1** to the **CTRL** register.
4. The PWM output immediately starts generating the configured waveform.

---

# Example Register Configuration

```c
#include "io.h"

int main()
{
    IO_OUT(IO_PWM_PERIOD, 100);   // Set PWM period
    IO_OUT(IO_PWM_DUTY, 40);      // Set HIGH time
    IO_OUT(IO_PWM_CTRL, 1);       // Enable PWM

    while (1);

    return 0;
}
```

This configuration produces:

- **System Clock:** 12 MHz
- **PERIOD:** 100 clock cycles
- **DUTY:** 40 clock cycles
- **Duty Cycle:** 40%
- **PWM Frequency:** 120 kHz
- **PWM Output:** Enabled
