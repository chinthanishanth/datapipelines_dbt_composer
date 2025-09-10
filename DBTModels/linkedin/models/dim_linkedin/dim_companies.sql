{{ config(schema='dim_linkedin',alias='dim_companies',materialized='incremental',unique_key=['sur_company_id']) }}

with source_data as (
select 
DENSE_RANK() OVER (order by company_name) as sur_company_id,
company_name,
src_timestamp
from {{ ref('stg_dim_companies') }}
)
select
DISTINCT
sur_company_id,
company_name,
src_timestamp
from
source_data
{% if is_incremental() %}
WHERE src_timestamp > (SELECT MAX(src_timestamp) FROM {{ this }})
{% endif %}