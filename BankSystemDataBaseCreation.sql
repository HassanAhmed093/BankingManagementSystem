CREATE DATABASE BankSystem
GO
USE BankSystem
GO
CREATE SCHEMA [bank]
GO

CREATE TABLE [bank].[customers] (
  [CustomerID] int PRIMARY KEY IDENTITY(1, 1),
  [FullName] nvarchar(255) NOT NULL,
  [DateOfBirth] date,
  [Email] nvarchar(255) UNIQUE NOT NULL,
  [Phone] nvarchar(20),
  [Street] NVARCHAR(100) NOT NULL,
  [City] NVARCHAR(50) NOT NULL,
  [State] NVARCHAR(50) NOT NULL,
  [Zip] NVARCHAR(20) NOT NULL,
  [Country] NVARCHAR(50) NOT NULL,
  [NationalID] nvarchar(50) UNIQUE,
  [CustomerType] nvarchar(20) NOT NULL,
  [RiskRating] nvarchar(10) NOT NULL,
  [KYCStatus] nvarchar(20) NOT NULL 
  CHECK (KYCStatus IN (
  'Pending', 'In Review', 'Verified', 'Rejected', 'Expired', 'Blocked'
)),
  [Occupation] nvarchar(100),
  [MonthlyIncome] decimal(12,2),
  [DateCreated] datetime2 NOT NULL DEFAULT (SYSDATETIME()),
  [LastUpdated] datetime2 NOT NULL DEFAULT (SYSDATETIME())
)
GO

CREATE TABLE [bank].[business_details] (
  [BusinessID] int not null,
  [CustomerID] int not null,
  [BusinessName] nvarchar(255) NOT NULL,
  [RegistrationNumber] nvarchar(100) UNIQUE,
  [TaxID] nvarchar(100) UNIQUE,
  [BusinessType] nvarchar(50) NOT NULL CHECK (BusinessType IN ('LLC', 'Corporation', 'Sole Proprietorship')),
  [AnnualRevenue] decimal(15,2),
  PRIMARY KEY (CustomerID, [BusinessID])
   
)
GO

CREATE TABLE [bank].[branches] (
  [BranchID] int PRIMARY KEY IDENTITY(1, 1),
  [BranchName] nvarchar(255) NOT NULL,
  [Street] NVARCHAR(100) NOT NULL,
  [City] NVARCHAR(50) NOT NULL,
  [State] NVARCHAR(50) NOT NULL,
  [Zip] NVARCHAR(20) NOT NULL,
  [Country] NVARCHAR(50) NOT NULL,
  [Phone] nvarchar(20),
  [ManagerID] int
)
GO

CREATE TABLE [bank].[employees] (
  [EmployeeID] int PRIMARY KEY IDENTITY(1, 1),
  [BranchID] int NOT NULL,
  [Street] NVARCHAR(100) NOT NULL,
  [City] NVARCHAR(50) NOT NULL,
  [State] NVARCHAR(50) NOT NULL,
  [Zip] NVARCHAR(20) NOT NULL,
  [Country] NVARCHAR(50) NOT NULL,
  [DateOfBirth] date CHECK (DateOfBirth <= GETDATE() AND DATEDIFF(YEAR, DateOfBirth, GETDATE()) >= 18),  
  [Email] nvarchar(255) UNIQUE NOT NULL,
  [Phone] nvarchar(20),
  [Salary] decimal(12,2),
  [FullName] nvarchar(255) NOT NULL,
  [Position] nvarchar(100) NOT NULL,
  [Department] nvarchar(50) NOT NULL,
   [AccessLevel] nvarchar(20) NOT NULL CHECK (AccessLevel IN ('Admin', 'Manager', 'Employee', 'Support')) 

)
GO

