# Radix-4 Booth + Dadda Tree Multiplier

## Overview

This module implements a **16-bit signed multiplier** using **Radix-4 Booth encoding** combined with **Dadda Tree reduction**.

The objective of this architecture is to minimize the **Power-Delay Product (PDP)** by:

* Reducing the number of generated partial products
* Minimizing the number of reduction compressors
* Achieving efficient parallel compression

This architecture was evaluated as part of the **Silicon Sprint Hackathon 2026 – Power-Aware Multiplier Design**.

---

## Architecture

The Radix-4 Booth + Dadda multiplier follows the structure below:

```
Inputs (X, Y)
      │
      ▼
Radix-4 Booth Encoder
      │
      ▼
Partial Product Generation
      │
      ▼
Dadda Tree Reduction
      │
      ▼
Final Carry Propagate Adder
      │
      ▼
Product Output
```

---

## Radix-4 Booth Encoding

Radix-4 Booth encoding groups the multiplier bits in **sets of three**.

Example grouping:

```
y2 y1 y0
```

Each group determines the operation applied to the multiplicand.

| y2 y1 y0 | Operation |
| -------- | --------- |
| 000      | 0         |
| 001      | +X        |
| 010      | +X        |
| 011      | +2X       |
| 100      | −2X       |
| 101      | −X        |
| 110      | −X        |
| 111      | 0         |

Advantages:

* Reduces partial products
* Improves multiplication efficiency
* Reduces switching activity

For a **16-bit multiplier**:

```
Normal multiplication → 16 partial products
Radix-4 Booth → 8 partial products
```

---

## Partial Product Generation

The multiplicand is conditionally selected and shifted according to the Booth encoding signals.

Possible generated values:

```
0
+X
+2X
−X
−2X
```

Each partial product is aligned by shifting based on the Booth group index.

---

## Dadda Tree Reduction

The **Dadda tree** is an optimized partial product reduction technique.

Unlike the Wallace tree, which compresses rows aggressively, the Dadda tree performs reductions in a way that **minimizes the number of adders used**.

Reduction levels follow the sequence:

```
8 → 6 → 4 → 3 → 2
```

At each stage:

* **Full adders** reduce three rows into two
* **Half adders** reduce two rows into two

Advantages of Dadda reduction:

* Fewer adders compared to Wallace
* Reduced switching activity
* Lower power consumption

---

## Final Adder

After the Dadda tree reduction, two rows remain:

```
Final Sum Row
Final Carry Row
```

These rows are combined using a **carry propagate adder** (such as a CLA or ripple adder) to produce the final product.

---

## Key Features

* Reduced partial products using **Radix-4 Booth encoding**
* Efficient reduction using **Dadda tree compression**
* Lower switching activity
* Reduced number of adders
* Optimized **Power-Delay Product**

---

## Design Characteristics

| Feature      | Description                 |
| ------------ | --------------------------- |
| Input width  | 16-bit signed               |
| Output width | 32-bit product              |
| Encoding     | Radix-4 Booth               |
| Reduction    | Dadda Tree                  |
| Technology   | 90 nm standard cell library |

---

## Observations from Evaluation

During synthesis and analysis:

* **Radix-4 Booth + Dadda Tree achieved the lowest PDP** among the non-pipelined multiplier architectures.
* It showed **very similar delay performance to the Booth + Wallace design**, but with **lower power consumption** due to fewer compressor units.
* This reduction in switching activity led to improved energy efficiency.

---

## Conclusion

The **Radix-4 Booth + Dadda Tree multiplier** provides an excellent balance between:

* Power consumption
* Hardware complexity
* Computational delay

Among all the **non-pipelined architectures evaluated**, this design achieved the **lowest Power-Delay Product (PDP)** and was therefore selected as the **most power-efficient multiplier architecture** for this project.

For applications requiring higher throughput, a **pipelined Radix-4 Booth + Wallace architecture** can be used, although it results in a higher overall PDP due to pipeline overhead.

---

