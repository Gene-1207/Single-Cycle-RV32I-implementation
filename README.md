# Single-Cycle-RV32I-implementation

# Single-Cycle RV32I Processor Implementation

## Overview

This project focuses on the design and implementation of a **Single-Cycle RISC-V RV32I Processor** using System Verilog and Xilinx Vivado.

The processor follows the RISC-V 32-bit base integer instruction set architecture (RV32I), where each instruction is designed to complete execution within a single clock cycle.

The design is developed using a modular approach, with individual hardware components responsible for instruction fetching, decoding, register operations, control signal generation, and immediate value generation.

## Instruction Set Architecture

The implementation is based on the **RISC-V RV32I base integer ISA**, which includes the following instruction formats:

- R-Type
- I-Type
- S-Type
- B-Type
- U-Type
- J-Type

## Technologies Used

- **HDL:** System Verilog
- **EDA Tool:** Xilinx Vivado
- **Architecture:** RISC-V RV32I
- **Processor Design:** Single-Cycle Architecture
- **Version Control:** Git and GitHub


## Design Approach

The processor is developed using a modular RTL design methodology. Each component is implemented independently to simplify development, testing, debugging, and eventual integration into the complete single-cycle datapath.
