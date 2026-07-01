-- Staging model for CPI CAGR using GET_CPI_CONFIG UDF (SELECT-only; DDL managed by DCM)
-- Co-authored with CoCo

SELECT
    {{ get_db_name() }}.RAW.GET_CPI_CONFIG('cpi_cagr') AS cpi_cagr
