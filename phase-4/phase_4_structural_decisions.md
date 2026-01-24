# Phase 4 — Structural Decisions

## Project

**Snowflake Query Performance & Optimization (TPCDS)**

---

## Purpose

This document records **architectural decisions** made during Phase 4.

* Decisions are **evidence-based**
* Each decision is **locked once made**
* Evidence is referenced, not duplicated

This file complements:

* `phase-4-query-profile-evidence.md`

---

## Decision Log

### Decision 1 — Clustering

* **Lever:** Clustering
* **Status:** ❌ Rejected
* **Phase:** Phase 4 — Structural Optimization

#### Evidence Referenced

* Query Profile metrics documented in:

  * `phase-4-query-profile-evidence.md`

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

## Decision Log

### Decision 1 — Clustering

* **Lever:** Clustering
* **Status:** ❌ Rejected
* **Phase:** Phase 4 — Structural Optimization

#### Evidence Referenced

* Query Profile metrics documented in:

  * `phase-4-query-profile-evidence.md`

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

### Decision 2 — Search Optimization (SOS)

* **Lever:** Search Optimization (SOS)
* **Status:** ❌ Rejected
* **Phase:** Phase 4 — Structural Optimization

#### Evidence Referenced

* Query Profile metrics documented in:

  * `phase-4-query-profile-evidence.md`

#### Reasoning (Why SOS Was Rejected)

1. The query does **not** use direct predicates on the fact table (`WEB_SALES`).
2. All filtering occurs on **dimension tables** and is applied via joins.
3. The filter `d_year = 2001` is **not highly selective** in the TPCDS dataset.
4. Query Profile shows a **broad analytical scan**, not sparse point lookups.
5. SOS is designed for **highly selective, repetitive lookup patterns**, which this query does not exhibit.
6. Expected performance gain is **low**, while SOS introduces additional storage and maintenance cost.

#### Final Conclusion

Search Optimization does not reduce the dominant fact-table scan for this access pattern and is therefore **not justified**.

This decision is **locked** and will not be re-evaluated unless query shape or access pattern changes.

---

## Status

* **Decisions recorded:** 2
* **Rejected levers:** Clustering, Search Optimization (SOS)
* **Next decision to evaluate:** Query Acceleration Service (QAS)
* **Document status:** Ready for GitHub commit
