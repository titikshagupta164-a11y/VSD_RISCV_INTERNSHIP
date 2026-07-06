# <img src="https://img.icons8.com/color/48/000000/1-circle.png" width="28"/> IP Overview

## 🔗 What Is This IP?

The **PWM (Pulse Width Modulation) IP** is a memory-mapped peripheral developed for the **VSDSquadron RISC-V SoC**. It enables software to generate configurable PWM waveforms by controlling the **period**, **duty cycle**, and **output enable** through four memory-mapped registers.

The IP is integrated directly into the processor's memory bus, allowing firmware to configure PWM output using normal memory read and write operations without requiring any dedicated hardware interface.

---

## Purpose

Pulse Width Modulation (PWM) is one of the most commonly used techniques in embedded systems for generating variable duty-cycle digital signals. It is widely used for:

- LED brightness control
- Motor speed control
- Servo motor positioning
- Power electronics
- Switching regulators
- Digital waveform generation

This PWM IP provides a simple and reusable hardware peripheral that can be easily integrated into the VSDSquadron SoC and controlled entirely through software.

---

## Typical Use Cases

- Controlling LED brightness by varying duty cycle
- Driving DC motors with variable speed
- Servo motor control
- Generating digital square waves
- FPGA peripheral demonstrations
- Embedded systems education and experimentation

---

## When to Use This IP

Use this IP whenever an application requires a configurable PWM signal whose frequency and duty cycle can be modified through software.

Typical examples include:

- Embedded control applications
- Robotics
- Motor control
- Lighting systems
- FPGA prototyping
- Hardware/software co-design projects

The IP is designed for simple memory-mapped operation, making it suitable for applications where the processor periodically updates PWM parameters.

---

# <img src="https://img.icons8.com/color/48/000000/2-circle.png" width="28"/> Feature Summary

## Supported Features

- Memory-mapped peripheral interface
- Software programmable Period register
- Software programmable Duty Cycle register
- Enable/Disable control through CTRL register
- 32-bit register interface
- Automatic PWM waveform generation
- Counter-based PWM architecture
- Continuous waveform generation after enabling
- Compatible with VSDSquadron memory bus
- Simple RTL implementation
- Easily reusable as standalone IP
- Synthesizable Verilog design

---

## Register Interface

The PWM controller exposes four memory-mapped registers:

| Register | Purpose |
|-----------|---------|
| CTRL | Enable or disable PWM output |
| PERIOD | Sets PWM period |
| DUTY | Sets PWM duty cycle |
| STATUS | Reports PWM enable status |

---

## Bit Widths

- Memory Interface : 32-bit
- Counter Width : 32-bit
- Duty Register : 32-bit
- Period Register : 32-bit
- Control Register : 32-bit
- Status Register : 32-bit

---

## Clock Assumptions

The PWM controller operates directly from the system clock.

- System Clock : 12 MHz (VSDSquadron default)
- Counter increments every clock cycle
- PWM frequency depends on the programmed PERIOD value

PWM Frequency is approximately:

```
PWM Frequency = System Clock / PERIOD
```

Example:

| PERIOD | PWM Frequency |
|---------|---------------|
| 100 | 120 kHz |
| 1000 | 12 kHz |
| 10000 | 1.2 kHz |

---

## Duty Cycle Calculation

Duty cycle is determined by comparing the internal counter with the DUTY register.

```
Duty Cycle (%) = (DUTY / PERIOD) × 100
```

Example:

| PERIOD | DUTY | Duty Cycle |
|---------|------|------------|
|100|50|50%|
|100|25|25%|
|100|75|75%|
|100|100|100%|

## Design Highlights

- Simple hardware architecture
- Low resource utilization
- Easy software programming
- Memory-mapped interface
- Parameter-free RTL implementation
- Continuous hardware PWM generation
- Suitable for embedded control applications


# <img src="https://img.icons8.com/color/48/000000/3-circle.png" width="28"/> Block Diagram

The following figure illustrates the overall architecture of the PWM IP and its integration with the VSDSquadron RISC-V SoC. The processor accesses the PWM controller through the memory-mapped bus, allowing software to configure the PWM registers. Internally, the controller uses a counter and comparator to generate the PWM waveform based on the programmed period and duty cycle.

<p align="center">
    <img src="../images/pwm_block_diagram.png" width="900">
</p>

<p align="center">
<b>Figure 1.</b> Overall architecture of the PWM IP showing memory-mapped interface, internal PWM logic, and output generation.
</p>

---

## Block Description

The PWM controller is composed of the following functional blocks:

### RISC-V CPU

The processor configures and controls the PWM IP by writing to its memory-mapped registers. Software can enable or disable the PWM output, configure the period, and modify the duty cycle at runtime.

---

### Memory Bus Interface

