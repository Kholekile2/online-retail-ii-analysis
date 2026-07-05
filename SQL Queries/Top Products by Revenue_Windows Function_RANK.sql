select products.description,
sum (orders.price * orders.quantity) as total_revenue,
rank() over (order by sum(orders.price * orders.quantity) desc) as sales_rank
from orders
left join products
on orders.stock_code = products.stock_code
where products.is_product_code
group by products.stock_code, products.description
order by sales_rank asc;