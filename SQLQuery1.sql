CREATE DATABASE SupermarketDB;

USE SupermarketDB;

create table Cities (
    CityID int identity(1,1) primary key,
    CityName varchar(50) not null
);

create table Branches (
    BranchID int identity(1,1) primary key,
    BranchCode varchar(10),
    CityID int,
	FOREIGN KEY (CityID) REFERENCES Cities(CityID)
);

create table Customers (
    name varchar(100),
    CustomerID int identity(1,1) primary key,
    CustomerType varchar(20),
    Gender  varchar(10),
	address varchar(100)
);

create table Payments (
    PaymentID int identity(1,1) primary key,
    PaymentType varchar(20)
);

create table Dates (
    DateID int identity(1,1) primary key,
    DateValue date,
    TimeValue time
);

create table Products (
    ProductID int identity(1,1) primary key,
    ProductLine varchar(100),
    UnitPrice decimal(10,2)
);

create table Invoices (
    InvoiceID varchar(20) primary key,
	Tax decimal(10,2),
    Total decimal(10,2),
	Quantity int,
    BranchID int,
    CustomerID int,
    ProductID int ,
    DateID int ,
    PaymentID int ,
    FOREIGN KEY(BranchID) REFERENCES Branches(BranchID),
	FOREIGN KEY (CustomerID)REFERENCES Customers(CustomerID),
	FOREIGN KEY (ProductID)REFERENCES Products(ProductID),
	FOREIGN KEY(DateID) REFERENCES Dates(DateID),
	FOREIGN KEY(PaymentID) REFERENCES Payments(PaymentID)

);

create table Ratings (
    RatingID int identity(1,1) primary key,
	Rating decimal(3,1),
    InvoiceID varchar(20),
	FOREIGN KEY(InvoiceID ) REFERENCES Invoices(InvoiceID)
    
);

INSERT INTO Cities (CityName) VALUES 
('Yangon'),
('Mandalay'),
('Naypyitaw');


INSERT INTO Branches (BranchCode, CityID) VALUES
('A', 1),
('B', 2),
('C', 3);


INSERT INTO Customers (CustomerType, Gender) VALUES
('Member', 'Female'),
('Normal', 'Male'),
('Member', 'Male');


INSERT INTO Payments (PaymentType) VALUES
('Cash'),
('Credit Card'),
('Ewallet');


INSERT INTO Dates (DateValue, TimeValue) VALUES
('2023-05-10', '12:30:00'),
('2023-05-11', '15:45:00'),
('2023-05-12', '10:15:00');


INSERT INTO Products (ProductLine, UnitPrice) VALUES
('Health and beauty', 20.50),
('Electronic accessories', 75.00),
('Food and beverages', 15.99);


INSERT INTO Invoices (InvoiceID, Tax,  Total ,Quantity, BranchID ,CustomerID, ProductID, DateID, PaymentID ) VALUES
('INV0001', 1.78, 1.55, 1, 1, 1, 2, 2, 1),
('INV0002', 2.90, 2.23, 2, 2, 2, 1, 3, 2),
('INV0003', 3.48, 3.77, 3, 3, 3, 5, 4, 3);



INSERT INTO Ratings (InvoiceID, Rating) VALUES
('INV0001', 9.1),
('INV0002', 8.5),
('INV0003', 7.0);


USE SupermarketDB;

SELECT TOP 50 * FROM [SuperMarket Analysis];

SELECT City, SUM(Quantity) AS TotalSales
FROM [SuperMarket Analysis]
GROUP BY City
ORDER BY TotalSales DESC;


SELECT Customer_type, COUNT(*) AS NumberOfInvoices
FROM [SuperMarket Analysis]
GROUP BY Customer_type;


SELECT Branch, AVG(Rating) AS AvgRating
FROM [SuperMarket Analysis]
GROUP BY Branch;

SELECT Payment, COUNT(*) AS PaymentCount
FROM [SuperMarket Analysis]
GROUP BY Payment;



CREATE VIEW View_SalesSummary AS
SELECT Invoice_ID, Branch, City, Customer_type, Payment
FROM [SuperMarket Analysis];

select *from View_SalesSummary;


SELECT Product_line, SUM(Unit_price) AS TotalSales
FROM [SuperMarket Analysis]
GROUP BY Product_line
ORDER BY TotalSales DESC;



CREATE VIEW View_InvoiceDetailsWithCityName AS
SELECT 
    i.InvoiceID,
    c.CityName,
    i.Total
FROM Invoices i
INNER JOIN Branches b ON i.BranchID = b.BranchID
INNER JOIN Cities c ON b.CityID = c.CityID;


SELECT * FROM View_InvoiceDetailsWithCityName;



SELECT 
    i.InvoiceID,
    c.CustomerType,
    c.Gender,
    p.PaymentType,
    i.Total
FROM Invoices i
JOIN Customers c ON i.CustomerID = c.CustomerID
JOIN Payments p ON i.PaymentID = p.PaymentID;




SELECT 
    b.BranchCode,
    SUM(i.Total) AS TotalSales
FROM Invoices i
JOIN Branches b ON i.BranchID = b.BranchID
GROUP BY b.BranchCode;


SELECT 
    ct.CityName,
    AVG(r.Rating) AS AvgRating
FROM Ratings r
JOIN Invoices i ON r.InvoiceID = i.InvoiceID
JOIN Branches b ON i.BranchID = b.BranchID
JOIN Cities ct ON b.CityID = ct.CityID
GROUP BY ct.CityName;


SELECT 
    pr.ProductLine,
    COUNT(*) AS TimesPurchased
FROM Invoices i
JOIN Products pr ON i.ProductID = pr.ProductID
GROUP BY pr.ProductLine;


SELECT TOP 3 
    r.Rating,
    i.InvoiceID,
    c.CityName
FROM Ratings r
JOIN Invoices i ON r.InvoiceID = i.InvoiceID
JOIN Branches b ON i.BranchID = b.BranchID
JOIN Cities c ON b.CityID = c.CityID
ORDER BY r.Rating DESC;



SELECT 
    c.CustomerType,
    COUNT(i.InvoiceID) AS InvoiceCount
FROM Invoices i
JOIN Customers c ON i.CustomerID = c.CustomerID
GROUP BY c.CustomerType;


SELECT 
    i.InvoiceID,
    p.ProductLine,
    p.UnitPrice,
    i.Quantity,
    (p.UnitPrice * i.Quantity) AS SubTotal
FROM Invoices i
JOIN Products p ON i.ProductID = p.ProductID;


SELECT 
    i.InvoiceID,
    d.DateValue,
    d.TimeValue,
    i.Total
FROM Invoices i
JOIN Dates d ON i.DateID = d.DateID
WHERE d.DateValue = '2023-05-10';


CREATE VIEW FullInvoiceDetails AS
SELECT 
    i.InvoiceID,
    c.CityName,
    b.BranchCode,
    cu.CustomerType,
    cu.Gender,
    p.ProductLine,
    i.Quantity,
    i.Tax,
    i.Total,
    pay.PaymentType,
    d.DateValue,
    d.TimeValue,
    r.Rating
FROM Invoices i
JOIN Branches b ON i.BranchID = b.BranchID
JOIN Cities c ON b.CityID = c.CityID
JOIN Customers cu ON i.CustomerID = cu.CustomerID
JOIN Products p ON i.ProductID = p.ProductID
JOIN Payments pay ON i.PaymentID = pay.PaymentID
JOIN Dates d ON i.DateID = d.DateID
LEFT JOIN Ratings r ON i.InvoiceID = r.InvoiceID;




select *from FullInvoiceDetails;