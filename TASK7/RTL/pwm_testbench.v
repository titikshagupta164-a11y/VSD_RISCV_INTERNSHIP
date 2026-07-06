# RTL Folder Structure

```
RTL/
├── pwm.v                     # Main PWM IP module
├── riscv.v                   # SoC integration (modified)
└── README.md                 # RTL description (optional)
```

> **Note:** `pwm_test.c` belongs in the `SOFTWARE/` folder, **not** in `RTL/`.
>
> If you do not have `pwm_testbench.v`, it is perfectly fine to omit it instead of adding a fake testbench.

---

# pwm.v

The following functional blocks are present inside `pwm.v`.

## Register Address Definitions

```verilog
// Register offsets
localparam CTRL_ADDR   = 32'h00;
localparam PERIOD_ADDR = 32'h04;
localparam DUTY_ADDR   = 32'h08;
localparam STATUS_ADDR = 32'h0C;
```

---

## Register Select Encoding

```verilog
// Register select
localparam REG_CTRL   = 2'b00;
localparam REG_PERIOD = 2'b01;
localparam REG_DUTY   = 2'b10;
localparam REG_STATUS = 2'b11;
```

---

## Write Logic

```verilog
// Write logic
always @(posedge clk)
begin
    ...
end
```

---

## Read Logic

```verilog
// Read logic
always @(*)
begin
    ...
end
```

---

## PWM Counter

```verilog
// PWM Counter
always @(posedge clk)
begin
    ...
end
```

---

## Status Register

```verilog
// Status Register
always @(posedge clk)
begin
    ...
end
```

---

## PWM Output Generation

```verilog
// PWM Output
assign pwm_raw = (counter < duty);
assign pwm_out = ctrl[0] ? (ctrl[1] ? ~pwm_raw : pwm_raw) : 1'b0;
```

---

# riscv.v

The following modifications were made for PWM integration.

## PWM Signals

```verilog
wire pwm_sel;
wire [31:0] pwm_rdata;
wire PWM_OUT;
```

---

## PWM Address Decode

```verilog
assign pwm_sel = isIO & mem_wordaddr[IO_PWM_bit];
```

---

## PWM IO Address

```verilog
localparam IO_PWM_bit = 4;
```

---

## PWM IP Instantiation

```verilog
pwm_control pwm_inst (
    ...
);
```

---

## Read Data Multiplexer

```verilog
wire [31:0] IO_rdata =
        mem_wordaddr[IO_UART_CNTL_bit] ? {22'b0, !uart_ready, 9'b0} :
        mem_wordaddr[IO_GPIO_bit]      ? gpio_rdata :
        mem_wordaddr[IO_PWM_bit]       ? pwm_rdata :
                                         32'b0;
```

---

# SOFTWARE Folder

```
SOFTWARE/
└── pwm_test.c
```

This firmware configures the PWM peripheral by writing the PERIOD, DUTY and CTRL registers.

---

# README.md (RTL)

```markdown
# RTL Files

This folder contains the RTL implementation of the PWM IP.

## Files

- **pwm.v** — Main PWM peripheral
- **riscv.v** — PWM integration into the VSDSquadron SoC

The PWM IP is memory mapped and accessed through the CPU using memory-mapped I/O transactions.
```
