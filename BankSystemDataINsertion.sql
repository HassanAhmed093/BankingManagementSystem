-- Insert data into bank.customers
USE BankSystem
GO
 

INSERT INTO [bank].[customers] (
    FullName, DateOfBirth, Email, Phone, Street, City, State, Zip, Country, 
    NationalID, CustomerType, RiskRating, KYCStatus, Occupation, MonthlyIncome
) VALUES
    ('John Michael Smith', '1985-03-15', 'john.smith@email.com', '555-0101', '123 Main St', 'New York', 'NY', '10001', 'USA', 'SSN123456789', 'Individual', 'Low', 'Verified', 'Engineer', 7500.00),
    ('Sarah Jane Wilson', '1990-07-22', 'sarah.wilson@email.com', '555-0102', '456 Oak Ave', 'Boston', 'MA', '02108', 'USA', 'SSN987654321', 'Individual', 'Medium', 'Verified', 'Teacher', 4500.00),
    ('Tech Solutions LLC', NULL, 'contact@techsolutions.com', '555-0103', '789 Pine Rd', 'San Francisco', 'CA', '94105', 'USA', 'EIN123456789', 'Business', 'Low', 'Verified', NULL, NULL),
    ('Emily Rose Carter', '1978-11-30', 'emily.carter@email.com', '555-0104', '321 Elm St', 'Chicago', 'IL', '60601', 'USA', 'SSN456789123', 'Individual', 'High', 'In Review', 'Doctor', 12000.00),
    ('Global Traders Inc', NULL, 'info@globaltraders.com', '555-0105', '654 Birch Ln', 'Miami', 'FL', '33101', 'USA', 'EIN987654321', 'Business', 'Medium', 'Verified', NULL, NULL),
    ('David Lee Brown', '1982-05-10', 'david.brown@email.com', '555-0106', '987 Cedar Dr', 'Seattle', 'WA', '98101', 'USA', 'SSN789123456', 'Individual', 'Low', 'Verified', 'Accountant', 6000.00),
    ('Lisa Marie Evans', '1995-09-18', 'lisa.evans@email.com', '555-0107', '147 Maple Ave', 'Austin', 'TX', '73301', 'USA', 'SSN321654987', 'Individual', 'Low', 'Pending', 'Designer', 4000.00),
    ('Prime Retail Co', NULL, 'support@primeretail.com', '555-0108', '258 Spruce Ct', 'Denver', 'CO', '80201', 'USA', 'EIN456789123', 'Business', 'High', 'Verified', NULL, NULL);

-- Insert data into bank.branches
INSERT INTO [bank].[branches] (
    BranchName, Street, City, State, Zip, Country, Phone, ManagerID
) VALUES
    ('Downtown Branch', '100 Bank St', 'New York', 'NY', '10002', 'USA', '555-0201', NULL),
    ('Northside Branch', '200 Finance Ave', 'Boston', 'MA', '02109', 'USA', '555-0202', NULL),
    ('Tech Park Branch', '300 Circuit Rd', 'San Francisco', 'CA', '94106', 'USA', '555-0203', NULL),
    ('City Center Branch', '400 Trade St', 'Chicago', 'IL', '60602', 'USA', '555-0204', NULL),
    ('Beachfront Branch', '500 Ocean Dr', 'Miami', 'FL', '33102', 'USA', '555-0205', NULL),
    ('Emerald Branch', '600 Pine Way', 'Seattle', 'WA', '98102', 'USA', '555-0206', NULL),
    ('Capital Branch', '700 Congress Ave', 'Austin', 'TX', '73302', 'USA', '555-0207', NULL),
    ('Mountain Branch', '800 Ridge Rd', 'Denver', 'CO', '80202', 'USA', '555-0208', NULL);

