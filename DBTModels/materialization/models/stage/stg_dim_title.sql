{{ config(schema='stage',alias='stg_dim_title',materialized='incremental',pre_hook=["truncate table {{this}}"]) }}

with source_data as ( 
select 
lower(trim(title)) as designation,
src_timestamp
from {{ source('raw_data','linkedin_jobs') }}
)
select
designation,
src_timestamp
from source_data
