# CPU Hardware Design Repository

This repository contains implementations of various CPU architectures, including single-cycle and pipelined designs, with a focus on ARM and MIPS instruction sets. The designs range from basic single-cycle implementations to more advanced pipelined architectures with features like forwarding and hazard handling.

## Repository Structure

The repository is organized as follows:

```
.
├── ARMish_MultiCycle/                  # Multi-cycle ARM-like CPU implementation
├── ARM_Pipeline_WithCache_FullForwarding_WithControlHazardHandling/  # ARM pipelined CPU with cache, forwarding, and control hazard handling
├── Mars45.jar                          # MIPS Assembler and Runtime Simulator (MARS) for testing and debugging
├── MIPS_Pipeline_FullForwarding_NoControlHazardHandling/  # MIPS pipelined CPU with full forwarding but no control hazard handling
├── MIPS_Pipeline_FullForwarding_WithControlHazardHandling/  # MIPS pipelined CPU with full forwarding and control hazard handling
├── MIPSReference.pdf                   # Reference document for MIPS architecture and instructions
├── MIPS_SingleCycle/                   # Basic single-cycle MIPS CPU implementation
├── MIPS_SingleCycle_MoreInstructions/  # Extended single-cycle MIPS CPU with additional instructions
└── README.md                           # This file
```

## Contents

### 1. **ARM Implementations**
   - **ARMish_MultiCycle**: A multi-cycle implementation of an ARM-like CPU.
   - **ARM_Pipeline_WithCache_FullForwarding_WithControlHazardHandling**: A pipelined ARM CPU with cache, full forwarding, and control hazard handling.

### 2. **MIPS Implementations**
   - **MIPS_SingleCycle**: A basic single-cycle implementation of a MIPS CPU.
   - **MIPS_SingleCycle_MoreInstructions**: An extended single-cycle MIPS CPU supporting additional instructions.
   - **MIPS_Pipeline_FullForwarding_NoControlHazardHandling**: A pipelined MIPS CPU with full forwarding but no control hazard handling.
   - **MIPS_Pipeline_FullForwarding_WithControlHazardHandling**: A pipelined MIPS CPU with full forwarding and control hazard handling.

### 3. **Tools and Resources**
   - **Mars45.jar**: The MIPS Assembler and Runtime Simulator (MARS) for assembling, testing, and debugging MIPS programs.
   - **MIPSReference.pdf**: A reference document for the MIPS architecture, including instruction set details.

---

## Getting Started

### Prerequisites
- A Verilog simulator (e.g., [ModelSim](https://www.mentor.com/products/fpga/modelism/), [Icarus Verilog](http://iverilog.icarus.com/)). 
   - preferably ModelSim and QuestaSim because there is a Makefile customized for these simulator in the folder /sim in every project.
- Java Runtime Environment (JRE) for running `Mars45.jar`.

### Running the Simulations
1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/CPU_HW_Design.git
   cd CPU_HW_Design
   ```

2. Navigate to the desired CPU implementation directory, e.g.:
   ```bash
   cd MIPS_SingleCycle
   ```

3. Compile and simulate the Verilog design using your preferred Verilog simulator. For example, with Icarus Verilog:
   ```bash
   iverilog -o simv top_module.v testbench.v
   vvp simv
   ```

4. For MIPS programs, use `Mars45.jar` to assemble and test your code:
   ```bash
   java -jar Mars45.jar program.asm
   ```

---

## Contributing

Contributions to this repository are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

1. Fork the repository.
2. Create a new branch for your feature or bugfix:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "Add your commit message here"
   ```
4. Push to the branch:
   ```bash
   git push origin feature/your-feature-name
   ```
5. Open a pull request.

---


## Acknowledgments
- [MARS (MIPS Assembler and Runtime Simulator)](http://courses.missouristate.edu/KenVollmar/mars/) for providing a robust environment to test MIPS programs.
- The MIPS and ARM architectures for serving as the foundation of these designs.

---

## Contact

For questions or feedback, feel free to reach out through GitHub Issues. 
