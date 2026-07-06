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

# <img src="https://img.icons8.com/fluency/48/000000/2-circle.png" width="32"/> Feature Summary

## Supported Features

The PWM IP provides a simple memory-mapped interface that allows software to configure and control PWM signal generation through four programmable registers. Once enabled, the hardware continuously generates the PWM waveform without requiring further CPU intervention until new register values are written.

### Key Features

- Memory-mapped peripheral for the VSDSquadron RISC-V SoC
- Four software-accessible 32-bit registers
- Programmable PWM period
- Programmable PWM duty cycle
- Enable/Disable PWM output through CTRL register
- Optional PWM output inversion
- Continuous PWM waveform generation
- 32-bit up-counter architecture
- Automatic counter reset after one PWM period
- Synthesizable Verilog RTL
- Simple SoC integration through address decoding
- Fully software configurable

---

## Register Interface

The PWM controller exposes four memory-mapped registers.

| Register | Offset | Access | Description |
|----------|--------|--------|-------------|
| CTRL | 0x00 | R/W | Controls PWM enable and output inversion |
| PERIOD | 0x04 | R/W | Sets the PWM period |
| DUTY | 0x08 | R/W | Sets the PWM duty cycle |
| STATUS | 0x0C | R | Indicates current PWM enable status |

---

## Control Register

The CTRL register controls the PWM output.

| Bit | Name | Description |
|-----|------|-------------|
| 0 | EN | Enables PWM output |
| 1 | INV | Inverts PWM output when set |
| 31:2 | Reserved | Reserved |

---

## Period Register

The PERIOD register defines the total number of clock cycles that make up one PWM period.

- Register Width: 32 bits
- Access: Read/Write
- Default Value: 100

Example:

| PERIOD | Result |
|---------|--------|
|100|100 clock cycles per PWM period|
|500|500 clock cycles per PWM period|
|1000|1000 clock cycles per PWM period|

---

## Duty Register

The DUTY register specifies how long the PWM output remains HIGH during one PWM period.

The output remains HIGH while:

```text
counter < duty
```

Example:

| PERIOD | DUTY | Output Duty Cycle |
|---------|------|------------------|
|100|25|25%|
|100|50|50%|
|100|75|75%|
|100|100|100%|

---

## Status Register

The STATUS register reports whether PWM generation is currently enabled.

| Bit | Description |
|-----|-------------|
|0|PWM Enable Status|
|31:1|Reserved|

The status bit directly reflects the Enable bit stored in the CTRL register.

---

## Register Widths

All memory-mapped registers are 32 bits wide.

| Item | Width |
|------|-------|
|CTRL Register|32 bits|
|PERIOD Register|32 bits|
|DUTY Register|32 bits|
|STATUS Register|32 bits|
|PWM Counter|32 bits|
|Memory Bus|32 bits|

---

## PWM Counter Operation

The PWM controller contains an internal 32-bit counter.

The counter operates as follows:

1. Counter resets to zero after reset.
2. When PWM is enabled, the counter increments every clock cycle.
3. When the counter reaches `PERIOD - 1`, it automatically wraps back to zero.
4. This process repeats continuously while PWM remains enabled.

---

## PWM Output Generation

The PWM waveform is generated by continuously comparing the counter value with the DUTY register.

```verilog
assign pwm_raw = (counter < duty);
assign pwm_out = ctrl[0] ? (ctrl[1] ? ~pwm_raw : pwm_raw) : 1'b0;
```

Operation:

- If EN = 0, PWM output remains LOW.
- If EN = 1, the PWM waveform is generated.
- If INV = 1, the PWM waveform is inverted.
- Otherwise, the normal PWM waveform is produced.

---

## Clock Assumptions

The PWM controller operates directly from the VSDSquadron system clock.

Default assumptions:

- System Clock = 12 MHz
- Counter increments every clock cycle
- PWM Frequency depends on the PERIOD register

Approximate PWM frequency:

```text
PWM Frequency = System Clock / PERIOD
```

Example:

| PERIOD | PWM Frequency |
|---------|---------------|
|100|120 kHz|
|1000|12 kHz|
|12000|1 kHz|

---

## Duty Cycle Calculation

The duty cycle is determined by the ratio of the DUTY register to the PERIOD register.

```text
Duty Cycle (%) = (DUTY / PERIOD) × 100
```

Example:

| PERIOD | DUTY | Duty Cycle |
|---------|------|------------|
|100|20|20%|
|100|40|40%|
|100|50|50%|
|100|80|80%|
|100|100|100%|

---

## Design Highlights

- Simple hardware architecture
- Low resource utilization
- Easy software programming
- Memory-mapped interface
- Parameter-free RTL implementation
- Continuous hardware PWM generation
- Suitable for embedded control applications
