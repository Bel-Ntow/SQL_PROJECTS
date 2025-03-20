USE Sales_db;
-- Standardizing column names to maintain consistency
ALTER TABLE Customers 
RENAME COLUMN CustomerID TO Customer_ID,
RENAME COLUMN CustomerName TO Customer_Name;
SELECT * FROM Customers;                            

ALTER TABLE Orders
RENAME COLUMN OrderID TO Order_ID,
RENAME COLUMN OrderDate TO Order_Date;
SELECT * FROM Orders;                                 

ALTER TABLE Products
RENAME COLUMN ProductID TO Product_ID,
RENAME COLUMN ProductName TO Product_Name;
SELECT * FROM Products;                               

-- Total Revenue Generated
SELECT SUM(p.price * o.quantity) AS Total_Revenue
FROM Orders AS o
JOIN Products AS p ON o.Product_ID = p.Product_ID;

-- Total Orders Placed
SELECT SUM(Quantity) as Total_Orders
FROM Orders;

-- Best-Selling Products by Quantity Sold
SELECT p.Product_Name, SUM(o.Quantity) AS Total_Quantity_Sold  
FROM Orders AS o  
JOIN Products AS p ON o.Product_ID = p.Product_ID  
GROUP BY p.Product_Name  
ORDER BY Total_Quantity_Sold DESC;

-- Highest Revenue-Generating Products
SELECT p.Product_Name, SUM(p.price * o.quantity) AS Revenue
FROM Orders AS o
JOIN Products AS p ON o.Product_ID = p.Product_ID
GROUP BY Product_Name
ORDER BY Revenue DESC;

-- Monthly Sales Trend (Total Sales per Month)
SELECT DATE_FORMAT(o.Order_Date, '%Y-%m') AS Month, 
SUM(p.Price * o.Quantity) AS Total_Sales
FROM Orders AS o
JOIN Products AS p ON o.Product_ID = p.Product_ID
GROUP BY Month  
ORDER BY Month;  

-- Total number of transactions (orders) per customer
SELECT c.Customer_Name, COUNT(o.Order_ID) AS Total_Transactions
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_Name
ORDER BY Total_Transactions DESC;





