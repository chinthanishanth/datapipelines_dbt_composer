-- CHECK FOR DUPLICATE DESIGNATIONS IN DIM_TITLE
-- This test checks for duplicate entries in the designation column of the dim_title table.
-- If any duplicates are found, the test will fail, indicating that the data integrity constraint has been violated.

SELECT designation FROM {{ ref('dim_title') }}
GROUP BY designation
HAVING COUNT(*) > 1