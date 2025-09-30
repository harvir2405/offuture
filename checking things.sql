
-- top 15 products, on average profit 
SELECT 
	AVG(profit)
	, product_id
	, product_name
FROM 
	all_2509.team9_master
GROUP BY 
	product_id
	, product_name
ORDER BY 
	AVG(profit) DESC
LIMIT 15; 

-- worst 15 products, on average profit 
SELECT 
	AVG(profit)
	, product_id
	, product_name
FROM 
	all_2509.team9_master
GROUP BY 
	product_id
	, product_name
ORDER BY 
	AVG(profit)
LIMIT 15; 

-- number of total orders 
SELECT 
	COUNT(DISTINCT order_id)
FROM
	all_2509.team9_master
-- Output = 25,754

	
-- 
SELECT 
	order_id 
	, product_id
	, product_name
	, sub_category
	, Avg(quantity)
FROM all_2509.team9_master
GROUP BY 
	order_id
	, product_id
	, product_name
	, sub_category
HAVING 
	AVG(quantity) > 13
ORDER BY 
	AVG(quantity) DESC; 



