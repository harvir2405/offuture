--- creating the master view



---slide 2 



---slide 3



---slide 4 

-- This code shows the total profits for each segment
-- DON'T NEED?
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



---slide 5 






---slide 6 






---slide 7 

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

-- This code creates a table to find the percentage of items sold which were discounted grouped by subcategory
SELECT 
	sub_category AS "Subcategory",
	SUM(CASE WHEN discount != 0 THEN "sum" END) AS "Total items discounted",
	SUM("sum") AS "Total items sold",
	ROUND((SUM(CASE WHEN discount != 0 THEN "sum" END)/SUM("sum"))*100, 0) AS "Percentage of items discounted"
FROM all_2509.subcat_quant_dis_group9
GROUP BY sub_category;



---slide 8 

-- This code calculates the average discount per order per subcategory
SELECT 
	sub_category AS "Subcategory",
	ROUND(AVG(discount), 2) AS "Average discount",
	MAX(discount) AS "Highest discount"
FROM all_2509.team9_master
GROUP BY sub_category
ORDER BY sub_category ASC;



---slide 9 

-- This code identifies the total profit and the average discount applied to an order for each country in the database.
SELECT 	
	country AS "Country",
	ROUND(SUM(profit), 0) AS "Total profit",
	ROUND(AVG(discount), 1) AS "Average discount"
FROM all_2509.team9_master
GROUP BY country
ORDER BY
	"Total profit" DESC,
	"Average discount" DESC;

