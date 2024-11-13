CREATE DATABASE coffee_shop_sales_db;
SELECT *
FROM coffee_shop_sales_db.coffee_shop_sales;

DESCRIBE coffee_shop_sales_db.coffee_shop_sales;

-- Changing data value of 'transaction_date' from text type to DATE format--
SET SQL_SAFE_UPDATES = 0;
UPDATE coffee_shop_sales_db.coffee_shop_sales
SET transaction_date = STR_TO_DATE(transaction_date, '%Y-%m-%d');
SET SQL_SAFE_UPDATES = 1;


-- Changing colum data-type of 'transaction_date' from text type to DATE data-type--
ALTER TABLE coffee_shop_sales_db.coffee_shop_sales
MODIFY COLUMN transaction_date DATE;

-- Changing data value of 'transaction_time' from text type to TIME format--
SET SQL_SAFE_UPDATES = 0;
UPDATE coffee_shop_sales_db.coffee_shop_sales
SET transaction_time = STR_TO_DATE(transaction_time, '%H:%i:%s');
SET SQL_SAFE_UPDATES = 1;

-- Changing colum data-type of 'transaction_time' from text type to TIME data-type--
ALTER TABLE coffee_shop_sales_db.coffee_shop_sales
MODIFY COLUMN transaction_time TIME;

DESCRIBE coffee_shop_sales_db.coffee_shop_sales;


-- changing column name without affecting data type--
ALTER TABLE coffee_shop_sales_db.coffee_shop_sales
CHANGE COLUMN ï»¿transaction_id transaction_id INT;


-- Calculate total sales for each respective month--
-- Total sale for April month--
SELECT ROUND(SUM(transaction_qty*unit_price)) AS total_sale
FROM coffee_shop_sales_db.coffee_shop_sales
WHERE month(transaction_date)=4;
-- Total sale for each respective  month--
SELECT monthname(transaction_date) AS month_name,ROUND(SUM(transaction_qty*unit_price)) AS total_sale
FROM coffee_shop_sales_db.coffee_shop_sales
GROUP BY monthname(transaction_date)
ORDER BY 2 DESC ;


-- month-on-month increase or decrease in total sales--
SELECT
month(transaction_date) AS monthday,
monthname(transaction_date) AS month_name,
SUM(transaction_qty*unit_price) AS curent_month_of_totale_sale,
LAG(SUM(transaction_qty*unit_price),1) OVER ( ORDER BY month(transaction_date) ASC ) AS previous_month_of_total_sale,
ROUND((SUM(transaction_qty*unit_price)-LAG(SUM(transaction_qty*unit_price),1) OVER ( ORDER BY month(transaction_date) ASC ))/
LAG(SUM(transaction_qty*unit_price),1) OVER ( ORDER BY month(transaction_date) ASC )*100,2) AS month_on_month_percentage_ofsale
FROM coffee_shop_sales_db.coffee_shop_sales
GROUP BY month(transaction_date), monthname(transaction_date)
order by month(transaction_date);

-- difference in sales between current and previous month--
SELECT
month(transaction_date) AS monthday,
monthname(transaction_date) AS month_name,
SUM(transaction_qty*unit_price) AS curent_month_of_totale_sale,
LAG(SUM(transaction_qty*unit_price),1) OVER ( ORDER BY month(transaction_date) ASC ) AS previous_month_of_total_sale,
(SUM(transaction_qty*unit_price)-LAG(SUM(transaction_qty*unit_price),1) OVER ( ORDER BY month(transaction_date) ASC )) AS month_on_month_difference_ofsale
FROM coffee_shop_sales_db.coffee_shop_sales
GROUP BY month(transaction_date), monthname(transaction_date)
order by month(transaction_date);



SELECT *
FROM coffee_shop_sales_db.coffee_shop_sales;


-- Calculateing total orders for each respective month--
SELECT 
monthname(transaction_date) AS month_name,
COUNT(transaction_id)As total_order
FROM coffee_shop_sales_db.coffee_shop_sales
GROUP BY monthname(transaction_date);

