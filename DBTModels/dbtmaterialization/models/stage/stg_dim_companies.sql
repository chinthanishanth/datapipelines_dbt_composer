{{ config(schema='stage',alias='stg_dim_companies') }}

with source_data as ( 
select 
trim(company) as company_name,
src_timestamp
from {{ source('raw_data','linkedin_jobs') }}
)
select
company_name,
src_timestamp
from source_data