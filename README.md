# VSD_RISCV_INTERNSHIP

## DETAILS

**Titiksha Gupta**  
*B.Tech, Electronics & Communication Engineering*  
*The LNM Institute of Information Technology (LNMIIT), Jaipur*  

**Email:** titikshagupta164@gmail.com  
**Official Email:** 24dec023@lnmiit.ac.in  

**GitHub:** https://github.com/titikshagupta164-a11y  

**LinkedIn:** https://www.linkedin.com/in/titiksha-gupta-

---
<details>
<summary><b>Task 1: Compilation of a C Program using GCC and RISC-V GCC Compiler</b></summary>

# Objective

The objective of this task is to understand the complete workflow of compiling a C program using both the native GCC compiler and the RISC-V cross-compilation toolchain. The task also focuses on examining the generated assembly instructions and analyzing the impact of compiler optimization levels on the generated machine code.

---

# Step 1: Program Development

A simple C program was written to calculate the sum of natural numbers from **1 to n** using a loop.

Initially, the value of **n = 5** was used to verify the correctness of the program logic.

## Source Code

![Source Code](Task1/task1_source_code_sum_to_5.jpeg)

### Explanation

- Variable `sum` stores the cumulative result.
- Variable `i` acts as the loop counter.
- The loop iterates from 1 to `n`.
- During each iteration, the current value of `i` is added to `sum`.
- The final result is displayed using the `printf()` function.

---

# Step 2: Compilation and Execution using GCC

The source program was compiled and executed using the GNU GCC compiler.

## Commands Used

```bash
gcc sum1ton.c
./a.out
```

## Output

![GCC Output](Task1/task1_gcc_output_sum_to_9.jpeg)

### Terminal Execution Verification

The following terminal snapshot confirms successful compilation and execution of the program for **n = 9**.

![Execution for n = 9](Task1/task1_gcc_execution_sum_to_9.jpeg)

### Observation

For n = 9:

```text
1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 = 45
```

The output confirms that the program logic is functioning correctly.

---

# Step 3: Program Modification and Verification

To further validate the implementation, the value of `n` was modified from **9** to **100**.

## Modified Source Code

![Modified Source Code](Task1/task1_source_code_sum_to_100.jpeg)

The source file was then displayed using the `cat` command for verification.

## Source File Verification

```bash
cat sum1ton.c
```

![Source Verification](Task1/task1_terminal_source_listing.jpeg)

### Observation

The source listing confirms that the value of `n` was successfully updated to 100 before recompilation.

---

# Step 4: Recompilation and Execution

After modifying the value of `n`, the program was recompiled and executed.

## Commands Used

```bash
gcc sum1ton.c
./a.out
```

## Output

![GCC Output for n = 100](Task1/task1_gcc_output_sum_to_100.jpeg)

### Terminal Execution Verification

The following screenshot shows successful recompilation and execution after updating the value of `n` from 9 to 100.

![Execution for n = 100](Task1/task1_gcc_execution_sum_to_100.jpeg)

### Observation

For n = 100:

```text
100 × 101 / 2 = 5050
```

The obtained result matches the expected mathematical value.

---

# Step 5: Compilation Workflow

The following screenshot shows the complete workflow of program editing, compilation, and execution within the development environment.

![Compilation Workflow](Task1/task1_compilation_workflow.jpeg)

### Workflow Summary

1. Create or edit the source code.
2. Compile using GCC.
3. Execute the generated binary.
4. Verify the output.
5. Modify the source code when required.
6. Recompile and execute again.
7. Cross-compile for the RISC-V architecture.
8. Analyze generated machine instructions.

---

# Step 6: Cross Compilation using RISC-V GCC

After verifying the program using the native compiler, the next step was to generate machine code for the RISC-V architecture.

## Command

```bash
riscv64-unknown-elf-gcc -O1 -mabi=lp64 -march=rv64i -c sum1ton.c
```

## Parameter Description

| Option | Description |
|----------|----------|
| `-O1` | Enables basic compiler optimizations |
| `-mabi=lp64` | Uses LP64 ABI |
| `-march=rv64i` | Targets RV64I architecture |
| `-c` | Generates object file without linking |

The compilation process generates the object file:

```text
sum1ton.o
```

### Observation

Cross compilation allows code developed on the host machine to be translated into machine instructions for the RISC-V processor architecture.

---

