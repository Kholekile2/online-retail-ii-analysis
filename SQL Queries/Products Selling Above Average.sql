WITH product_revenue AS (
    select products.description, products.stock_code,
    sum(orders.price * orders.quantity) as total_revenue
    from orders
    left join products on orders.stock_code = products.stock_code
    where orders.is_product_code
    group by products.stock_code, products.description
)
select description, total_revenue
from product_revenue
where total_revenue > (select avg(total_revenue) from product_revenue)
order by total_revenue desc;