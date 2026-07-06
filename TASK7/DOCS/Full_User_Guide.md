

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
  <img src="https://github.com/user-attachments/assets/01fabe43-f1d0-456d-8b40-699186696d59"  alt="pwm_ip" width="1536">
</p>
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


# <img src="https://img.icons8.com/color/48/000000/5-circle.png" width="28"/> Validation and Expected Behaviour

The PWM IP was validated through RTL simulation and integrated into the VSDSquadron RISC-V SoC. The verification process confirmed correct register operation, counter functionality, and PWM waveform generation based on the configured period and duty cycle values.

---

## RTL Simulation

The PWM controller was simulated using the provided Verilog testbench and GTKWave.

The simulation verified:

- Correct memory-mapped register write operations.
- Proper initialization of CTRL, PERIOD, DUTY, and STATUS registers.
- Counter increment on every clock cycle when PWM is enabled.
- Automatic counter reset after reaching the programmed period.
- Correct comparison between the counter and DUTY register.
- Expected PWM waveform generation.

<p align="center">
    <img src="../../TASK6/14_t6.jpeg" width="900">
</p>

<p align="center">
<b>Figure 2.</b> GTKWave simulation showing PWM waveform generation.
</p>

---

## Functional Verification

The following functionality was verified during simulation:

| Feature | Verification Status |
|----------|---------------------|
| Register Read/Write | ✅ Verified |
| PWM Enable Control | ✅ Verified |
| Counter Operation | ✅ Verified |
| Period Configuration | ✅ Verified |
| Duty Cycle Configuration | ✅ Verified |
| PWM Output Generation | ✅ Verified |

---

## Hardware Validation

The PWM IP was successfully integrated into the VSDSquadron SoC and programmed onto the FPGA.

The build process, synthesis, place-and-route, and FPGA programming completed successfully. A constant HIGH output corresponding to a 100% duty cycle was observed during hardware testing.

Intermediate duty-cycle values are expected to generate PWM waveforms according to the programmed register values. Verification of these waveforms is recommended using an oscilloscope or logic analyzer connected to the `pwm_out` signal.

---

## Expected Behaviour

The PWM controller is expected to operate as follows:

1. Software writes the PERIOD register.
2. Software writes the DUTY register.
3. Software enables the PWM controller through the CTRL register.
4. The internal counter increments continuously.
5. The comparator evaluates `counter < duty`.
6. The output logic generates the corresponding PWM waveform.
7. The waveform continues until the controller is disabled or new configuration values are written.

---

## Expected PWM Characteristics

| Parameter | Behaviour |
|-----------|-----------|
| DUTY = 0 | Output remains LOW |
| DUTY = PERIOD | Output remains HIGH |
| 0 < DUTY < PERIOD | PWM waveform generated |
| CTRL.EN = 0 | PWM disabled |
| CTRL.EN = 1 | PWM enabled |

---

# <img src="https://img.icons8.com/color/48/000000/6-circle.png" width="28"/> Known Limitations

The current implementation of the PWM IP is intended as a lightweight, educational memory-mapped peripheral for the VSDSquadron FPGA platform. While suitable for a wide range of embedded applications, the present version has the following limitations.

---

## Functional Limitations

- Supports only a single PWM output channel.
- Does not generate interrupts.
- No dead-time insertion for complementary outputs.
- No phase-shift control.
- No prescaler or programmable clock divider.
- No hardware fault protection.
- No DMA support.

---

## Timing Limitations

- PWM frequency depends directly on the fixed system clock.
- Maximum achievable frequency is limited by the FPGA system clock.
- Very small period values may reduce duty-cycle resolution.

---

## Register Limitations

- Duty cycle should not exceed the configured PERIOD value.
- Reserved register bits should always be written as zero.
- STATUS register reports only the PWM enable state.

---

## Hardware Considerations

- Intermediate duty-cycle values are best verified using an oscilloscope or logic analyzer.
- Visible LED brightness changes depend on both PWM frequency and the connected load.
- Proper FPGA pin assignment is required for observing the PWM output on external hardware.

---

## Future Improvements

The PWM IP can be extended with additional functionality, including:

- Multi-channel PWM support
- Programmable clock prescaler
- Interrupt generation
- Center-aligned PWM
- Complementary PWM outputs
- Dead-time insertion
- Runtime frequency scaling
- Capture and measurement support
- Hardware fault detection
- Advanced motor-control features

---

The modular architecture of the PWM IP allows these enhancements to be incorporated with minimal impact on the existing software interface.
