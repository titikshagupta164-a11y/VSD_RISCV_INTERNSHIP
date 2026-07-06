# <img src="https://img.icons8.com/color/48/000000/1-circle.png" width="28"/> Example Software

This example demonstrates how to configure and enable the PWM IP through its memory-mapped registers.

The program sets the PWM period, configures the duty cycle, enables the PWM output, and then continuously generates the waveform.

---

## Register Address Definition

The register addresses are defined in `io.h`.

```c
#define IO_PWM_CTRL      64
#define IO_PWM_PERIOD    68
#define IO_PWM_DUTY      72
#define IO_PWM_STATUS    76
```

These definitions correspond to the memory-mapped PWM registers inside the SoC.

---

## Example Program

```c
#include "io.h"

int main()
{
    // Configure PWM period
    IO_OUT(IO_PWM_PERIOD, 100);

    // Configure duty cycle
    IO_OUT(IO_PWM_DUTY, 40);

    // Enable PWM
    IO_OUT(IO_PWM_CTRL, 1);

    // Keep PWM running
    while (1);

    return 0;
}
```

---

## Program Explanation

### Step 1 : Set PWM Period

```c
IO_OUT(IO_PWM_PERIOD, 100);
```

Sets the PWM period to **100 clock cycles**.

---

### Step 2 : Set Duty Cycle

```c
IO_OUT(IO_PWM_DUTY, 40);
```

Sets the PWM output HIGH for **40 clock cycles**.

Duty Cycle

```text
40 / 100 × 100 = 40%
```

---

### Step 3 : Enable PWM

```c
IO_OUT(IO_PWM_CTRL, 1);
```

Sets bit 0 of the CTRL register, enabling PWM generation.

---

### Step 4 : Keep Program Running

```c
while(1);
```

The processor remains idle while the PWM hardware continuously generates the waveform.

---

# Expected PWM Output

For the configuration

| Register | Value |
|----------|-------|
| PERIOD | 100 |
| DUTY | 40 |
| CTRL | 1 |

the PWM output is

- PWM Enabled
- Period = 100 clock cycles
- HIGH Time = 40 clock cycles
- LOW Time = 60 clock cycles
- Duty Cycle = **40%**

---

## PWM Waveform

```text
PWM_OUT

HIGH  ────────────────
      │               │
      │               │
______│               └────────────────────────

      <---40---><-----------60----------->

         Total Period = 100 clock cycles
```

---

## Compile and Run

From the Firmware directory

```bash
make pwm_test.bram.hex
```

From the RTL directory

```bash
make build
sudo make flash
sudo make terminal
```

---

## Expected Behaviour

After programming the FPGA,

- The PWM hardware begins generating the waveform immediately.
- The PWM output remains enabled until CTRL is cleared.
- The output frequency depends on the programmed PERIOD value.
- The duty cycle depends on the DUTY register value.

No additional CPU intervention is required once the PWM has been configured.
