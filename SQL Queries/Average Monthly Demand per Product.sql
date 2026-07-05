with monthly_totals as(
	select orders.stock_code,
	date_trunc('month', invoice_date) as demand_month,
	sum(quantity) as total_demand
	from orders
	left join products
	on products.stock_code = orders.stock_code
	where products.is_product_code
	group by orders.stock_code, date_trunc('month', invoice_date)
)
select stock_code,
	round(avg(total_demand), 2) as avg_monthly_demand
	from monthly_totals
	group by stock_code
	order by avg_monthly_demand desc;