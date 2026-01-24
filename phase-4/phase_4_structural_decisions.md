# Phase 4 — Structural Decisions

## Project
**Snowflake Query Performance & Optimization (TPCDS)**

---

## Purpose
This document records **architectural decisions** made during Phase 4.

- Decisions are **evidence-based**
- Each decision is **locked once made**
- Evidence is referenced, not duplicated

This file complements:
- `phase-4-query-profile-evidence.md`

---

## Decision Log

### Decision 1 — Clustering

- **Lever:** Clustering
- **Status:** ❌ Rejected
- **Phase:** Phase 4 — Structural Optimization

#### Evidence Referenced
- Query Profile metrics documented in:
  - `phase-4-query-profile-evidence.md`

#### Reasoning (Why Clustering Was Rejected)

1. The query does **not** apply filters directly on the fact table (`WEB_SALES`).
2. All filters originate from **dimension tables** and rely on **join-based pruning**.
3. Clustering is most effective when queries use **direct predicates** on clustered columns.
4. Join-based pruning does **not reliably benefit** from clustering.
5. Query Profile shows ~**80% metadata pruning already occurs** without clustering.
6. Remaining scan volume is driven by **data shape**, not lack of clustering.
7. Clustering introduces **ongoing maintenance cost** with **low expected ROI** for this access pattern.

#### Final Conclusion
Clustering does not address the root cause of the performance bottleneck for this query and is therefore **not justified**.

This decision is **locked** and will not be re-evaluated unless query shape changes.

---

## Status

- **Decisions recorded:** 1
- **Next decision to evaluate:** Search Optimization (SOS)
- **Document status:** Ready for GitHub commit

