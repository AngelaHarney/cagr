select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      -- Verify that cagr_metrics contains all expected CAGR metric columns
-- Co-authored with CoCo

SELECT 'MISSING_COLUMN' AS failure_reason, t.expected_column
FROM (
    SELECT 'CURRENT_CAGR' AS expected_column
    UNION ALL SELECT 'REMAINING_LEASE_CAGR'
    UNION ALL SELECT 'FULL_LIFETIME_CAGR'
    UNION ALL SELECT 'TOTAL_RETURN_CAGR'
    UNION ALL SELECT 'NOI_GROWTH_CAGR'
    UNION ALL SELECT 'REAL_CAGR'
    UNION ALL SELECT 'SPREAD_VS_BENCHMARK'
) t
LEFT JOIN PRECISION.INFORMATION_SCHEMA.COLUMNS c
    ON c.TABLE_SCHEMA = 'FINANCE_CURATED'
    AND c.TABLE_NAME = 'CAGR_METRICS'
    AND c.COLUMN_NAME = t.expected_column
WHERE c.COLUMN_NAME IS NULL
      
    ) dbt_internal_test