-- month-on-month increase or decrease in number of orders--
SELECT 
month(transaction_date) AS month_day,
monthname(transaction_date) AS month_name,
COUNT(transaction_id) AS curent_month_of_totale_orders,
LAG(COUNT(transaction_id),1) OVER (ORDER BY month(transaction_date)) AS previous_month_of_total_orders,
ROUND((COUNT(transaction_id)-LAG(COUNT(transaction_id),1) OVER (ORDER BY month(transaction_date)))/LAG(COUNT(transaction_id),1) OVER (ORDER BY month(transaction_date))*100,2)AS month_on_month_percentage_oforders
FROM coffee_shop_sales_db.coffee_shop_sales
GROUP BY month(transaction_date), monthname(transaction_date)
order by month(transaction_date);

-- difference in total numbers of  orders between current and previous month--
SELECT 
month(transaction_date) AS month_day,
monthname(transaction_date) AS month_name,
COUNT(transaction_id) AS curent_month_of_totale_orders,
LAG(COUNT(transaction_id),1) OVER (ORDER BY month(transaction_date)) AS previous_month_of_total_orders,
ROUND((COUNT(transaction_id)-LAG(COUNT(transaction_id),1) OVER (ORDER BY month(transaction_date))),2)AS month_on_month_difference_oforders
FROM coffee_shop_sales_db.coffee_shop_sales
GROUP BY month(transaction_date), monthname(transaction_date)
order by month(transaction_date);


-- Calculate total orders for each respective month--
SELECT 
monthname(transaction_date) AS month_name,
SUM(transaction_qty) AS total_quantity_sold
FROM coffee_shop_sales_db.coffee_shop_sales
GROUP BY monthname(transaction_date);

-- IN which month maximum amount of product was sold?--

SELECT 
monthname(transaction_date) AS month_name,
SUM(transaction_qty) AS total_quantity_sold
FROM coffee_shop_sales_db.coffee_shop_sales
GROUP BY monthname(transaction_date)
ORDER BY 2 DESC
LIMIT 1;

-- month-on-month increase or decrease in total quantity sold--
SELECT
month(transaction_date) AS month_day,
monthname(transaction_date) AS month_name,
SUM(transaction_qty) AS curent_month_of_totale_quantity_sold,
LAG(SUM(transaction_qty),1) OVER (ORDER BY month(transaction_date)) AS previous_month_of_totale_quantity_sold,
ROUND((SUM(transaction_qty)-LAG(SUM(transaction_qty),1) OVER (ORDER BY month(transaction_date)))/LAG(SUM(transaction_qty),1) OVER (ORDER BY month(transaction_date))*100,2) AS month_on_month_percentage_of_total_sold_quantity
FROM coffee_shop_sales_db.coffee_shop_sales
GROUP BY month(transaction_date), monthname(transaction_date)
order by month(transaction_date);

-- difference in total quantity sold numbers of  orders between current and previous month--
SELECT
month(transaction_date) AS month_day,
monthname(transaction_date) AS month_name,
SUM(transaction_qty) AS curent_month_of_totale_quantity_sold,
LAG(SUM(transaction_qty),1) OVER (ORDER BY month(transaction_date)) AS previous_month_of_totale_quantity_sold,
ROUND((SUM(transaction_qty)-LAG(SUM(transaction_qty),1) OVER (ORDER BY month(transaction_date))),2) AS month_on_month_difference_of_total_quantites
FROM coffee_shop_sales_db.coffee_shop_sales
GROUP BY month(transaction_date), monthname(transaction_date)
order by month(transaction_date);


-- Identifying top 10 products type in  term of total sales --
SELECT product_type, CONCAT(ROUND(SUM(transaction_qty*unit_price)/1000),'k')AS tota_sales
FROM  coffee_shop_sales_db.coffee_shop_sales
GROUP BY product_type
ORDER BY SUM(transaction_qty*unit_price) DESC
LIMIT 10;

-- Identifying top 5 products type in  term of total sales for may month --
SELECT product_type, CONCAT(ROUND(SUM(transaction_qty*unit_price)/1000),'k')AS tota_sales
FROM  coffee_shop_sales_db.coffee_shop_sales
WHERE month(transaction_date)=5
GROUP BY product_type
ORDER BY SUM(transaction_qty*unit_price) DESC
LIMIT 5;

