# Phase 4 — Query Profile Evidence Summary

## Project
**Snowflake Query Performance & Optimization (TPCDS)**

---

## Phase Context
- **Active Phase:** Phase 4 — Structural Optimization
- **Baseline Query:** 🔒 Locked (no modification)
- **Phase 3 Learnings:** 🔒 Frozen
- **Objective of this document:** Capture *evidence* from Query Profile to justify or reject structural optimization levers.

---

## Query Profile Evidence (Baseline)

### 1. Fact Table Scan Dominance
**Operator:** `TableScan [17]` — `WEB_SALES`

- **% of total query time:** 84.4%
- **Bytes scanned:** 7.14 GB
- **Scan progress:** 19.90%
- **Partitions scanned:** 5,487
- **Total partitions:** 27,579

**Interpretation (Evidence-based):**
- Query is strongly **I/O-bound**
- Majority of time is spent reading data from the fact table
- Even after pruning, scanned data volume remains high

---

### 2. Join-Based Pruning Effectiveness
**Operator:** `JoinFilter [16]`

- **Time spent:** ~0.1%
- Join filters are present and active
- However, pruning impact is limited (5,487 partitions still scanned)

**Interpretation:**
- Join-based pruning **exists**
- Dimension filters do not translate into strong fact-table pruning
- Confirms Phase 3 finding: filtering happens on dimension, not directly on fact

---

### 3. Dimension Filter Selectivity
**Operator:** `Filter [12]` — `D.D_YEAR = 2001`

- Filter cost: ~0%
- Date dimension scan is negligible compared to fact scan

**Interpretation:**
- Dimension filter is selective
- Selectivity does **not** significantly reduce fact-table scan

---

### 4. Spill & Resource Pressure Check
**Profile Overview:**
- Processing: 2.0%
- Remote disk I/O: 97.6%
- Local disk I/O: 0.3%
- Synchronization: 0.2%

**Interpretation:**
- No memory pressure
- No spill to disk
- Query is **purely data / I/O bound**

---

## Key Metrics Insight (Phase 4 Anchor)

### Why these metrics matter

- **Bytes scanned (7.14 GB):**
  - Primary driver of cost and performance
  - Any optimization that does not reduce bytes scanned will have limited benefit

- **Scan progress (19.90%):**
  - Metadata pruning is already working
  - Remaining scanned data is still large due to data shape and access pattern

**Combined Insight:**
> Pruning exists, but the remaining data volume is still too large.
> Only **structural optimizations that reduce data touched** can meaningfully improve performance.

---

## Phase 4 Readiness Conclusion

Based on evidence:
- ✅ Query is data-bound
- ✅ Fact table scan dominates execution time
- ✅ Join pruning is present but insufficient
- ❌ Not CPU-bound
- ❌ Not memory-bound

This evidence will be used to **evaluate (not blindly apply)**:
- Clustering
- Search Optimization (SOS)
- Query Acceleration Service (QAS)

Each lever will be evaluated **one at a time** with apply-or-reject decisions.

---

## Status
**Document status:** Ready for GitHub commit
**Next step:** Evaluate first structural lever based on this evidence

---

## README — Short Summary (for GitHub)

### What this is
This document captures **baseline Query Profile evidence** for the Snowflake TPCDS performance project.
It serves as the **decision foundation** for Phase 4 (Structural Optimization).

### Why this exists
Before applying any structural optimization (Clustering, SOS, QAS), we validate:
- Where time is actually spent
- Whether pruning already works
- Whether the problem is CPU, memory, or I/O

### Key findings (TL;DR)
- Query is **data-bound**
- `WEB_SALES` fact table scan dominates (**84.4%** of query time)
- **7.14 GB** of data scanned even after pruning
- Join-based pruning exists but is **insufficient**
- No CPU pressure, no memory spill — pure I/O bottleneck

### Outcome
This evidence is used to **evaluate (not blindly apply)** structural optimizations one by one.
Each lever will be either **applied or rejected with justification**.

---

## Diagram Note — Query Profile Interpretation

### Purpose of the diagram
To visually explain **why the query is slow** and **where optimization must focus**.

### How to read the diagram
1. **Bottom node (TableScan — WEB_SALES)**
   - Represents the fact table scan
   - Dominates execution time (84.4%)
   - Main performance bottleneck

2. **JoinFilter above the scan**
   - Indicates join-based pruning is active
   - Impact is limited (still ~20% partitions scanned)

3. **Dimension filter (D_YEAR = 2001)**
   - Highly selective on dimension table
   - Does not translate into strong fact pruning

4. **Thin operators above (Aggregate, Filter)**
   - Low cost
   - Not performance-relevant

### Visual takeaway
> The query spends most of its time **reading data**, not computing.
> Any optimization must reduce **data scanned**, not CPU work.

### Suggested diagram caption (for README / blog)
"Query Profile shows an I/O-bound workload where fact table scan dominates despite active join-based pruning."

