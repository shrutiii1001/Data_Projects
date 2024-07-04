SELECT * FROM PIZZA_SALES

--KPI'S REQUIREMENTS.


--REQUIRMENT 1. TOTAL REVENUE: THE SUM OF THE TOTAL PRICE OF ALL PIZZA ORDERS.

 SELECT SUM(TOTAL_PRICE)AS TOTAL_REVENUE FROM PIZZA_SALES

 --REQUIRMENT 2. AVERAGE ORDER VALUE: THE AVERAGE AMOUNT SPENT PER ORDER. CALCULATED BY DIVIDING THE TOTAL REVENUE BY TOTAL NUMBER OF ORDERS.

 SELECT SUM(TOTAL_PRICE) / COUNT(DISTINCT ORDER_ID) AS AVG_ORDER_VALUE FROM pizza_sales

 --REQUIRMENT  3. TOTAL PIZZA SOLD: THE SUM OF THE QUANTITIES OF ALL PIZZAS SOLD.

 SELECT SUM(QUANTITY) AS TOTAL_SOLD_PIZZA FROM pizza_sales

 --REQUIRMENT 4. TOTAL ORDERS: THE TOTAL NUMBER OF ORDERS PLACED.

 SELECT COUNT(DISTINCT ORDER_ID) AS TOTAL_PLACED_ORDERS FROM pizza_sales

 --REQUIRMENT 5. AVAERAGE PIZZAS PER ORDER: THE AVERAGE NUMBER OF PIZZAS SOLD PER ORDER, 
                --CALCULATED BY DIVIDING THE TOTAL NUMBER OF PIZZAS SOLD BY THE TOTAL NUMBER OF ORDERS.

SELECT CAST(CAST(SUM(QUANTITY) AS DECIMAL (10,2)) / CAST(COUNT(DISTINCT ORDER_ID) AS DECIMAL (10,2)) AS DECIMAL (10,2)) FROM pizza_sales

--CHARTS REQUIREMENTS.

--REQUIRMENT 1. DAILY TREND FOR TOTAL ORDERS.

SELECT DATENAME(DW,ORDER_DATE) AS ORDER_DAY, COUNT(DISTINCT ORDER_ID) AS TOTAL_ORDERS
FROM PIZZA_SALES
GROUP BY DATENAME(DW, ORDER_DATE)

--REQUIRMENT 2. HOURLY TREND FOR TOTAL ORDERS.

SELECT DATEPART(HOUR, ORDER_TIME) AS ORDER_HOURS, COUNT(DISTINCT ORDER_ID) AS TOTAL_ORDERS
FROM PIZZA_SALES
GROUP BY DATEPART(HOUR, ORDER_TIME)
ORDER BY DATEPART(HOUR, ORDER_TIME)

--REQUIRMENT 3. PERCENTAGE OF SALES BY PIZZA CATEGORY:

SELECT PIZZA_CATEGORY, CAST(SUM(TOTAL_PRICE) AS DECIMAL (10,2)) AS TOTAL_SALES, CAST(SUM(TOTAL_PRICE) * 100/
(SELECT SUM(TOTAL_PRICE) FROM PIZZA_SALES) AS DECIMAL (10,2)) AS PCT 
FROM PIZZA_SALES
GROUP BY pizza_category

--REQUIRMENT 4. PERCENTAGE OF SALES BY PIZZA SIZE: 

SELECT pizza_size,CAST(SUM(TOTAL_PRICE)AS DECIMAL(10,2)) AS TOTAL_SALES,CAST(SUM(TOTAL_PRICE)* 100 /
(SELECT SUM(TOTAL_PRICE) FROM pizza_sales WHERE DATEPART(QUARTER,ORDER_DATE)= 1) AS DECIMAL (10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_size
ORDER BY PCT DESC

--REQUIRMENT 5. TOTAL PIZZAS SOLD BY PIZZA CATEGORY:

SELECT PIZZA_CATEGORY, SUM(quantity) AS TOTAL_PIZZA_SOLD FROM pizza_sales
GROUP BY pizza_category

--REQUIRMENT 6. TOP 5 BEST SELLER BY TOTAL PIZZA SOLD:

SELECT TOP 5 PIZZA_NAME, SUM(QUANTITY) AS TOTAL_PIZZA_SOLD 
FROM pizza_sales
GROUP BY pizza_name
ORDER BY SUM(quantity) DESC

--REQUIRMENT 7. BOTTOM 5 WORST SELLER BY TOTAL PIZZA SOLD: 

--NOTE : MONTHS IS FOR EXTRA ADDITION IN QUERY...

SELECT TOP 5 PIZZA_NAME, SUM(QUANTITY) AS TOTAL_PIZZA_SOLD 
FROM pizza_sales
GROUP BY pizza_name
ORDER BY SUM(quantity) ASC





