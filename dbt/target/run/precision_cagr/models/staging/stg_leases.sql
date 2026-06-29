
  create or replace   view PRECISION.ODS.stg_leases
  
   as (
    -- Staging model for leases seed data
-- Co-authored with CoCo

SELECT
    lease_id,
    property_id,
    tenant_name,
    lease_start_date::DATE AS lease_start_date,
    lease_end_date::DATE AS lease_end_date,
    monthly_rent,
    annual_escalation_pct,
    projected_end_value,
    DATEDIFF('day', lease_start_date::DATE, lease_end_date::DATE) / 365.25 AS total_lease_years,
    DATEDIFF('day', CURRENT_DATE(), lease_end_date::DATE) / 365.25 AS years_remaining
FROM PRECISION.RAW.leases
  );