-- Insert data into bank.employees
INSERT INTO [bank].[employees] (
    BranchID, Street, City, State, Zip, Country, DateOfBirth, Email, Phone, 
    Salary, FullName, Position, Department, AccessLevel
) VALUES
    (1, '101 Bank St', 'New York', 'NY', '10002', 'USA', '1975-06-12', 'mary.jones@email.com', '555-0301', 80000.00, 'Mary Ann Jones', 'Manager', 'Operations', 'Manager'),
    (2, '201 Finance Ave', 'Boston', 'MA', '02109', 'USA', '1980-09-25', 'robert.taylor@email.com', '555-0302', 65000.00, 'Robert Lee Taylor', 'Teller', 'Retail', 'Employee'),
    (3, '301 Circuit Rd', 'San Francisco', 'CA', '94106', 'USA', '1988-03-17', 'alice.wong@email.com', '555-0303', 90000.00, 'Alice Mei Wong', 'Loan Officer', 'Lending', 'Employee'),
    (4, '401 Trade St', 'Chicago', 'IL', '60602', 'USA', '1970-12-01', 'thomas.moore@email.com', '555-0304', 85000.00, 'Thomas Ray Moore', 'Manager', 'Operations', 'Manager'),
    (5, '501 Ocean Dr', 'Miami', 'FL', '33102', 'USA', '1990-07-08', 'julia.martin@email.com', '555-0305', 60000.00, 'Julia Grace Martin', 'Teller', 'Retail', 'Employee'),
    (6, '601 Pine Way', 'Seattle', 'WA', '98102', 'USA', '1985-11-22', 'kevin.white@email.com', '555-0306', 70000.00, 'Kevin Scott White', 'Analyst', 'Risk', 'Employee'),
    (7, '701 Congress Ave', 'Austin', 'TX', '73302', 'USA', '1978-04-30', 'susan.jackson@email.com', '555-0307', 95000.00, 'Susan Lynn Jackson', 'Manager', 'Operations', 'Manager'),
    (8, '801 Ridge Rd', 'Denver', 'CO', '80202', 'USA', '1982-08-14', 'mark.lee@email.com', '555-0308', 62000.00, 'Mark David Lee', 'Teller', 'Retail', 'Employee');

 
-- Update branches with ManagerID
UPDATE [bank].[branches] SET ManagerID = 1 WHERE BranchID = 1;
UPDATE [bank].[branches] SET ManagerID = 4 WHERE BranchID = 4;
UPDATE [bank].[branches] SET ManagerID = 7 WHERE BranchID = 7;

-- Insert data into bank.business_details
INSERT INTO [bank].[business_details] (
    BusinessID, CustomerID, BusinessName, RegistrationNumber, TaxID, BusinessType, AnnualRevenue
) VALUES
    (1, 3, 'Tech Solutions LLC', 'REG123456', 'TAX123456', 'LLC', 5000000.00),
    (2, 3, 'Tech Solutions Branch', 'REG123457', 'TAX123457', 'LLC', 2000000.00),
    (1, 5, 'Global Traders Inc', 'REG987654', 'TAX987654', 'Corporation', 10000000.00),
    (2, 5, 'Global Traders Div', 'REG987655', 'TAX987655', 'Corporation', 3000000.00),
    (1, 8, 'Prime Retail Co', 'REG456789', 'TAX456789', 'Sole Proprietorship', 1500000.00),
    (2, 8, 'Prime Retail Store', 'REG456790', 'TAX456790', 'Sole Proprietorship', 800000.00),
    (3, 3, 'Tech Solutions HQ', 'REG123458', 'TAX123458', 'LLC', 4000000.00),
    (4, 5, 'Global Traders Unit', 'REG987656', 'TAX987656', 'Corporation', 2500000.00);

