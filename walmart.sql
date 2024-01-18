
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

DROP TABLE walmart_data;

SET GLOBAL local_infile=1;

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

ALTER TABLE walmart_data
ADD COLUMN day_name VARCHAR(10);

UPDATE walmart_data
SET day_name = DAYNAME(date);

ALTER TABLE walmart_data
ADD COLUMN month_name VARCHAR(15);

UPDATE walmart_data
SET month_name = MONTHNAME(date);

SELECT DISTINCT City
FROM walmart_data;

SELECT DISTINCT City, Branch
FROM walmart_data;

SELECT COUNT(DISTINCT Product_line)
FROM walmart_data;

SELECT payment, COUNT (Payment) AS Most_used
FROM walmart_data
GROUP BY payment
ORDER BY Most_used DESC;

SELECT Product_line, COUNT(Product_line) AS CNT
FROM walmart_data
GROUP BY Product_line
ORDER BY CNT DESC;  

SELECT month_name, SUM(Total) AS Revenue
FROM walmart_data
GROUP BY month_name
ORDER BY Revenue DESC;

SELECT month_name, SUM(cogs) AS COG
FROM walmart_data
GROUP BY month_name
ORDER BY COG DESC;

SELECT Product_line, ROUND(SUM(Total), 2) AS Revenue
FROM walmart_data
GROUP BY Product_line
ORDER BY Revenue DESC;
