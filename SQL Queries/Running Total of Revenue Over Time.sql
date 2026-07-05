with monthly_revenue as (
select date_trunc('month', invoice_date)::date as revenue_month,
sum (price * quantity) as total_revenue
from orders
where is_product_code = 'TRUE'
group by date_trunc('month', invoice_date)
)
select
	revenue_month,
	total_revenue,
	sum(total_revenue) over (order by revenue_month) as running_total
from monthly_revenue