{{ config(schema='dim_linkedin',alias='dim_companies',materialized='incremental',unique_key=['sur_company_id']) }}

with source_data as (
select 
ROW_NUMBER() OVER (order by company_name) as sur_company_id,
company_name,
src_timestamp
from {{ ref('stg_dim_companies') }}
)
select
sur_company_id,
company_name,
src_timestamp
from
source_data