# Step 7: Disassembling the Object File

The generated object file was analyzed using the RISC-V disassembler.

## Command

```bash
riscv64-unknown-elf-objdump -d sum1ton.o
```

## Disassembly Output

![RISC-V Disassembly](Task1/task1_riscv_objdump_disassembly.jpeg)

### Analysis

The disassembly output converts machine instructions into a human-readable assembly representation.

Important observations include:

- Function labels such as `<main>`
- Arithmetic instructions
- Memory access operations
- Stack pointer manipulation
- Function call instructions
- Return instructions

This provides a detailed view of how high-level C code is translated into RISC-V assembly language.

---

# Step 8: Analysis of O1 Optimization

The program was compiled using the **-O1** optimization level.

## Command

```bash
riscv64-unknown-elf-gcc -O1 -mabi=lp64 -march=rv64i -c sum1ton.c
```

## Main Function Generated with O1

![O1 Optimization Analysis](Task1/task1_o1_optimization_main_function.jpeg)

### What is O1 Optimization?

`-O1` performs basic compiler optimizations while maintaining a structure that closely resembles the original source code.

The optimizations include:

- Dead code elimination
- Constant propagation
- Simple instruction scheduling
- Basic loop optimization
- Removal of redundant operations

### Observation

The generated assembly still contains loop-related instructions that perform the summation operation during runtime.

**Key observations:**

- The loop structure is preserved.
- Branch instructions are present.
- Runtime calculations are performed inside the loop.
- Approximately 15 instructions are generated within the main routine.
- The generated code remains easy to correlate with the original C program.

This optimization level improves execution efficiency while preserving code readability and debugging capability.

---

# Step 9: Analysis of OFast Optimization

The same source code was compiled using the **-Ofast** optimization level.

## Command

```bash
riscv64-unknown-elf-gcc -Ofast -mabi=lp64 -march=rv64i -c sum1ton.c
```

## Main Function Generated with OFast

![OFast Optimization Analysis](Task1/task1_ofast_optimization_main_function.jpeg)

### What is OFast Optimization?

`-Ofast` enables all optimizations available in `-O3` along with additional aggressive optimizations that prioritize maximum execution speed.

The optimizations include:

- Constant folding
- Constant propagation
- Loop elimination
- Aggressive instruction scheduling
- Compile-time evaluation
- Advanced code simplification

### Observation

Unlike the assembly generated with **-O1**, the loop is no longer present in the generated machine code.

Since the value of `n` is known during compilation (`n = 100`), the compiler computes the final result at compile time and directly inserts the constant value into the assembly instructions.

**Key observations:**

- Loop instructions have been eliminated.
- Branch instructions related to iteration are removed.
- The final result is precomputed by the compiler.
- Approximately 12 instructions are generated.
- Fewer instructions are generated overall.
- Execution becomes faster due to reduced runtime computation.

In the OFast version, the compiler effectively transforms the original iterative computation into a simplified sequence of instructions that directly prepares the output for the `printf()` function.

---

# O1 vs OFast Comparison

| Feature | O1 | OFast |
|----------|----------|----------|
| Loop Structure | Preserved | Eliminated |
| Runtime Computation | Present | Reduced |
| Instruction Count | ~15 Instructions | ~12 Instructions |
| Code Readability | Easier to Understand | More Optimized |
| Execution Speed | Moderate | Faster |
| Compiler Aggressiveness | Basic | High |

The comparison clearly demonstrates how higher optimization levels can significantly reduce instruction count and improve execution efficiency by performing calculations during compilation rather than at runtime.

---

# Key Learning Outcomes

- Understood the workflow of native compilation using GCC.
- Learned the fundamentals of cross-compilation for the RISC-V architecture.
- Generated RISC-V object code from a high-level C program.
- Examined machine-level instructions using the `objdump` utility.
- Compared assembly output produced under different optimization levels.
- Analyzed the impact of compiler optimizations on instruction count and execution efficiency.
- Verified successful execution of RISC-V object code.
- Observed how compiler optimizations can transform iterative logic into highly optimized machine instructions.

---

# Conclusion

This task provided practical exposure to both native compilation and RISC-V cross-compilation workflows. The generated assembly code was analyzed using `objdump`, enabling a deeper understanding of how high-level C statements are translated into architecture-specific instructions.

