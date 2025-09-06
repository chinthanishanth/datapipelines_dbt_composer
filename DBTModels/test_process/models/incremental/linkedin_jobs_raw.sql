{{ config(schema='stage',alias='stg_linkedin_jobs',materialized='incremental',pre_hook=["truncate table {{this}}"]) }}

{%set insert_batch_id =  var('batch_nbr') %}
{%set delta_start_dttm = var('delta_start_dttm') %}
{%set delta_end_dttm = var('delta_end_dttm') %}

with source_data as (

  select 
  *
  from {{ source('raw_data','linkedin_jobs') }}
)
select 
title as role,
company,
location,
cast( posting_date as Date) posting_date,
job_id,
job_description,
{{ insert_batch_id }} as insert_batch_id,
'{{ delta_start_dttm }}' as delta_start_dttm,
'{{ delta_end_dttm }}' as delta_end_dttm
from
source_data
