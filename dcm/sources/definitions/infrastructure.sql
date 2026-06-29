-- DCM infrastructure definitions for PRECISION_CALCS project
-- Co-authored with CoCo

-- ============================================================
-- This file defines the infrastructure shell managed by DCM.
-- dbt manages the tables/views INSIDE these schemas.
-- DCM manages the schemas, warehouse, and access control.
-- ============================================================

-- Warehouse for dbt and analytics workloads
DEFINE WAREHOUSE PRECISION_WH{{env_suffix}}
WITH
    WAREHOUSE_SIZE = '{{wh_size}}'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE
    COMMENT = 'Warehouse for PRECISION CAGR project';
