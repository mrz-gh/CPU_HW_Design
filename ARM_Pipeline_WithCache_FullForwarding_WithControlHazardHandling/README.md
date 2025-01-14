# What
This is the repository of 
-	Computer Architecture Lab 
-	@ University of Tehran
-	Spring 2023
-	Authors: Amirreza Gholami & Mohammad Mahdi Moeini Manesh

# 5-Stage In-Order ARM CPU Core

## Features

- 5-stage in-order pipeline
- Limited ARM instruction set
- Full forwarding (bypassing) logic
- Stall logic implementation
- Static branch preditction
- Separate Instruction and Data Memory (Harvard Architecture)
- Emulating Memory with SRAM
- Featuring Cache (./Cache) (Also Without Cache (./SRAM))

## Pipeline Stages

1. **Instruction Fetch (IF)**: Fetches the instruction from memory.
2. **Instruction Decode (ID)**: Decodes the fetched instruction and reads the necessary registers.
3. **Execute (EX)**: Performs arithmetic or logical operations.
4. **Memory Access (MEM)**: Accesses memory for load and store instructions.
5. **Write Back (WB)**: Writes the result back to the register file.



