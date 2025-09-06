{{ config(schema='dim_linkedin',alias='dim_title',materialized='incremental',unique_key=['sur_title_id']) }}

with source_data as (
select 
ROW_NUMBER() OVER (order by designation) as sur_title_id,
designation,
src_timestamp
from {{ ref('stg_dim_title') }}
)
select
sur_title_id,
designation,
src_timestamp
from
source_data