Furthermore, comparison of **-O1** and **-Ofast** optimization levels demonstrated how compiler optimizations influence instruction generation, code size, and execution efficiency. Successful execution of the generated code validated the correctness of the compilation process and reinforced the concepts of compiler optimization, assembly analysis, and RISC-V program execution.

</details>

<details>
<summary><b>Task 2.1: RISC-V Program Simulation using SPIKE</b></summary>

## Objective

The objective of this task is to compile a C program, execute it using the SPIKE RISC-V simulator, and perform instruction-level debugging by examining register values and stack pointer behavior.

---

## 1. Compilation and Execution using GCC

The source file `sum1ton.c` was compiled using GCC and executed successfully. The output confirms the correctness of the program.

### Commands

```bash
gcc sum1ton.c
./a.out
```

### Output

![GCC Output](Task2/gcc_output.png)
The program calculates the sum of integers from 1 to 100 and produces the expected result:

```text
Sum from 1 to 100 is 5050
```

---

## 2. Execution using SPIKE Simulator

The generated RISC-V executable was executed using the SPIKE simulator along with the proxy kernel (`pk`).

### Command

```bash
spike pk sum1ton.o
```

### Output

![Verification of Program Output in SPIKE](Task2/Verification%20of%20Program%20Output%20in%20SPIKE.png)

The output obtained through SPIKE matches the GCC execution result, confirming successful simulation.

---

## 3. Launching SPIKE in Debug Mode

To perform instruction-level analysis, SPIKE was launched in debug mode.

### Command

```bash
spike -d pk sum1ton.o
```

### Register Inspection

The value of register `a2` was inspected before execution of the target instruction.

![Inspection of Register a2 in SPIKE Debug Mode](Task2/Inspection%20of%20Register%20a2%20in%20SPIKE%20Debug%20Mode.png)

At this stage, register `a2` contains:

```text
0x0000000000000000
```

---

## 4. Single-Step Instruction Execution

The debugger was used to execute instructions one step at a time, enabling detailed observation of program execution.

![Single-Step Instruction Execution in SPIKE Debugger](Task2/Single-Step%20Instruction%20Execution%20in%20SPIKE%20Debugger.png)

This approach helps in understanding how individual instructions modify processor state.

---

## 5. Effect of the LUI Instruction

The following instruction was executed:

```assembly
lui a2, 0x1
```

The value loaded into register `a2` was verified.

![Effect of LUI Instruction on Register Contents](Task2/Effect%20of%20LUI%20Instruction%20on%20Register%20Contents.png)

### Observation

```text
a2 = 0x0000000000001000
```

This demonstrates the operation of the Load Upper Immediate (LUI) instruction.

---

## 6. Verification of Register Updates

After subsequent instruction execution, the updated register values were examined.

![Register Value Verification](Task2/modified%20a2.png)

### Observation

```text
a2 = 0x0000000000001000
a0 = 0x0000000000021000
```

The observed values confirm that the instructions correctly modified the destination registers.

---

## 7. Initial Stack Pointer Analysis

Before stack allocation, the value of the stack pointer (`sp`) was recorded.

![Initial Stack Pointer](Task2/initial%20sp.png)

### Initial Value

```text
sp = 0x000000007f7e9b50
```

---

## 8. Stack Pointer Modification using ADDI

The following instruction was executed:

```assembly
addi sp, sp, -16
```

This instruction allocates stack space by decrementing the stack pointer.

![Stack Pointer Analysis After ADDI Instruction Execution](Task2/Stack%20Pointer%20Analysis%20After%20ADDI%20Instruction%20Execution.png)

### Observation

Before execution:

```text
sp = 0x000000007f7e9b50
```

After execution:

```text
sp = 0x000000007f7e9b40
```

Difference:

```text
16 bytes
```

The result confirms successful stack frame allocation.

---

## Conclusion

This task demonstrated:

- Compilation and execution of a C program using GCC.
- Execution of a RISC-V binary using the SPIKE simulator.
- Instruction-level debugging using SPIKE debug mode.
- Inspection and verification of register contents.
- Analysis of the `LUI` instruction and its effect on registers.
- Observation of stack pointer updates during stack frame allocation.
- Understanding of processor state changes through single-step execution.

These experiments provided practical exposure to the RISC-V software toolchain, simulation environment, and debugging workflow.
</details>

<details>
<summary><b>Task 2.2: ATM SIMULATOR USING SPIKE AND GCC</b></summary>

