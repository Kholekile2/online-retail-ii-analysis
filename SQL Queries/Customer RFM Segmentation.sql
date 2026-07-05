SELECT customer_segment, COUNT(*) AS customer_count
FROM (
    WITH customer_monetary AS (
        SELECT customer_id, SUM(price * quantity) AS monetary
        FROM orders
        WHERE is_product_code AND has_customer_id
        GROUP BY customer_id
    ),
    rfm_base AS (
        SELECT c.customer_id, c.total_orders AS frequency, cm.monetary,
            (SELECT max(invoice_date) FROM orders)::date - c.last_purchase_date::date AS recency
        FROM customers c
        JOIN customer_monetary cm ON c.customer_id = cm.customer_id
    ),
    rfm_scores AS (
        SELECT customer_id, recency, frequency, monetary,
            NTILE(4) OVER (ORDER BY recency DESC) AS recency_score,
            NTILE(4) OVER (ORDER BY frequency ASC) AS frequency_score,
            NTILE(4) OVER (ORDER BY monetary ASC) AS monetary_score
        FROM rfm_base
    )
    SELECT customer_id, recency, frequency, monetary,
        recency_score, frequency_score, monetary_score,
        (recency_score + frequency_score + monetary_score) AS rfm_total,
        CASE
            WHEN (recency_score + frequency_score + monetary_score) >= 10 THEN 'High Value'
            WHEN (recency_score + frequency_score + monetary_score) >= 7 THEN 'Mid Value'
            WHEN (recency_score + frequency_score + monetary_score) >= 4 THEN 'Low Value'
            ELSE 'At Risk'
        END AS customer_segment
    FROM rfm_scores
    -- 1. Fixed: Removed the semicolon and ORDER BY from here
) AS rfm_final
GROUP BY customer_segment
ORDER BY customer_count DESC; -- 2. Kept: The only semicolon belongs at the absolute end
