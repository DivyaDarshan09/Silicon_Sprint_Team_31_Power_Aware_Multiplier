# Silicon Sprint - Team 31 
## Power-Aware 16-bit Multiplier Architecture
---
## Overview

- This project implements and evaluates multiple 16-bit multiplier architectures optimized for **low Power-Delay Product (PDP)**.
- The objective is to design a high-performance integer multiplier suitable for **energy-efficient DSP and accelerator systems**.

---
## Problem Statement

- Design a **16×16 signed integer multiplier** optimized for the **lowest possible Power-Delay Product (PDP)**.
- Deliverables include:

1. Synthesizable RTL implementation
2. Verification across the full 16-bit input range
3. Synthesis reports including:

- * Area
- * Power consumption
- * Timing performance

The multiplier architectures are evaluated to determine the most efficient design for **energy-constrained digital systems**.

---
### Implemented Architectures

- • Radix-4 Booth Multiplier
- • Radix-4 Booth + Wallace Tree Multiplier
- • Pipelined Radix-4 Booth + Wallace Tree Multiplier
- • Radix-4 Booth + 4:2 Compressor

Each architecture is implemented in **SystemVerilog**, simulated for functional correctness, and synthesized using a **TSMC 90nm standard cell library** to evaluate:

* Area
* Power
* Critical path delay
* Power-Delay Product (PDP)

The final goal is to identify the architecture achieving the **lowest PDP while maintaining reasonable area overhead.**

---
## Performance Evaluation

| Architecture                | Area (µm²) | Delay (ps) | Power (mW) | PDP (pJ) |
| --------------------------- | ---------- | ---------- | ---------- | ---      |
| Radix-4 Booth               |  5280.891  |    3862    |    0.274   |  1.05    |
| Booth + Wallace             |  6150.569  |    3346    |    0.4485  |  1.48    |
| Pipelined Booth + Wallace   | 11          | –          | –          | –        |

---
