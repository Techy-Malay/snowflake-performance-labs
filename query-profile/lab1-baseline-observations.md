# Lab 1 — Baseline Observations

> **Lab:** Lab 1 — Baseline Performance & Query Profile  
> **Goal:** Capture evidence before any optimization

---

## 1. Environment

- Warehouse size: **X-SMALL**
- Auto-resume: ON
- Auto-suspend: 60 seconds
- Dataset: `SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL`

---

## 2. Query Executed

Baseline aggregation on `WEB_SALES` joined with dimensions (`DATE_DIM`, `CUSTOMER`, `CUSTOMER_ADDRESS`).

(Query stored separately in `lab1_baseline_performance.sql`)

---

## 3. Execution Summary

- Total execution time: **~38 seconds**
- Compilation time: Minor
- Cache used: **0%** (first run)

---

## 4. Query Profile Observations

### Most expensive operators

- **TableScan [17]** → ~84%
- **Join [7]** → ~2–3%

### Execution breakdown

- Remote Disk I/O: **~87%**
- Processing (CPU): **~12%**

### Scan statistics

- Partitions scanned: ~6,005
- Total partitions: ~28,097
- Pruning effectiveness: **~21%**
- Bytes scanned: ~7.5 GB

---

## 5. Interpretation (Plain English)

- Query is dominated by data scanning
- Joins and aggregation are not the main bottleneck
- Filter on `d_year` does not prune `WEB_SALES` effectively

---

## 6. Hypothesis

> **This workload is scan-heavy and data-bound. The main issue is weak pruning on the `WEB_SALES` fact table due to dimension-based filtering, not warehouse sizing or join cost.**

---

## 7. Open Questions / Learning Gaps

- How to push filters earlier to improve pruning?
- When should clustering be considered?
- How much improvement is possible without scaling warehouse?

---

*This document captures baseline truth before optimization.*