-- Insert data into bank.accounts
INSERT INTO [bank].[accounts] (
    CustomerID, BranchID, AccountNumber, AccountType, Balance, CurrencyType, 
    MinimumBalance, InterestRate, OverdraftProtection, OnlineBankingEnabled, Status, DateOpened
) VALUES
    (1, 1, 'ACC100000001', 'Savings', 15000.00, 'USD', 1000.00, 1.50, 0, 1, 'Active', '2023-01-15'),
    (2, 2, 'ACC200000002', 'Checking', 5000.00, 'USD', 500.00, 0.00, 1, 1, 'Active', '2023-02-20'),
    (3, 3, 'ACC300000003', 'Business', 100000.00, 'USD', 5000.00, 0.50, 0, 1, 'Active', '2023-03-10'),
    (4, 4, 'ACC400000004', 'Fixed Deposit', 25000.00, 'USD', 10000.00, 2.75, 0, 0, 'Active', '2023-04-05'),
    (5, 5, 'ACC500000005', 'Business', 75000.00, 'USD', 10000.00, 0.75, 0, 1, 'Active', '2023-05-12'),
    (6, 6, 'ACC600000006', 'Savings', 20000.00, 'USD', 1000.00, 1.25, 0, 1, 'Active', '2023-06-18'),
    (7, 7, 'ACC700000007', 'Checking', 3000.00, 'USD', 500.00, 0.00, 1, 1, 'Active', '2023-07-25'),
    (8, 8, 'ACC800000008', 'Business', 50000.00, 'USD', 5000.00, 0.60, 0, 1, 'Active', '2023-08-30');

-- Insert data into bank.atms
INSERT INTO [bank].[atms] (
    BranchID, LocationLat, LocationLong, CashBalance, LastMaintenanceDate
) VALUES
    (1, 40.712800, -74.006000, 50000.00, '2025-04-01'),
    (2, 42.360100, -71.058900, 40000.00, '2025-04-02'),
    (3, 37.774900, -122.419400, 60000.00, '2025-04-03'),
    (4, 41.878100, -87.629800, 45000.00, '2025-04-04'),
    (5, 25.761700, -80.191800, 55000.00, '2025-04-05'),
    (6, 47.606200, -122.332100, 35000.00, '2025-04-06'),
    (7, 30.267200, -97.743100, 42000.00, '2025-04-07'),
    (8, 39.739200, -104.990300, 48000.00, '2025-04-08');

-- Insert data into bank.transactions
INSERT INTO [bank].[transactions] (
    AccountID, AtmID, TransactionType, Amount, Date, Description, 
    AuthorizationCode, DeviceUsed, TransactionStatus
) VALUES
    (1, 1, 'Deposit', 2000.00, '2025-04-01 10:00:00', 'Salary deposit', 'AUTH1001', 'ATM', 'Completed'),
    (2, 2, 'Withdrawal', 500.00, '2025-04-02 12:30:00', 'Cash withdrawal', 'AUTH1002', 'ATM', 'Completed'),
    (3, 3, 'Transfer', 10000.00, '2025-04-03 09:15:00', 'Vendor payment', 'AUTH1003', 'Online', 'Completed'),
    (4, 4, 'Deposit', 5000.00, '2025-04-04 14:45:00', 'Investment deposit', 'AUTH1004', 'Branch', 'Completed'),
    (5, 5, 'Bill Payment', 2000.00, '2025-04-05 11:20:00', 'Utility bill', 'AUTH1005', 'Mobile', 'Completed'),
    (6, 6, 'Deposit', 3000.00, '2025-04-06 13:10:00', 'Freelance payment', 'AUTH1006', 'Online', 'Completed'),
    (7, 7, 'Withdrawal', 1000.00, '2025-04-07 15:50:00', 'Shopping', 'AUTH1007', 'ATM', 'Completed'),
    (8, 8, 'Transfer', 15000.00, '2025-04-08 08:30:00', 'Supplier payment', 'AUTH1008', 'Online', 'Completed'),
	 
	 
