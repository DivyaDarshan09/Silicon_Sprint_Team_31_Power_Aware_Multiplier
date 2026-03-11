# Radix-4 Booth Multiplier (16-bit)

## Overview

This module implements a **16×16 signed multiplier** using the **Radix-4 Booth algorithm**.
Radix-4 Booth encoding reduces the number of partial products by grouping multiplier bits in pairs, improving speed and reducing hardware complexity.

---
## Architecture

The multiplier consists of the following stages:

1. **Booth Pre-Encoder**
2. **Booth Encoder**
3. **Partial Product Generator**
4. **Shift Alignment**
5. **Final Adder**

```
X,Y
 ↓
Booth Encoder
 ↓
Partial Product Generator
 ↓
Shifted Partial Products
 ↓
Adder
 ↓
Product
```
---
## Key Idea

Radix-4 Booth encoding examines **3 bits of the multiplier at a time**:

| y₂ y₁ y₀ | Operation |
| -------- | --------- |
| 000      | 0         |
| 001      | +X        |
| 010      | +X        |
| 011      | +2X       |
| 100      | -2X       |
| 101      | -X        |
| 110      | -X        |
| 111      | 0         |

This reduces **N partial products to N/2**.

---
## Parameters

| Parameter | Description                 |
| --------- | --------------------------- |
| N         | Operand width (default: 16) |

---
## Advantages

* Reduces number of partial products
* Faster multiplication compared to array multipliers
* Lower switching activity

---
## Results (90nm)

| Metric | Value    |
| ------ | -------- |
| Area   | 5280 µm² |
| Delay  | 3862 ps  |
| Power  | 0.274 mW |
| PDP    | 1.05 pJ  |

---
## Files

* `booth_encoder.sv`
* `booth_preencode.sv`
* `partial_product_gen.sv`
* `booth_top.sv`

---
## Verification

Testbench includes:

* Zero multiplication
* Maximum values
* Negative numbers
* Random tests

---

## Simulation Results



![rtl](images/rtl.png)