# ATM Transaction Simulator using RISC-V GCC and SPIKE

## Project Overview

This project implements an ATM Transaction Simulator in C and demonstrates its execution on the RISC-V architecture using the RISC-V GCC Toolchain and SPIKE Simulator.

The simulator supports the following operations:

* Check Balance
* Deposit Money
* Withdraw Money
* Exit Application

The project was compiled and analyzed using two optimization levels:

* `-O1`
* `-Ofast`

The generated assembly code was examined using Objdump, and instruction counts were calculated for comparison.

---

# Tools Used

| Tool          | Purpose                   |
| ------------- | ------------------------- |
| C Programming | ATM Simulator Development |
| GCC           | Native Compilation        |
| RISC-V GCC    | Cross Compilation         |
| SPIKE         | RISC-V ISA Simulation     |
| Objdump       | Assembly Analysis         |
| GitHub        | Documentation             |

---

# Source Code

The ATM Simulator is implemented in C using a menu-driven approach that allows users to perform basic banking transactions.

---

# Native GCC Compilation

## Compile

```bash
gcc atm_simulator.c
```

## Run

```bash
./a.out
```

---

# Program Execution

## Check Balance

![Balance Output](TASK2.2/balance.jpeg)

---

## Deposit Money

![Deposit Output](TASK2.2/deposit.jpeg)

---

## Withdraw Money

![Withdrawal Output](TASK2.2/withdrawl.jpeg)

---

## Exit Application

![Exit Output](TASK2.2/exit.jpeg)

---

# RISC-V Cross Compilation (-O1)

## Compilation Command

```bash
riscv64-unknown-elf-gcc -O1 -mabi=lp64 -march=rv64i -o atm_simulator.o atm_simulator.c
```

## Object File Generation

```bash
ls -ltr atm_simulator.o
```

### Output

![Object File Generation](TASK2.2/ltr.jpeg)

---

# SPIKE Simulation

## Execute on SPIKE

```bash
spike pk atm_simulator.o
```

### Initial SPIKE Execution

![SPIKE Output](TASK2.2/spike_output.jpeg)

### Complete ATM Transaction Execution

![SPIKE Transaction Output](TASK2.2/spike_output_2.jpeg)

---

# Objdump Analysis (-O1)

## Generate Assembly

```bash
riscv64-unknown-elf-objdump -d atm_simulator.o | less
```

### Main Function Assembly

![O1 Main Function](TASK2.2/o1_main.jpeg)

---

## Instruction Count Calculation (-O1)

### Main Function Address Information

| Parameter     | Address |
| ------------- | ------- |
| Start Address | 0x10184 |
| End Address   | 0x1039C |

### Calculation

```text
Number of Instructions
= (0x1039C - 0x10184) / 4

= 0x218 / 4

= 536 / 4

= 134 Instructions
```

### Result

| Optimization | Instruction Count |
| ------------ | ----------------- |
| -O1          | 134               |

---

# SPIKE Debug Mode (-O1)

## Command

```bash
spike -d pk atm_simulator.o
```

### Commands Used

```bash
until pc 0 10184
reg 0 sp
```

### Debug Output

![O1 Debug Mode](TASK2.2/o1_spike_debug.jpeg)

---

# RISC-V Cross Compilation (-Ofast)

## Compilation Command

```bash
riscv64-unknown-elf-gcc -Ofast -mabi=lp64 -march=rv64i -o atm_simulator_fast.o atm_simulator.c
```

---

# Objdump Analysis (-Ofast)

## Generate Assembly

```bash
riscv64-unknown-elf-objdump -d atm_simulator_fast.o | less
```

### Main Function Assembly

![Ofast Main Function](TASK2.2/ofast_main.jpeg)

---

## Instruction Count Calculation (-Ofast)

### Main Function Address Information

| Parameter     | Address |
| ------------- | ------- |
| Start Address | 0x100B0 |
| End Address   | 0x102C4 |

### Calculation

```text
Number of Instructions
= (0x102C4 - 0x100B0) / 4

= 0x214 / 4

= 532 / 4

= 133 Instructions
```

### Result

| Optimization | Instruction Count |
| ------------ | ----------------- |
| -Ofast       | 133               |

---

# SPIKE Debug Mode (-Ofast)

## Command

```bash
spike -d pk atm_simulator_fast.o
```

