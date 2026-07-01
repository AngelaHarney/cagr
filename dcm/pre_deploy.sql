-- Bootstrap script: creates the DCM project container for a single target environment
-- Co-authored with CoCo
--
-- DCM cannot create its own parent container. Run this ONCE per environment
-- before the first `snow dcm plan` or `snow dcm deploy`.
--
-- Usage (pass env_suffix as a variable):
--   DEV: snow sql -f pre_deploy.sql -D env_suffix=_DEV -c default
--   TST: snow sql -f pre_deploy.sql -D env_suffix=_TST -c default
--   PRD: snow sql -f pre_deploy.sql -D env_suffix= -c default

CREATE DATABASE IF NOT EXISTS IDENTIFIER('PRECISION' || '&env_suffix');
CREATE SCHEMA IF NOT EXISTS IDENTIFIER('PRECISION' || '&env_suffix' || '.CAGR');
