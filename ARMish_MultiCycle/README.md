# README for Multi-Cycle Processor (ARMish-like ISA) Design Project

## Overview
This project involves designing a multi-cycle processor based on the RISC ISA provided in the Computer Architecture course (CA#03). The processor is implemented in Verilog-2001 and will be tested with a specific program to ensure its correctness and functionality. The design can be simulated using **Questasim** or **ModelSim**.

## Processor Specifications
The processor has the following features:
- **General-Purpose Registers**: 16 registers (R0 to R15).
- **Flags**: Four flags (N, Z, C, V) that change based on instruction execution.
- **Address Space**: Supports a 4GB address space (32-bit word addressing).
- **Instruction Set**: All instructions are 32 bits long.
- **Instruction Types**:
  - **Data Processing Instructions**: Perform arithmetic and logical operations.
  - **Data Transfer Instructions**: Handle data movement between memory and registers.
  - **Branch Instructions**: Control flow instructions for jumping to different parts of the program.

## Instruction Formats
- **Data Processing Instructions**:
  ```
  |C|000000|I|opc|Rn|Rd|Op2|
  ```
- **Data Transfer Instructions**:
  ```
  |C|010000000|L|Rb|Rd|Offset|
  ```
- **Branch Instructions**:
  ```
  |C|101|L|Offset|
  ```

## Condition Codes
The `C` field in the instructions determines the condition under which the instruction is executed. The conditions are:
- **00 (EQ)**: Execute if the Z flag is set.
- **01 (GT)**: Execute if Z is clear, and either N is set and V is set, or N is clear and V is clear.
- **10 (LT)**: Execute if N is set and V is clear, or N is clear and V is set.
- **11 (AL)**: Always execute.

## Data Processing Instructions
The `opc` field in data processing instructions specifies the operation to be performed:
- **000 (ADD)**: Add `Rn` and `Op2`, store result in `Rd`.
- **001 (SUB)**: Subtract `Op2` from `Rn`, store result in `Rd`.
- **010 (RSB)**: Subtract `Rn` from `Op2`, store result in `Rd`.
- **011 (AND)**: Bitwise AND of `Rn` and `Op2`, store result in `Rd`.
- **100 (NOT)**: 2's complement of `Op2`, store result in `Rd`.
- **101 (TST)**: Set condition codes based on `Rn AND Op2`.
- **110 (CMP)**: Set condition codes based on `Rn - Op2`.
- **111 (MOV)**: Move `Op2` to `Rd`.

## Data Transfer and Branch Instructions
- **Data Transfer**:
  - **Load**: `Rd = Mem[Rb + Offset]`
  - **Store**: `Mem[Rb + Offset] = Rd`
- **Branch**:
  - **B**: Jump to `PC + Offset`
  - **B and Link**: Jump to `PC + Offset`, store return address in `R15`

## Flags Affected by Instructions
- **Z (Zero)**: Affected by all instructions.
- **C (Carry)**: Affected by ADD, SUB, RSB, CMP.
- **N (Negative)**: Affected by all instructions.
- **V (Overflow)**: Affected by ADD, SUB, RSB, CMP.

---

## Test Program
The processor will be tested with the following assembly program, which finds the smallest element in a 10-element array starting at memory address 1000. The program writes the smallest element and its index to memory addresses 2000 and 2004, respectively.

### Assembly Program
```assembly
addi R3, R0, 1000        ; R3 = R0 + 1000 (Initialize R3 with 1000)
addi R4, R0, 0           ; R4 = R0 + 0 (Initialize R4 to 0)
addi R2, R0, 0           ; R2 = R0 + 0 (Initialize R2 to 0)
CMP R2, 10               ; Compare R2 with 10
BEQ 12                   ; Branch to instruction 12 if Z flag is set (R2 == 10)
lw R5, 1000(R2)          ; Load value from memory address (R2 + 1000) into R5
CMP R5, R3               ; Compare R5 with R3
BGT 10                   ; Branch to instruction 10 if R5 > R3
addi R3, R5, 0           ; R3 = R5 + 0 (Update R3 with R5)
addi R4, R2, 0           ; R4 = R2 + 0 (Update R4 with R2)
addi R2, R2, 1           ; R2 = R2 + 1 (Increment R2)
J 3                      ; Jump to instruction 3 (loop)
sw R3, 2000(R0)          ; Store R3 into memory address 2000
sw R4, 2004(R0)          ; Store R4 into memory address 2004
```

---

## How to Run the Project

### Prerequisites
- **Verilog HDL**: The processor is implemented in Verilog.
- **Simulation Tool**: You can use **Questasim** or **ModelSim** for simulation.
- **Test Program**: The test program is written in assembly or machine code and should be loaded into the processor's memory.

### Steps to Run the Project

1. **Clone the Repository**:
   - Clone the repository containing the Verilog code for the processor and the test program.

2. **Open the Project in Questasim/ModelSim**:
   - Launch Questasim or ModelSim.
   - Create a new project and add all the Verilog files (`*.v`) to the project.

3. **Compile the Verilog Code**:
   - Compile all the Verilog files in the project. Ensure there are no syntax errors.

4. **Load the Test Program**:
   - Load the test program (assembly or machine code) into the processor's memory. This can be done by initializing the memory module in Verilog with the test program data.

5. **Run the Simulation**:
   - Start the simulation in Questasim/ModelSim.
   - Run the simulation for enough clock cycles to allow the processor to execute the test program fully.

6. **Analyze the Results**:
   - Check the memory locations 2000 and 2004 to verify that the smallest element and its index have been correctly written.
   - Inspect the waveform to ensure that the processor is functioning as expected.

7. **Debugging (if necessary)**:
   - If the results are incorrect, use the waveform and simulation logs to debug the design.
   - Check the control signals, register values, and memory accesses to identify any issues.

---
## DataPath
![alt text](<figures/Screenshot from 2025-01-14 17-39-03.png>)
## Controller
![alt text](<./figures/Screenshot from 2025-01-14 17-39-21.png>)





---
## Contact
For any questions or clarifications, please contact me.
