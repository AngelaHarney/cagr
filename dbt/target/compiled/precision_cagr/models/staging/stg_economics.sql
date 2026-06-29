-- Staging model pulling CPI data from Snowflake Public Data (FRED)
-- Co-authored with CoCo

-- NOTE: After installing Snowflake Public Data (Free) from Marketplace,
-- update the database/schema below to match your installation.
-- Common names: ECONOMY_DATA_ATLAS.ECONOMY.USINFLATION
-- or: GOVERNMENT_ESSENTIALS.CYBERSYN.FRED_TIMESERIES

-- This model pulls the latest CPI value and calculates annualized CPI growth.
-- If the Snowflake Public Data listing uses a different schema, update accordingly.

WITH cpi_data AS (
    SELECT
        date AS period_date,
        value AS cpi_index
    FROM ECONOMY_DATA_ATLAS.ECONOMY.BEANIPA
    WHERE "Table Name" = 'Price Indexes For Personal Consumption Expenditures By Major Type Of Product'
      AND "Indicator Name" = 'Personal consumption expenditures (PCE)'
      AND freq = 'M'
    ORDER BY date DESC
    LIMIT 60
),

cpi_range AS (
    SELECT
        MAX(cpi_index) AS latest_cpi,
        MIN(cpi_index) AS earliest_cpi,
        DATEDIFF('month', MIN(period_date), MAX(period_date)) / 12.0 AS years_span
    FROM cpi_data
)

SELECT
    latest_cpi,
    earliest_cpi,
    years_span,
    POWER(latest_cpi / NULLIF(earliest_cpi, 0), 1.0 / NULLIF(years_span, 0)) - 1 AS cpi_cagr
FROM cpi_range