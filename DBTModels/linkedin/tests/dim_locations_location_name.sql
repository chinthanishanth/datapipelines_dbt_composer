-- CHECK FOR DUPLICATE LOCATION NAMES IN DIM_COMPANIES
-- This test checks for duplicate entries in the location column of the dim_companies table.
-- If any duplicates are found, the test will fail, indicating that the data integrity constraint has been violated.

SELECT location FROM {{ ref('dim_locations') }}
GROUP BY location
HAVING COUNT(*) > 1