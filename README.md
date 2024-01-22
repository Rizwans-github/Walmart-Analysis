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
![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/44efe9e6-c7e3-4dd7-9b95-e42d69d410e0)

```MySQL
-- Analyzing the most used payment methods and their occurrences.
SELECT payment, COUNT(Payment) AS Most_used
FROM walmart_data
GROUP BY payment
ORDER BY Most_used DESC;
```
![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/a0bef0f1-4f61-4431-86e6-e5ffef96af56)


```MySQL
-- Counting occurrences of each product line.
SELECT Product_line, COUNT(Product_line) AS CNT
FROM walmart_data
GROUP BY Product_line
ORDER BY CNT DESC;
```
![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/e5c55a08-40e5-4ef3-9dcd-b867363a56cf)


```MySQL
-- Total revenue for each month.
SELECT month_name, SUM(Total) AS Revenue
FROM walmart_data
GROUP BY month_name
ORDER BY Revenue DESC;
```
![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/7e7696de-f2e3-4aa4-8a92-ed4f86ca05a5)



```MySQL
-- Cost of Goods Sold (COGS) for each month.
SELECT month_name, SUM(cogs) AS COG
FROM walmart_data
GROUP BY month_name
ORDER BY COG DESC;
```
![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/039562bf-2e56-4699-8b24-efe98212049b)
```MySQL
-- Revenue for each product line.
SELECT Product_line, ROUND(SUM(Total), 2) AS Revenue
FROM walmart_data
GROUP BY Product_line
ORDER BY Revenue DESC;

```
![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/df01269c-a021-4d2e-9db1-8b2cd19fd165)

```MySQL
-- Revenue for each city.
SELECT City, ROUND(SUM(Total), 2) AS Revenue
FROM walmart_data
GROUP BY City
ORDER BY Revenue DESC;
```
![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/3b93d522-93ea-4f65-b1c3-001a3566205f)

```MySQL
-- Average Tax (VAT) for each product line.
SELECT Product_line, ROUND(AVG(Tax), 2) AS VAT
FROM walmart_data
GROUP BY Product_line
ORDER BY VAT DESC;
```

![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/bf139304-0391-42ce-a3e4-5a980aa33163)


```MySQL
-- Quantity sold for each branch (above average).
SELECT Branch, SUM(Quantity) AS QTY
FROM walmart_data
GROUP BY Branch
HAVING SUM(Quantity) > (SELECT AVG(Quantity) FROM walmart_data);
```
![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/a9b5c4fa-1c90-430f-9195-27a3170a28ad)


```MySQL
-- Count of transactions by gender and product line.
SELECT Gender, Product_line, COUNT(Gender) AS CNT
FROM walmart_data
GROUP BY Product_line, Gender
ORDER BY CNT DESC;
```

![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/da021a3b-99b0-4674-a5e6-32365a7c187f)

```MySQL
-- Average rating for each product line.
SELECT Product_line, ROUND(AVG(Rating),  2)
FROM walmart_data
GROUP BY Product_line
ORDER BY AVG(Rating) DESC;
```
![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/c4b717aa-bd58-4f20-8f02-66eba223eca0)

```MySQL
-- Total revenue, average gross margin percentage for each product line.
SELECT Product_line, 
  ROUND(SUM(Total), 2) AS Total_Revenue,
  ROUND(AVG(gross_margin_percentage), 2) AS Avg_Gross_Margin_Percentage
FROM walmart_data
GROUP BY Product_line
ORDER BY Total_Revenue DESC;
```

![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/a69c0989-faa9-43de-967a-d146126d287e)

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
```

![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/419a4717-b688-4379-8c8b-9df79709daaa)
```MySQL
-- Total sales count for each time of day.
SELECT time_of_day, COUNT(*) AS Total_Sales
FROM walmart_data
GROUP BY time_of_day
ORDER BY Total_Sales DESC;
```
![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/39309f03-ff11-4fec-8d05-4575eb612ea9)
```MySQL
-- Total revenue for each customer type.
SELECT Customer_type, ROUND(SUM(Total), 2) AS Total_Rev 
FROM walmart_data
GROUP BY Customer_type
ORDER BY Total_Rev DESC;
```
![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/16db44a1-9f20-4c4b-a237-3b1a88922bf6)
```MySQL
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
```

![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/2f33d06d-7d92-4fa8-b65d-79975f2ad805)


```MySQL
-- Average tax for each customer type.
SELECT Customer_type, ROUND(AVG(Tax), 2) AS Avg_Tax
FROM walmart_data
GROUP BY Customer_type
ORDER BY Avg_Tax DESC;
```

![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/9d5218eb-0760-4e59-809a-d22919fe1c36)


```MySQL
-- Distinct customer types.
SELECT DISTINCT Customer_type
FROM walmart_data;
```

![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/6f000cab-3ed9-4f94-a310-9d2f0b109efe)


```MySQL
-- Distinct payment methods.
SELECT DISTINCT Payment
FROM walmart_data;
```
![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/b28cbdc5-1bff-40e5-a69f-60542fe03678)


```MySQL
-- Count of transactions for each customer type.
SELECT Customer_type, COUNT(*) AS CUST
FROM walmart_data
GROUP BY Customer_type
ORDER BY CUST DESC;
```

![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/e6c2a5f1-5294-4e40-a37d-de6af6b83d57)

```MySQL
-- Count of transactions for each gender.
SELECT Gender, COUNT(*) AS CUST
FROM walmart_data
GROUP BY Gender
ORDER BY CUST DESC;
```
![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/6ed23026-f752-437d-940c-34dbccaa20c6)


```MySQL
-- Count of transactions by branch and gender.
SELECT Branch, Gender, COUNT(*) AS CNT
FROM walmart_data
GROUP BY Branch, Gender
ORDER BY Branch, CNT DESC;
```

![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/93ea5557-a68f-4263-9d90-93f7530a101e)


```MySQL
-- Average ratings for each time of day.
SELECT time_of_day, ROUND(AVG(Rating), 2) AS Rtngs
FROM walmart_data
GROUP BY time_of_day;
```

![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/5378f45d-d0d4-445b-8fd2-9a4f84330872)

```MySQL
-- Average ratings for each day of the week.
SELECT day_name, ROUND(AVG(Rating), 2) AS Rtngs
FROM walmart_data
GROUP BY day_name
ORDER BY Rtngs DESC;
```
![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/474ccd44-b408-4553-ab84-f00d83f2e751)


```MySQL
-- Average ratings by branch and day of the week.
SELECT Branch, day_name, ROUND(AVG(Rating), 2) AS Rtngs
FROM walmart_data
GROUP BY Branch, day_name
ORDER BY Branch, Rtngs DESC;
```
![image](https://github.com/Rizwans-github/Walmart-Analysis/assets/141806496/dea20451-430a-48cc-a288-84ed5f5d82f9)


```MySQL
/*
With this am almost done with this project and this was made possible by Code With Prince,
the project was meant to be a guide for me so took a look at the video for the questions
that needed to be answered for the analysis and whenever I felt stuck,
so I referred to the video and links in the read-me file to be added soon.
*/
```
