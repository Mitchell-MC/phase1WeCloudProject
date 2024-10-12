-- tests/test_customer_demographics_coverage.sql
{% test customer_demographics_coverage(model, column_name) %}

WITH customer_demo_status AS (
    SELECT 
        CASE 
            WHEN {{ column_name }} > 480200 THEN 'No Demographics'
            ELSE 'Has Demographics'
        END as demo_status
    FROM {{ model }}
),
demo_counts AS (
    SELECT 
        demo_status,
        COUNT(*) as count
    FROM customer_demo_status
    GROUP BY demo_status
),
total_count AS (
    SELECT SUM(count) as total
    FROM demo_counts
),
percentages AS (
    SELECT 
        demo_status,
        count,
        (count * 100.0 / total) as percentage
    FROM demo_counts, total_count
)

SELECT *
FROM percentages
WHERE demo_status = 'No Demographics' AND percentage > 20  -- Adjust threshold as needed

{% endtest %}