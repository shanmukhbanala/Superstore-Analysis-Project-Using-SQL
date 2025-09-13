#  Superstore Analysis SQL Project

##  Project Name  
**Order Management & Sales Analysis using SQL**  

## 📌 Project Level  
Intermediate  


##  Project Overview  
This project focuses on cleaning, transforming, and analyzing sales and order data using **SQL**. It involves database normalization, column restructuring, applying constraints, data updates, and deriving valuable insights through SQL queries.  

## 🎯 Objective 
The main objective is to **analyze order and sales data** by restructuring tables, applying primary/foreign keys, cleaning product/category fields, and extracting insights on sales, profit, and customer behavior. The project demonstrates the use of **SQL DDL (Data Definition Language) and DML (Data Manipulation Language) commands** for both **data preparation and analysis**.  


---

##  SQL Code  FOR Data Cleaning

```sql
ALTER TABLE OrdersList
ALTER COLUMN OrderID nvarchar(255) NOT NULL;

ALTER TABLE OrdersList
ADD CONSTRAINT pk_orderid PRIMARY KEY(OrderID);

ALTER TABLE EachOrderBreakdown
ALTER COLUMN OrderID nvarchar(255) NOT NULL;

ALTER TABLE EachOrderBreakdown
ADD CONSTRAINT fk_Orderid FOREIGN KEY (OrderID) REFERENCES OrdersList(OrderID);

ALTER TABLE OrdersList
ADD City nvarchar(255),
    State nvarchar(255),
    Country nvarchar(255);

UPDATE OrdersList
SET City = PARSENAME(REPLACE([City State Country],',','.'),3),
    State = PARSENAME(REPLACE([City State Country],',','.'),2),
    Country = PARSENAME(REPLACE([City State Country],',','.'),1);

ALTER TABLE OrdersList
DROP COLUMN [City State Country];

SELECT * FROM OrdersList;

ALTER TABLE EachOrderBreakdown
ADD Category nvarchar(255);

UPDATE EachOrderBreakdown
SET Category = CASE 
                  WHEN LEFT(ProductName,3) = 'OFS' THEN 'Office Supplies'
                  WHEN LEFT(ProductName,3) = 'TEC' THEN 'Technology'
                  WHEN LEFT(ProductName,3) = 'FUR' THEN 'Furniture'
               END;

UPDATE EachOrderBreakdown
SET ProductName = SUBSTRING(ProductName,5,LEN(ProductName)-4);

WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER(
        PARTITION BY OrderID, ProductName, Discount, Sales, Profit, Quantity,
                     SubCategory, Category 
        ORDER BY OrderID) AS rn 
    FROM EachOrderBreakdown
)
DELETE FROM CTE WHERE rn > 1;

UPDATE OrdersList
SET OrderPriority = 'NA'
WHERE OrderPriority IS NULL;

SELECT * FROM OrdersList;
```

###  Data Analysis Queries  

```sql
-- List the top 10 orders with the highest sales
SELECT TOP 10 * 
FROM EachOrderBreakdown 
ORDER BY Sales DESC;

-- Show the number of orders for each product category
SELECT Category, COUNT(*) AS NumberOfOrders 
FROM EachOrderBreakdown 
GROUP BY Category;

-- Find the total profit from each sub-category
SELECT SubCategory, SUM(Profit) AS TotalProfit 
FROM EachOrderBreakdown 
GROUP BY SubCategory;

-- Identify the customer with the highest total sales
SELECT TOP 1 CustomerName, SUM(Sales) AS TotalSales 
FROM OrdersList ol 
JOIN EachOrderBreakdown ob ON ol.OrderID = ob.OrderID 
GROUP BY CustomerName 
ORDER BY TotalSales DESC;

-- Find the month with the highest average sales
SELECT TOP 1 MONTH(OrderDate) AS Month, SUM(Sales) AS AvgSales 
FROM OrdersList ol 
JOIN EachOrderBreakdown ob ON ol.OrderID = ob.OrderID 
GROUP BY MONTH(OrderDate) 
ORDER BY AvgSales DESC;

-- Find average quantity ordered by customers whose name starts with 'S'
SELECT AVG(Quantity) AS AvgQuantity 
FROM OrdersList ol 
JOIN EachOrderBreakdown ob ON ol.OrderID = ob.OrderID 
WHERE LEFT(CustomerName,1) = 's';

-- Find how many new customers were acquired in 2014
SELECT COUNT(*) AS CustomerWithFirstOrder2014 
FROM (
    SELECT CustomerName, MIN(OrderDate) AS FirstOrderDate 
    FROM OrdersList 
    GROUP BY CustomerName 
    HAVING MIN(YEAR(OrderDate)) = 2014
) AS CustomerWithFirstOrder2014;

-- Calculate profit contribution percentage by sub-category
SELECT SubCategory, 
       SUM(Profit) AS SubCategoryProfit, 
       SUM(Profit) * 100.0 / (SELECT SUM(Profit) FROM EachOrderBreakdown) AS PercentageOfTotalContribution 
FROM EachOrderBreakdown 
GROUP BY SubCategory;

-- Average sales per customer (only customers with more than one order)
WITH CustomerAvgSales AS (
    SELECT CustomerName, 
           COUNT(DISTINCT ol.OrderID) AS NumberOfOrders, 
           AVG(Sales) AS AvgSales 
    FROM OrdersList ol 
    JOIN EachOrderBreakdown ob ON ol.OrderID = ob.OrderID 
    GROUP BY CustomerName
)
SELECT CustomerName, AvgSales 
FROM CustomerAvgSales 
WHERE NumberOfOrders > 1;
```

---

##  Report  
The SQL queries answered key business questions such as:  
- Top 10 orders with the highest sales.  
- Number of orders for each product category.  
- Total profit contributed by each sub-category.  
- Customer with the highest total sales.  
- Month with the highest average sales.  
- Average quantity ordered by customers whose name starts with ‘S’.  
- Number of new customers acquired in 2014.  
- Percentage contribution of each sub-category to overall profit.  
- Average sales per customer (considering repeat customers).  

---

##  Conclusion  
This project demonstrates how **SQL can be used not only for data storage but also for powerful data cleaning, transformation, and analysis**. By restructuring tables, applying constraints, and writing analytical queries, we extracted **valuable business insights** such as customer trends, sales performance, and profitability drivers. This analysis provides a foundation for better **business decision-making**.  
