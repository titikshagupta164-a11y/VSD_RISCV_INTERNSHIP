# VSD_RISCV_INTERSHIP
## DETAILS

**Titiksha Gupta**  
*B.Tech, Electronics & Communication Engineering*  
*The LNM Institute of Information Technology (LNMIIT), Jaipur*

📧 **Email:** titikshagupta164@gmail.com

💻 **GitHub:** https://github.com/titikshagupta164-a11y

🔗 **LinkedIn:** https://www.linkedin.com/in/titiksha-gupta-

---
<details>
<summary><b>Task 1: Compilation of a C Program using GCC and RISC-V GCC Compiler</b></summary>

# Objective

The objective of this task is to understand the complete workflow of compiling a C program using both the native GCC compiler and the RISC-V cross-compilation toolchain. The task also focuses on examining the generated assembly instructions and analyzing the impact of compiler optimization levels on the generated machine code.

---

# Step 1: Program Development

A simple C program was written to calculate the sum of natural numbers from **1 to n** using a loop.

Initially, the value of **n = 9** was used to verify the correctness of the program logic.

## Source Code

![Source Code](Task1/task1_source_code_sum_to_9.png)

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

![GCC Output](Task1/task1_gcc_output_sum_to_9.png)

### Observation

For n = 9:

\[
1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 = 45
\]

The output confirms that the program logic is functioning correctly.

---

# Step 3: Program Modification and Verification

To further validate the implementation, the value of `n` was modified from **9** to **100**.

## Modified Source Code

![Modified Source Code](Task1/task1_source_code_sum_to_100.png)

The source file was then displayed using the `cat` command for verification.

## Source File Verification

```bash
cat sum1ton.c
```

![Source Verification](Task1/task1_terminal_source_listing.png)

---

# Step 4: Recompilation and Execution

After modifying the value of `n`, the program was recompiled and executed.

## Commands Used

```bash
gcc sum1ton.c
./a.out
```

## Output

![GCC Output for n = 100](Task1/task1_gcc_output_sum_to_100.png)

### Observation

For n = 100:

\[
\frac{100(100+1)}{2}=5050
\]

The obtained result matches the expected mathematical value.

---

# Step 5: Compilation Workflow

The following screenshot shows the complete workflow of program editing, compilation, and execution within the development environment.

![Compilation Workflow](Task1/task1_compilation_workflow.png)

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

---

# Step 7: Disassembling the Object File

The generated object file was analyzed using the RISC-V disassembler.

## Command

```bash
riscv64-unknown-elf-objdump -d sum1ton.o
```

## Disassembly Output

![RISC-V Disassembly](Task1/task1_riscv_objdump_disassembly.png)

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

![O1 Optimization Analysis](Task1/task1_o1_optimization_main_function.png)

### What is O1 Optimization?

`-O1` performs fundamental optimization techniques such as:

- Dead code elimination
- Constant propagation
- Basic instruction scheduling
- Simple loop optimization

### Observation

The generated assembly preserves most of the original program structure and contains explicit loop-related instructions. This makes the generated assembly easier to understand while still improving performance compared to unoptimized code.

---

# Step 9: Analysis of Ofast Optimization

The same source code was compiled using the **-Ofast** optimization level.

## Command

```bash
riscv64-unknown-elf-gcc -Ofast -mabi=lp64 -march=rv64i -c sum1ton.c
```

## Main Function Generated with Ofast

![Ofast Optimization Analysis](Task1/task1_ofast_optimization_main_function.png)

### What is Ofast Optimization?

`-Ofast` enables aggressive compiler optimizations including:

- All optimizations provided by `-O3`
- Function inlining
- Advanced instruction scheduling
- Constant folding
- Loop transformations
- Performance-focused code generation

### Observation

Compared to `-O1`, the generated assembly contains fewer instructions and more efficient execution paths. The compiler aggressively simplifies operations, resulting in improved runtime performance.

---

# Comparison of O1 and Ofast

| Feature | O1 | Ofast |
|----------|----------|----------|
| Optimization Level | Basic | Aggressive |
| Instruction Count | Higher | Lower |
| Code Readability | Easier | More Complex |
| Execution Speed | Moderate | Faster |
| Performance | Improved | Highly Optimized |

---

# Key Learning Outcomes

- Understanding the GCC compilation workflow.
- Learning RISC-V cross-compilation techniques.
- Generating object files for the RV64I architecture.
- Using `objdump` to analyze assembly instructions.
- Understanding the relationship between C code and machine instructions.
- Studying the impact of compiler optimization levels on generated code.

---

# Conclusion

This task provided hands-on experience with both native compilation and RISC-V cross-compilation workflows. A C program was successfully developed, compiled, and executed using GCC. The same program was then cross-compiled for the RV64I architecture using the RISC-V GCC toolchain.

The generated object code was analyzed using `objdump`, providing insight into how high-level C code is translated into assembly instructions. Furthermore, the comparison between `-O1` and `-Ofast` optimization levels demonstrated how compiler optimizations can significantly influence instruction count, code efficiency, and overall execution performance.

This exercise established a strong foundation in compiler behavior, assembly analysis, and RISC-V software development.

</details>