-- Insert data into bank.overdrafts
INSERT INTO [bank].[overdrafts] (
    OverdraftID, AccountID, LimitAmount, InterestRate, ApprovalDate, ExpiryDate
) VALUES
    (1, 2, 1000.00, 7.50, '2023-02-20', '2024-02-20'),
    (2, 2, 2000.00, 8.00, '2024-02-21', '2025-02-21'),
    (1, 7, 1500.00, 7.75, '2023-07-25', '2024-07-25'),
    (2, 7, 2500.00, 8.25, '2024-07-26', '2025-07-26'),
    (1, 1, 500.00, 7.00, '2023-01-15', '2024-01-15'),
    (1, 3, 5000.00, 6.50, '2023-03-10', '2024-03-10'),
    (1, 5, 3000.00, 6.75, '2023-05-12', '2024-05-12'),
    (1, 8, 4000.00, 7.25, '2023-08-30', '2024-08-30');

-- Insert data into bank.loans
INSERT INTO [bank].[loans] (
    EmployeeID, CustomerID, LoanType, PrincipalAmount, InterestRate, TermMonths, 
    MonthlyPaymentAmount, StartDate, EndDate, CollateralDescription, CollateralValue, Status
) VALUES
    (3, 1, 'Personal', 10000.00, 5.50, 36, 304.76, '2023-01-20', '2026-01-20', NULL, NULL, 'Active'),
    (3, 2, 'Auto', 25000.00, 4.75, 60, 468.22, '2023-02-25', '2028-02-25', 'Car', 30000.00, 'Active'),
    (3, 4, 'Mortgage', 200000.00, 3.80, 360, 932.57, '2023-04-10', '2053-04-10', 'House', 250000.00, 'Active'),
    (6, 6, 'Education', 15000.00, 4.00, 48, 340.66, '2023-06-20', '2027-06-20', NULL, NULL, 'Active'),
    (6, 7, 'Personal', 5000.00, 6.00, 24, 221.88, '2023-07-30', '2025-07-30', NULL, NULL, 'Active'),
    (3, 3, 'Business', 50000.00, 5.25, 60, 951.27, '2023-03-15', '2028-03-15', 'Equipment', 60000.00, 'Active'),
    (3, 5, 'Business', 75000.00, 5.00, 72, 1220.08, '2023-05-20', '2029-05-20', 'Inventory', 90000.00, 'Active'),
    (6, 8, 'Business', 30000.00, 5.75, 48, 705.63, '2023-09-05', '2027-09-05', 'Property', 40000.00, 'Active');

-- Insert data into bank.loan_payments
INSERT INTO [bank].[loan_payments] (
    LoanID, PaymentDate, AmountPaid, RemainingBalance, PaymentMethod, Status
) VALUES
    (1, '2025-04-01 09:00:00', 304.76, 6500.00, 'Bank Transfer', 'Completed'),
    (2, '2025-04-02 10:30:00', 468.22, 20000.00, 'Check', 'Completed'),
    (3, '2025-04-03 11:15:00', 932.57, 195000.00, 'Bank Transfer', 'Completed'),
    (4, '2025-04-04 12:45:00', 340.66, 11000.00, 'Cash', 'Completed'),
    (5, '2025-04-05 14:00:00', 221.88, 3000.00, 'Bank Transfer', 'Completed'),
    (6, '2025-04-06 15:20:00', 951.27, 45000.00, 'Bank Transfer', 'Completed'),
    (7, '2025-04-07 16:40:00', 1220.08, 70000.00, 'Check', 'Completed'),
    (8, '2025-04-08 17:50:00', 705.63, 25000.00, 'Bank Transfer', 'Completed');

