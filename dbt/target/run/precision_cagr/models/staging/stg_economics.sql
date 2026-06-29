
  create or replace   view PRECISION.ODS.stg_economics
  
   as (
    -- Staging model for CPI CAGR using GET_CPI_CONFIG UDF
-- Co-authored with CoCo

SELECT
    PRECISION.RAW.GET_CPI_CONFIG('cpi_cagr') AS cpi_cagr
  );

