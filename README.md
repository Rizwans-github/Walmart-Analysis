```MySQL
-- Here I am creating the 'walmart' database to store sales data.
CREATE DATABASE walmart;

-- Switching to the 'walmart' database.
USE walmart;

-- Now am defining the structure of the 'walmart_data' table.
CREATE TABLE walmart_data(
  Invoice_ID         INT(10)  NOT NULL PRIMARY KEY , -- Unique identifier for each invoice.
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

/* The below query wasn't working because VS CODE didn't have the permission
it wasn't even working in MySQL workbench due to [ERROR 3948 (42000), ERROR 2068 (HY000)]
and on the hunt for the reasons I was able to resolve it with the help of StackOverflow
(https://stackoverflow.com/questions/59993844/error-loading-local-data-is-disabled-this-must-be-enabled-on-both-the-client,
https://stackoverflow.com/questions/63361962/error-2068-hy000-load-data-local-infile-file-request-rejected-due-to-restrict)
LOAD DATA LOCAL INFILE "C:/Users/Mohd Rizwan/Downloads/Walmartwalmart_dataData.csv"
INTO TABLE walmart_data
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';
These restrictions can be removed from MySQL Workbench 8.0 in the following ways.
First run SET GLOBAL local_infile=1; query and Edit the connection, on the Connection tab, 
go to the 'Advanced' sub-tab, and in the 'Others:' box add the line 'OPT_LOCAL_INFILE=1'.
*/
-- Loading sales data from a CSV file into the 'walmart_data' table.
LOAD DATA LOCAL INFILE "C:/Users/Mohd Rizwan/Downloads/WalmartSalesData.csv"
INTO TABLE walmart_data
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

--Ran the first test query to look at all my data
SELECT *
FROM walmart_data
LIMIT 5;
```
![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/ba6d3c58-2a59-49cb-969b-82558222b201)


```MySQL
SELECT * 
FROM walmart_data
LIMIT 10;
```

![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/0d175f59-4362-4d9d-921b-91eb64763b60)
```MySQL
SELECT *
FROM walmart_data
WHERE (Branch = "A") & (Quantity < 5) & (Unit_price > 60)
LIMIT 5;


```
![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/6d940aa6-cce1-4476-acc6-b0dbe9930447)
```MySQL
-- Updating the 'walmart_data' table with a new column 'time_of_day' based on time ranges.
UPDATE walmart_data
SET time_of_day = (
  CASE
    WHEN Time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
    WHEN Time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
    ELSE "Evening"
  END
);

-- Adding new columns for 'day_name' and 'month_name' to enhance analysis.
ALTER TABLE walmart_data
ADD COLUMN day_name VARCHAR(10);

UPDATE walmart_data
SET day_name = DAYNAME(date);

ALTER TABLE walmart_data
ADD COLUMN month_name VARCHAR(15);

UPDATE walmart_data
SET month_name = MONTHNAME(date);-- Selecting distinct cities from the 'walmart_data' table.
SELECT DISTINCT City
FROM walmart_data;

-- Selecting distinct cities along with branches.
SELECT DISTINCT City, Branch
FROM walmart_data;

```
![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/fd95258a-253c-46dc-bc7e-58a5180bcef4)
```
```MySQL
-- Selecting distinct cities along with branches.
SELECT DISTINCT City, Branch
FROM walmart_data;
```
![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/c5e19878-2268-42c8-9f9f-d7bbbaa54c40)

```MySQL
-- Counting the number of distinct product lines in the dataset.
SELECT COUNT(DISTINCT Product_line)
FROM walmart_data;
```
![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/a4e77257-c337-4c4d-864d-85904487b6ac)
```MySQL
-- Analyzing the most used payment methods and their occurrences.
SELECT payment, COUNT(Payment) AS Most_used
FROM walmart_data
GROUP BY payment
ORDER BY Most_used DESC;
```
![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/1b064f1d-a74c-4729-81ea-c99e02ca28a0)

```MySQL
-- Counting occurrences of each product line.
SELECT Product_line, COUNT(Product_line) AS CNT
FROM walmart_data
GROUP BY Product_line
ORDER BY CNT DESC;
```
![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/b73f1a2d-67a7-4081-945d-3573cca312c9)

```MySQL
-- Total revenue for each month.
SELECT month_name, SUM(Total) AS Revenue
FROM walmart_data
GROUP BY month_name
ORDER BY Revenue DESC;
```
![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/5d5922d9-cb57-4d0f-a385-cbd38d67c933)



```MySQL
-- Cost of Goods Sold (COGS) for each month.
SELECT month_name, SUM(cogs) AS COG
FROM walmart_data
GROUP BY month_name
ORDER BY COG DESC;
```

![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/74cf84ad-6ed0-4df7-b1ef-7b347c70fb16)
```MySQL
-- Revenue for each product line.
SELECT Product_line, ROUND(SUM(Total), 2) AS Revenue
FROM walmart_data
GROUP BY Product_line
ORDER BY Revenue DESC;
```
![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/96871071-3704-4f7a-af27-764f51d94844)

```MySQL
-- Revenue for each city.
SELECT City, ROUND(SUM(Total), 2) AS Revenue
FROM walmart_data
GROUP BY City
ORDER BY Revenue DESC;
```
![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/228657db-af77-4ced-86d1-aeef65617833)
```MySQL
-- Average Tax (VAT) for each product line.
SELECT Product_line, ROUND(AVG(Tax), 2) AS VAT
FROM walmart_data
GROUP BY Product_line
ORDER BY VAT DESC;
```
![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/93cdf5fd-72aa-4feb-bcbe-d6145c3d0f30)
```MySQL
-- Quantity sold for each branch (above average).
SELECT Branch, SUM(Quantity) AS QTY
FROM walmart_data
GROUP BY Branch
HAVING SUM(Quantity) > (SELECT AVG(Quantity) FROM walmart_data);
```
![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/50ccdd0a-b2a2-4856-9902-e0a03f2d7d52)
```MySQL
-- Count of transactions by gender and product line.
SELECT Gender, Product_line, COUNT(Gender) AS CNT
FROM walmart_data
GROUP BY Product_line, Gender
ORDER BY CNT DESC;
```
![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/04647830-f249-4f52-969e-11b5990eb7c2)
```MySQL
-- Average rating for each product line.
SELECT Product_line, ROUND(AVG(Rating),  2)
FROM walmart_data
GROUP BY Product_line
ORDER BY AVG(Rating) DESC;
```
![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/6b566b9d-3d8f-43d3-87bf-52d7bf94b9d8)
```MySQL
-- Total revenue, average gross margin percentage for each product line.
SELECT Product_line, 
  ROUND(SUM(Total), 2) AS Total_Revenue,
  ROUND(AVG(gross_margin_percentage), 2) AS Avg_Gross_Margin_Percentage