CREATE TABLE [bank].[accounts] (
  [AccountID] int PRIMARY KEY IDENTITY(1, 1),
  [CustomerID] int NOT NULL,
  [BranchID] int NOT NULL,
  [AccountNumber] nvarchar(34) UNIQUE NOT NULL,
  [AccountType] nvarchar(50) NOT NULL CHECK (AccountType IN ('Savings', 'Checking', 'Business', 'Fixed Deposit')),
  [Balance] decimal(15,2) NOT NULL,
  [CurrencyType] char(3) NOT NULL,
  [MinimumBalance] decimal(15,2),
  [InterestRate] decimal(5,2),
  [OverdraftProtection] bit NOT NULL DEFAULT (0),
  [OnlineBankingEnabled] bit NOT NULL DEFAULT (1),
  [Status] nvarchar(20) NOT NULL CHECK (Status IN ('Active', 'Dormant', 'Closed')),
  [DateOpened] date NOT NULL,
  [LastActivityDate] datetime2
)
GO

CREATE TABLE [bank].[transactions] (
  [TransactionID] uniqueidentifier PRIMARY KEY DEFAULT (NEWID()),
  [AccountID] int NOT NULL,
  [AtmID] int NOT NULL,
  [TransactionType] nvarchar(50) NOT NULL  CHECK (TransactionType IN ('Deposit', 'Withdrawal', 'Transfer', 'Bill Payment')),

  [Amount] decimal(12,2) NOT NULL,
  [Date] datetime2 NOT NULL,
  [Description] nvarchar(max),
  [AuthorizationCode] nvarchar(100),
  [DeviceUsed] nvarchar(20)  CHECK (DeviceUsed IN ('ATM', 'Online', 'Mobile', 'Branch')),

  [TransactionStatus] nvarchar(20) NOT NULL  CHECK (TransactionStatus IN ('Completed', 'Pending', 'Failed'))

)
GO

CREATE TABLE [bank].[overdrafts] (
  [OverdraftID] int not null,
  [AccountID] int not null ,
  [LimitAmount] decimal(10,2),
  [InterestRate] decimal(5,2),
  [ApprovalDate] date NOT NULL,
  [ExpiryDate] date,
  PRIMARY KEY ([AccountID], [OverdraftID])
)
GO

CREATE TABLE [bank].[loans] (
  [LoanID] int PRIMARY KEY IDENTITY(1, 1),
  [EmployeeID] int NOT NULL,
  [CustomerID] int NOT NULL,
  [LoanType] nvarchar(50) NOT NULL CHECK (LoanType IN ('Personal', 'Mortgage', 'Auto', 'Education', 'Business')), 
  [PrincipalAmount] decimal(12,2) NOT NULL,
  [InterestRate] decimal(5,2) NOT NULL,
  [TermMonths] int NOT NULL,
  [MonthlyPaymentAmount] decimal(10,2) NOT NULL,
  [StartDate] date NOT NULL,
  [EndDate] date NOT NULL,
  [CollateralDescription] nvarchar(max),
  [CollateralValue] decimal(12,2),
  [Status] nvarchar(20) NOT NULL CHECK (Status IN ('Active', 'Paid', 'Defaulted'))
)
GO

CREATE TABLE [bank].[loan_payments] (
  
  [LoanID] int NOT NULL,
  [PaymentDate] datetime2 NOT NULL,
  [AmountPaid] decimal(10,2) NOT NULL,
  [RemainingBalance] decimal(12,2) NOT NULL,
  [PaymentMethod] nvarchar(50) NOT NULL  CHECK ([PaymentMethod] IN ('Bank Transfer', 'Cash', 'Check')),
  [Status] nvarchar(20) NOT NULL  CHECK ([Status] IN  ('Completed', 'Pending', 'Failed')),
  PRIMARY KEY ([LoanID], [PaymentDate])
)
GO

