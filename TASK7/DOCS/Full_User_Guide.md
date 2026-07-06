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
