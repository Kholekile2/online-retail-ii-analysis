select products.description, sum (orders.price * orders.quantity) as top10_total_revenue
from orders
left join products
on orders.stock_code = products.stock_code
where orders.is_product_code
group by products.stock_code, products.description
order by top10_total_revenue desc, products.description
limit 10;