-- Infrastructure definitions: database, schemas, tables, and functions for PRECISION CAGR
-- Co-authored with CoCo

-- =============================================================================
-- DATABASE
-- =============================================================================
DEFINE DATABASE PRECISION{{env_suffix}}
    COMMENT = 'Precision CAGR analytics platform';

-- =============================================================================
-- SCHEMAS
-- =============================================================================
DEFINE SCHEMA PRECISION{{env_suffix}}.RAW
    COMMENT = 'Raw seed data and configuration tables';

DEFINE SCHEMA PRECISION{{env_suffix}}.ODS
    COMMENT = 'Operational data store - staging transformations';

DEFINE SCHEMA PRECISION{{env_suffix}}.ANALYTICS
    COMMENT = 'Intermediate analytics';

DEFINE SCHEMA PRECISION{{env_suffix}}.FINANCE_CURATED
    COMMENT = 'Curated finance metrics for consumption';

-- =============================================================================
-- WAREHOUSE
-- =============================================================================
DEFINE WAREHOUSE PRECISION_WH{{env_suffix}}
WITH
    WAREHOUSE_SIZE = '{{wh_size}}'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE
    COMMENT = 'Compute for PRECISION CAGR workloads';

-- =============================================================================
-- RAW TABLES (previously managed by dbt seeds / on-run-start)
-- =============================================================================
DEFINE TABLE PRECISION{{env_suffix}}.RAW.CPI_CONFIG (
    CONFIG_KEY VARCHAR,
    DEFAULT_VALUE VARCHAR,
    OVERRIDE_VALUE VARCHAR,
    OVERRIDE_UNTIL_DATE DATE
)
COMMENT = 'CPI configuration parameters with time-limited overrides';

DEFINE TABLE PRECISION{{env_suffix}}.RAW.PROPERTIES (
    PROPERTY_ID NUMBER,
    PROPERTY_NAME VARCHAR,
    ADDRESS VARCHAR,
    PROPERTY_TYPE VARCHAR,
    ACQUISITION_DATE VARCHAR,
    ACQUISITION_PRICE NUMBER,
    CURRENT_VALUE NUMBER
)
COMMENT = 'Source property records';

DEFINE TABLE PRECISION{{env_suffix}}.RAW.LEASES (
    LEASE_ID NUMBER,
    PROPERTY_ID NUMBER,
    TENANT_NAME VARCHAR,
    LEASE_START_DATE VARCHAR,
    LEASE_END_DATE VARCHAR,
    MONTHLY_RENT NUMBER,
    ANNUAL_ESCALATION_PCT NUMBER(5,4),
    PROJECTED_END_VALUE NUMBER
)
COMMENT = 'Source lease records';

DEFINE TABLE PRECISION{{env_suffix}}.RAW.FINANCIALS (
    PROPERTY_ID NUMBER,
    PERIOD_DATE VARCHAR,
    NOI NUMBER,
    CAPITAL_EXPENDITURES NUMBER,
    DISTRIBUTIONS NUMBER
)
COMMENT = 'Source financial period records';

-- =============================================================================
-- SQL FUNCTION
-- =============================================================================
DEFINE FUNCTION PRECISION{{env_suffix}}.RAW.GET_CPI_CONFIG(P_CONFIG_KEY VARCHAR)
RETURNS FLOAT
COMMENT = 'Returns effective CPI config value, respecting time-limited overrides'
AS
$$
    SELECT
        CASE
            WHEN OVERRIDE_VALUE IS NOT NULL AND OVERRIDE_UNTIL_DATE >= CURRENT_DATE()
                THEN OVERRIDE_VALUE::FLOAT
            ELSE DEFAULT_VALUE::FLOAT
        END
    FROM PRECISION{{env_suffix}}.RAW.CPI_CONFIG
    WHERE CONFIG_KEY = P_CONFIG_KEY
    LIMIT 1
$$;
