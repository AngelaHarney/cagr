-- CAGR metrics mart combining properties, leases, and financials
-- Co-authored with CoCo

WITH props AS (
    SELECT * FROM PRECISION.ODS.stg_properties
),

leases AS (
    SELECT * FROM PRECISION.ODS.stg_leases
),

fins AS (
    SELECT * FROM PRECISION.ODS.stg_financials
),

econ AS (
    SELECT cpi_cagr FROM PRECISION.ODS.stg_economics
)

SELECT
    p.property_id,
    p.property_name,
    p.property_type,
    p.acquisition_date,
    p.acquisition_price,
    p.current_value,
    l.lease_start_date,
    l.lease_end_date,
    l.projected_end_value,
    l.tenant_name,

    -- Years calculations
    p.years_elapsed,
    l.years_remaining,
    l.total_lease_years,

    -- METRIC 1: Current CAGR (acquisition to today)
    CASE WHEN p.years_elapsed > 0
        THEN POWER(p.current_value / NULLIF(p.acquisition_price, 0), 1.0 / p.years_elapsed) - 1
        ELSE NULL
    END AS current_cagr,

    -- METRIC 2: Remaining Lease CAGR (today to lease end)
    CASE WHEN l.years_remaining > 0
        THEN POWER(l.projected_end_value / NULLIF(p.current_value, 0), 1.0 / l.years_remaining) - 1
        ELSE NULL
    END AS remaining_lease_cagr,

    -- METRIC 3: Full Lifetime CAGR (acquisition to lease end)
    CASE WHEN l.total_lease_years > 0
        THEN POWER(l.projected_end_value / NULLIF(p.acquisition_price, 0), 1.0 / l.total_lease_years) - 1
        ELSE NULL
    END AS full_lifetime_cagr,

    -- METRIC 4: Total Return CAGR (includes distributions and capex)
    CASE WHEN p.years_elapsed > 0
        THEN POWER(
            (p.current_value + COALESCE(f.total_distributions, 0) - COALESCE(f.total_capex, 0))
            / NULLIF(p.acquisition_price, 0),
            1.0 / p.years_elapsed
        ) - 1
        ELSE NULL
    END AS total_return_cagr,

    -- METRIC 5: NOI Growth CAGR
    CASE WHEN f.financial_years_span > 0 AND f.first_noi > 0
        THEN POWER(f.latest_noi / f.first_noi, 1.0 / f.financial_years_span) - 1
        ELSE NULL
    END AS noi_growth_cagr,

    -- METRIC 6: Real CAGR (inflation-adjusted)
    CASE WHEN p.years_elapsed > 0 AND e.cpi_cagr IS NOT NULL
        THEN (
            (1 + (POWER(p.current_value / NULLIF(p.acquisition_price, 0), 1.0 / p.years_elapsed) - 1))
            / (1 + e.cpi_cagr)
        ) - 1
        ELSE NULL
    END AS real_cagr,

    -- METRIC 7: Spread vs Treasury (placeholder — uses CPI as proxy until FRED rates loaded)
    CASE WHEN p.years_elapsed > 0
        THEN (POWER(p.current_value / NULLIF(p.acquisition_price, 0), 1.0 / p.years_elapsed) - 1) - COALESCE(e.cpi_cagr, 0)
        ELSE NULL
    END AS spread_vs_benchmark

FROM props p
LEFT JOIN leases l ON p.property_id = l.property_id
LEFT JOIN fins f ON p.property_id = f.property_id
CROSS JOIN econ e