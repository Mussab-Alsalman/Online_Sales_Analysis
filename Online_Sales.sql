

SELECT 
	*
FROM
	sales;


-- Quick Exploration:
SELECT 
	MIN(order_date) AS First_Date,
	MAX(order_date) AS Last_Date
FROM
	sales;



SELECT 
	COUNT(DISTINCT order_id) AS Customers,
	COUNT(order_id) AS Orders,
	COUNT(DISTINCT product) AS Product,
	COUNT(DISTINCT purchase_address) AS Locations
FROM
	sales;



SELECT 
	COUNT(order_id) AS Total_Orders,
	ROUND(SUM(sales),0) AS Total_Sales,
	ROUND(AVG(sales),0) AS AVG_Sales,
	SUM(quantity_ordered) AS Total_QTY
FROM
	sales;



-- Checking orders that has more than one product:
SELECT 
	order_id,
	COUNT(*) AS Total_Orders
FROM
	sales
GROUP BY
	order_id
HAVING 
	COUNT(*) > 1;



SELECT
	*
FROM
	sales
WHERE
	order_id = '214081'



-- See the monthly trend in pct:
WITH Monthly_Trends_Summary AS
(
	WITH Monthly_Trends AS
	(
		SELECT 
			month,
			COUNT(order_id) AS Total_Orders,
			SUM(quantity_ordered) AS Total_QTY,
			SUM(sales) AS Total_Sales
		FROM
			sales
		GROUP BY
			month
		ORDER BY
			month
	)
	SELECT
		month,
		total_orders,
		SUM(total_orders) OVER() AS Overall_Sales,
		ROUND((total_orders/ SUM(total_orders) OVER()) * 100, 2) AS Pct_Orders,
		total_qty,
		SUM(total_qty) OVER () AS Overall_QTY,
		ROUND((total_qty / SUM(total_qty) OVER()) * 100, 2) AS Pct_QTY,
		total_sales,
		SUM(total_sales) OVER() AS Overall_Sales,
		ROUND((total_sales/ SUM(total_sales) OVER ()) * 100, 2) AS Pct_Sales
	FROM
		Monthly_Trends
)
SELECT 
	month,
	total_orders,
	pct_orders,
	total_qty,
	pct_qty,
	total_sales,
	pct_sales
FROM
	Monthly_Trends_Summary;
-- Orders, quantity and sales started low, then spike a little and stay in Apr and May, then drop in the summer month, then start to spike again in the winter month especially in Dec.



-- Top 3 product each month:
WITH Product_Monthly_Trends_Summary AS
(
	WITH Monthly_Trends AS
	(
		SELECT 
			month,
			product,
			COUNT(order_id) AS Total_Orders,
			SUM(quantity_ordered) AS Total_QTY,
			SUM(sales) AS Total_Sales,
			RANK() OVER(PARTITION BY MONTH ORDER BY SUM(sales)DESC) AS Product_Ranking
		FROM
			sales
		GROUP BY
			month,
			product
	)
	SELECT
		month,
		product,
		total_orders,
		SUM(total_orders) OVER() AS Overall_Sales,
		ROUND((total_orders/ SUM(total_orders) OVER()) * 100, 2) AS Pct_Orders,
		total_qty,
		SUM(total_qty) OVER () AS Overall_QTY,
		ROUND((total_qty / SUM(total_qty) OVER()) * 100, 2) AS Pct_QTY,
		total_sales,
		SUM(total_sales) OVER() AS Overall_Sales,
		ROUND((total_sales/ SUM(total_sales) OVER ()) * 100, 2) AS Pct_Sales,
		Product_Ranking
	FROM
		Monthly_Trends
	WHERE
		Product_Ranking <= 3
)
SELECT 
	month,
	product,
	total_orders,
	pct_orders,
	total_qty,
	pct_qty,
	total_sales,
	pct_sales,
	Product_Ranking
FROM
	Product_Monthly_Trends_Summary;
