# Pipeline---register---handshake
Single stage pipeline register with valid/ready handshake in SystemVerilog
# Single-Stage Pipeline Register with Valid/Ready Handshake

## Overview
This repository implements a **single-stage pipeline register** in **SystemVerilog** using a standard **valid/ready handshake protocol**.

The module sits between an input and output interface, stores one data item, and correctly handles **backpressure** without data loss or duplication. The design is fully synthesizable and resets to a clean empty state.

---

## Task
Implement a single-stage pipeline register in SystemVerilog using a standard valid/ready handshake.

---

## Handshake Protocol

### Input Interface
| Signal | Direction | Description |
|--------|-----------|-------------|
| `in_valid` | Input | Upstream data valid |
| `in_ready` | Output | Stage ready to accept |
| `in_data` | Input | Input data bus |

### Output Interface
| Signal | Direction | Description |
|--------|-----------|-------------|
| `out_valid` | Output | Output data valid |
| `out_ready` | Input | Downstream ready |
| `out_data` | Output | Output data bus |

---

## Key Logic
Accept new data only when stage is empty OR downstream is consuming data simultaneously. This prevents data overwrite and loss.

---

## Features
- Fully synthesizable RTL
- Uses `always_ff` with non-blocking assignments
- Active low reset to clean empty state
- No latches, no delays
- Backpressure handled correctly
- No data loss or duplication

---

## Simulation

Three test cases verified:
1. **Normal transfer** — basic data flow
2. **Backpressure** — output stalled for 3 cycles, data held correctly
3. **Continuous traffic** — 5 random transfers back to back

Tools used: **Icarus Verilog**, **GTKWave**

---

## Synthesis

Synthesized using **Yosys** — 0 problems reported.

Cells inferred:
- DFF (flip flops)
- MUX
- NAND
- ORNOT

---

## Files
| File | Description |
|------|-------------|
| `pipeline_reg.sv` | RTL design |
| `tb_pipeline_reg.sv` | Testbench |
| `wave.vcd` | Simulation waveform |
| `synthesis` | Synthesis report |
---

## Applications
- CPU pipelines
- NoC routers
- DMA engines
- AI accelerators
- Memory subsystems

---

## Author
**Dhanya H**  
