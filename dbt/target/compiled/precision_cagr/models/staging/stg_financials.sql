-- Staging model for financials seed data with aggregations per property
-- Co-authored with CoCo

SELECT
    property_id,
    MIN(period_date::DATE) AS first_period,
    MAX(period_date::DATE) AS last_period,
    SUM(noi) AS total_noi,
    SUM(capital_expenditures) AS total_capex,
    SUM(distributions) AS total_distributions,
    MIN(noi) AS first_noi,
    MAX(noi) AS latest_noi,
    DATEDIFF('day', MIN(period_date::DATE), MAX(period_date::DATE)) / 365.25 AS financial_years_span
FROM PRECISION.RAW.financials
GROUP BY property_id