-- sales: macbook pro, iphone, thinkpad
-- quantity and orders are same: aaa batteries, aa batteires, usb-c charging cable, lightning charging cable.



	
-- See the hours trend:
WITH Hourly_Trends_Summary AS
(
	WITH Hourly_Trends AS
	(
		SELECT 
			hour,
			COUNT(order_id) AS Total_Orders,
			SUM(quantity_ordered) AS Total_QTY,
			SUM(sales) AS Total_Sales
		FROM
			sales
		GROUP BY
			hour
		ORDER BY
			hour
	)
	SELECT
		hour,
		total_orders,
		SUM(total_orders) OVER() AS Overall_Sales,
		ROUND((total_orders/ SUM(total_orders) OVER()) * 100, 2) AS Pct_Orders,
		total_qty,
		SUM(total_qty) OVER () AS Overall_QTY,
		ROUND((total_qty / SUM(total_qty) OVER()) * 100, 2) AS Pct_QTY,
		total_sales,
		SUM(total_sales) OVER() AS Overall_Sales,
		ROUND((total_sales/ SUM(total_sales) OVER ()) * 100, 2) AS Pct_Sales
	FROM
		hourly_Trends
)
SELECT 
	hour,
	total_orders,
	pct_orders,
	total_qty,
	pct_qty,
	total_sales,
	pct_sales
FROM
	hourly_Trends_Summary;
-- orders, quantity and sales start from 10 to 22(11am, 23pm) , 12 to 13, 19 to 21 has the highest.   



-- Top 3 product each Hour:
WITH Product_Hourly_Trends_Summary AS
(
	WITH Hourly_Trends AS
	(
		SELECT 
			HOUR,
			product,
			COUNT(order_id) AS Total_Orders,
			SUM(quantity_ordered) AS Total_QTY,
			SUM(sales) AS Total_Sales,
			RANK() OVER(PARTITION BY HOUR ORDER BY SUM(quantity_ordered)DESC) AS Product_Ranking
		FROM
			sales
		GROUP BY
			HOUR,
			product
	)
	SELECT
		HOUR,
		product,
		total_orders,
		SUM(total_orders) OVER() AS Overall_Sales,
		ROUND((total_orders/ SUM(total_orders) OVER()) * 100, 2) AS Pct_Orders,
		total_qty,
		SUM(total_qty) OVER () AS Overall_QTY,
		ROUND((total_qty / SUM(total_qty) OVER()) * 100, 2) AS Pct_QTY,
		total_sales,
		SUM(total_sales) OVER() AS Overall_Sales,
		ROUND((total_sales/ SUM(total_sales) OVER ()) * 100, 2) AS Pct_Sales,
		Product_Ranking
	FROM
		Hourly_Trends
	WHERE
		Product_Ranking <= 3
)
SELECT 
	HOUR,
	product,
	total_orders,
	pct_orders,
	total_qty,
	pct_qty,
	total_sales,
	pct_sales,
	Product_Ranking
FROM
	Product_Hourly_Trends_Summary;
-- sales: macbook pro, iphone, thinkpad
-- quantity and orders are same: aaa batteries, aa batteires, usb-c charging cable, lightning charging cable.


	
-- Week trends:
-- 1 = Monday and so on 
SELECT 
	EXTRACT(ISODOW FROM order_date) AS Weekdays,
	COUNT(order_id) AS Total_Orders,
	SUM(quantity_ordered) AS Total_QTY,
	SUM(sales) AS Total_Sales
FROM
	sales
GROUP BY
	EXTRACT(ISODOW FROM order_date)
ORDER BY
	EXTRACT(ISODOW FROM order_date);
-- results same no crazy changes.



-- Products ranking Overall:
SELECT 
	product,
	COUNT(order_id) AS Total_Orders,
	SUM(quantity_ordered) AS Total_QTY,
	SUM(sales) AS Total_Sales
FROM
	sales
GROUP BY
	product
ORDER BY
	total_orders DESC;
-- sales: macbook pro, quantity: AAA batteries, orders: usb-c charging cable. cheap products has higher quantity and orders, and lower sales amount.



--Checking what products sold togther:
SELECT 
    S1.product AS P1,
    S2.product AS P2,
    COUNT(*) AS Products_Together
FROM 
    sales AS S1
JOIN 
    sales AS S2 
    ON S1.order_id = S2.order_id
    AND S1.product < S2.product
GROUP BY 
    S1.product, S2.product
ORDER BY 
    Products_Together DESC;
--Top3:
-- lightning charging cable with iphone.
-- google phone with usb-c charging cable.
-- wired headphone with iphone.



-- Location:
SELECT 
	purchase_address,
	COUNT(order_id) AS Total_Orders,
	SUM(quantity_ordered) AS Total_QTY,
	SUM(sales) AS Total_Sales
FROM
	sales
GROUP BY
	purchase_address
ORDER BY
	total_sales DESC;
-- California Has the highest especially San Francisco.

