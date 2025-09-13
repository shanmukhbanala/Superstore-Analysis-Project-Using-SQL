ALTER TABLE OrdersList
ALTER COLUMN OrderID nvarchar(255) NOT NULL

ALTER table Orderslist
ADD CONSTRAINT  pk_orderid PRIMARY KEY(OrderID)

ALTER TABLE EachOrderBreakdown
Alter column OrderID nvarchar(255) NOT NULL

ALTER TABLE EachOrderBreakdown
ADD CONSTRAINT fk_Orderid FOREIGN KEY (OrderID) REFERENCES OrdersList(OrderID)

ALTER TABLE OrdersList
ADD City nvarchar(255),
	State nvarchar(255),
	Country nvarchar(255);

UPDATE OrdersList
SET City= PARSENAME(REPLACE([City State Country],',','.'),3),
	State= PARSENAME(REPLACE([City State Country],',','.'),2),
	Country= PARSENAME(REPLACE([City State Country],',','.'),1);

ALTER TABLE OrdersList
DROP COLUMN [City State Country]

SELECT * FROM OrdersList

ALTER TABLE EachOrderBreakdown
ADD Category nvarchar(255)

UPDATE EachOrderBreakdown
SET Category = CASE WHEN LEFT(ProductName,3) = 'OFS' THEN 'Office Supplies'
					WHEN LEFT(ProductName,3) = 'TEC' THEN 'Technology'
					WHEN LEFT(ProductName,3) = 'FUR' THEN 'Furniture'
				END;

UPDATE EachOrderBreakdown
Set ProductName = SUBSTRING(ProductName,5,LEN(ProductName)-4)

WITH CTE AS(
SELECT *,ROW_NUMBER() OVER(PARTITION BY OrderID, ProductName, Discount, Sales, Profit, Quantity,
		SubCategory, Category ORDER BY OrderID) AS rn FROM EachOrderBreakdown
)
DELETE FROM CTE
WHERE rn > 1

UPDATE  OrdersList
SET  OrderPriority= 'NA'
WHERE  OrderPriority IS NULL

SELECT * FROM OrdersList