-- Figering out top 3 product_type for each category of products--
-- getting the total sales for each product category--
WITH my_cte AS (
SELECT product_id,product_category,product_type,
SUM(transaction_qty*unit_price)AS total
FROM coffee_shop_sales_db.coffee_shop_sales
GROUP BY product_id, product_category,product_type
),

-- giving rank number for most sold  product type respective for each product category--

row_nums AS(
SELECT *,
ROW_NUMBER() OVER (PARTITION BY product_category ORDER BY total  DESC ) AS polular_items
FROM my_cte
)   

SELECT *
FROM row_nums 
WHERE polular_items<=3
ORDER BY polular_items;



-- Calculateing total sales,total count of ordersfor and total order quantity for  each respective day for each month--
SELECT
monthname( transaction_date)AS month_name,
transaction_date AS per_day,
ROUND(SUM(transaction_qty*unit_price),2) AS totat_sale,
COUNT(transaction_qty) AS total_order,
SUM(transaction_qty) AS total_quantity_of_orders
FROM coffee_shop_sales_db.coffee_shop_sales
GROUP BY monthname( transaction_date),transaction_date
ORDER BY transaction_date;

-- Calculateing total sales,total count of ordersfor and total order quantity for  each respective day for "MAY MONTH"--
SELECT
monthname( transaction_date)AS month_name,
transaction_date AS per_day,
ROUND(SUM(transaction_qty*unit_price),2) AS totat_sale,
COUNT(transaction_qty) AS total_order,
SUM(transaction_qty) AS total_quantity_of_orders
FROM coffee_shop_sales_db.coffee_shop_sales
WHERE MONTH( transaction_date)=5
GROUP BY monthname( transaction_date),transaction_date
ORDER BY transaction_date;

-- which day May month earn most--
SELECT
transaction_date AS earning_date,
CONCAT(ROUND(SUM(transaction_qty*unit_price)/1000,1),'k') AS highest_earning
FROM coffee_shop_sales_db.coffee_shop_sales
WHERE MONTH( transaction_date)=5
GROUP BY transaction_date
ORDER BY SUM(transaction_qty*unit_price) DESC
LIMIT 1;


-- which day May month earn less--
SELECT
transaction_date AS earning_date,
CONCAT(ROUND(SUM(transaction_qty*unit_price)/1000,1),'k') AS lowest_earning
FROM coffee_shop_sales_db.coffee_shop_sales
WHERE MONTH( transaction_date)=5
GROUP BY transaction_date
ORDER BY SUM(transaction_qty*unit_price) ASC
LIMIT 1;

-- What was the average earnings for whole MAY month--
WITH my_cte AS(
SELECT
transaction_date AS earning_date,
CONCAT(ROUND(SUM(transaction_qty*unit_price)/1000,1),'k') AS total_earning
FROM coffee_shop_sales_db.coffee_shop_sales
WHERE MONTH( transaction_date)=5
GROUP BY transaction_date
ORDER BY SUM(transaction_qty*unit_price) DESC
)
SELECT  CONCAT(ROUND(AVG(total_earning)),'k') AS may_average_sale
FROM my_cte;

-- Show Sales Status  Good or Bad only for April month--
WITH my_cte AS(
SELECT
DAY(transaction_date) AS earning_day,
SUM(transaction_qty*unit_price) AS total_sales,
AVG(SUM(transaction_qty*unit_price)) OVER () AS average_sale
FROM coffee_shop_sales_db.coffee_shop_sales
WHERE MONTH( transaction_date)=4
GROUP BY DAY(transaction_date)
)

SELECT earning_day,total_sales,
    CASE 
        WHEN total_sales > average_sale THEN 'Good'
        WHEN total_sales < average_sale THEN 'Bad'
        ELSE 'Average'
    END AS sales_status
    FROM my_cte
    ORDER BY earning_day;





