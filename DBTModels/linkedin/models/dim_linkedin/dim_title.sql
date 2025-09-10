{{ config(schema='dim_linkedin',alias='dim_title',materialized='table',unique_key=['sur_title_id']) }}

with source_data as (
select 
DENSE_RANK() OVER (order by designation) as sur_title_id,
designation,
src_timestamp
from {{ ref('stg_dim_title') }}
)
select
DISTINCT
sur_title_id,
designation,
src_timestamp
from
source_data

