# README for MIPS Pipeline Processor Design Project

## Overview
This project involves designing a **pipelined MIPS processor** based on the specifications provided in the Computer Architecture course (CA#04). The processor supports a subset of MIPS instructions, including arithmetic/logical operations, memory reference instructions, and control flow instructions. The design focuses on implementing **data hazard detection and resolution** in hardware, while **control hazards** are handled using **NOP (No Operation)** instructions. The processor is tested with a program that finds the smallest element in a 10-element array and writes the result to memory.

---

## Processor Specifications

### Supported Instructions
The processor supports the following MIPS instructions:

#### Arithmetic/Logical Instructions:
- **add**: Add two registers.
- **addi**: Add an immediate value to a register.
- **sub**: Subtract two registers.
- **slt**: Set less than (compare two registers).
- **slti**: Set less than immediate (compare register with immediate value).
- **and**: Bitwise AND operation.
- **or**: Bitwise OR operation.

#### Memory Reference Instructions:
- **lw**: Load word from memory into a register.
- **sw**: Store word from a register into memory.

#### Control Flow Instructions:
- **j**: Unconditional jump.
- **jal**: Jump and link (used for function calls).
- **jr**: Jump to address in register.
- **beq**: Branch if equal.

---

## Pipeline Design
The processor is designed as a **5-stage pipeline** with the following stages:
1. **Instruction Fetch (IF)**: Fetch the instruction from memory.
2. **Instruction Decode (ID)**: Decode the instruction and read registers.
3. **Execute (EX)**: Perform arithmetic/logical operations or calculate memory addresses.
4. **Memory Access (MEM)**: Access memory for load/store operations.
5. **Write Back (WB)**: Write results back to registers.

### Hazard Handling
- **Data Hazards**: Detected and resolved using **forwarding (bypassing)** and **stalling** when necessary.
- **Control Hazards**: Handled by inserting **NOP (No Operation)** instructions (e.g., `add R0, R0, R0`) to flush the pipeline when a branch is taken.

---

## Test Program
The processor is tested with a program that performs the following tasks:
1. Finds the **smallest element** in a 20-element array starting at memory address **1000**.
2. Writes the **smallest element** to memory address **2000**.
3. Writes the **index of the smallest element** to memory address **2004**.


---

## How to Run the Project

### Prerequisites
- **Verilog HDL**: The processor is implemented in Verilog.
- **Simulation Tool**: Use **ModelSim** or **Questasim** for simulation.
- **Test Program**: The test program is written in assembly and should be loaded into the processor's memory.

### Steps to Run the Project
1. **Clone the Repository**:
   - Clone the repository containing the Verilog code for the processor and the test program.

2. **Open the Project in ModelSim/Questasim**:
   - Launch the simulation tool and create a new project.
   - Add all Verilog files (`*.v`) to the project.

3. **Compile the Verilog Code**:
   - Compile all Verilog files. Ensure there are no syntax errors.

4. **Load the Test Program**:
   - Load the test program (assembly or machine code) into the processor's memory. This can be done by initializing the memory module in Verilog with the test program data.

5. **Run the Simulation**:
   - Start the simulation and run it for enough clock cycles to allow the processor to execute the test program fully.

6. **Analyze the Results**:
   - Check memory addresses **2000** and **2004** to verify that the smallest element and its index have been correctly written.
   - Inspect the waveform to ensure the processor is functioning as expected.

7. **Debugging (if necessary)**:
   - If the results are incorrect, use the waveform and simulation logs to debug the design.
   - Check control signals, register values, and memory accesses to identify issues.

---

## Contact
For any questions or clarifications, please contact me.