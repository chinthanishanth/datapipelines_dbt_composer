# LinkedIn Job Market Data Warehouse - Project Overview

## Project Description

The LinkedIn DBT project (`dataengineeringprd`) is a data transformation pipeline designed to process and model LinkedIn job posting data for analytical purposes. This project transforms raw LinkedIn job data into a structured data warehouse following dimensional modeling principles.

## Project Structure

### Data Architecture
The project follows a three-layer architecture:
- **Stage Layer**: Raw data cleaning and initial transformations
- **Dimension Layer**: Reference data and lookup tables
- **Facts Layer**: Transactional and event data

### Database Configuration
- **Project Name**: dataengineeringprd
- **Version**: 1.0.0
- **Target Database**: calm-repeater-471011-d8 (Google BigQuery)
- **Schema**: dim_linkedin (for seed tables)

## Data Sources

### Raw Data Sources
- **linkedin_jobs**: Primary source table containing raw LinkedIn job posting data
  - Database: calm-repeater-471011-d8
  - Schema: raw_data
  - Freshness monitoring: Warns after 24 hours, errors after 96 hours

### Dimension Sources
- **dim_dates**: Date dimension table for temporal analysis
  - Schema: dim_linkedin

## Models Overview

### Staging Models (stage/)
- `stg_linkedin_jobs.sql`: Cleaned and standardized LinkedIn job data
- `stg_dim_companies.sql`: Company data staging
- `stg_dim_title.sql`: Job title data staging
- `stg_stage_location.sql`: Location data staging

### Dimension Models (dim_linkedin/)
- `dim_companies.sql`: Company dimension with surrogate keys
- `dim_locations.sql`: Location dimension for geographic analysis
- `dim_title.sql`: Job title dimension for role categorization

### Fact Models (facts/)
- `fact_job_descriptions.sql`: Central fact table containing job posting details with foreign keys to all dimensions

## Key Features

### Data Quality
- Comprehensive data testing with dbt tests
- Unique and not-null constraints on surrogate keys
- Referential integrity checks between fact and dimension tables
- Custom data quality tests for duplicate value detection

### Incremental Processing
- Fact tables configured for incremental loading
- Unique key strategy for handling updates and duplicates
- Optimized for large-scale data processing

### Surrogate Key Management
- Uses dbt_utils.generate_surrogate_key() for consistent key generation
- Maintains referential integrity across all dimension relationships

## Dependencies
- **dbt_utils**: Utility macros for common dbt operations
- **Google BigQuery**: Target data warehouse platform

## Data Lineage
```
raw_data.linkedin_jobs → stg_linkedin_jobs → fact_job_descriptions
                      ↓
                   dim_companies ← stg_dim_companies
                   dim_locations ← stg_stage_location  
                   dim_title ← stg_dim_title
                   dim_dates (seed)
```

## Usage
This data warehouse supports various analytical use cases:
- Job market trend analysis
- Company hiring pattern analysis
- Geographic job distribution analysis
- Job title and skill demand analysis
- Temporal analysis of job posting patterns

## Maintenance
- Regular data freshness monitoring
- Automated testing on model builds
- Incremental refresh strategy for optimal performance
