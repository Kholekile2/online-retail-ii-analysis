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
)
SELECT customer_id, recency, frequency, monetary,
    NTILE(4) OVER (ORDER BY recency DESC) AS recency_score,
    NTILE(4) OVER (ORDER BY frequency ASC) AS frequency_score,
    NTILE(4) OVER (ORDER BY monetary ASC) AS monetary_score
FROM rfm_base;