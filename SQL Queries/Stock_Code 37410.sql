SELECT date_trunc('month', invoice_date) AS demand_month, SUM(quantity) AS monthly_quantity
FROM orders
WHERE stock_code = '37410'
GROUP BY date_trunc('month', invoice_date)
ORDER BY demand_month;