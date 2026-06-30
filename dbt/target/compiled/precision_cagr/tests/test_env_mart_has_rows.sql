-- Verify that the cagr_metrics mart is populated with at least one row
-- Co-authored with CoCo

SELECT 1 AS failure_flag
WHERE (SELECT COUNT(*) FROM PRECISION.FINANCE_CURATED.cagr_metrics) = 0