### Commands Used

```bash
until pc 0 100b0
reg 0 sp
```

### Debug Output

![Ofast Debug Mode](TASK2.2/ofast_spike_debug.jpeg)

---

# Optimization Comparison

| Parameter          | -O1     | -Ofast  |
| ------------------ | ------- | ------- |
| Main Start Address | 0x10184 | 0x100B0 |
| Main End Address   | 0x1039C | 0x102C4 |
| Instruction Count  | 134     | 133     |

---

# Observations

* The ATM Simulator was successfully compiled using both `-O1` and `-Ofast` optimization levels.
* The generated RISC-V object files executed correctly on the SPIKE simulator.
* Objdump analysis was used to inspect the generated assembly instructions.
* The instruction count for the `main()` function was calculated manually from the assembly output.
* `-Ofast` generated slightly fewer instructions compared to `-O1`, indicating a more aggressive optimization strategy.
* SPIKE debug mode enabled instruction-level execution and register inspection.

---

# Conclusion

The ATM Transaction Simulator was successfully implemented in C and executed on the RISC-V architecture using SPIKE.

This project demonstrates:

* Native C program execution
* Cross-compilation using RISC-V GCC
* Simulation using SPIKE
* Assembly code analysis using Objdump
* Instruction count comparison across optimization levels
* Instruction-level debugging using SPIKE Debug Mode

The results confirm correct functionality of the ATM Simulator and provide insight into the effects of compiler optimizations on generated RISC-V assembly code.
</details>

<details>
<summary><b>Task 3: Environment Setup & RISC-V Reference Bring-Up</b></summary>

## Objective

The objective of this task was to establish a complete RISC-V development environment, validate the functionality of the provided reference design, execute the VSD FPGA laboratory exercises, and prepare a local development setup for future FPGA and IP integration tasks.

The task focused on:

* Toolchain verification and readiness
* Understanding the RISC-V software execution flow
* Running a working RISC-V reference program
* Executing VSDFPGA laboratory examples
* Preparing a local Linux-based development environment
* Understanding the integration of future FPGA IP blocks

---

# Development Environment

## Cloud Environment

* GitHub Codespaces
* Pre-configured VSD RISC-V development container
* RISC-V GCC Toolchain
* Spike RISC-V ISA Simulator
* Icarus Verilog

## Local Environment

* Oracle VirtualBox
* Ubuntu Linux Virtual Machine
* Local repository setup for future FPGA development

---

# Step 1: GitHub Codespaces Setup

The official `vsd-riscv2` repository was forked and launched using GitHub Codespaces.

The environment was verified successfully using:

```bash
riscv64-unknown-elf-gcc --version
spike --version
iverilog -V
```

This confirmed that the required RISC-V software toolchain and simulation tools were correctly installed and accessible.

---

# Step 2: RISC-V Reference Program Execution

The reference RISC-V program available in the `samples` directory was compiled using the RISC-V cross-compiler and executed using the Spike simulator.

## Compilation Command

```bash
riscv64-unknown-elf-gcc -o sum1ton.o sum1ton.c
```

## Execution Command

```bash
spike pk sum1ton.o
```

## Program Source

```c
#include <stdio.h>

int main()
{
    int i, sum=0, n=100;

    for(i=1;i<=n;i++)
        sum += i;

    printf("Sum from 1 to %d is %d\n", n, sum);

    return 0;
}
```

## Expected Output

```text
Sum from 1 to 100 is 5050
```

## Observed Output

```text
Sum from 1 to 100 is 5050
```

### Execution Snapshot

![RISC-V Program Execution](TASK3/snap1.jpeg)

---

# Step 3: VSDFPGA Laboratory Execution

After validating the RISC-V reference flow, the FPGA laboratory repository was executed within the same Codespaces environment.

The firmware example was compiled and simulated successfully.

## Firmware Build Process

* Firmware source verification
* Hex file generation
* RISC-V compilation
* Simulation using Spike

## Observed Output

```text
LEARN TO THINK LIKE A CHIP
VSDSQUADRON FPGA MINI
BRINGS RISC-V TO VSD CLASSROOM
```

### Firmware Execution Snapshot

!![VSDFPGA Firmware Execution](TASK3/build.jpeg)

---

# Step 4: Local Machine Preparation

To prepare for future FPGA development activities, the repositories were cloned on a local Ubuntu virtual machine.