FROM walmart_data
GROUP BY Product_line
ORDER BY Total_Revenue DESC;
```
![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/1c42c774-00f6-4c9b-8af3-54d0d647ba45)
```MySQL
-- Transaction details by branch and customer type.
SELECT Branch, Customer_type, 
  COUNT(*) AS Transaction_Count,
  MIN(Quantity) AS Min_Quantity,
  MAX(Quantity) AS Max_Quantity,
  ROUND(AVG(Quantity), 2) AS Avg_Quantity
FROM walmart_data
GROUP BY Branch, Customer_type
ORDER BY Transaction_Count DESC;

-- Total sales count for each time of day.
SELECT time_of_day, COUNT(*) AS Total_Sales
FROM walmart_data
GROUP BY time_of_day
ORDER BY Total_Sales DESC;

-- Total revenue for each customer type.
SELECT Customer_type, ROUND(SUM(Total), 2) AS Total_Rev 
FROM walmart_data
GROUP BY Customer_type
ORDER BY Total_Rev DESC;

/*
Today I got so many errors MySQL not showing up in the CLI(command prompt)
so had to go into environment variables of my pc to set it up by adding the bin file
in the environment itself which helped in showing MySQL in CLI.
After this, I was able to import data into SQL without the help of
MySQL workbench.
Coding is fun :)
PS: am not crying
*/


-- Average tax for each city.
SELECT City, ROUND(AVG(Tax), 2) AS Avg_Tax
FROM walmart_data
GROUP BY City
ORDER BY Avg_Tax DESC;

-- Average tax for each customer type.
SELECT Customer_type, ROUND(AVG(Tax), 2) AS Avg_Tax
FROM walmart_data
GROUP BY Customer_type
ORDER BY Avg_Tax DESC;

-- Distinct customer types.
SELECT DISTINCT Customer_type
FROM walmart_data;

-- Distinct payment methods.
SELECT DISTINCT Payment
FROM walmart_data;

-- Count of transactions for each customer type.
SELECT Customer_type, COUNT(*) AS CUST
FROM walmart_data
GROUP BY Customer_type
ORDER BY CUST DESC;

-- Count of transactions for each gender.
SELECT Gender, COUNT(*) AS CUST
FROM walmart_data
GROUP BY Gender
ORDER BY CUST DESC;

-- Count of transactions by branch and gender.
SELECT Branch, Gender, COUNT(*) AS CNT
FROM walmart_data
GROUP BY Branch, Gender
ORDER BY Branch, CNT DESC;

-- Average ratings for each time of day.
SELECT time_of_day, ROUND(AVG(Rating), 2) AS Rtngs
FROM walmart_data
GROUP BY time_of_day;

-- Average ratings for each day of the week.
SELECT day_name, ROUND(AVG(Rating), 2) AS Rtngs
FROM walmart_data
GROUP BY day_name
ORDER BY Rtngs DESC;

-- Average ratings by branch and day of the week.
SELECT Branch, day_name, ROUND(AVG(Rating), 2) AS Rtngs
FROM walmart_data
GROUP BY Branch, day_name
ORDER BY Branch, Rtngs DESC;


/*
With this am almost done with this project and this was made possible by Code With Prince,
the project was meant to be a guide for me so took a look at the video for the questions
that needed to be answered for the analysis and whenever I felt stuck,
so I referred to the video and links in the read-me file to be added soon.
*/
```
