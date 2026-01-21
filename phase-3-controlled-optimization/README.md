# Phase 3 — Controlled Optimization (Summary)

## Purpose of Phase 3
Validate *why* the query behaves the way it does using **small, controlled experiments**.

Rules followed:
- One hypothesis at a time
- One change per experiment
- Before vs After Query Profile
- No warehouse scaling
- No clustering or structural changes

---

## Baseline (Locked)
**Query:**
- Fact table: `web_sales`
- Filters applied via dimensions
- Observation: Query is **data-bound** with **weak pruning** at baseline

This baseline was used consistently for all comparisons.

---

## Experiment 1 — Dimension Filter Effect
**Hypothesis:**
Filtering on `date_dim` can reduce fact table scan via join-based pruning.

**Change Made (only one):**
- Added a more selective filter on `date_dim`

**Query Profile Observation:**
- `web_sales` fact scan **reduced**

**Conclusion:**
- Join-based pruning exists
- Dimension filters can influence fact scan

---

## Experiment 2 — Projection Reduction
**Hypothesis:**
Selecting fewer columns can reduce data scanned due to column pruning.

**Change Made (only one):**
- Reduced selected columns (projection)

**Query Profile Observation:**
- `web_sales` fact scan **reduced**

**Conclusion:**
- Column pruning is effective
- Projection matters for scan volume

---

## Experiment 3 — ORDER BY / Aggregation Impact
**Hypothesis:**
Removing `ORDER BY` affects execution time but does not reduce fact scan.

**Change Made (only one):**
- Removed `ORDER BY`

**Query Profile Observation:**
- `web_sales` fact scan **remained almost the same**

**Conclusion:**
- Sorting affects compute, not scan
- ORDER BY does not influence pruning

---

## Key Learnings (Phase 3)
- Fact scan reduction comes from:
  - Row pruning (dimension filters)
  - Column pruning (projection)
- Sorting changes execution cost, not scan volume
- Evidence-based tuning is essential before scaling

---

## What Phase 3 Does NOT Do
- No clustering
- No warehouse resizing
- No structural changes

These are intentionally deferred.

---

## Output of Phase 3
- Clear cause → effect understanding
- Evidence to justify (or reject) structural optimizations
- Inputs for Phase 4 decisions
- Insights ready for external articulation (LinkedIn)

---

## Status
**Phase 3:** ✅ COMPLETED

---

Author: Malaya (Pronounced as Malay) Padhi  
Role: Senior Solution Architect  
Focus: Snowflake Performance & Data Architecture

