# Silicon Sprint Hackathon 2026
## Power-Aware 16-bit Multiplier Architectures

**Team:** Silicon Sprint – Team 31

**Event:** Silicon Sprint Hackathon
**Organized by:** Mindgrove Technologies
**In collaboration with:** SRM Institute of Science and Technology
**Date:** March 10–11, 2026

---
## 🎯 Overview

- This project implements and evaluates multiple 16-bit multiplier architectures optimized for **low Power-Delay Product (PDP)**.
- The objective is to design a high-performance integer multiplier suitable for **energy-efficient DSP and accelerator systems**.

---
## 🎯 Problem Statement

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
### ⚙️ Technology & Tools

| Category        | Tool                        |
| --------------- | --------------------------- |
| RTL Design      | SystemVerilog               |
| Simulation      | Cadence Xcelium             |
| Synthesis       | Cadence Genus               |
| Technology Node | 90 nm Standard Cell Library |

---
# 🧠 Multiplier Architectures Implemented

We implemented and analyzed the following architectures:

### 1️⃣ Radix-4 Booth Multiplier

Reduces the number of partial products by grouping multiplier bits in pairs.

Key idea:

```
16 partial products → 8 partial products
```

Benefits:

* Lower switching activity
* Reduced hardware complexity
* Good PDP efficiency

---

### 2️⃣ Wallace Tree Multiplier

Uses **parallel carry-save compression** to reduce partial products quickly.

Architecture:

```
Partial Products
        ↓
Wallace Tree Reduction
        ↓
Final Carry Propagate Adder
```

Benefits:

* Very fast multiplication
* Reduced critical path delay

Trade-off:

* Higher switching activity
* Increased dynamic power

---

### 3️⃣ Radix-4 Booth + Wallace Tree

Combines:

* **Booth encoding → fewer partial products**
* **Wallace compression → faster reduction**

Architecture:

```
Inputs
  ↓
Radix-4 Booth Encoder
  ↓
Partial Product Generator
  ↓
Wallace Tree Reduction
  ↓
Final Adder
  ↓
Product
```

---

### 4️⃣ Radix-4 Booth + Dadda Tree

Uses **Dadda reduction**, which minimizes the number of compressors required.

Reduction sequence:

```
8 → 6 → 4 → 3 → 2
```

Advantages:

* Lower number of adders
* Reduced power consumption
* Slightly better PDP compared to Wallace

---

### 5️⃣ Pipelined Radix-4 Booth + Wallace Multiplier

We implemented a **3-stage pipelined architecture** to improve throughput.

Pipeline stages:

```
Stage 1
Booth Encoding + Partial Product Generation

Stage 2
Wallace Reduction (Stage1 + Stage2)

Stage 3
Final Wallace Reduction + CLA Adder
```

Benefits:

* Higher clock frequency
* Increased throughput

Trade-off:

* Increased power due to pipeline registers
* Higher PDP compared to non-pipelined designs

---

# 📊 Evaluation Metrics

The following metrics were used to evaluate each architecture:

| Metric | Description             |
| ------ | ----------------------- |
| Power  | Total power consumption |
| Delay  | Critical path delay     |
| Area   | Synthesized cell area   |
| PDP    | Power × Delay           |

**PDP definition:**

```
PDP = Power \times Delay
```
---
# 📈 Key Observations

### Radix-4 Booth

* Low switching activity
* Good power efficiency
* Competitive PDP

---

### Radix-4 Booth + Wallace

* Faster reduction
* Higher power consumption due to many compressors

---

### Radix-4 Booth + Dadda

* Similar delay to Wallace
* Slightly lower power
* **Lowest PDP among non-pipelined designs**

---

### Pipelined Radix-4 Booth + Wallace

* Critical path divided into **3 stages**
* Higher achievable clock frequency
* Increased power consumption due to pipeline registers
* PDP increases compared to non-pipelined designs

However, it provides **significantly higher throughput**.

---
## Performance Evaluation

| Architecture                | Area (µm²) | Delay (ps) | Power (mW) | PDP (pJ) |
| --------------------------- | ---------- | ---------- | ---------- | ---      |
| Radix-4 Booth               |  5280.891  |    3862    |   0.274    |  1.05    |
| NP Booth + Wallace          |  6150.569  |    3346    |   0.4485   |  1.48    |
| Pipelined Booth + Wallace   | 11403.455  |    3000    |   3.6      |  10.8    |

---
# 🏆 Final Solution

- The primary objective of this project was to design a **16-bit multiplier architecture with the lowest possible Power-Delay Product (PDP)**.
- After implementing and synthesizing multiple multiplier architectures, the following observations were made:

- * **Radix-4 Booth + Wallace Tree** and **Radix-4 Booth + Dadda Tree** achieved very similar performance in terms of delay.
- * However, **Radix-4 Booth + Dadda Tree required fewer compressor units**, resulting in **lower switching activity and reduced dynamic power consumption**.
- * Because of this reduction in power while maintaining comparable delay, the **Radix-4 Booth + Dadda architecture produced the lowest PDP among all evaluated designs**.

- Although the **pipelined Radix-4 Booth + Wallace multiplier** achieved significantly higher clock frequency due to the division of the critical path into multiple stages, the introduction of pipeline registers increased switching activity and power consumption. As a result, the pipelined design showed a **higher overall PDP compared to the non-pipelined architectures**.
- Therefore, considering the project goal of minimizing **Power-Delay Product**, the **Radix-4 Booth + Dadda Tree multiplier is selected as the final optimized solution**.

### Final Selected Architecture
```
Radix-4 Booth Encoding
↓
Partial Product Generation
↓
Dadda Tree Compression
↓
Final Carry Propagate Adder
↓
Product Output
```

This architecture achieves the **best balance between power efficiency and computational delay**, making it the most suitable design for the **Power-Aware Multiplier problem in Silicon Sprint 2026**.

---
