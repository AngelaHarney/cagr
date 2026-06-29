-- Staging model for CPI CAGR using GET_CPI_CONFIG UDF
-- Co-authored with CoCo

SELECT
    {{ get_db_name() }}.RAW.GET_CPI_CONFIG('cpi_cagr') AS cpi_cagr
