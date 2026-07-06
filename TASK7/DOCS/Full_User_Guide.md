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

