/*****************************************************************************************************************
NAME:    3.4 Create Answers Script By Jeannot Akondi
PURPOSE: My script purpose...

MODIFICATION LOG:
Ver      Date        Author        Description
-----   ----------   -----------   -------------------------------------------------------------------------------
1.0     05/23/2022   JJAUSSI       1. Built this script for EC IT440


RUNTIME: 
Xm Xs

NOTES: 
This is where I talk about what this script is, why I built it, and other stuff...
 
******************************************************************************************************************/
USE AdventureWorks2022
GO

-- Q1: What is the total number of employees that joined the company in February? Guillermo Ezequiel Chehda 
-- A1: -- Count employees whose HireDate month equals?2 (February, any year)

SELECT COUNT(*) AS EmployeesHiredInFebruary
FROM HumanResources.Employee
WHERE MONTH(HireDate) = 2;

-- Q2: How many employees have the job title Design Engineer? Robert Young 
-- A2: Total number of employees with the exact JobTitle 'Design Engineer'

SELECT COUNT(*) AS DesignEngineerCount
FROM HumanResources.Employee
WHERE JobTitle = 'Design Engineer';

-- Q3: Which customers purchased products with a list price over $500? List their names and order dates. Ibrahim Conteh 
-- A3: Names and order dates for customers who purchased products priced over $500

SELECT DISTINCT 
    p.FirstName + ' ' + p.LastName AS CustomerName,
    soh.OrderDate
FROM Sales.SalesOrderHeader       AS soh
JOIN Sales.SalesOrderDetail        AS sod ON sod.SalesOrderID  = soh.SalesOrderID
JOIN Production.Product            AS pr  ON pr.ProductID      = sod.ProductID
JOIN Sales.Customer                AS c   ON c.CustomerID      = soh.CustomerID
JOIN Person.Person                 AS p   ON p.BusinessEntityID = c.PersonID
WHERE pr.ListPrice > 500
ORDER BY soh.OrderDate, CustomerName;

-- Q4: I’m looking to compare average list prices between road bikes and mountain bikes. Can you show me the average list price for each type? Bismark Ahadzie 
-- A4: Average list price for Road and Mountain bikes 

WITH BikeTypes AS (
    SELECT
        pr.ProductID,
        pr.ListPrice,
        CASE
            WHEN pc.Name = 'Bikes' AND psc.Name LIKE 'Road%'     THEN 'Road Bikes'
            WHEN pc.Name = 'Bikes' AND psc.Name LIKE 'Mountain%' THEN 'Mountain Bikes'
        END AS BikeType
    FROM Production.Product              AS pr
    JOIN Production.ProductSubcategory   AS psc ON psc.ProductSubcategoryID = pr.ProductSubcategoryID
    JOIN Production.ProductCategory      AS pc  ON pc.ProductCategoryID     = psc.ProductCategoryID
    WHERE pc.Name = 'Bikes'
)
SELECT
    BikeType,
    AVG(ListPrice) AS AvgListPrice
FROM BikeTypes
WHERE BikeType IS NOT NULL
GROUP BY BikeType;

-- Q5: "As we plan next quarter’s marketing push, I’m reviewing accessory sales. 
--      For?Q3?2013, please summarize total quantity, average discount, and net revenue for each helmet model sold to online customers. 
--      Group the results by month and helmet size. Jeannot Akondi" 
-- A5: Q3 2013 helmet sales for online orders, by month & helmet size 

