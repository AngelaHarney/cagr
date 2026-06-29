-- Staging model for CPI CAGR sourced from cpi_config seed
-- Co-authored with CoCo

SELECT
    CASE
        WHEN override_value IS NOT NULL AND override_until_date >= CURRENT_DATE()
            THEN override_value::FLOAT
        ELSE default_value::FLOAT
    END AS cpi_cagr
FROM {{ ref('cpi_config') }}
WHERE config_key = 'cpi_cagr'
