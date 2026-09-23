/*****************************************************************************************************************
NAME:    W3.4 - AdventureWorks Questions & Answers 
PURPOSE: Analysis Data from Adventure works 2022

MODIFICATION LOG:
Ver      Date        Author        Description
-----   ----------   -----------   -------------------------------------------------------------------------------
1.0     09/21/2026   MMVS      1. Built this script for EC IT143


RUNTIME: 
Xm 

NOTES: 
This is where I talk about what this script is, why I built it, and other stuff...
 
******************************************************************************************************************/

USE AdventureWorks;
GO


/* ==============================================================================
   CATEGORY 1: BUSINESS USER QUESTIONS - MARGINAL COMPLEXITY
   ============================================================================== */

--------------------------------------------------------------------------------
-- Q1: "Which products have the highest list prices?"
-- A1: Question goes on the previous line, intoduction to the answer goes on this line...

--------------------------------------------------------------------------------
SELECT
    Name AS ProductName,
    ListPrice
FROM Production.Product
WHERE ListPrice = (
    SELECT MAX(ListPrice)
    FROM Production.Product
);
GO


--------------------------------------------------------------------------------

-- Q2: "Which products have a safety stock level below 500?"
-- A2: Question goes on the previous line, intoduction to the answer goes on this line...

--------------------------------------------------------------------------------
SELECT
    Name AS ProductName,
    SafetyStockLevel
FROM Production.Product
WHERE SafetyStockLevel < 500
ORDER BY SafetyStockLevel ASC;
GO


/* ==============================================================================
   CATEGORY 2: BUSINESS USER QUESTIONS - MODERATE COMPLEXITY
   ============================================================================== */

--------------------------------------------------------------------------------
-- Question: "Which sales territories generated the highest total sales
--            in 2013? Include the territory name and total sales amount."
-- A3: Question goes on the previous line, intoduction to the answer goes on this line...

--------------------------------------------------------------------------------
SELECT
    st.Name AS TerritoryName,
    SUM(soh.TotalDue) AS TotalSalesAmount
FROM Sales.SalesOrderHeader AS soh
JOIN Sales.SalesTerritory AS st
    ON soh.TerritoryID = st.TerritoryID
WHERE YEAR(soh.OrderDate) = 2013
GROUP BY st.Name
ORDER BY TotalSalesAmount DESC;
GO


--------------------------------------------------------------------------------
-- Q4: "Our sales manager wants to review customer purchases. Which
--            customers placed the most sales orders, and how many orders
--            did each customer place?"
-- A4: Question goes on the previous line, intoduction to the answer goes on this line...

--------------------------------------------------------------------------------
SELECT
    p.FirstName + ' ' + p.LastName AS CustomerName,
    COUNT(soh.SalesOrderID) AS NumberOfOrders
FROM Sales.SalesOrderHeader AS soh
JOIN Sales.Customer AS c
    ON soh.CustomerID = c.CustomerID
JOIN Person.Person AS p
    ON c.PersonID = p.BusinessEntityID
GROUP BY p.FirstName, p.LastName
ORDER BY NumberOfOrders DESC;
GO


/* ==============================================================================
   CATEGORY 3: BUSINESS USER QUESTIONS - INCREASED COMPLEXITY
   ============================================================================== */

--------------------------------------------------------------------------------
-- Q5: "AdventureWorks management wants to understand which products
--            generated the most revenue. Using product, sales detail, and
--            sales order information, which five products produced the
--            highest total sales amount in 2013?"
-- A5: Question goes on the previous line, intoduction to the answer goes on this line...

--------------------------------------------------------------------------------
SELECT TOP 5
    p.Name AS ProductName,
    SUM(sod.LineTotal) AS TotalSalesAmount
FROM Sales.SalesOrderDetail AS sod
JOIN Sales.SalesOrderHeader AS soh
    ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.Product AS p
    ON sod.ProductID = p.ProductID
WHERE YEAR(soh.OrderDate) = 2013
GROUP BY p.Name
ORDER BY TotalSalesAmount DESC;
GO


--------------------------------------------------------------------------------
-- Q6: "The inventory team is checking products that may be getting
--            low on stock. Which products have a total inventory quantity
--            below their safety stock level, and how much inventory does
--            each product currently have?"
-- A6: Question goes on the previous line, intoduction to the answer goes on this line...

--------------------------------------------------------------------------------
SELECT
    p.Name AS ProductName,
    p.SafetyStockLevel,
    SUM(pi.Quantity) AS TotalInventoryQuantity
FROM Production.Product AS p
JOIN Production.ProductInventory AS pi
    ON p.ProductID = pi.ProductID
GROUP BY p.Name, p.SafetyStockLevel
HAVING SUM(pi.Quantity) < p.SafetyStockLevel
ORDER BY TotalInventoryQuantity ASC;
GO


/* ==============================================================================
   CATEGORY 4: METADATA QUESTIONS (INFORMATION_SCHEMA VIEWS)
   ============================================================================== */

--------------------------------------------------------------------------------
-- Q7: "Which tables in AdventureWorks contain columns named
--            ProductID?"
-- A7: Question goes on the previous line, intoduction to the answer goes on this line...

--------------------------------------------------------------------------------
SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'ProductID'
ORDER BY TABLE_SCHEMA, TABLE_NAME;
GO


--------------------------------------------------------------------------------
-- Q8: "Which columns in the Production schema contain the word
--            'Price' in their column name, and what data type does each
--            column use?"
-- A8: Question goes on the previous line, intoduction to the answer goes on this line...

--------------------------------------------------------------------------------
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Production'
    AND COLUMN_NAME LIKE '%Price%'
ORDER BY TABLE_NAME, COLUMN_NAME;
GO


/* ================================ END OF SCRIPT ================================ */