CREATE TABLE [bank].[cards] (
  [CardID] int PRIMARY KEY IDENTITY(1, 1),
  [AccountID] int NOT NULL,
  [CardNumber] nvarchar(50) UNIQUE NOT NULL,
  [CardType] nvarchar(20) NOT NULL    CHECK ([CardType] IN ('Debit', 'Credit', 'Prepaid')),
  [CardHolderName] nvarchar(255) NOT NULL,
  [IssueDate] date NOT NULL,
  [ExpiryDate] date NOT NULL,
  [CVV] nvarchar(4) NOT NULL,
  [PIN] nvarchar(255) NOT NULL,
  [DailyWithdrawalLimit] decimal(8,2),
  [DailyPurchaseLimit] decimal(8,2),
  [ContactlessEnabled] bit NOT NULL DEFAULT (0),
  [Status] nvarchar(20) NOT NULL CHECK ([Status] IN ('Active', 'Blocked', 'Expired', 'Cancelled'))
)
GO

CREATE TABLE [bank].[fraud_alerts] (
  [TransactionID] uniqueidentifier PRIMARY KEY NOT NULL,
  [TriggerReason] nvarchar(50) NOT NULL CHECK ([TriggerReason] IN (
      'Unusual Location',
      'Large Transaction',
      'Multiple Failed Attempts',
      'Rapid Successive Transactions'
    )), 
  [SeverityLevel] nvarchar(20) NOT NULL CHECK ([SeverityLevel] IN ('Low', 'Medium', 'High', 'Critical')),
  [Status] nvarchar(20) NOT NULL  CHECK ([Status] IN ('Pending', 'Investigating', 'Resolved', 'Dismissed'))
)
GO

CREATE TABLE [bank].[atms] (
  [ATMID] int PRIMARY KEY IDENTITY(1, 1),
  [BranchID] int NOT NULL,
  [LocationLat] decimal(9,6) NOT NULL,
  [LocationLong] decimal(9,6) NOT NULL,
  [CashBalance] decimal(15,2) NOT NULL,
  [LastMaintenanceDate] date
)
GO
ALTER TABLE [bank].[business_details] ADD FOREIGN KEY ([CustomerID]) REFERENCES [bank].[customers] ([CustomerID])
GO

ALTER TABLE [bank].[employees] ADD FOREIGN KEY ([BranchID]) REFERENCES [bank].[branches] ([BranchID])
GO

ALTER TABLE [bank].[accounts] ADD FOREIGN KEY ([CustomerID]) REFERENCES [bank].[customers] ([CustomerID])
GO

ALTER TABLE [bank].[accounts] ADD FOREIGN KEY ([BranchID]) REFERENCES [bank].[branches] ([BranchID])
GO

ALTER TABLE [bank].[transactions] ADD FOREIGN KEY ([AccountID]) REFERENCES [bank].[accounts] ([AccountID])
GO

ALTER TABLE [bank].[transactions] ADD FOREIGN KEY ([AtmID]) REFERENCES [bank].[atms] ([ATMID])
GO

ALTER TABLE [bank].[overdrafts] ADD FOREIGN KEY ([AccountID]) REFERENCES [bank].[accounts] ([AccountID])
GO

ALTER TABLE [bank].[loans] ADD FOREIGN KEY ([EmployeeID]) REFERENCES [bank].[employees] ([EmployeeID])
GO

ALTER TABLE [bank].[loans] ADD FOREIGN KEY ([CustomerID]) REFERENCES [bank].[customers] ([CustomerID])
GO

ALTER TABLE [bank].[loan_payments] ADD FOREIGN KEY ([LoanID]) REFERENCES [bank].[loans] ([LoanID])
GO

ALTER TABLE [bank].[cards] ADD FOREIGN KEY ([AccountID]) REFERENCES [bank].[accounts] ([AccountID])
GO

ALTER TABLE [bank].[fraud_alerts] ADD FOREIGN KEY ([TransactionID]) REFERENCES [bank].[transactions] ([TransactionID])
GO

ALTER TABLE [bank].[atms] ADD FOREIGN KEY ([BranchID]) REFERENCES [bank].[branches] ([BranchID])
GO

ALTER TABLE [bank].[branches] ADD FOREIGN KEY ([ManagerID]) REFERENCES [bank].[employees] ([EmployeeID])
GO
 