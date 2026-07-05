select sum (price * quantity) as total_revenue
from orders where is_product_code = 'TRUE';

select 
	count(*) as row_count,
	sum(quantity) as total_quantity,
	avg(price) as avg_price,
	avg(quantity) as avg_quantity
from orders
where is_product_code = 'TRUE';