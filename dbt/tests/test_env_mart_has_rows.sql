-- Verify that the cagr_metrics mart is populated with at least one row
-- Co-authored with CoCo

SELECT 1 AS failure_flag
WHERE (SELECT COUNT(*) FROM {{ ref('cagr_metrics') }}) = 0
