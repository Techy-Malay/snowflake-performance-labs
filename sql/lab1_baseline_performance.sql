-- =============================================================
-- File: lab1_baseline_performance.sql
-- Lab:  Lab 1 — Baseline Performance & Query Profile
-- Goal: Establish an unbiased baseline for Snowflake performance
-- Scope:
--   - Run ONE time only
--   - No query rewrites
--   - No warehouse scaling
--   - No clustering / caching / data copy
--
-- Output of this lab is NOT data.
-- Output is: Query Profile observations + hypothesis.
-- =============================================================


-- -------------------------------------------------------------
-- STEP 0: WAREHOUSE EXPECTATION (DO NOT CHANGE HERE)
-- -------------------------------------------------------------
-- Warehouse Size : X-SMALL
-- Auto-Resume    : ON
-- Auto-Suspend   : 60 seconds
--
-- Reason:
-- Small warehouse exposes real bottlenecks (scan, join, pruning)
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- STEP 1: SET CONTEXT
-- -------------------------------------------------------------
-- Using Snowflake-provided benchmark data to avoid
-- ingestion and data-layout bias in baseline measurement

USE DATABASE SNOWFLAKE_SAMPLE_DATA;
USE SCHEMA TPCDS_SF10TCL;


-- -------------------------------------------------------------
-- STEP 2: BASELINE QUERY (RUN EXACTLY ONCE)
-- -------------------------------------------------------------
-- Business Question:
--   Total web sales by year and customer state
--
-- Performance Intent:
--   - Large fact table scan (WEB_SALES)
--   - Dimension joins (DATE_DIM, CUSTOMER)
--   - Filter on DATE_DIM
--   - Grouping + aggregation
--
-- This query is intentionally NOT optimized.

SELECT
    d.d_year,
    ca.ca_state,
    SUM(ws.ws_ext_sales_price) AS total_sales
FROM web_sales ws
JOIN date_dim d
    ON ws.ws_sold_date_sk = d.d_date_sk
JOIN customer c
    ON ws.ws_bill_customer_sk = c.c_customer_sk
JOIN customer_address ca
    ON c.c_current_addr_sk = ca.ca_address_sk
WHERE d.d_year = 2001
GROUP BY d.d_year, ca.ca_state
ORDER BY total_sales DESC;




-- -------------------------------------------------------------
-- STEP 3: POST-EXECUTION (NO MORE SQL)
-- -------------------------------------------------------------
-- Immediately open Query Profile and record:
--   1. Total execution time
--   2. Largest scan operator
--   3. Most expensive join operator
--   4. CPU vs IO vs Network distribution
--
-- Write ONE hypothesis, example:
--   "This workload is scan-heavy with weak pruning;
--    warehouse sizing is not the primary issue."
--
-- STOP HERE. DO NOT RERUN.
-- -------------------------------------------------------------
