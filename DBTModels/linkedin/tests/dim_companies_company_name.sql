-- CHECK FOR DUPLICATE COMPANY NAMES IN DIM_COMPANIES
-- This test checks for duplicate entries in the company_name column of the dim_companies table.
-- If any duplicates are found, the test will fail, indicating that the data integrity constraint has been violated.

SELECT company_name FROM {{ ref('dim_companies') }}
GROUP BY company_name
HAVING COUNT(*) > 1