## Workspace Creation

```bash
mkdir ~/riscv_fpga_ip
cd ~/riscv_fpga_ip
```

## Repository Cloning

```bash
git clone https://github.com/vsdip/vsd-riscv2.git

git clone https://github.com/vsdip/vsdfpga_labs.git
```

## Verification

```bash
ls
```

Output:

```text
vsd-riscv2
vsdfpga_labs
```

### Local Setup Snapshot

![Local Ubuntu Setup](TASK3/vm.jpeg)

---

# Understanding Questions

## Q1. Where is the RISC-V reference program located?

The RISC-V reference program is located in the `samples` directory of the `vsd-riscv2` repository. This directory contains example programs used to verify the RISC-V toolchain and simulation flow.

---

## Q2. How is the program compiled and loaded into memory?

The source file is compiled using the RISC-V cross-compiler (`riscv64-unknown-elf-gcc`) which generates a RISC-V executable binary.

The executable is then executed using the Spike simulator through:

```bash
spike pk <program>
```

The Proxy Kernel (`pk`) loads the executable into simulated memory and manages execution.

---

## Q3. How does the RISC-V core access memory and memory-mapped I/O?

The RISC-V processor accesses memory using standard load and store instructions.

Memory-mapped peripherals are assigned dedicated address ranges within the system memory map. The processor communicates with these peripherals by reading from and writing to the corresponding addresses.

---

## Q4. Where would a new FPGA IP block logically integrate within the system?

A new FPGA IP block would typically be integrated as a memory-mapped peripheral connected to the SoC interconnect.

This allows the RISC-V processor to access the IP block through standard memory transactions without requiring special instructions.

---

# Key Learning Outcomes

Through this task, the following concepts were understood and validated:

* RISC-V software compilation flow
* Cross-compilation using the RISC-V GCC toolchain
* Program execution using the Spike simulator
* Firmware build and simulation process
* Repository management in GitHub Codespaces
* Local Linux development environment preparation
* Memory-mapped peripheral architecture
* Foundation concepts for future FPGA and SoC integration tasks

---

# Conclusion

The development environment was successfully configured and validated. The reference RISC-V application executed correctly, the VSDFPGA laboratory exercises were completed successfully, and a local Ubuntu-based development environment was prepared.

This task established a strong foundation for upcoming RTL design, FPGA integration, and custom IP development activities in the VSD RISC-V Internship program.

</details>
<details>
<summary><b>Task 4: Design & Integrate Your First Memory-Mapped IP </b></summary>

## Objective

The objective of this task was to understand the existing RISC-V System-on-Chip (SoC) architecture, design a custom General Purpose Input Output (GPIO) peripheral, integrate it into the memory-mapped I/O framework of the SoC, and validate its operation through simulation.

This task involved studying the existing peripheral interface, creating a standalone GPIO RTL module, connecting it to the processor bus, writing firmware to access the GPIO register, and verifying the complete functionality using simulation and waveform analysis.

---

# Step 1: Understanding the Existing SoC

Before implementing the GPIO peripheral, the architecture of the provided RISC-V SoC was analyzed.

The SoC follows a memory-mapped I/O approach, where peripherals are assigned specific address locations within the processor address space. The processor communicates with peripherals using standard memory read and write operations.

The following observations were made during the analysis:

- The processor generates memory addresses through the `mem_addr` bus.
- Read and write operations are controlled through `mem_rstrb` and `mem_wmask`.
- Existing peripherals such as LEDs and UART are already connected through the memory-mapped I/O interface.
- Peripheral selection is performed using address decoding logic based on `mem_wordaddr`.
- Data from peripherals is returned to the processor through the `mem_rdata` bus.

## Project Structure

![Project Structure](TASK4/1_t4.jpeg)

### GPIO Address Decode Identification

The existing address decoding mechanism was studied to determine how a new peripheral could be integrated into the SoC.

A dedicated decode bit was assigned for the GPIO peripheral:

```verilog
localparam IO_GPIO_bit = 3;
```

This decode bit is used to identify accesses directed toward the GPIO peripheral.

### Screenshot

![GPIO Decode Bit](TASK4/3_t4.jpeg)

---

# Step 2: GPIO RTL Design

A custom RTL module named `gpio_output.v` was developed to implement the GPIO peripheral.

The module contains:

