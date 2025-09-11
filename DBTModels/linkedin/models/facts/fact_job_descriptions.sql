{{ config(schema='facts',alias='fact_job_descriptions',materialized='incremental',unique_key=['sur_description_id']) }}

with source_data as (
select 
{{ dbt_utils.generate_surrogate_key(['job_id']) }} as sur_description_id,
-- ROW_NUMBER() OVER (order by job_id) as sur_description_id,
job_id,
job_description,
trim(company) as company_name,
lower(trim(title)) as designation,
trim(location) as location,
posting_date
from {{ source('raw_data','linkedin_jobs') }}
),

-- Get company surrogate key
company_lookup as (
select 
    s.*,
    c.sur_company_id
from source_data s
left join {{ ref('dim_companies') }} c
    on s.company_name = c.company_name
),

-- Get title surrogate key
title_lookup as (
select 
    cl.*,
    t.sur_title_id
from company_lookup cl
left join {{ ref('dim_title') }} t
    on cl.designation = t.designation 
),

-- get datekey surrogate key
date_lookup as (
select 
    tl.*,
    dt.datekey
from title_lookup tl
left join {{ source('dim_linkedin','dim_dates') }} dt
    on tl.posting_date = PARSE_DATE('%m/%d/%y',dt.full_date)
),

-- Get location surrogate key
final_lookup as (
select 
    dt.*,
    l.sur_location_id
from date_lookup dt
left join {{ ref('dim_locations') }} l
    on dt.location = l.location
)

select 
sur_description_id,
job_id,
sur_company_id,
sur_title_id,
sur_location_id,
datekey,
job_description,
from final_lookup