The PWM IP connects directly to the VSDSquadron SoC memory bus. All register accesses are performed using standard load and store instructions without requiring any special communication protocol.

Signals exchanged with the processor include:

- `mem_addr`
- `mem_wdata`
- `mem_rdata`
- `mem_wstrb`
- `sel`
- `we`

---

### Address Decoder

The address decoder activates the PWM peripheral whenever the processor accesses the PWM address space.

The decoder generates the internal select signal used by the PWM controller while preventing accesses intended for other peripherals.

---

### Memory-Mapped Registers

The controller exposes four software-accessible registers:

| Register | Function |
|----------|----------|
| CTRL | Enables PWM and controls output inversion |
| PERIOD | Defines the PWM period |
| DUTY | Defines the HIGH time of the PWM signal |
| STATUS | Reports whether PWM is enabled |

---

### PWM Counter

The internal 32-bit counter increments on every clock cycle whenever PWM is enabled.

The counter automatically resets to zero after reaching the programmed period value, thereby starting the next PWM cycle.

---

### Comparator

The comparator continuously compares

```
counter < duty
```

If the comparison is true, the PWM output remains HIGH; otherwise it becomes LOW.

This comparison directly determines the duty cycle of the generated waveform.

---

### PWM Output Logic

The output logic generates the final PWM waveform.

- When **EN = 0**, the output remains LOW.
- When **EN = 1**, the comparator output is forwarded.
- When **INV = 1**, the generated PWM waveform is inverted before driving the output pin.

The generated signal is available on the `pwm_out` output port and can be connected to LEDs, motors, servo controllers, or any external digital circuit.

---

## Data Flow

The overall operation of the PWM controller follows this sequence:

1. The CPU writes configuration values into the CTRL, PERIOD, and DUTY registers.
2. The address decoder selects the PWM peripheral.
3. The PWM counter starts counting system clock cycles.
4. The comparator compares the counter value against the programmed duty cycle.
5. The output logic generates the PWM waveform.
6. The waveform is continuously produced until the configuration registers are updated or the controller is disabled.


# <img src="https://img.icons8.com/color/48/000000/4-circle.png" width="28"/> Software Programming Model

## How Software Controls the PWM IP

The PWM controller is completely software programmable through four memory-mapped registers. The RISC-V processor configures the PWM output by writing to the control, period, and duty cycle registers using ordinary memory write instructions.

Unlike dedicated PWM peripherals that require complex configuration sequences, this implementation follows a simple register-based programming model. Once configured, the hardware automatically generates the PWM waveform without further CPU intervention until new values are written.

---

## Programming Sequence

The recommended sequence for configuring the PWM controller is:

1. Program the desired PWM period.
2. Program the required duty cycle.
3. Enable the PWM output by writing to the CTRL register.
4. Read the STATUS register whenever software needs to verify whether the PWM output is enabled.
5. Update PERIOD or DUTY at runtime whenever a new waveform is required.

---

## Initialization Example

```c
// Configure PWM period
IO_OUT(IO_PWM_PERIOD, 100);

// Configure duty cycle
IO_OUT(IO_PWM_DUTY, 40);

// Enable PWM
IO_OUT(IO_PWM_CTRL, 1);
```

The above configuration generates a PWM waveform with:

- Period = 100 clock cycles
- Duty = 40 clock cycles
- Duty Cycle = 40%

---

## Register Access Flow

The software interacts with the PWM controller through the following sequence:

```
CPU
 │
 │ Write PERIOD
 ▼
PERIOD Register

 │
 │ Write DUTY
 ▼
DUTY Register

 │
 │ Write CTRL
 ▼
CTRL Register

 │
 ▼
PWM Hardware

 │
 ▼
PWM Output
```

---

## Runtime Parameter Update

One of the major advantages of the PWM IP is that both the period and duty cycle can be modified while the processor is running.

Changing the duty cycle immediately affects the pulse width of the generated waveform, while updating the period changes the PWM frequency. Since both values are stored in hardware registers, software can continuously adjust the output waveform without modifying the RTL implementation.

Example:

```c
// Increase brightness
IO_OUT(IO_PWM_DUTY, 80);

// Reduce brightness
IO_OUT(IO_PWM_DUTY, 20);

// Change PWM frequency
IO_OUT(IO_PWM_PERIOD, 200);
```

---

## Reading the Status Register

The STATUS register allows software to determine whether the PWM controller is currently enabled.

```c
uint32_t status = IO_IN(IO_PWM_STATUS);

if(status & 0x1)
{
    // PWM is enabled
}
else
{
    // PWM is disabled
}
```

Bit 0 of the STATUS register reflects the enable state of the controller, while all remaining bits are reserved.

---

## Typical Software Flow

