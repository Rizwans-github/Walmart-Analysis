-- Creating a database named "walmart"
CREATE DATABASE walmart;
-- Switching to the "walmart" database
USE walmart;

-- Creating a table to store Walmart transaction data
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

-- Importing data from a CSV file into the "walmart_data" table
-- (Note: Set global local_infile=1; and OPT_LOCAL_INFILE=1 in MySQL Workbench connection settings)
LOAD DATA LOCAL INFILE "C:/Users/Mohd Rizwan/Downloads/Walmartwalmart_dataData.csv"
INTO TABLE walmart_data
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

-- Viewing the first 5 rows of the "walmart_data" table
SELECT *
FROM walmart_data
LIMIT 5;

-- Adding a new column "time_of_day" to classify transactions into Morning, Afternoon, or Evening
ALTER TABLE walmart_data 
ADD COLUMN time_of_day VARCHAR(20);

-- Updating the "time_of_day" column based on the time of the transaction
UPDATE walmart_data
SET time_of_day = (
  CASE
        WHEN Time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN Time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
  END
);

-- Adding a new column "day_name" to store the day of the week for each transaction
ALTER TABLE walmart_data
ADD COLUMN day_name VARCHAR(10);

-- Updating the "day_name" column with the day of the week for each transaction
UPDATE walmart_data
SET day_name = DAYNAME(date);

-- Adding a new column "month_name" to store the month name for each transaction
ALTER TABLE walmart_data
ADD COLUMN month_name VARCHAR(15);

-- Updating the "month_name" column with the month name for each transaction
UPDATE walmart_data
SET month_name = MONTHNAME(date);

-- Querying for unique cities in the dataset
SELECT DISTINCT City
FROM walmart_data;

-- Querying for the unique combinations of city and branch in the dataset
SELECT DISTINCT City, Branch
FROM walmart_data;

-- Querying the count of distinct product lines in the dataset
SELECT COUNT(DISTINCT Product_line)
FROM walmart_data;

-- Querying for the most used payment method and its count
SELECT payment, COUNT (Payment) AS Most_used
FROM walmart_data
GROUP BY payment
ORDER BY Most_used DESC;

-- Querying the count of each product line in the dataset
SELECT Product_line, COUNT(Product_line) AS CNT
FROM walmart_data
GROUP BY Product_line
ORDER BY CNT DESC;  

-- Querying total revenue per month in descending order
SELECT month_name, SUM(Total) AS Revenue
FROM walmart_data
GROUP BY month_name
ORDER BY Revenue DESC;

-- Querying COG (Cost of Goods Sold) per month in descending order
SELECT month_name, SUM(cogs) AS COG
FROM walmart_data
GROUP BY month_name
ORDER BY COG DESC;

-- Querying total revenue per product line in descending order
SELECT Product_line, ROUND(SUM(Total), 2) AS Revenue
FROM walmart_data
GROUP BY Product_line
ORDER BY Revenue DESC;

-- Querying total revenue per city in descending order
SELECT City, ROUND(SUM(Total), 2) AS Revenue
FROM walmart_data
GROUP BY City
ORDER BY Revenue DESC;

-- Querying average VAT (Value Added Tax) per product line in descending order
SELECT Product_line, ROUND(AVG(Tax), 2) AS VAT
FROM walmart_data
GROUP BY Product_line
ORDER BY VAT DESC;

-- Querying total quantity sold per branch where quantity is above the average quantity
SELECT Branch, SUM(Quantity) As QTY
FROM walmart_data
GROUP BY Branch
HAVING SUM(Quantity) > (SELECT AVG(Quantity) FROM walmart_data);

-- Querying the count of each gender for each product line in descending order
SELECT Gender, Product_line, COUNT(Gender) AS CNT
FROM walmart_data
GROUP BY Product_line, Gender
ORDER BY CNT DESC;

-- Querying average customer rating per product line in descending order
SELECT Product_line, ROUND(AVG(Rating),  2)
FROM walmart_data
GROUP BY Product_line
ORDER BY AVG(Rating) DESC;


-- Querying total revenue and gross margin percentage per product line
SELECT Product_line, ROUND(SUM(Total), 2) AS Total_Revenue, ROUND(AVG(gross_margin_percentage), 2) AS Avg_Gross_Margin_Percentage
FROM walmart_data
GROUP BY Product_line
ORDER BY Total_Revenue DESC;

-- Analyzing the distribution of quantities sold per branch and customer type
SELECT Branch, Customer_type, COUNT(*) AS Transaction_Count, MIN(Quantity) AS Min_Quantity, MAX(Quantity) AS Max_Quantity, ROUND(AVG(Quantity), 2) AS Avg_Quantity
FROM walmart_data
GROUP BY Branch, Customer_type
ORDER BY Transaction_Count DESC;
