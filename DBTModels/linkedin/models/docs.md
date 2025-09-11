# LinkedIn DBT Project - Column Documentation

This document provides detailed documentation for all columns defined in the LinkedIn DBT project schema.

## Table of Contents
- [fact_job_descriptions](#fact_job_descriptions)
- [dim_companies](#dim_companies)
- [Data Types and Constraints](#data-types-and-constraints)
- [Testing Strategy](#testing-strategy)

---

## fact_job_descriptions

**Description**: This table contains job description data and serves as the central fact table in the LinkedIn job market data warehouse.

**Table Type**: Fact Table  
**Materialization**: Incremental  
**Unique Key**: `sur_description_id`

### Columns

| Column Name | Data Type | Description | Constraints | Tests |
|-------------|-----------|-------------|-------------|-------|
| `sur_description_id` | STRING | Surrogate key for job descriptions. Generated using dbt_utils.generate_surrogate_key() based on job_id. This serves as the primary key for the fact table. | Primary Key | `not_null`, `unique` |
| `job_id` | STRING | Identifier for the job. This is the natural key from the source system representing a unique job posting. | Natural Key | `unique` |
| `sur_company_id` | STRING | Surrogate key for the company. Foreign key reference to the dim_companies table to establish the relationship between job postings and companies. | Foreign Key | `relationships` to `dim_companies.sur_company_id` |
| `sur_location_id` | STRING | Surrogate key for the location. Foreign key reference to the dim_locations table to establish geographic relationships for job postings. | Foreign Key | `relationships` to `dim_locations.sur_location_id` |

### Additional Columns (from SQL model)
Based on the fact_job_descriptions.sql model, the table also includes:

| Column Name | Data Type | Description | Source |
|-------------|-----------|-------------|---------|
| `sur_title_id` | STRING | Surrogate key for job title dimension | Lookup from `dim_title` |
| `datekey` | INT64 | Date key for temporal analysis | Lookup from `dim_dates` |
| `job_description` | STRING | Full text of the job description | Raw source data |

---

## dim_companies

**Description**: This table contains company data and serves as a dimension table for company-related attributes.

**Table Type**: Dimension Table  
**Materialization**: Table

### Columns

| Column Name | Data Type | Description | Constraints | Tests |
|-------------|-----------|-------------|-------------|-------|
| `sur_company_id` | STRING | Surrogate key for companies. This serves as the primary key for the company dimension and is referenced by fact tables. | Primary Key | `test_check_duplicate_values` |

### Additional Columns (inferred from model structure)
Based on the project structure, the dim_companies table likely includes:

| Column Name | Data Type | Description | Source |
|-------------|-----------|-------------|---------|
| `company_name` | STRING | Name of the company | Cleaned from raw LinkedIn data |

---

## Data Types and Constraints

### Surrogate Keys
- All surrogate keys are generated using `dbt_utils.generate_surrogate_key()`
- Surrogate keys are of type STRING (hash-based)
- Provide stable, unique identifiers independent of source system changes

### Natural Keys
- `job_id`: Unique identifier from the source LinkedIn data
- Maintained for traceability and debugging purposes

### Foreign Key Relationships
The following referential integrity constraints are enforced:

```sql
fact_job_descriptions.sur_company_id → dim_companies.sur_company_id
fact_job_descriptions.sur_location_id → dim_locations.sur_location_id
```

---

## Testing Strategy

### Data Quality Tests

#### Primary Key Tests
- **not_null**: Ensures surrogate keys are never null
- **unique**: Ensures surrogate keys are unique across the table

#### Referential Integrity Tests
- **relationships**: Validates foreign key constraints between fact and dimension tables
- Ensures data consistency across the dimensional model

#### Custom Tests
- **test_check_duplicate_values**: Custom test for detecting duplicate values in critical columns
- Applied to `dim_companies.sur_company_id` to ensure dimension integrity

### Test Coverage Summary

| Table | Column | Test Type | Purpose |
|-------|--------|-----------|---------|
| fact_job_descriptions | sur_description_id | not_null, unique | Primary key validation |
| fact_job_descriptions | job_id | unique | Natural key validation |
| fact_job_descriptions | sur_company_id | relationships | Foreign key validation |
| fact_job_descriptions | sur_location_id | relationships | Foreign key validation |
| dim_companies | sur_company_id | test_check_duplicate_values | Custom duplicate detection |

---

## Data Lineage and Transformations

### Source to Target Mapping

#### fact_job_descriptions
- **Source**: `raw_data.linkedin_jobs`
- **Transformations**:
  - Generate surrogate key from `job_id`
  - Clean and trim company names
  - Normalize job titles to lowercase
  - Trim location data
  - Join with dimension tables to get surrogate keys

#### Dimension Tables
- **dim_companies**: Derived from unique company names in source data
- **dim_locations**: Derived from unique locations in source data
- **dim_title**: Derived from unique job titles in source data

---

## Usage Notes

### Incremental Loading
- `fact_job_descriptions` uses incremental materialization
- New records are identified by `sur_description_id`
- Supports efficient processing of large datasets

### Query Patterns
Common query patterns for this schema:

```sql
-- Job postings by company
SELECT 
    c.company_name,
    COUNT(*) as job_count
FROM {{ ref('fact_job_descriptions') }} f
JOIN {{ ref('dim_companies') }} c ON f.sur_company_id = c.sur_company_id
GROUP BY c.company_name;

-- Geographic distribution of jobs
SELECT 
    l.location,
    COUNT(*) as job_count
FROM {{ ref('fact_job_descriptions') }} f
JOIN {{ ref('dim_locations') }} l ON f.sur_location_id = l.sur_location_id
GROUP BY l.location;
```

### Performance Considerations
- Surrogate keys enable efficient joins
- Incremental loading reduces processing time
- Proper indexing on surrogate keys recommended for query performance
