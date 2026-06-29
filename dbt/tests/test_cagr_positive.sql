-- Test that all CAGR values are between -1 and 10 (reasonable bounds)
-- Co-authored with CoCo

SELECT *
FROM {{ ref('cagr_metrics') }}
WHERE current_cagr < -1.0
   OR current_cagr > 10.0
   OR remaining_lease_cagr < -1.0
   OR remaining_lease_cagr > 10.0
   OR full_lifetime_cagr < -1.0
   OR full_lifetime_cagr > 10.0
