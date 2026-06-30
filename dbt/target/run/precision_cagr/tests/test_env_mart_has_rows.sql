select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      -- Verify that the cagr_metrics mart is populated with at least one row
-- Co-authored with CoCo

SELECT 1 AS failure_flag
WHERE (SELECT COUNT(*) FROM PRECISION.FINANCE_CURATED.cagr_metrics) = 0
      
    ) dbt_internal_test