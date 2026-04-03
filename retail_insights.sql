CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    CategoryID INT,
    StockCount INT,
    ExpiryDate DATE,
    Price DECIMAL(10,2),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE SalesTransactions (
    TransactionID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    TransactionDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


INSERT INTO Categories VALUES
(1, 'Dairy'),
(2, 'Snacks'),
(3, 'Beverages');


INSERT INTO Products VALUES
(101, 'Milk', 1, 80, CURRENT_DATE + INTERVAL 5 DAY, 50.00),
(102, 'Cheese', 1, 30, CURRENT_DATE + INTERVAL 15 DAY, 120.00),
(103, 'Chips', 2, 100, CURRENT_DATE + INTERVAL 30 DAY, 20.00),
(104, 'Biscuits', 2, 60, CURRENT_DATE + INTERVAL 3 DAY, 25.00),
(105, 'Juice', 3, 40, CURRENT_DATE + INTERVAL 10 DAY, 60.00),
(106, 'Soda', 3, 70, CURRENT_DATE + INTERVAL 6 DAY, 40.00);


INSERT INTO SalesTransactions VALUES
(1, 101, 10, CURRENT_DATE - INTERVAL 10 DAY),
(2, 101, 5, CURRENT_DATE - INTERVAL 20 DAY),
(3, 103, 20, CURRENT_DATE - INTERVAL 5 DAY),
(4, 104, 15, CURRENT_DATE - INTERVAL 40 DAY),
(5, 105, 8, CURRENT_DATE - INTERVAL 15 DAY);


SELECT *
FROM Products
WHERE ExpiryDate BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL 7 DAY
AND StockCount > 50;


SELECT p.*
FROM Products p
LEFT JOIN SalesTransactions s
ON p.ProductID = s.ProductID
AND s.TransactionDate >= CURRENT_DATE - INTERVAL 60 DAY
WHERE s.ProductID IS NULL;


SELECT c.CategoryName, SUM(p.Price * s.Quantity) AS TotalRevenue
FROM SalesTransactions s
JOIN Products p ON s.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE s.TransactionDate >= DATE_FORMAT(CURRENT_DATE - INTERVAL 1 MONTH, '%Y-%m-01')
AND s.TransactionDate < DATE_FORMAT(CURRENT_DATE, '%Y-%m-01')
GROUP BY c.CategoryName
ORDER BY TotalRevenue DESC;