WITH HelmetSales AS (
    SELECT
        DATENAME(MONTH, soh.OrderDate)          AS OrderMonth,
        pr.Name                                 AS HelmetModel,
        pr.Size                                 AS HelmetSize,
        sod.OrderQty,
        sod.UnitPrice,
        sod.UnitPriceDiscount,
        (sod.UnitPrice - sod.UnitPriceDiscount) * sod.OrderQty AS NetRevenue
    FROM Sales.SalesOrderHeader       AS soh
    JOIN Sales.SalesOrderDetail        AS sod ON sod.SalesOrderID        = soh.SalesOrderID
    JOIN Production.Product            AS pr  ON pr.ProductID            = sod.ProductID
    JOIN Production.ProductSubcategory AS psc ON psc.ProductSubcategoryID = pr.ProductSubcategoryID
    JOIN Production.ProductCategory    AS pc  ON pc.ProductCategoryID     = psc.ProductCategoryID
    WHERE pc.Name            = 'Accessories'
      AND psc.Name           = 'Helmets'
      AND soh.OnlineOrderFlag = 1
      AND soh.OrderDate >= '2013-07-01'
      AND soh.OrderDate <  '2013-10-01'
)
SELECT
    OrderMonth,
    HelmetSize,
    HelmetModel,
    SUM(OrderQty)                    AS TotalQuantity,
    AVG(UnitPriceDiscount)           AS AvgDiscount,
    SUM(NetRevenue)                  AS NetRevenue
FROM HelmetSales
GROUP BY OrderMonth, HelmetSize, HelmetModel
ORDER BY OrderMonth, HelmetModel;

-- Q6: I am reviewing the revenue made from the fourth quarter of 2024. 
--Which products had declining sales of 50% and beyond compared to the third quarter? State the product name and units sold per quarter. Clarence Rudaviro Makwasha 
-- A6: Identify products whose units sold dropped by ?50?% from Q3 to Q4 2024 

WITH Quarterly AS (
    SELECT
        pr.ProductID,
        pr.Name AS ProductName,
        YEAR(soh.OrderDate)                                                    AS OrderYear,
        CASE
            WHEN MONTH(soh.OrderDate) BETWEEN  1 AND  3 THEN 'Q1'
            WHEN MONTH(soh.OrderDate) BETWEEN  4 AND  6 THEN 'Q2'
            WHEN MONTH(soh.OrderDate) BETWEEN  7 AND  9 THEN 'Q3'
            ELSE                                   'Q4'
        END                                                                     AS Quarter,
        SUM(sod.OrderQty)                                                       AS UnitsSold
    FROM Sales.SalesOrderHeader       AS soh
    JOIN Sales.SalesOrderDetail        AS sod ON sod.SalesOrderID = soh.SalesOrderID
    JOIN Production.Product            AS pr  ON pr.ProductID     = sod.ProductID
    WHERE YEAR(soh.OrderDate) = 2024
    GROUP BY pr.ProductID, pr.Name, YEAR(soh.OrderDate),
             CASE
                 WHEN MONTH(soh.OrderDate) BETWEEN  1 AND  3 THEN 'Q1'
                 WHEN MONTH(soh.OrderDate) BETWEEN  4 AND  6 THEN 'Q2'
                 WHEN MONTH(soh.OrderDate) BETWEEN  7 AND  9 THEN 'Q3'
                 ELSE                                   'Q4'
             END
), Comparison AS (
    SELECT
        q3.ProductID,
        q3.ProductName,
        q3.UnitsSold AS Q3Units,
        q4.UnitsSold AS Q4Units
    FROM Quarterly q3
    JOIN Quarterly q4
      ON q4.ProductID  = q3.ProductID
     AND q3.OrderYear  = q4.OrderYear
     AND q3.Quarter    = 'Q3'
     AND q4.Quarter    = 'Q4'
)
SELECT
    ProductName,
    Q3Units,
    Q4Units
FROM Comparison
WHERE Q4Units <= Q3Units * 0.5
ORDER BY ProductName;

-- Q7: Referencing INFORMATION_SCHEMA.TABLES, list any AdventureWorks tables whose names include the substring “Territory” but are not views. Jeannot Akondi 
-- A7: Look for tables whose names include 'Territory' (excluding views)

SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_NAME LIKE '%Territory%';

-- Q8: Which columns in the database use the data type 'money'? Provide the table name and column name. Alex Ohuru 
-- A8: All columns declared as 'money' across AdventureWorks

SELECT
    TABLE_SCHEMA,
    TABLE_NAME,
    COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE DATA_TYPE = 'money'
ORDER BY TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME;

SELECT GETDATE() AS my_date;