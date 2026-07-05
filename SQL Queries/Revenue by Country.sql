select country,
sum(price * quantity) as country_revenue
from orders
where is_product_code and country != 'United Kingdom'
group by country
order by country_revenue desc;