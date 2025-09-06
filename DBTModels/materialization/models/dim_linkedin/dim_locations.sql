{{ config(schema='dim_linkedin',alias='dim_locations',materialized='incremental',unique_key=['sur_location_id']) }}

with source_data as (
select 
ROW_NUMBER() OVER (order by location) as sur_location_id,
location,
src_timestamp
from {{ ref('stg_stage_location') }}
)
select
sur_location_id,
location,
src_timestamp
from
source_data