CREATE OR REPLACE FUNCTION PRECISION.RAW.GET_CPI_CONFIG(p_config_key VARCHAR) RETURNS FLOAT LANGUAGE SQL AS $$
  SELECT
    CASE
      WHEN override_value IS NOT NULL AND override_until_date >= CURRENT_DATE()
        THEN override_value::FLOAT
      ELSE default_value::FLOAT
    END
  FROM IDENTIFIER('PRECISION.RAW.CPI_CONFIG')
  WHERE config_key = p_config_key
  LIMIT 1
$$