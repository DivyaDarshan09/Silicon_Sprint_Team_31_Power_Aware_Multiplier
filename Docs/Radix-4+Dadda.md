# Radix-4 Booth + Wallace Tree Multiplier

## Overview

- This design combines **Radix-4 Booth encoding** with **Wallace tree reduction** to achieve a high-performance multiplier.
- Booth encoding reduces the number of partial products, while the Wallace tree accelerates their reduction.

---
## Architecture

```
Inputs
 ↓
Radix-4 Booth Encoder
 ↓
Partial Product Generator
 ↓
Wallace Reduction Tree
 ↓
Carry Propagate Adder
 ↓
Product
```
---
## Benefits

* Fewer partial products (Booth)
* Fast parallel reduction (Wallace)
* Reduced critical path

---
## Design Flow

1. Booth encoding of multiplier bits
2. Generation of signed partial products
3. Wallace tree reduction
4. Final addition

---
## Results (90nm)

| Metric | Value        |
| ------ | --------     |
| Area   | 6150.569 µm² |
| Delay  | 3346  ps     |
| Power  | 0.4485 mW    |
| PDP    | 1.48 pJ      |

---
## Modules

- * Booth encoder
- * Partial product generator
- * Wallace tree compressor
- * Final adder

---
## Verification

* Edge cases
* Signed multiplication
* Randomized testing
