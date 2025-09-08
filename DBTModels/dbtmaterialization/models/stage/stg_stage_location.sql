{{ config(
    schema='stage',
    alias='stg_dim_location',
    materialized='ephemeral'
) }}
with source_data as (
select 
trim(location) as location,
src_timestamp
from  {{ source('raw_data','linkedin_jobs') }}
)
select
location,
src_timestamp
from
source_data