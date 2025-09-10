{{ config(schema='dim_linkedin',alias='dim_locations',materialized='incremental',unique_key=['sur_location_id']) }}

with source_data as (
select 
DENSE_RANK() OVER (order by location) as sur_location_id,
location,
src_timestamp
from {{ ref('stg_stage_location') }}
)
select
DISTINCT
sur_location_id,
location,
src_timestamp
from
source_data