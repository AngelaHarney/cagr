
  create or replace   view PRECISION.ODS.stg_properties
  
   as (
    -- Staging model for properties seed data
-- Co-authored with CoCo

SELECT
    property_id,
    property_name,
    address,
    property_type,
    acquisition_date::DATE AS acquisition_date,
    acquisition_price,
    current_value,
    DATEDIFF('day', acquisition_date::DATE, CURRENT_DATE()) / 365.25 AS years_elapsed
FROM PRECISION.RAW.properties
  );

