-- Create the Customer Loan Database
CREATE DATABASE CustomerLoanDB;
USE CustomerLoanDB;

-- ===========================================
-- Tables
-- ============================================

-- Table for storing customer details
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(255) NOT NULL
);


-- Table for storing loan details
CREATE TABLE Loans (
    LoanID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    LoanAmount DECIMAL(10,2) NOT NULL,
    DueDate DATE NOT NULL,
    Status VARCHAR(20) DEFAULT 'Active',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);


-- Table for tracking loan repayments
CREATE TABLE Repayments (
    RepaymentID INT PRIMARY KEY AUTO_INCREMENT,
    LoanID INT,
    PaymentAmount DECIMAL(10,2) NOT NULL,
    PaymentDate DATE NOT NULL,
    FOREIGN KEY (LoanID) REFERENCES Loans(LoanID)
);


-- ============================================
-- Data Retrieval Queries
-- ============================================

-- Retrieve all records from each table
SELECT * FROM Customers;  -- View all customers
SELECT * FROM Loans;      -- View all loans
SELECT * FROM Repayments; -- View all repayments


-- Update loan status to 'Overdue' if the due date has passed
UPDATE Loans
SET Status = 'Overdue'
WHERE DueDate < CURDATE();


-- ============================================
-- Loan Metrics and Reports
-- ============================================

-- Calculate the total amount of loans disbursed
SELECT SUM(LoanAmount) AS Total_Disbursed FROM Loans;


-- Count the total number of loans issued
SELECT COUNT(LoanAmount) AS Total_Loans FROM Loans;


-- Calculate the total outstanding balance (total loans minus total repayments)
SELECT SUM(l.LoanAmount) - SUM(r.PaymentAmount) AS Total_Outstanding_Balance
FROM Loans l
LEFT JOIN Repayments r ON l.LoanID = r.LoanID;


-- Retrieve each customer's total loans, total amount borrowed, total repaid, and remaining balance
SELECT C.FullName, COUNT(L.LoanID) AS Total_Loans, 
       SUM(l.LoanAmount) AS Total_LoanAmount, 
       SUM(R.PaymentAmount) AS Total_Repaid, 
       (SUM(l.LoanAmount) - SUM(R.PaymentAmount)) AS RemainingBalance
FROM Customers C
LEFT JOIN Loans l ON C.CustomerID = l.CustomerID
LEFT JOIN Repayments r ON l.LoanID = r.LoanID
GROUP BY C.CustomerID;


-- Retrieve loan details along with total amount paid and remaining balance for each loan
SELECT c.Fullname, l.LoanID, l.LoanAmount, 
       SUM(r.PaymentAmount) AS TotalPaid, 
       (l.LoanAmount - SUM(r.PaymentAmount)) AS Balance
FROM Loans AS l
JOIN Customers C ON L.CustomerID = C.CustomerID
LEFT JOIN Repayments AS r ON l.LoanID = r.LoanID
GROUP BY c.Fullname, l.LoanID, l.LoanAmount;


-- Count the number of loans that are overdue
SELECT COUNT(*) AS OverdueLoans
FROM Loans
WHERE DueDate < CURDATE() AND Status = 'Active';


-- Retrieve customers with the highest outstanding balances (Top 5)
SELECT c.FullName, l.LoanAmount - SUM(r.PaymentAmount) AS Balance
FROM Loans AS l
JOIN Customers AS c ON c.CustomerID = l.CustomerID
LEFT JOIN Repayments AS r ON l.LoanID = R.LoanID
GROUP BY c.FullName
ORDER BY Balance DESC
LIMIT 5;


-- Retrieve customers who have fully repaid their loans
SELECT c.Fullname, l.LoanAmount, SUM(r.PaymentAmount) AS TotalPaid
FROM Loans l
JOIN Customers c ON l.CustomerID = c.CustomerID
LEFT JOIN Repayments r ON l.LoanID = r.LoanID
GROUP BY c.Fullname, l.LoanAmount
HAVING l.LoanAmount = SUM(r.PaymentAmount);
