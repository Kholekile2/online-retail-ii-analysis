with ranked_products as (
	select 
		products.description,
		sum (orders.price * orders.quantity) as total_revenue,
		rank() over (order by sum(orders.price * orders.quantity) desc) as sales_rank
		from orders
		left join products
		on orders.stock_code = products.stock_code
		where products.is_product_code
		group by products.description, products.stock_code
		order by sales_rank asc
	)
select * from ranked_products
where sales_rank <= 10;