- A 32-bit register for storing GPIO data.
- Synchronous write logic triggered on the rising edge of the clock.
- Reset functionality for initialization.
- Readback support allowing software to retrieve stored values.
- Continuous output assignment to expose the register contents.

## GPIO RTL Implementation

```verilog
module gpio_output(
    input clk,
    input resetn,
    input gpio_sel,
    input gpio_we,
    input [31:0] gpio_wdata,
    output reg [31:0] gpio_rdata,
    output [31:0] gpio_out
);
```

### Working Principle

#### Reset Operation

Whenever the active-low reset signal is asserted, the GPIO register is cleared.

```verilog
if(!resetn)
    gpio_reg <= 32'd0;
```

#### Write Operation

When both the GPIO select signal and write enable signal are active, the incoming write data is stored inside the GPIO register.

```verilog
if(gpio_sel && gpio_we)
    gpio_reg <= gpio_wdata;
```

#### Read Operation

When the GPIO peripheral is selected, the stored register value is placed on the read data bus.

```verilog
gpio_rdata = gpio_reg;
```

#### Output Operation

The GPIO output always reflects the current value stored in the GPIO register.

```verilog
assign gpio_out = gpio_reg;
```

### RTL Screenshot

![GPIO RTL](TASK4/2_t4.jpeg)

---

# Step 3: GPIO Integration into the SoC

After creating the GPIO RTL module, it was integrated into the SoC top level.

The integration process consisted of address decoding, module instantiation, bus connection, and readback integration.

## GPIO Address Decoding

The processor accesses peripherals through memory-mapped addresses.

The GPIO select signal was generated using:

```verilog
assign gpio_sel = isIO & mem_wordaddr[IO_GPIO_bit];
```

### Explanation

- `isIO` indicates that the processor is accessing the I/O region.
- `mem_wordaddr` contains the decoded word address.
- `IO_GPIO_bit` uniquely identifies the GPIO peripheral.
- When this bit becomes active, the GPIO peripheral is selected.

### Screenshot

![GPIO Decode](TASK4/3_t4.jpeg)

---

## GPIO Module Instantiation

The GPIO module was instantiated inside the SoC and connected to the processor bus signals.

```verilog
gpio_output custom_gpio_inst(
    .clk(clk),
    .resetn(resetn),
    .gpio_sel(gpio_sel),
    .gpio_we(mem_wstrb),
    .gpio_wdata(mem_wdata),
    .gpio_rdata(gpio_rdata),
    .gpio_out(GPIO_OUT)
);
```

### Explanation

The connections perform the following functions:

| Signal | Purpose |
|----------|----------|
| clk | System clock |
| resetn | Active-low reset |
| gpio_sel | Peripheral selection |
| mem_wstrb | Write enable |
| mem_wdata | Data from CPU |
| gpio_rdata | Read data to CPU |
| GPIO_OUT | GPIO output |

### Screenshot

![GPIO Instance](TASK4/4_t4.jpeg)

---

## GPIO Readback Integration

To allow software to read the GPIO register, the GPIO read data was added to the SoC readback multiplexer.

```verilog
: gpio_rdata
```

### Explanation

When the processor performs a read operation targeting the GPIO address, the stored GPIO register value is returned through the `mem_rdata` bus.

### Screenshot

![GPIO Readback](TASK4/5_t4.jpeg)

---

# Step 4: Firmware Development and Simulation

To validate the GPIO peripheral, a simple firmware application was developed.

The firmware writes multiple test values into the GPIO register.

## Firmware Source Code

```c
#define GPIO_ADDR 0x00400020

volatile unsigned int *gpio =
    (volatile unsigned int *)GPIO_ADDR;

void main()
{
    *gpio = 0xABCDEF12;
    *gpio = 0xA0A0A0A0;
    *gpio = 0x02468135;

    while(1);
}
```

### Explanation

The program:

1. Defines the GPIO base address.
2. Creates a pointer to the GPIO register.
3. Writes three different values to the peripheral.
4. Keeps running indefinitely.

The final value written is:

```text
0x02468135
```

### Firmware Screenshot

![Firmware Source](TASK4/6_t4.jpeg)

---

## Firmware Compilation

The firmware was compiled using the RISC-V cross-compilation toolchain.

The resulting executable was converted into a BRAM HEX file which is loaded into the SoC memory.

### BRAM HEX Generation

