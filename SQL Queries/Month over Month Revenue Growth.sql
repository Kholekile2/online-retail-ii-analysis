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
	case
		when LAG(total_revenue) over (ORDER BY revenue_month) is null then 0
		else ((total_revenue - lag(total_revenue) over (order by revenue_month))
		/lag(total_revenue) over (order by revenue_month))*100
	end as previous_month_revenue	
from monthly_revenue
order by revenue_month asc;