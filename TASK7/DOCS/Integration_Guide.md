# <img src="https://img.icons8.com/color/48/000000/1-circle.png" width="28"/> Integration Guide

This guide explains how to integrate the **PWM (Pulse Width Modulation) IP** into the **VSDSquadron RISC-V SoC**. The reader is assumed to be familiar with the existing `riscv.v` design and the memory-mapped peripheral architecture used in the project.

---

# Required RTL Files

The following RTL files are required for PWM integration.

- `pwm.v` — PWM Controller IP
- `riscv.v` — VSDSquadron SoC
- `ice40_stubs.v` — iCE40 primitive definitions (simulation only)

---

# Step 1 : Add PWM Module

Copy **pwm.v** into the RTL directory of the SoC project.

```
RTL/
│
├── riscv.v
├── pwm.v
├── gpio_control.v
├── clockworks.v
├── emitter_uart.v
└── ...
```

---

# Step 2 : Add PWM Output Port

Open **riscv.v** and add the PWM output port to the top-level module.

```verilog
output PWM_OUT
```

---

# Step 3 : Declare PWM Signals

Inside `riscv.v`, declare the PWM select signal and read-data wire.

```verilog
wire pwm_sel;
wire [31:0] pwm_rdata;
```

---

# Step 4 : Add Address Decode

Assign a memory-mapped address for the PWM peripheral.

```verilog
localparam IO_PWM_bit = 4;

assign pwm_sel = isIO & mem_wordaddr[IO_PWM_bit];
```

This maps the PWM controller into the processor's I/O address space.

Base Address:

```
0x400040
```

---

# Step 5 : Instantiate PWM IP

Instantiate the PWM controller inside the SoC.

```verilog
pwm_control pwm_inst (

    .clk(clk),
    .resetn(resetn),

    .sel(pwm_sel),
    .we(mem_wstrb),

    .addr(mem_addr),
    .wdata(mem_wdata),
    .rdata(pwm_rdata),

    .pwm_out(PWM_OUT)

);
```

---

# Step 6 : Connect Read Data MUX

Connect the PWM read-data output to the existing memory read multiplexer.

```verilog
wire [31:0] IO_rdata =

        mem_wordaddr[IO_UART_CNTL_bit] ? {22'b0,!uart_ready,9'b0} :

        mem_wordaddr[IO_GPIO_bit] ? gpio_rdata :

        mem_wordaddr[IO_PWM_bit] ? pwm_rdata :

        32'b0;
```

This allows software to read the PWM registers using normal memory accesses.

---

# Step 7 : Register Map

The PWM IP occupies four consecutive 32-bit registers.

| Offset | Register | Description |
|---------|----------|-------------|
| 0x00 | CTRL | Enable PWM output |
| 0x04 | PERIOD | PWM period |
| 0x08 | DUTY | PWM duty cycle |
| 0x0C | STATUS | PWM enable status |

Base Address

```
0x400040
```

---

# Step 8 : Verify Integration

After integrating the RTL,

- Rebuild the design
- Program the FPGA
- Execute the PWM software
- Observe the PWM output on the assigned FPGA pin

If the PERIOD and DUTY registers are written correctly, the PWM waveform should appear immediately after enabling the controller.

---

# <img src="https://img.icons8.com/color/48/000000/2-circle.png" width="28"/> Board-level Usage

## FPGA Pin Assignment

The PWM output is routed to one FPGA I/O pin.

| Signal | FPGA Pin | Description |
|---------|----------|-------------|
| PWM_OUT | User GPIO | PWM waveform output |

> **Note:** Replace the pin number above with the actual pin used in your `.pcf` file if it is different.

---

## Connecting External Hardware

The PWM output can be connected directly to

- LED (through resistor)
- Oscilloscope
- Logic Analyzer
- Servo Driver
- Motor Driver Enable Pin

For LED testing, connect

```
PWM_OUT
   │
220Ω Resistor
   │
 LED
   │
 GND
```

Brightness changes according to the programmed duty cycle.

---

## Build and Flash

From the RTL directory run:

```bash
sudo make clean
sudo make build
sudo make flash
```

If UART messages are enabled in software,

```bash
sudo make terminal
```

---

## UART Monitor Settings

| Parameter | Value |
|-----------|-------|
| Baud Rate | 9600 |
| Data Bits | 8 |
| Stop Bits | 1 |
| Parity | None |

---

## Verification Checklist

Before running the PWM software, verify:

- ✔ PWM IP is instantiated
- ✔ Address decoder includes `IO_PWM_bit`
- ✔ Read-data MUX connected
- ✔ PWM output connected to FPGA pin
- ✔ Software writes CTRL, PERIOD and DUTY registers
- ✔ FPGA programmed successfully

Once these checks pass, the PWM waveform should be visible on the output pin.
