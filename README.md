# README for CPU Hardware Design Repository

## Overview
This repository contains various implementations of **RISC CPU**, primarily MIPS, designed as part of a Computer Architecture course. The repository includes single-cycle, multi-cycle, and pipelined processor designs, along with additional tools and reference materials. Each folder contains a specific implementation or resource, as described below.

---

## Repository Structure

### 1. **ARMish_MultiCycle**
This folder contains the implementation of a **multi-cycle processor** inspired by the ARM architecture. The design supports a subset of ARM-like instructions and is implemented in Verilog. The multi-cycle design breaks instruction execution into multiple clock cycles, improving resource utilization.

### 2. **Mars45.jar**
This is the **MARS (MIPS Assembler and Runtime Simulator)** tool, version 4.5. MARS is used to write, assemble, and simulate MIPS assembly programs. It is a valuable tool for testing and debugging MIPS programs before running them on the processor implementations in this repository.

### 3. **MIPS_Pipeline_FullForwarding_NoControlHazardHandling**
This folder contains a **pipelined MIPS processor** implementation with **full forwarding** to handle data hazards. However, this design does **not handle control hazards** (e.g., branches and jumps). It is a basic pipelined implementation suitable for understanding pipeline stages and forwarding mechanisms.

### 4. **MIPS_Pipeline_FullForwarding_WithControlHazardHandling**
This folder contains a **pipelined MIPS processor** implementation with **full forwarding** and **control hazard handling**. Control hazards are handled using flush(kill) technique. This design is more advanced and closer to a real-world pipelined processor.

### 5. **MIPSReference.pdf**
This is a reference document that provides detailed information about the **MIPS instruction set architecture (ISA)**, including instruction formats, opcodes, and functionality. It is a useful resource for understanding the MIPS instructions supported by the processors in this repository.

### 6. **MIPS_SingleCycle**
This folder contains the implementation of a **single-cycle MIPS processor**. In this design, each instruction is executed in a single clock cycle. The implementation supports a subset of MIPS instructions, including arithmetic/logical operations, memory access, and control flow instructions.

### 7. **MIPS_SingleCycle_MoreInstructions**
This folder contains an **extended version of the single-cycle MIPS processor** that supports **additional instructions** beyond the basic set. This implementation is useful for exploring how to extend a processor's instruction set and modify the control unit and data path accordingly.

---

## How to Use This Repository

### Prerequisites
- **Verilog HDL**: The processor designs are implemented in Verilog.
- **Simulation Tool**: Use **ModelSim** or **Questasim** for simulating the Verilog designs.
- **MARS (Mars45.jar)**: Use MARS to write and test MIPS assembly programs.

### Steps to Run the Projects
1. **Clone the Repository**:
   ```bash
   git clone <repository-url>
   ```
   Replace `<repository-url>` with the actual URL of this repository.

2. **Choose a Design**:
   - Navigate to the folder corresponding to the processor design you want to simulate (e.g., `MIPS_SingleCycle`, `MIPS_Pipeline_FullForwarding_WithControlHazardHandling`, etc.).

3. **Compile and Simulate**:
   - Open the Verilog files in your simulation tool (e.g., ModelSim or Questasim).
   - Compile the Verilog code and run the simulation.
   - Load the test program (assembly or machine code) into the processor's memory.

4. **Test with MARS**:
   - Use `Mars45.jar` to write and test MIPS assembly programs.
   - Convert the assembly program to machine code and load it into the processor's memory for simulation.

5. **Analyze Results**:
   - Check the simulation waveform and memory/register values to verify the correctness of the processor design.
   - Debug any issues by inspecting control signals, register values, and memory accesses.

---

## Key Features of Each Design

### Single-Cycle Processors (`MIPS_SingleCycle` and `MIPS_SingleCycle_MoreInstructions`)
- **Simple Design**: Each instruction is executed in one clock cycle.
- **Basic Instruction Set**: Supports arithmetic/logical, memory access, and control flow instructions.
- **Extended Instruction Set**: The `MIPS_SingleCycle_MoreInstructions` folder includes additional instructions for more advanced functionality.

### Multi-Cycle Processor (`ARMish_MultiCycle`)
- **Multi-Cycle Execution**: Instructions are broken into multiple clock cycles for better resource utilization.
- **ARM-Like Design**: Inspired by the ARM architecture, with support for a subset of ARM-like instructions.

### Pipelined Processors (`MIPS_Pipeline_FullForwarding_NoControlHazardHandling` and `MIPS_Pipeline_FullForwarding_WithControlHazardHandling`)
- **Pipelined Execution**: Instructions are executed in stages (IF, ID, EX, MEM, WB) for higher throughput.
- **Full Forwarding**: Data hazards are resolved using forwarding techniques.
- **Control Hazard Handling**: The `WithControlHazardHandling` folder includes mechanisms to handle control hazards (e.g., branches and jumps).

---

## Evaluation and Testing
Each processor design can be tested using MIPS assembly programs. The repository includes example programs for testing basic functionality, such as finding the largest or smallest element in an array. You can also write your own programs using MARS and test them on the processor designs.

---

## Contact
For any questions or issues, please contact the me.