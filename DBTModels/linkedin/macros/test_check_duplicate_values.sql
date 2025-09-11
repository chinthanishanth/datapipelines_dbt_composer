{% test test_check_duplicate_values(model, column_name)  %}

    WITH duplicate_values AS (  
        SELECT {{ column_name }}  
        FROM {{ model }}  
        GROUP BY {{ column_name }}  
        HAVING COUNT(*) > 1  
    )
    SELECT COUNT(*) AS duplicate_count  
    FROM duplicate_values
{% endtest %}