-- Sales by weekday/weekend for each month--
SELECT
month(transaction_date) AS month_number,
monthname(transaction_date) AS name_of_month,
CASE 
WHEN dayofweek(transaction_date) IN (1,7) THEN 'weekend'
ELSE 'weekday'
END AS day_type,
ROUND(SUM(transaction_qty*unit_price))AS total_sales
FROM coffee_shop_sales_db.coffee_shop_sales
GROUP BY 
month(transaction_date),monthname(transaction_date),
CASE 
WHEN dayofweek(transaction_date) IN (1,7) THEN 'weekend'
ELSE 'weekday'
END
ORDER BY month_number;


-- Sales by weekday/weekend for June month--
SELECT
monthname(transaction_date) AS name_of_month,
CASE 
WHEN dayofweek(transaction_date) IN (1,7) THEN 'weekend'
ELSE 'weekday'
END AS day_type,
ROUND(SUM(transaction_qty*unit_price))AS total_sales
FROM coffee_shop_sales_db.coffee_shop_sales
WHERE MONTH(transaction_date)=6-- filter for JUNE month--
GROUP BY 
monthname(transaction_date),
CASE 
WHEN dayofweek(transaction_date) IN (1,7) THEN 'weekend'
ELSE 'weekday'
END;

-- In which month weekend's products got most sale -- 
WITH my_cte AS(
SELECT
month(transaction_date) AS month_number,
monthname(transaction_date) AS name_of_month,
CASE 
WHEN dayofweek(transaction_date) IN (1,7) THEN 'weekend'
ELSE 'weekday'
END AS day_type,
ROUND(SUM(transaction_qty*unit_price))AS total_sales
FROM coffee_shop_sales_db.coffee_shop_sales
GROUP BY 
month(transaction_date),monthname(transaction_date),
CASE 
WHEN dayofweek(transaction_date) IN (1,7) THEN 'weekend'
ELSE 'weekday'
END
ORDER BY total_sales)
SELECT *
FROM my_cte
WHERE day_type='weekend'
ORDER BY total_sales DESC
LIMIT 1;


-- Sales by weekday/weekend for each month--
SELECT
month(transaction_date) AS month_number,
monthname(transaction_date) AS name_of_month,
CASE 
WHEN dayofweek(transaction_date) IN (1,7) THEN 'weekend'
ELSE 'weekday'
END AS day_type,
ROUND(SUM(transaction_qty*unit_price))AS total_sales
FROM coffee_shop_sales_db.coffee_shop_sales
GROUP BY 
month(transaction_date),monthname(transaction_date),
CASE 
WHEN dayofweek(transaction_date) IN (1,7) THEN 'weekend'
ELSE 'weekday'
END
ORDER BY month_number;


-- Sales by weekday/weekend for June month--
SELECT
monthname(transaction_date) AS name_of_month,
CASE 
WHEN dayofweek(transaction_date) IN (1,7) THEN 'weekend'
ELSE 'weekday'
END AS day_type,
ROUND(SUM(transaction_qty*unit_price))AS total_sales
FROM coffee_shop_sales_db.coffee_shop_sales
WHERE MONTH(transaction_date)=6-- filter for JUNE month--
GROUP BY 
monthname(transaction_date),
CASE 
WHEN dayofweek(transaction_date) IN (1,7) THEN 'weekend'
ELSE 'weekday'
END;

-- In which month weekend's products got most sale -- 
WITH my_cte AS(
SELECT
month(transaction_date) AS month_number,
monthname(transaction_date) AS name_of_month,
CASE 
WHEN dayofweek(transaction_date) IN (1,7) THEN 'weekend'
ELSE 'weekday'
END AS day_type,
ROUND(SUM(transaction_qty*unit_price))AS total_sales
FROM coffee_shop_sales_db.coffee_shop_sales
GROUP BY 
month(transaction_date),monthname(transaction_date),
CASE 
WHEN dayofweek(transaction_date) IN (1,7) THEN 'weekend'
ELSE 'weekday'
END
ORDER BY total_sales)
SELECT *
FROM my_cte
WHERE day_type='weekend'
ORDER BY total_sales DESC
LIMIT 1;


-- finding out total sales for each store location and wh--
SELECT 
store_location,
ROUND(SUM(transaction_qty*unit_price))AS total_sales
FROM coffee_shop_sales_db.coffee_shop_sales
GROUP BY store_location
ORDER BY total_sales DESC;

