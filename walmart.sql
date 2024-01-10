--creating a database to use:
CREATE DATABASE walmart;
USE walmart;

--creating a table to import data:
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

--Importing data from a csv file from kaggle:

/* The below query wasn't working because VS CODE isn't given the permissions
it wasn't even working in MySQL workbench due to [ERROR 3948 (42000), ERROR 2068 (HY000)] and and on the hunt for the reasons 
I was able to resolve it with the help of StackOverflow(https://stackoverflow.com/questions/59993844/error-loading-local-data-is-disabled-this-must-be-enabled-on-both-the-client,
https://stackoverflow.com/questions/63361962/error-2068-hy000-load-data-local-infile-file-request-rejected-due-to-restrict)

LOAD DATA LOCAL INFILE "C:/Users/Mohd Rizwan/Downloads/Walmartwalmart_dataData.csv"
INTO TABLE walmart_data
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

These restrictions can be removed from MySQL Workbench 8.0 in the following ways.
First run SET GLOBAL local_infile=1; query and Edit the connection, on the Connection tab, 
go to the 'Advanced' sub-tab, and in the 'Others:' box add the line 'OPT_LOCAL_INFILE=1'.

*/

--Ran the first test query to look at all my data

SELECT *
FROM walmart_data
LIMIT 5;


SELECT * 
FROM walmart_data
LIMIT 10;

SELECT *
FROM walmart_data
WHERE (Branch = "A") & (Quantity < 5) & (Unit_price > 60)
LIMIT 5;

------------------------------------------------------------------------------------------------------
----------------------------- Feature Engineering ----------------------------------------------------
-- time_of_day


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