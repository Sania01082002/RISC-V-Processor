# RISC-V-Processor
# Abstract
This project implements a single-cycle RISC-V processor core in Verilog, supporting RV32I instructions: ADDI, ADD, SUB, LW, and SW. Each instruction executes in one clock cycle. The architecture includes a program counter, 256x32-bit instruction and data memory, 32x32-bit register file, and ALU. The core was simulated and verified using Icarus Verilog on EDA Playground, with a testbench validating functionality. A block diagram created in Draw.io illustrates the core’s components and data flow.
# Objectives

Design a single-cycle RISC-V processor core in Verilog supporting ADDI, ADD, SUB, LW, and SW.
Verify instruction execution through simulation on EDA Playground.
Validate signal transitions (e.g., pc, instr, alu_result) using EPWave.
Document the architecture with a Draw.io block diagram.

# Working Flow Explanation
The processor operates in a single-cycle architecture:

Instruction Fetch: The program counter (pc) addresses instruction memory, fetching a 32-bit instruction (instr). pc increments by 4.
Decode: The instruction is decoded to extract opcode, funct3, rd, rs1, rs2, and imm (immediate). Source registers (rs1, rs2) are read from the register file.
Execute: The ALU processes the instruction:

ADDI: Adds rs1 and imm to rd.
ADD: Adds rs1 and rs2 to rd.
SUB: Subtracts rs2 from rs1 to rd.
SW: Stores rs2 to memory at rs1 + imm.
LW: Loads data from memory at rs1 + imm to rd.


Write Back: Results are written to the register file (rd) or memory.
Signal Update: alu_result reflects the ALU computation; signals like imm, rs1, rs2 are updated for verification.

# Result Explanation
The testbench executed a program with:

ADDI x5, x0, 5: Set x5=5.
ADDI x6, x0, 6: Set x6=6.
ADD x7, x5, x6: Set x7=11 (5 + 6).
SW x7, 0(x5): Stored 11 in memory address 5.
LW x8, 0(x5): Loaded 11 from memory address 5 to x8.
Simulation output confirmed: x5=5, x6=6, x7=11, x8=11, Mem[5]=11, PC=0x14. EPWave waveforms verified: pc (0→4→8→12→16→20), instr (e.g., 00500293, 00600313, 006283b3), alu_result (5, 6, 11, 5, 5), and signals (imm, rs1, rs2, opcode, funct3, rd, reg_x5–x8, mem_5). The core supports SUB, though not tested in this run.

# Conclusion
The RISC-V processor core successfully executes ADDI, ADD, SW, and LW, with SUB implemented but untested in the simulation. The design is efficient, and verification confirms functional correctness. This project is ideal for a hardware design portfolio. Future work could include testing SUB or adding more RV32I instructions.

## Files
- design.sv : Design code
- testbench.sv : testbench code
- Result_waveform_RISC-V.png : waveform output
- Result_console_RISC-v : console output