![BRAM HEX Generation](TASK4/bram_hex_t4.jpeg)

---

## Firmware Verification

The generated firmware image was successfully copied to the RTL directory.

This confirms that the simulation will execute the newly generated firmware instead of the default firmware.

### Firmware Build Status

![Firmware Build](TASK4/7_t4.jpeg)

### Firmware Verification

![Firmware Verification](TASK4/8_t4.jpeg)

---

## Simulation Execution

Simulation was performed using Icarus Verilog.

### Commands Used

```bash
iverilog -DBENCH -o sim2.vvp riscv.v gpio_output.v ice40_stubs.v

vvp sim2.vvp

gtkwave sim2.vcd
```

### Purpose

- `iverilog` compiles the design.
- `vvp` executes the simulation.
- `gtkwave` visualizes signal activity.

### Simulation Log

![Simulation Log](TASK4/9_t4.jpeg)

---

# GTKWave Verification

The generated waveform was analyzed using GTKWave.

The following signals were monitored:

- clk
- resetn
- gpio_sel
- mem_addr
- mem_wdata
- GPIO_OUT

### Observations

1. Clock signal is active.
2. Reset signal is released.
3. GPIO peripheral is selected through address decoding.
4. Data is written from the processor into the GPIO register.
5. GPIO output updates correctly.

### Final GPIO Value

```text
0x02468135
```

This value matches the last value written by the firmware, confirming successful operation.

### Waveform Screenshot

![GTKWave Verification](TASK4/10_t4.jpeg)

---

# Submission Requirements

## GPIO IP RTL File

The GPIO peripheral was implemented in:

```text
RTL/gpio_output.v
```

The RTL file contains:

- Register storage
- Write logic
- Readback logic
- Reset functionality

---

## SoC Integration Description

The GPIO peripheral was integrated into the SoC by:

1. Creating a dedicated GPIO RTL module.
2. Assigning a unique decode bit (`IO_GPIO_bit = 3`).
3. Generating a GPIO select signal using address decoding.
4. Instantiating the GPIO module in the SoC top level.
5. Connecting processor write data and control signals.
6. Integrating GPIO readback into the SoC read path.
7. Routing the GPIO output to the system output bus.

This integration enables the processor to communicate with the GPIO peripheral through memory-mapped I/O transactions.

---

## Simulation Proof

Simulation was successfully completed and verified using GTKWave.

Evidence provided in this report includes:

- Firmware compilation log
- BRAM HEX generation log
- Firmware loading verification
- Simulation execution log
- GTKWave waveform screenshot

These results confirm successful operation of the GPIO peripheral.

---

# Short Explanation

## Address Used

The GPIO peripheral was assigned the memory-mapped base address:

```text
0x00400020
```

This address belongs to the I/O address region of the SoC. Whenever the processor accesses this address, the GPIO peripheral is selected through the address decoding logic and responds to the operation.

---

## How CPU Accesses the GPIO IP

The processor accesses the GPIO peripheral through memory-mapped I/O.

From the software perspective, the GPIO register behaves like a normal memory location.

### Write Example

```c
*gpio = 0x02468135;
```

### Read Example

```c
value = *gpio;
```

The CPU performs the following sequence:

1. Places the GPIO address on the address bus.
2. Places data on the write data bus.
3. Activates the write enable signal.
4. Address decoding logic selects the GPIO peripheral.
5. The GPIO register stores the incoming value.
6. The GPIO output updates accordingly.

For read operations, the stored GPIO value is returned through the processor read data bus.

---

## What Was Validated in Simulation

The simulation verified the complete functionality of the GPIO peripheral.

The following features were successfully validated:

- Correct memory-mapped address decoding.
- Successful GPIO module instantiation.
- Proper write operation.
- Register storage behavior.
- GPIO output update.
- Readback path integration.
- Correct processor-to-peripheral communication.
- Successful execution of firmware-generated writes.

The final waveform showed the GPIO output reaching:

```text
0x02468135
```

which exactly matches the last value written by the firmware.

---

# Conclusion

A custom 32-bit GPIO peripheral was successfully designed, integrated, and verified within the RISC-V SoC environment. The peripheral correctly responded to memory-mapped accesses, stored processor-generated data, and reflected the expected output value during simulation. The successful waveform verification confirms correct RTL functionality, SoC integration, firmware interaction, and overall system operation.
</details>
