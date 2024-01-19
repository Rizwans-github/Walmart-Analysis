
CREATE DATABASE walmart;
USE walmart;

CREATE TABLE walmart_data(
  Invoice_ID         INT(10)  NOT NULL PRIMARY KEY ,
  Branch                    VARCHAR(1) NOT NULL,
  City                      VARCHAR(9) NOT NULL,
  Customer_type           VARCHAR(6) NOT NULL,
  Gender                    VARCHAR(6) NOT NULL,
  Product_line            VARCHAR(22) NOT NULL,
  Unit_price              NUMERIC(5,2) NOT NULL,
  Quantity                  INTEGER  NOT NULL,
  Tax                   NUMERIC(7,4) NOT NULL,
  Total                     NUMERIC(8,4) NOT NULL,
  Date                      DATE  NOT NULL,
  Time                      VARCHAR(8) NOT NULL,
  Payment                   VARCHAR(11) NOT NULL,
  cogs                      NUMERIC(6,2) NOT NULL,
  gross_margin_percentage NUMERIC(11,9) NOT NULL,
  gross_income            NUMERIC(7,4) NOT NULL,
  Rating                    NUMERIC(3,1) NOT NULL
);


LOAD DATA LOCAL INFILE "C:/Users/Mohd Rizwan/Downloads/WalmartSalesData.csv"
INTO TABLE walmart_data
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

ALTER TABLE walmart_data 
ADD COLUMN time_of_day VARCHAR(20);

UPDATE walmart_data
SET time_of_day = (
  CASE
        WHEN Time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN Time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
  END
);

SELECT *
FROM walmart_data
LIMIT 5;


ALTER TABLE walmart_data
ADD COLUMN day_name VARCHAR(10);

UPDATE walmart_data
SET day_name = DAYNAME(date);

ALTER TABLE walmart_data
ADD COLUMN month_name VARCHAR(15);

UPDATE walmart_data
SET month_name = MONTHNAME(date);

SELECT 
  DISTINCT City
FROM walmart_data;

SELECT
  DISTINCT City,
  Branch
FROM walmart_data;

SELECT 
  COUNT(DISTINCT Product_line)
FROM walmart_data;

SELECT 
  payment, 
  COUNT (Payment) AS Most_used
FROM walmart_data
GROUP BY payment
ORDER BY Most_used DESC;

SELECT 
  Product_line, 
  COUNT(Product_line) AS CNT
FROM walmart_data
GROUP BY Product_line
ORDER BY CNT DESC;  

SELECT
  month_name,
  SUM(Total) AS Revenue
FROM walmart_data
GROUP BY month_name
ORDER BY Revenue DESC;

SELECT
  month_name,
  SUM(cogs) AS COG
FROM walmart_data
GROUP BY month_name
ORDER BY COG DESC;

SELECT 
  Product_line,
  ROUND(SUM(Total), 2) AS Revenue
FROM walmart_data
GROUP BY Product_line
ORDER BY Revenue DESC;


SELECT
  City,
  ROUND(SUM(Total), 2) AS Revenue
FROM walmart_data
GROUP BY City
ORDER BY Revenue DESC;

SELECT
  Product_line,
  ROUND(AVG(Tax), 2) AS VAT
FROM walmart_data
GROUP BY Product_line
ORDER BY VAT DESC;

SELECT 
  Branch,
  SUM(Quantity) As QTY
FROM walmart_data
GROUP BY Branch
HAVING SUM(Quantity) > (SELECT AVG(Quantity) FROM walmart_data);

SELECT
  Gender,
  Product_line,
  COUNT(Gender) AS CNT
FROM walmart_data
GROUP BY Product_line, Gender
ORDER BY CNT DESC;

SELECT
  Product_line,
  ROUND(AVG(Rating),  2)
FROM walmart_data
GROUP BY Product_line
ORDER BY AVG(Rating) DESC;

SELECT 
  Product_line,
  ROUND(SUM(Total), 2) AS Total_Revenue,
  ROUND(AVG(gross_margin_percentage), 2) AS Avg_Gross_Margin_Percentage
FROM walmart_data
GROUP BY Product_line
ORDER BY Total_Revenue DESC;

SELECT 
  Branch, 
  Customer_type, 
  COUNT(*) AS Transaction_Count, 
  MIN(Quantity) AS Min_Quantity, 
  MAX(Quantity) AS Max_Quantity, 
  ROUND(AVG(Quantity), 2) AS Avg_Quantity
FROM walmart_data
GROUP BY Branch, Customer_type
ORDER BY Transaction_Count DESC;

SELECT 
  time_of_day,
  COUNT(*) AS Total_Sales
FROM walmart_data
GROUP BY time_of_day
ORDER BY Total_Sales Desc;

SELECT 
  Customer_type,
  ROUND(SUM(Total), 2) AS Total_Rev 
FROM walmart_data
GROUP BY Customer_type
ORDER BY Total_Rev DESC;



/*
Today I got so many errors my sql not showing up in the CLI(command prompt)
so had to go into enviroment variables of my pc to set it up coding is fun :)
PS: am not crying
*/

SELECT 
  City, 
  ROUND(AVG(Tax), 2) AS Avg_Tax
FROM walmart_data
GROUP BY City
ORDER BY Avg_Tax DESC;


SELECT 
  Customer_type, 
  ROUND(AVG(Tax), 2) AS Avg_Tax
FROM walmart_data
GROUP BY Customer_type
ORDER BY Avg_Tax DESC;

SELECT 
  DISTINCT Customer_type
FROM walmart_data;

SELECT 
  DISTINCT Payment
FROM walmart_data;

SELECT 
  Customer_type,
  COUNT(*) AS CUST
FROM walmart_data
GROUP BY Customer_type
ORDER BY CUST DESC;

SELECT 
  Gender,
  COUNT(*) AS CUST
FROM walmart_data
GROUP BY Gender
ORDER BY CUST DESC;

SELECT 
  Branch, Gender, 
  COUNT(*) AS CNT
FROM walmart_data
GROUP BY Branch, Gender
ORDER BY Branch, CNT DESC;

SELECT
  time_of_day, 
  ROUND(AVG(Rating), 2) AS Rtngs
FROM walmart_data
GROUP BY time_of_day;

SELECT
  day_name, 
  ROUND(AVG(Rating), 2) AS Rtngs
FROM walmart_data
GROUP BY day_name
ORDER BY Rtngs DESC;

SELECT
  Branch,
  day_name, 
  ROUND(AVG(Rating), 2) AS Rtngs
FROM walmart_data
GROUP BY Branch, day_name
ORDER BY Branch, Rtngs DESC;

/*
With this am almost done with this project and this was made possible by Code With Prince, the project was meant to be a guide for me so took a look at the video for the questions that needed to get answered for the analysis and whenever I felt stuck, I referred to the videos links in the read me file will be added.
*/

