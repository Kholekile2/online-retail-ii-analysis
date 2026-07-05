select date_trunc('month', invoice_date)::date as revenue_month,
sum (price * quantity) as total_revenue
from orders
where is_product_code = 'TRUE'
group by date_trunc('month', invoice_date)
order by revenue_month asc;