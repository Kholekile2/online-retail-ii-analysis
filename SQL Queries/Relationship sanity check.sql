select count(*) from orders o
left join products p on o.stock_code = p.stock_code
where p.stock_code is null;