INSERT INTO inventory_snapshot (stock_code, avg_monthly_demand, active_months, is_steady_seller, starting_stock)
WITH monthly_totals AS (
    SELECT orders.stock_code, date_trunc('month', invoice_date) AS demand_month,
        SUM(quantity) AS total_demand
    FROM orders
    LEFT JOIN products ON products.stock_code = orders.stock_code
    WHERE products.is_product_code
    GROUP BY orders.stock_code, date_trunc('month', invoice_date)
),
product_stats AS (
    SELECT stock_code,
        AVG(total_demand) AS avg_monthly_demand,
        COUNT(*) AS active_months,
        SUM(total_demand) AS total_demand_overall
    FROM monthly_totals
    GROUP BY stock_code
)
SELECT stock_code, ROUND(avg_monthly_demand, 2), active_months,
    (active_months >= 12),
    GREATEST(0, ROUND(
        CASE WHEN active_months >= 12
            THEN avg_monthly_demand * 3
            ELSE total_demand_overall / 25.0
        END, 2))
FROM product_stats;