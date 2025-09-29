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

-- Final view
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
