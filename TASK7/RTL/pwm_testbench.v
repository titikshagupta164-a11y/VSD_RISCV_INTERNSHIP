
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

//====================================================
// Write Logic
//====================================================
always @(posedge clk) begin
    if (!resetn) begin
        ctrl   <= 32'd0;
        period <= 32'd100;
        duty   <= 32'd0;
        status <= 32'd0;
    end
    else begin
        if (sel && we) begin
            case (reg_sel)

                REG_CTRL:
                    ctrl <= wdata;

                REG_PERIOD:
                    period <= wdata;

                REG_DUTY:
                    duty <= wdata;

                REG_STATUS:
                    status <= wdata;

                default:
                    ;

            endcase
        end
    end
end
---

## Read Logic

```verilog
//====================================================
// Read Logic
//====================================================
always @(*) begin
    rdata = 32'd0;

    if (sel && !we) begin
        case (reg_sel)

            REG_CTRL:
                rdata = ctrl;

            REG_PERIOD:
                rdata = period;

            REG_DUTY:
                rdata = duty;

            REG_STATUS:
                rdata = status;

            default:
                rdata = 32'd0;

        endcase
    end
end

---

## PWM Counter

```verilog
//====================================================
// PWM Counter
//====================================================
always @(posedge clk) begin
    if (!resetn)
        counter <= 32'd0;

    else if (ctrl[0]) begin

        if (counter >= period - 1)
            counter <= 32'd0;

        else
            counter <= counter + 1;

    end

    else
        counter <= 32'd0;
end

---

## Status Register

//====================================================
// Status Register
//====================================================
always @(posedge clk) begin
    if (!resetn)
        status <= 32'd0;

    else
        status <= {31'd0, ctrl[0]};
end
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
//====================================================
// PWM IP Instantiation
//====================================================
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


