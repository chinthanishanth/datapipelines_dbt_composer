{{ config(schema='stage',alias='stg_linkedin_jobs') }}

with source_data as (
select 
job_id,
job_description
from {{ source('raw_data','linkedin_jobs') }}
)
select 
cast( job_id as INT64) job_id,
job_description,
from
source_data
