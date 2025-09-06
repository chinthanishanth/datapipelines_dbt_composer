{{ config(schema='facts',alias='fact_job_descriptions',materialized='incremental',unique_key=['sur_description_id']) }}

with source_data as (
select 
ROW_NUMBER() OVER (order by job_id) as sur_description_id,
job_id,
job_description
from {{ ref('stg_linkedin_jobs') }}
)
select 
sur_description_id,
job_id,
job_description
from
source_data