-- Insert data into bank.cards
INSERT INTO [bank].[cards] (
    AccountID, CardNumber, CardType, CardHolderName, IssueDate, ExpiryDate, 
    CVV, PIN, DailyWithdrawalLimit, DailyPurchaseLimit, ContactlessEnabled, Status
) VALUES
    (1, '4000-1234-5678-9012', 'Debit', 'John Michael Smith', '2023-01-15', '2026-01-15', '123', '1234', 1000.00, 5000.00, 1, 'Active'),
    (2, '4000-2345-6789-0123', 'Credit', 'Sarah Jane Wilson', '2023-02-20', '2026-02-20', '234', '2345', 500.00, 3000.00, 0, 'Active'),
    (3, '4000-3456-7890-1234', 'Debit', 'Tech Solutions LLC', '2023-03-10', '2026-03-10', '345', '3456', 2000.00, 10000.00, 1, 'Active'),
    (4, '4000-4567-8901-2345', 'Debit', 'Emily Rose Carter', '2023-04-05', '2026-04-05', '456', '4567', 1000.00, 4000.00, 0, 'Active'),
    (5, '4000-5678-9012-3456', 'Credit', 'Global Traders Inc', '2023-05-12', '2026-05-12', '567', '5678', 3000.00, 15000.00, 1, 'Active'),
    (6, '4000-6789-0123-4567', 'Debit', 'David Lee Brown', '2023-06-18', '2026-06-18', '678', '6789', 1000.00, 5000.00, 1, 'Active'),
    (7, '4000-7890-1234-5678', 'Credit', 'Lisa Marie Evans', '2023-07-25', '2026-07-25', '789', '7890', 500.00, 2000.00, 0, 'Active'),
    (8, '4000-8901-2345-6789', 'Debit', 'Prime Retail Co', '2023-08-30', '2026-08-30', '890', '8901', 2000.00, 8000.00, 1, 'Active');

-- Insert data into bank.fraud_alerts
INSERT INTO [bank].[fraud_alerts] (
    TransactionID, TriggerReason, SeverityLevel, Status
) VALUES
    ((SELECT TransactionID FROM [bank].[transactions] WHERE AuthorizationCode = 'AUTH1001'), 'Large Transaction', 'Medium', 'Pending'),
    ((SELECT TransactionID FROM [bank].[transactions] WHERE AuthorizationCode = 'AUTH1002'), 'Unusual Location', 'Low', 'Resolved'),
    ((SELECT TransactionID FROM [bank].[transactions] WHERE AuthorizationCode = 'AUTH1003'), 'Rapid Successive Transactions', 'High', 'Investigating'),
    ((SELECT TransactionID FROM [bank].[transactions] WHERE AuthorizationCode = 'AUTH1004'), 'Multiple Failed Attempts', 'Medium', 'Dismissed'),
    ((SELECT TransactionID FROM [bank].[transactions] WHERE AuthorizationCode = 'AUTH1005'), 'Large Transaction', 'Low', 'Resolved'),
    ((SELECT TransactionID FROM [bank].[transactions] WHERE AuthorizationCode = 'AUTH1006'), 'Unusual Location', 'Medium', 'Pending'),
    ((SELECT TransactionID FROM [bank].[transactions] WHERE AuthorizationCode = 'AUTH1007'), 'Multiple Failed Attempts', 'High', 'Investigating'),
    ((SELECT TransactionID FROM [bank].[transactions] WHERE AuthorizationCode = 'AUTH1008'), 'Rapid Successive Transactions', 'Critical', 'Pending');

use BankSystem
 UPDATE [bank].[transactions]
SET [Date] = '2024-09-01 10:00:00'
WHERE AccountID = 1;

 UPDATE [bank].[transactions]
SET [Date] = '2024-08-01 12:30:00'
WHERE AccountID = 2;

 UPDATE [bank].[transactions]
SET [Date] = '2024-07-01 09:15:00'
WHERE AccountID = 3;

 UPDATE [bank].[transactions]
SET [Date] = '2024-06-01 14:45:00'
WHERE AccountID = 4;

 UPDATE [bank].[transactions]
SET [Date] = '2024-05-01 11:20:00'
WHERE AccountID = 5;
