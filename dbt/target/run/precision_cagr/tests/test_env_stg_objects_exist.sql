select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      -- Verify that all four staging views exist in ODS schema
-- Co-authored with CoCo

SELECT 'MISSING_STAGING_OBJECT' AS failure_reason, t.expected_name
FROM (
    SELECT 'STG_PROPERTIES' AS expected_name
    UNION ALL SELECT 'STG_LEASES'
    UNION ALL SELECT 'STG_FINANCIALS'
    UNION ALL SELECT 'STG_ECONOMICS'
) t
LEFT JOIN PRECISION.INFORMATION_SCHEMA.VIEWS v
    ON v.TABLE_SCHEMA = 'ODS'
    AND v.TABLE_NAME = t.expected_name
WHERE v.TABLE_NAME IS NULL
      
    ) dbt_internal_test