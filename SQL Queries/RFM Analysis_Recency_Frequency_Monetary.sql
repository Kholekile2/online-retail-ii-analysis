WITH customer_monetary AS (
    SELECT customer_id, SUM(price * quantity) AS monetary
    FROM orders
    WHERE is_product_code AND has_customer_id
    GROUP BY customer_id
)

select c.customer_id, c.total_orders as frequency, cm.monetary,
(select max(invoice_date) from orders)::date - c.last_purchase_date::date as recency
from customers c
join customer_monetary cm on c.customer_id = cm.customer_id;

--confirming the missing 65 rows--
SELECT c.customer_id
FROM customers c
LEFT JOIN customer_monetary cm ON c.customer_id = cm.customer_id
WHERE cm.customer_id IS NULL;