```
Start

   │
   ▼

Write PERIOD

   │
   ▼

Write DUTY

   │
   ▼

Write CTRL (Enable)

   │
   ▼

Hardware Generates PWM

   │
   ▼

(Optional)

Read STATUS

   │
   ▼

Update DUTY/PERIOD if required

   │
   ▼

End
```

---

## Software Design Notes

- PERIOD should always be greater than zero.
- DUTY should not exceed the programmed PERIOD value.
- A duty cycle of zero generates a continuously LOW output.
- Setting DUTY equal to PERIOD produces a continuously HIGH output.
- The PWM waveform is generated entirely in hardware after configuration.
- Software only needs to update register values whenever a different frequency or duty cycle is required.


# <img src="https://img.icons8.com/color/48/000000/5-circle.png" width="28"/> Register Map

The PWM controller exposes four memory-mapped registers through the VSDSquadron memory bus. These registers allow software to configure the PWM output waveform by controlling the enable bit, period, duty cycle, and status.

---

## Register Summary

- **Base Address:** `0x00400040`
- **Bus Width:** 32-bit, word-aligned
- **Addressing:** Base + Offset

| Offset Address | Absolute Address | Register | R/W | Description |
|---------------:|:----------------:|:--------:|:---:|-------------|
| 0x00 | 0x00400040 | CTRL | R/W | PWM control register (Enable / Invert) |
| 0x04 | 0x00400044 | PERIOD | R/W | PWM period register |
| 0x08 | 0x00400048 | DUTY | R/W | PWM duty cycle register |
| 0x0C | 0x0040004C | STATUS | R | PWM status register |

---

# CTRL : Control Register (Offset 0x00)

- **Address:** `0x00400040`
- **Access:** Read / Write
- **Reset Value:** `0x00000000`

| Bits | Field | R/W | Reset | Description |
|------|------|-----|-------|-------------|
| 0 | EN | R/W | 0 | Enables PWM output |
| 1 | INV | R/W | 0 | Inverts PWM output |
| 31:2 | Reserved | - | 0 | Reserved |

### Register Description

The CTRL register controls the overall operation of the PWM controller.

- **EN = 0** → PWM output remains LOW.
- **EN = 1** → PWM waveform is generated.
- **INV = 0** → Normal PWM polarity.
- **INV = 1** → Inverted PWM polarity.

---

# PERIOD : Period Register (Offset 0x04)

- **Address:** `0x00400044`
- **Access:** Read / Write
- **Reset Value:** `0x00000064` (100)

| Bits | Field | R/W | Reset | Description |
|------|------|-----|-------|-------------|
|31:0|PERIOD|R/W|100|PWM period in clock cycles|

### Register Description

The PERIOD register determines the number of system clock cycles that make up one complete PWM cycle.

The internal counter increments every clock cycle and automatically resets when the programmed period is reached.

Increasing the PERIOD value decreases the PWM frequency, while decreasing the PERIOD value increases the PWM frequency.

---

# DUTY : Duty Register (Offset 0x08)

- **Address:** `0x00400048`
- **Access:** Read / Write
- **Reset Value:** `0x00000000`

| Bits | Field | R/W | Reset | Description |
|------|------|-----|-------|-------------|
|31:0|DUTY|R/W|0|PWM HIGH time in clock cycles|

### Register Description

The DUTY register specifies the number of clock cycles during which the PWM output remains HIGH within each PWM period.

The PWM controller continuously compares:

```text
counter < duty
```

If the comparison is true, the output is HIGH; otherwise, it is LOW.

Typical examples:

| PERIOD | DUTY | Duty Cycle |
|---------|------|-----------|
|100|0|0%|
|100|25|25%|
|100|50|50%|
|100|75|75%|
|100|100|100%|

---

# STATUS : Status Register (Offset 0x0C)

- **Address:** `0x0040004C`
- **Access:** Read-Only
- **Reset Value:** `0x00000000`

| Bits | Field | R/W | Reset | Description |
|------|------|-----|-------|-------------|
|0|EN_STATUS|R|0|Reflects current PWM enable state|
|31:1|Reserved|-|0|Reserved|

### Register Description

The STATUS register allows software to determine whether the PWM controller is currently enabled.

The value of bit 0 always mirrors the Enable bit stored in the CTRL register.

Example:

```c
uint32_t status = IO_IN(IO_PWM_STATUS);

if(status & 0x1)
{
    // PWM enabled
}
```

---

## Register Programming Notes

- Configure **PERIOD** before enabling PWM.
- Ensure **DUTY ≤ PERIOD** for predictable waveform generation.
- Changing PERIOD immediately changes the PWM frequency.
- Changing DUTY immediately changes the pulse width.
- STATUS is read-only and is intended for software monitoring.
- Reserved bits should always be written as zero.