-- Finding out top two stores location  based on highest amount of sale for January and April month--
WITH my_cte AS( SELECT 
store_location,monthname(transaction_date) AS month_name,MONTH(transaction_date),
 ROUND(SUM(transaction_qty*unit_price)) AS total_sales
 FROM coffee_shop_sales_db.coffee_shop_sales
 GROUP BY store_location, MONTH(transaction_date),monthname(transaction_date)
 ORDER BY MONTH(transaction_date)
 ),
 my_ctee AS (
 SELECT *, row_number()OVER(PARTITION BY month_name ORDER BY total_sales DESC) AS sales_rank
 FROM my_cte)
 SELECT sales_rank,month_name,store_location,total_sales
 FROM  my_ctee
 WHERE sales_rank<=2 AND month_name IN ('January','February')
 ORDER BY month_name DESC;

-- Figering out by weekly below and above of average sales status for each store location only for April month --
WITH my_cte AS (
SELECT 
store_location,
week(transaction_date) AS week_number,
SUM(transaction_qty*unit_price) AS current_week_sales,
LAG(SUM(transaction_qty*unit_price),1) OVER (ORDER BY week(transaction_date)ASC) AS previous_week_sales,
AVG(SUM(transaction_qty*unit_price)) OVER (PARTITION BY store_location ) AS average_sales_for_each_store,
ROUND((SUM(transaction_qty*unit_price)-LAG(SUM(transaction_qty*unit_price),1) OVER (ORDER BY week(transaction_date) ASC)) /LAG(SUM(transaction_qty*unit_price),1) OVER (ORDER BY week(transaction_date) ASC) *100 )AS by_weekly_percentof_sales
FROM coffee_shop_sales_db.coffee_shop_sales
WHERE monthname(transaction_date)='April'
GROUP BY store_location,week(transaction_date) 
)
SELECT *,
CASE 
WHEN current_week_sales>average_sales_for_each_store THEN 'above_average' 
WHEN current_week_sales<average_sales_for_each_store THEN 'below_average' 
ELSE 'Average'
END AS sales_status
FROM my_cte ;


-- AVG(SUM(transaction_qty*unit_price) ) OVER (PARTITION BY store_location,week(transaction_date) ORDER BY week(transaction_date) ASC) AS avg_sales--

 -- Analyzing sales performance acrooss different product categories till now--
SELECT *
FROM coffee_shop_sales_db.coffee_shop_sales;
with my_cte AS 
(SELECT product_category,ROUND(SUM(transaction_qty*unit_price))AS total_sales, ROUND(AVG(SUM(transaction_qty*unit_price)) OVER ()) AS average_price
FROM coffee_shop_sales_db.coffee_shop_sales
GROUP BY product_category)

SELECT product_category,total_sales,
CASE 
WHEN total_sales>average_price THEN 'popular_product'
WHEN total_sales<average_price THEN 'less_popular_product'
ELSE 'average_demand'
END AS sales_performance
FROM my_cte
GROUP BY product_category;

SELECT*
FROM coffee_shop_sales_db.coffee_shop_sales;
-- Figering out  daily  total_sales,total_orders,Total_quantity per hour for April month --
SELECT 
transaction_date,HOUR(transaction_time) AS hour_of_day,
ROUND(SUM(transaction_qty*unit_price),2) AS totat_sales,
COUNT(transaction_qty) AS total_order,
SUM(transaction_qty) AS total_quantity_of_orders
FROM  coffee_shop_sales_db.coffee_shop_sales
WHERE MONTH(transaction_date)=4
GROUP BY transaction_date,HOUR(transaction_time)
ORDER BY transaction_date;

-- calculating  total sales from Monday to Sunday for  month of MAY--
SELECT DAYNAME(transaction_date) AS week_name,ROUND(SUM(transaction_qty*unit_price)) AS totat_sales
FROM coffee_shop_sales_db.coffee_shop_sales
WHERE month(transaction_date) = 5
GROUP BY DAYNAME(transaction_date),weekday(transaction_date)
ORDER BY weekday(transaction_date);






































