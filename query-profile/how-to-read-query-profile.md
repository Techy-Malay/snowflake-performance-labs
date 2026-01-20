# How to Read Snowflake Query Profile (Practical Notes)

> **Purpose:** A simple, revisable guide to interpret Snowflake Query Profile and decide *what action to take and why*.
>
> This is written in **my own words** for quick revision when I get stuck.

---

## 1. First Rule (Always)

**Never optimize before reading the Query Profile.**  
Query Profile tells *where time is going*. Without it, tuning is guesswork.

---

## 2. Start with Profile Overview (Big Picture)

### Key sections

- **Processing (CPU)**  
  Actual compute work: joins, aggregations, expressions.

- **Remote Disk I/O**  
  Data being read from Snowflake storage (micro-partitions).

- **Local Disk I/O**  
  Temporary spilling to disk due to memory pressure.

- **Initialization / Synchronization**  
  Setup and coordination cost (usually small).

### How to interpret

- **Remote Disk I/O is high**  
  → Query is **data-bound**  
  → Problem is usually **poor pruning or large scans**

- **Processing (CPU) is high**  
  → Query is **compute-bound**  
  → Look at joins, aggregations, expressions

---

## 3. Look at “Most Expensive Nodes”

This section shows **which operators cost the most**.

### Common operators

- **TableScan** → Reading data from tables
- **Join** → Combining datasets
- **Aggregate** → GROUP BY / SUM / COUNT
- **Sort** → ORDER BY

### Interpretation rules

- **TableScan dominates**  
  → Too much data scanned  
  → Pruning is weak

- **Join dominates**  
  → Join order or join strategy issue

- **Aggregate dominates**  
  → High cardinality groups or heavy aggregation

---

## 4. Statistics Panel (Most Honest Section)

### Important metrics

- **Bytes scanned**  
  How much data Snowflake actually read

- **Partitions scanned / total partitions**  
  Indicates pruning effectiveness

- **Scan progress %**  
  Lower % = weak pruning

- **Cache used**  
  0% is normal on first run

### Interpretation

- **Low pruning %**  
  → Filters are not applied early or not on fact table

- **High bytes scanned**  
  → Reduce scanned data using filters, clustering, or design

---

## 5. Decision Cheat Sheet

| What I See | What It Means | First Action |
|-----------|---------------|--------------|
| High Remote Disk I/O | Data-bound query | Improve pruning |
| TableScan is top node | Large scan | Check filters / clustering |
| Join is expensive | Join strategy issue | Rewrite joins / order |
| Local Disk I/O high | Memory pressure | Increase warehouse |

---

## 6. Reminder

Query Profile is a **diagnostic tool**, not a performance trick.

Evidence → Hypothesis → Action

---

*This document will evolve as I learn more.*

