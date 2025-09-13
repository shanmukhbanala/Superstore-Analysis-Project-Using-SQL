--# List the top 10 orders with the highest sales from the EachOrderBreakdown table
SELECT TOP 10 * FROM EachOrderBreakdown
ORDER BY Sales DESC

--# Show the number of orders for each product category in the EachOrderBreakdown table
SELECT Category,COUNT (*) AS NumberOfOrders
FROM EachOrderBreakdown
GROUP BY Category

--# Find the total profit from each sub-category in the EachOrderBreakdown table.
SELECT SubCategory, Sum(Profit) AS TotalProfit
FROM EachOrderBreakdown
GROUP BY SubCategory

--# Identify the customer with the highest total sales across all orders.
SELECT TOP 1 CustomerName, SUM(Sales) AS TotalSales FROM OrdersList ol
JOIN EachOrderBreakdown ob
ON ol.OrderID = ob.OrderID
GROUP BY CustomerName
ORDER BY TotalSales DESC

--# Find the Month with the Highest average sales in the OrsersList table.
SELECT  TOP 1 MONTH(OrderDate) AS MONTH, SUM(Sales) AS AvgSales FROM OrdersList ol
JOIN EachOrderBreakdown ob
ON ol.OrderID = ob.OrderID
GROUP BY MONTH(OrderDate)
ORDER BY AvgSales DESC

--# Find out the average quantity ordered by customers whose first name starts with an alphabet 's'.
SELECT AVG(Quantity) AS AvgQuantity FROM OrdersList ol
JOIN EachOrderBreakdown ob
ON ol.OrderID = ob.OrderID
WHERE LEFT (CustomerName,1)='s'

--# Find out how many new customers were acquired in the year 2014
SELECT COUNT(*) AS CustomerWithFirstOrder2014 FROM(
SELECT CustomerName,MIN (OrderDate) AS FirstOrderDate FROM OrdersList
GROUP BY CustomerName
HAVING MIN(YEAR(OrderDate)) = 2014) AS CustomerWithFirstOrder2014

--# Calculate the percentage of total profit contributed by each sub- category to the overall profit.
SELECT SubCategory,SUM(Profit) AS SubCategoryProfit,
SUM(Profit)/(SELECT SUM(Profit) FROM EachOrderBreakdown) *100 AS PercentageofTotalContribution
FROM EachOrderBreakdown
GROUP BY SubCategory

--# Find the average sales per customer, considering only customers who have made more than one order.
WITH CustomerAvgSales AS(
SELECT CustomerName, COUNT(DISTINCT ol.OrderID) AS NumberofOrders, AVG(Sales) AS AvgSales
FROM OrdersList ol
JOIN EachOrderBreakdown ob
ON ol.OrderID = ob.OrderID
GROUP BY CustomerName
)
SELECT CustomerName,AvgSales
FROM CustomerAvgSales
WHERE NumberofOrders >12

SELECT * FROM EachOrderBreakdown
SELECT * FROM OrdersList