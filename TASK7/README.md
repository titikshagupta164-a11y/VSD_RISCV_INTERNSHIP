
# Commercial Grade PWM IP Documentation

## PWM Controller IP – VSDSquadron FPGA

- A lightweight, memory-mapped Pulse Width Modulation (PWM) Controller designed for the VSDSquadron FPGA (Lattice iCE40UP5K).
- Generates programmable PWM signals by configuring **Period**, **Duty Cycle**, and **Control** registers.
- Designed for seamless integration into the VSDSquadron RISC-V SoC using a 32-bit memory-mapped interface.
- Successfully verified using RTL simulation in GTKWave.

---

## What This IP Does

- Generates configurable PWM output.
- Supports programmable period and duty cycle.
- Controlled entirely through memory-mapped registers.
- Can enable or disable PWM through software.
- Returns status information to firmware.
- Easily integrates with the existing VSDSquadron SoC.

---

## PWM Module

The PWM controller exposes a memory-mapped interface that allows the processor to configure the PWM output. The module accepts address, write-data, select and write-enable signals from the SoC and returns register contents through the read-data bus. The generated PWM waveform is available on the `pwm_out` output.

```verilog
module pwm_control(
    input clk,
    input resetn,

    input sel,
    input we,

    // Memory-mapped interface
    input [31:0] addr,
    input [31:0] wdata,
    output reg [31:0] rdata,

    // PWM output
    output pwm_out
);

// Registers
reg [31:0] ctrl;
reg [31:0] period;
reg [31:0] duty;
reg [31:0] status;

// PWM counter
reg [31:0] counter;
```

---

## Key Features

| Feature | Description |
|---------|-------------|
| Interface | Memory-Mapped |
| Bus Width | 32-bit |
| Registers | CTRL, PERIOD, DUTY, STATUS |
| Output | Single PWM Output |
| Duty Cycle | Software Programmable |
| Period | Software Programmable |
| Verification | RTL Simulation |

---

# Quick Integration (3 Steps)

## Step 1: Copy RTL File

```text
RTL/pwm.v
```

---

## Step 2: Instantiate PWM IP inside SoC

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

## Step 3: Add Address Decode

```verilog
localparam IO_PWM_bit = 4;

wire pwm_sel = isIO & mem_wordaddr[IO_PWM_bit];
```

Add PWM read data into the IO read-data multiplexer.

```verilog
wire [31:0] IO_rdata =
        mem_wordaddr[IO_UART_CNTL_bit] ? {22'b0, !uart_ready, 9'b0} :
        mem_wordaddr[IO_GPIO_bit]      ? gpio_rdata :
        mem_wordaddr[IO_PWM_bit]       ? pwm_rdata :
                                         32'b0;
```

---

# RTL Verification

The PWM controller was verified through RTL simulation using GTKWave.

The waveform confirms:

- Register writes occur correctly.
- Counter increments every clock cycle.
- PWM output changes according to the programmed duty cycle.
- Period register determines the PWM frequency.
- Status register updates after configuration.

The PWM output is generated using the following logic:

```verilog
wire pwm_raw;

assign pwm_raw = (counter < duty);

assign pwm_out = ctrl[0] ?
                 (ctrl[1] ? ~pwm_raw : pwm_raw)
                 : 1'b0;
```

---

# Project Structure

| Document | Location |
|----------|----------|
| Full User Guide | [IP_PWM/DOCS/Full_User_Guide.md](DOCS/Full_User_Guide.md) |
| Integration Guide | [IP_PWM/DOCS/Integration_Guide.md](DOCS/Integration_Guide.md) |
| Register Map | [IP_PWM/DOCS/Register_Map.md](DOCS/Register_Map.md) |
| Example Software | [IP_PWM/DOCS/Example_Software.md](DOCS/Example_Software.md) |
| Firmware Source | [IP_PWM/SOFTWARE/pwm_test.c](SOFTWARE/pwm_test.c) |
| RTL Source | [IP_PWM/RTL](RTL/) |

