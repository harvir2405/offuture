--- Creating the views
-- First view 
CREATE VIEW all_2509.team9 AS (
	SELECT *
	FROM offuture.order) 
	
SELECT * 
FROM all_2509.team9;

GRANT ALL ON all_2509.team9 TO de14_daki; 
GRANT ALL ON all_2509.team9 TO de14_saan;
GRANT ALL ON all_2509.team9 TO da14_haku; 


-- Customer ID view
CREATE VIEW all_2509.customer_id_team9 AS (
SELECT order_id,
       c.customer_id_long AS new_customer_id
FROM offuture.order o
JOIN offuture.customer c
  ON o.customer_id = c.customer_id_short
UNION
SELECT o.order_id,
       c.customer_id_long AS new_customer_id
FROM offuture.order o
JOIN offuture.customer c
  ON o.customer_id = c.customer_id_long 
  )
  
SELECT * 
FROM all_2509.customer_id_team9
ORDER BY new_customer_id; 

GRANT ALL ON all_2509.customer_id_team9 TO de14_daki; 
GRANT ALL ON all_2509.customer_id_team9 TO de14_saan;
GRANT ALL ON all_2509.customer_id_team9 TO da14_haku; 

-- Final master view
CREATE VIEW all_2509.team9_master AS(
	SELECT * 
	FROM all_2509.team9
	INNER JOIN offuture.order_item
		USING(order_id)
	INNER JOIN offuture.address
		USING(address_id)
	INNER JOIN offuture.product
		USING(product_id)
	INNER JOIN all_2509.customer_id_team9
		USING(order_id)
	INNER JOIN offuture.customer
		ON customer.customer_id_long = customer_id_team9.new_customer_id
);

GRANT ALL ON all_2509.team9_master TO de14_daki; 
GRANT ALL ON all_2509.team9_master TO de14_saan;
GRANT ALL ON all_2509.team9_master TO da14_haku; 

SELECT * 
FROM all_2509.team9_master;



---slide 2 

-- This code calculates the total sales including shipping cost
SELECT
	SUM(sales + shipping_cost) AS total_sales_and_ship
FROM offuture.order_item;
-- Output= 13995327.94

-- This code shows a table for the total sales per year
SELECT 
	SUM(sales), 
	DATE_TRUNC('year', order_date::date)
FROM all_2509.team9_master
GROUP BY DATE_TRUNC('year', order_date::date)
ORDER BY DATE_TRUNC('year', order_date::date); 



---slide 3

-- This code shows a table for the total profit per year
SELECT 
	SUM(profit), 
	DATE_TRUNC('year', order_date::date)
FROM all_2509.team9_master
GROUP BY DATE_TRUNC('year', order_date::date)
ORDER BY DATE_TRUNC('year', order_date::date);


-- slide 4

-- This code identifies the total profit for each country, listing the top 5
SELECT 	
	country AS "Country",
	ROUND(SUM(profit), 0) AS "Total profit"
FROM all_2509.team9_master
GROUP BY country
ORDER BY "Total profit" DESC
LIMIT 5;



---slide 5 

-- This code shows the total profits for each segment
SELECT
	segment,
	SUM(profit)
FROM all_2509.team9_master
GROUP BY segment
ORDER BY SUM(profit) DESC;

-- This code shows an overview of the sales, profit and quantity by subcategory
SELECT 
	sub_category,
	ROUND(SUM(quantity), 0) AS total_quantity,
	ROUND(SUM(profit), 0) AS total_profit,
	ROUND(SUM(sales), 0) AS total_sales
FROM all_2509.team9_master
GROUP BY sub_category
ORDER BY sub_category ASC;



---slide 6

-- This code shows the top 15 products, on average profit
SELECT
	AVG(profit),
	product_id,
	product_name
FROM all_2509.team9_master
GROUP BY
	product_id,
	product_name
ORDER BY
	AVG(profit) DESC
LIMIT 15;



---slide 7 

-- This code shows the worst 15 products, on average profit
SELECT
	AVG(profit),
	product_id,
	product_name
FROM all_2509.team9_master
GROUP BY
	product_id,
	product_name
ORDER BY
	AVG(profit)
LIMIT 15;



---slide 8 

--This code created a view which I use in the next query
CREATE VIEW all_2509.subcat_quant_dis_group9 AS (
SELECT DISTINCT
	sub_category,
	discount,
	SUM(quantity)
FROM all_2509.team9_master
GROUP BY 
	sub_category,
	discount
ORDER BY sub_category);

GRANT ALL ON all_2509.subcat_quant_dis_group9 TO da14_hasi;
GRANT ALL ON all_2509.subcat_quant_dis_group9 TO de14_daki;
GRANT ALL ON all_2509.subcat_quant_dis_group9 TO da14_haku;

-- This code creates a table to find the percentage of items sold which were discounted grouped by subcategory
SELECT 
	sub_category AS "Subcategory",
	SUM(CASE WHEN discount != 0 THEN "sum" END) AS "Total items discounted",
	SUM("sum") AS "Total items sold",
	ROUND((SUM(CASE WHEN discount != 0 THEN "sum" END)/SUM("sum"))*100, 0) AS "Percentage of items discounted"
FROM all_2509.subcat_quant_dis_group9
GROUP BY sub_category;



---slide 9 

-- This code calculates the average discount per order per subcategory
SELECT 
	sub_category AS "Subcategory",
	ROUND(AVG(discount), 2) AS "Average discount",
	MAX(discount) AS "Highest discount"
FROM all_2509.team9_master
GROUP BY sub_category
ORDER BY sub_category ASC;



---slide 10 

-- This code identifies the total profit and the average discount applied to an order for each country in the database
-- I created a view with it to use in the next query

CREATE VIEW all_2509.group9_country_discount AS (
SELECT
    country AS "Country",
    ROUND(SUM(profit), 0) AS "Total profit",
    ROUND(AVG(discount), 1) AS "Average discount"
FROM all_2509.team9_master
GROUP BY country
ORDER BY
    "Total profit" DESC,
    "Average discount" DESC
);

GRANT ALL ON all_2509.group9_country_discount TO da14_hasi;
GRANT ALL ON all_2509.group9_country_discount TO de14_daki;
GRANT ALL ON all_2509.group9_country_discount TO da14_haku;

-- This code lists all countries with negative profit
SELECT COUNT("Country") AS "Countries making loss"
FROM all_2509.group9_country_discount
WHERE "Total profit" < 0;
