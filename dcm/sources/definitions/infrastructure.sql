-- DCM infrastructure definitions for PRECISION_CALCS project
-- Co-authored with CoCo

-- ============================================================
-- env_suffix and wh_size come from templating_config in manifest.yml
-- Deploy with: snow dcm deploy --target DEV|TST|PRD -c default
-- ============================================================

-- Database
DEFINE DATABASE PRECISION{{env_suffix}}
    COMMENT = 'PRECISION CAGR analytics platform';

-- Schemas for the data pipeline layers
DEFINE SCHEMA PRECISION{{env_suffix}}.CAGR
    COMMENT = 'DCM project container';

DEFINE SCHEMA PRECISION{{env_suffix}}.RAW
    COMMENT = 'Raw seed data and config tables';

DEFINE SCHEMA PRECISION{{env_suffix}}.ODS
    COMMENT = 'Operational data store - staging views';

DEFINE SCHEMA PRECISION{{env_suffix}}.ANALYTICS
    COMMENT = 'Analytics layer for transformed data';

DEFINE SCHEMA PRECISION{{env_suffix}}.FINANCE_CURATED
    COMMENT = 'Domain-curated views for finance metrics';

-- Warehouse for dbt and analytics workloads
DEFINE WAREHOUSE PRECISION_WH{{env_suffix}}
WITH
    WAREHOUSE_SIZE = '{{wh_size}}'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE
    COMMENT = 'Warehouse for PRECISION CAGR project';