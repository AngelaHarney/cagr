-- Macro to build the database name from env_name variable
-- Co-authored with CoCo

{% macro get_db_name() -%}
    {%- if var('env_name', '') != '' -%}
        PRECISION_{{ var('env_name') }}
    {%- else -%}
        PRECISION
    {%- endif -%}
{%- endmacro %}
