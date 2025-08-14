# Systolic Array for Matrix Multiplication -- This mini project was done per STMicroelectronics lab

## Overview
This project implements a **systolic array** architecture for performing matrix multiplication in hardware.  
It is written in **SystemVerilog** and designed for parameterized square matrices of size `N_SIZE × N_SIZE`.  
The design supports pipelined dataflow for high performance and has been tested for multiple matrix sizes.

## Architecture
- **2D register arrays** (`A_reg` and `B_reg`) buffer inputs to enable pipelined propagation.
- **Processing Elements (PEs)** perform multiply-accumulate (MAC) operations, passing partial results across the array.
- **Top-left PE (PE[0][0])** uses direct inputs to reduce latency by one cycle.
- Fully **parameterized by `N_SIZE`**, allowing scalability.
- **Control signals** (`counter`, `reg_idx`, `valid_out`) coordinate loading, computation, and output timing.

## Operation Phases
1. **Data Load**: Streams in columns of `A` and rows of `B` into internal registers.
2. **Multiply-Accumulate**: Diagonal propagation updates all partial sums.
3. **Output**: Asserts `valid_out` and streams the final matrix `C` row-by-row.

## Testing
- Implemented self-checking testbench.
- Test cases included: `3×3`, `4×4`, `5×5` (default).
- Compares DUT output with expected results on `valid_out` signal.
- Reports mismatches with element location.

## Simulation
- Simulated using **QuestaSim 2023.3**.
- Includes `run.do` and `wave.do` scripts for automation and waveform visualization.
- Waveform shows input streaming, computation, and output timing.

## Synthesis
- Synthesized with **Quartus Prime 20.1**.
- Successfully compiled with no functional errors.
- Minor warnings due to intentional counter width matching.

## How to Run
1. Open in **QuestaSim**.
2. Load the provided `run.do` script.
3. To change matrix size:
   - Edit `N_SIZE` in `systolic_array.sv`.
   - Update testbench configuration.  
