use BankSystem;
go 
select*from bank.customers
select*from bank.loans
select*from bank.loan_payments
select*from bank.accounts
select*from bank.branches

--1. Retrieve customer details and list their loans by ID or Name
go 
CREATE PROCEDURE CustomerDetails
 @CustomerID INT,
 @CustomerName NVARCHAR(100)
 AS
SELECT 
    c.CustomerID,
    c.FullName,
    c.Email,
    l.LoanID,
    l.PrincipalAmount,
    l.LoanType,
    l.LoanID,
    lp.PaymentDate,
    lp.AmountPaid,
    lp.PaymentMethod
FROM 
    bank.customers c
LEFT JOIN 
    bank.loans l ON c.CustomerID = l.CustomerID
LEFT JOIN 
    bank.loan_payments lp ON l.LoanID = lp.LoanID
WHERE 
    (@CustomerID IS NULL OR c.CustomerID = @CustomerID)
    AND 
    (@CustomerName IS NULL OR c.CustomerID = @CustomerID)
EXEC CustomerDetails @CustomerID=1, @CustomerName = 'John Michael Smith';

--2. List all accounts for a given customer*/
go
CREATE VIEW View_CustomerAccounts AS
SELECT 
    c.CustomerID,
    c.FullName,
    a.AccountID,
    a.AccountNumber,
    a.AccountType,
    a.Balance,
    a.DateOpened
FROM 
    bank.Customers c
INNER JOIN 
    bank.Accounts a ON c.CustomerID = a.CustomerID;
go
SELECT * FROM View_CustomerAccounts WHERE CustomerID = 2;
-- 3.Get Account Count and Total Balance for the Customer*/
go 
create  PROCEDURE GetCustomerAccounts 
    @CustomerID INT
	as
	SELECT 
    c.CustomerID,
    c.FullName,
    COUNT(a.AccountID) AS AccountCount,
    SUM(a.Balance) AS TotalBalance
FROM 
    bank.customers c
INNER JOIN 
    bank.accounts a ON c.CustomerID = a.CustomerID
WHERE 
    c.CustomerID = @CustomerID
GROUP BY 
    c.CustomerID, c.FullName;


exec GetCustomerAccounts  @CustomerID=2

--3. List all customers with their KYC status and risk rating
go
CREATE VIEW View_ComplianceRiskReport AS
SELECT 
    c.CustomerID,
    c.FullName,
    c.Phone,
    c.RiskRating,
    c.KYCStatus
FROM 
    bank.Customers c

WHERE 
    c.KYCStatus != 'Verified'
    OR c.RiskRating = 'High';

SELECT * FROM View_ComplianceRiskReport;

--4. Find business customers with their business details
go
CREATE VIEW bank.BusinessCustomersWithDetails
AS
SELECT 
    c.CustomerID,
    c.FullName,
    c.Email,
    c.Phone,
    c.KYCStatus,
    c.RiskRating,
    c.Occupation,
    c.MonthlyIncome,
    bd.BusinessID,
    bd.BusinessName,
    bd.RegistrationNumber,
    bd.TaxID,
    bd.BusinessType,
    bd.AnnualRevenue
FROM bank.customers c
INNER JOIN bank.business_details bd ON c.CustomerID = bd.CustomerID
WHERE c.CustomerType = 'Business';

SELECT * 
FROM bank.BusinessCustomersWithDetails

--5.Count customers by country and customer type
go
CREATE VIEW CustomerDemographicsByCountry
AS
SELECT 
    Country,
    CustomerType,
    COUNT(*) AS CustomerCount
FROM bank.customers
GROUP BY Country, CustomerType;

select*from CustomerDemographicsByCountry

--6. interest Calculation SP Applies monthly/annual interest to savings accounts.

go 
CREATE PROCEDURE [bank].[ApplyInterest]
    @AccountID INT,
    @InterestRate DECIMAL(5, 2),
    @InterestType NVARCHAR(10) -- 'Monthly' or 'Annual'
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentBalance DECIMAL(15, 2);
    DECLARE @InterestAmount DECIMAL(15, 2);

-- Get current account balance and validate account
    SELECT @CurrentBalance = Balance
    FROM [bank].[accounts]
    WHERE AccountID = @AccountID 
        AND AccountType = 'Savings' 
        AND Status = 'Active';

    -- Check if account exists and is valid
    IF @CurrentBalance IS NULL
    BEGIN
        RAISERROR ('Invalid or inactive savings account.', 16, 1);
        RETURN;
    END

    -- Calculate interest
    IF @InterestType = 'Monthly'
    BEGIN
        -- Calculate monthly interest
        SET @InterestAmount = @CurrentBalance * (@InterestRate / 100) / 12;
    END
    ELSE IF @InterestType = 'Annual'
    BEGIN
        -- Calculate annual interest
        SET @InterestAmount = @CurrentBalance * (@InterestRate / 100);
    END
    ELSE
    BEGIN
        -- Invalid Interest Type
        RAISERROR ('Invalid interest type. Use "Monthly" or "Annual".', 16, 1);
        RETURN;
    END

   
   
   
   -- Update the account balance with the calculated interest
    UPDATE bank.accounts
    SET Balance = @CurrentBalance + @InterestAmount,
        LastActivityDate = SYSDATETIME()
    WHERE AccountID = @AccountID;

    select 'Interest applied successfully.';
END;
 go




--7.Using Window Function :  Accounts with Overdraft Protection and Their Limits
with overdraftranked as (
    select 
        c.customerid,
        c.fullname,
        o.accountid,
        o.limitamount,
        rank() over (order by o.limitamount desc) as riskrank
    from bank.overdrafts o
    join bank.accounts a on o.accountid = a.accountid
    join bank.customers c on a.customerid = c.customerid
)
select *
from overdraftranked
where riskrank <= 5;
go 
--8. Using View : Find dormant accounts with no activity in the last 6 months
go
create or alter view bank.v_dormant_accounts as
select 
    a.accountid, 
    a.accountnumber, 
    a.[status], 
    max(t.[date]) as lasttransactiondate
from bank.accounts a
left join bank.transactions t 
    on a.accountid = t.accountid
group by a.accountid, a.accountnumber, a.[status]
having (max(t.[date]) is null 
        or datediff(month, max(t.[date]), getdate()) >= 6);
go
select * from bank.v_dormant_accounts
go

 
--9. Using Stored Procedure:  for Updating Dormant Accounts
create or alter procedure bank.UpdateDormantAccounts
as
begin
   update bank.accounts
set status = 'Dormant'
where AccountID in (
    select AccountID
    from bank.v_dormant_accounts
    where LastTransactionDate IS NULL 
       OR DATEDIFF(MONTH, LastTransactionDate, GETDATE()) >= 6
);
end;
go 
 
exec bank.UpdateDormantAccounts;
--. Using Window Function : To  Summarize transaction volume by type and branch (monthly)
select 
    t.TransactionType,
    a.BranchID,
    year(t.Date) as Year,
    month(t.Date) as Month,
    sum(t.Amount) over (partition by t.TransactionType, a.BranchID, year(t.Date), month(t.Date)) as TotalVolume
from 
    bank.transactions t
join 
    bank.accounts a on t.AccountID = a.AccountID
order by 
    Year, 
    Month, 
    a.BranchID, 
    t.TransactionType;
go
--10. List transactions with Critical or Medium severityLevel  and their account numbers

select 
    t.TransactionID,
    t.AccountID,
    t.TransactionType,
    t.Amount,
    t.Date,
    t.TransactionStatus,
    f.TriggerReason,
    f.SeverityLevel,
    f.Status as FraudAlertStatus,
    a.AccountNumber
from 
    bank.transactions t
join 
    bank.fraud_alerts f on t.TransactionID = f.TransactionID
join 
    bank.accounts a on t.AccountID = a.AccountID
where 
    f.SeverityLevel IN ('Critical', 'Medium')  -- Filtering for Critical or Medium severity
order by 
    t.Date desc;
go
--11. Get the top 10 largest transactions in the last 30 days
SELECT TOP 10
    t.TransactionID,
    t.AccountID,
    a.AccountNumber,
    c.FullName,
    t.TransactionType,
    t.Amount,
    t.Date,
    t.Description,
    t.TransactionStatus
FROM [bank].[transactions] t
JOIN [bank].[accounts] a ON t.AccountID = a.AccountID
JOIN [bank].[customers] c ON a.CustomerID = c.CustomerID
WHERE t.Date >= DATEADD(DAY, -30, GETDATE())
ORDER BY t.Amount DESC;

-- Generate detailed transaction history for a specific account
-- Replace @AccountID with the desired AccountID
DECLARE @AccountID int = 1; -- Example AccountID

SELECT 
    t.TransactionID,
    t.AccountID,
    a.AccountNumber,
    t.TransactionType,
    t.Amount,
    t.Date,
    t.Description,
    t.AuthorizationCode,
    t.DeviceUsed,
    t.TransactionStatus,
    fa.TriggerReason AS FraudAlertReason,
    fa.SeverityLevel AS FraudAlertSeverity
FROM [bank].[transactions] t
JOIN [bank].[accounts] a ON t.AccountID = a.AccountID
LEFT JOIN [bank].[fraud_alerts] fa ON t.TransactionID = fa.TransactionID
WHERE t.AccountID = @AccountID
ORDER BY t.Date DESC;

-- Identify transactions with high-severity fraud alerts
SELECT 
    t.TransactionID,
    t.AccountID,
    a.AccountNumber,
    c.FullName,
    t.TransactionType,
    t.Amount,
    t.Date,
    fa.TriggerReason,
    fa.SeverityLevel,
    fa.Status AS FraudAlertStatus
FROM [bank].[transactions] t
JOIN [bank].[accounts] a ON t.AccountID = a.AccountID
JOIN [bank].[customers] c ON a.CustomerID = c.CustomerID
JOIN [bank].[fraud_alerts] fa ON t.TransactionID = fa.TransactionID
WHERE fa.SeverityLevel IN ('High', 'Critical')
ORDER BY fa.SeverityLevel DESC, t.Date DESC;

-- List loans with overdue payments
SELECT 
    l.LoanID,
    l.CustomerID,
    c.FullName,
    l.LoanType,
    l.PrincipalAmount,
    l.MonthlyPaymentAmount,
    l.EndDate,
    l.Status,
    MAX(lp.PaymentDate) AS LastPaymentDate,
    DATEDIFF(MONTH, MAX(lp.PaymentDate), GETDATE()) AS MonthsOverdue
FROM [bank].[loans] l
JOIN [bank].[customers] c ON l.CustomerID = c.CustomerID
LEFT JOIN [bank].[loan_payments] lp ON l.LoanID = lp.LoanID
WHERE l.Status = 'Active'
GROUP BY 
    l.LoanID,
    l.CustomerID,
    c.FullName,
    l.LoanType,
    l.PrincipalAmount,
    l.MonthlyPaymentAmount,
    l.EndDate,
    l.Status
HAVING 
    DATEDIFF(MONTH, MAX(lp.PaymentDate), GETDATE()) > 1
    OR MAX(lp.PaymentDate) IS NULL
ORDER BY MonthsOverdue DESC;


-- Create a trigger to flag negative balances and abnormally high withdrawals
go
--12.Get the top 10 largest transactions in the last 30 days
SELECT TOP 10
    t.TransactionID,
    t.AccountID,
    a.AccountNumber,
    c.FullName,
    t.TransactionType,
    t.Amount,
    t.Date,
    t.Description,
    t.TransactionStatus
FROM [bank].[transactions] t
JOIN [bank].[accounts] a ON t.AccountID = a.AccountID
JOIN [bank].[customers] c ON a.CustomerID = c.CustomerID
WHERE t.Date >= DATEADD(DAY, -30, GETDATE())
ORDER BY t.Amount DESC;

-- 13.Generate detailed transaction history for a specific account
-- Replace @AccountID with the desired AccountID
DECLARE @AccountID int = 1; -- Example AccountID

SELECT 
    t.TransactionID,
    t.AccountID,
    a.AccountNumber,
    t.TransactionType,
    t.Amount,
    t.Date,
    t.Description,
    t.AuthorizationCode,
    t.DeviceUsed,
    t.TransactionStatus,
    fa.TriggerReason AS FraudAlertReason,
    fa.SeverityLevel AS FraudAlertSeverity
FROM [bank].[transactions] t
JOIN [bank].[accounts] a ON t.AccountID = a.AccountID
LEFT JOIN [bank].[fraud_alerts] fa ON t.TransactionID = fa.TransactionID
WHERE t.AccountID = @AccountID
ORDER BY t.Date DESC;

--14. Identify transactions with high-severity fraud alerts
SELECT 
    t.TransactionID,
    t.AccountID,
    a.AccountNumber,
    c.FullName,
    t.TransactionType,
    t.Amount,
    t.Date,
    fa.TriggerReason,
    fa.SeverityLevel,
    fa.Status AS FraudAlertStatus
FROM [bank].[transactions] t
JOIN [bank].[accounts] a ON t.AccountID = a.AccountID
JOIN [bank].[customers] c ON a.CustomerID = c.CustomerID
JOIN [bank].[fraud_alerts] fa ON t.TransactionID = fa.TransactionID
WHERE fa.SeverityLevel IN ('High', 'Critical')
ORDER BY fa.SeverityLevel DESC, t.Date DESC;

--15.List loans with overdue payments
SELECT 
    l.LoanID,
    l.CustomerID,
    c.FullName,
    l.LoanType,
    l.PrincipalAmount,
    l.MonthlyPaymentAmount,
    l.EndDate,
    l.Status,
    MAX(lp.PaymentDate) AS LastPaymentDate,
    DATEDIFF(MONTH, MAX(lp.PaymentDate), GETDATE()) AS MonthsOverdue
FROM [bank].[loans] l
JOIN [bank].[customers] c ON l.CustomerID = c.CustomerID
LEFT JOIN [bank].[loan_payments] lp ON l.LoanID = lp.LoanID
WHERE l.Status = 'Active'
GROUP BY 
    l.LoanID,
    l.CustomerID,
    c.FullName,
    l.LoanType,
    l.PrincipalAmount,
    l.MonthlyPaymentAmount,
    l.EndDate,
    l.Status
HAVING 
    DATEDIFF(MONTH, MAX(lp.PaymentDate), GETDATE()) > 1
    OR MAX(lp.PaymentDate) IS NULL
ORDER BY MonthsOverdue DESC;


--16.Create a trigger to flag negative balances and abnormally high withdrawals
go
CREATE TRIGGER [bank].[FraudOverdrawnTrigger]
ON [bank].[transactions]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ThresholdMultiplier decimal(5,2) = 3.0; -- Flag withdrawals 3x higher than average

    -- Flag negative balances
    INSERT INTO [bank].[fraud_alerts] (
        TransactionID,
        TriggerReason,
        SeverityLevel,
        Status
    )
    SELECT 
        i.TransactionID,
        'Negative Balance' AS TriggerReason,
        'High' AS SeverityLevel,
        'Pending' AS Status
    FROM inserted i
    JOIN [bank].[accounts] a ON i.AccountID = a.AccountID
    WHERE a.Balance < 0;

    -- Flag abnormally high withdrawals
    INSERT INTO [bank].[fraud_alerts] (
        TransactionID,
        TriggerReason,
        SeverityLevel,
        Status
    )
    SELECT 
        i.TransactionID,
        'Abnormally High Withdrawal' AS TriggerReason,
        'Medium' AS SeverityLevel,
        'Pending' AS Status
    FROM inserted i
    JOIN [bank].[accounts] a ON i.AccountID = a.AccountID
    CROSS APPLY (
        SELECT AVG(Amount) AS AvgWithdrawal
        FROM [bank].[transactions]
        WHERE AccountID = i.AccountID
            AND TransactionType = 'Withdrawal'
            AND Date >= DATEADD(DAY, -90, GETDATE())
            AND TransactionStatus = 'Completed'
    ) avg_w
    WHERE i.TransactionType = 'Withdrawal'
        AND i.Amount > (avg_w.AvgWithdrawal * @ThresholdMultiplier);
END;





--17 . 
go
CREATE TRIGGER [bank].[FraudOverdrawnTrigger]
ON [bank].[transactions]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ThresholdMultiplier decimal(5,2) = 3.0; -- Flag withdrawals 3x higher than average

    -- Flag negative balances
    INSERT INTO [bank].[fraud_alerts] (
        TransactionID,
        TriggerReason,
        SeverityLevel,
        Status
    )
    SELECT 
        i.TransactionID,
        'Negative Balance' AS TriggerReason,
        'High' AS SeverityLevel,
        'Pending' AS Status
    FROM inserted i
    JOIN [bank].[accounts] a ON i.AccountID = a.AccountID
    WHERE a.Balance < 0;

    -- Flag abnormally high withdrawals
    INSERT INTO [bank].[fraud_alerts] (
        TransactionID,
        TriggerReason,
        SeverityLevel,
        Status
    )
    SELECT 
        i.TransactionID,
        'Abnormally High Withdrawal' AS TriggerReason,
        'Medium' AS SeverityLevel,
        'Pending' AS Status
    FROM inserted i
    JOIN [bank].[accounts] a ON i.AccountID = a.AccountID
    CROSS APPLY (
        SELECT AVG(Amount) AS AvgWithdrawal
        FROM [bank].[transactions]
        WHERE AccountID = i.AccountID
            AND TransactionType = 'Withdrawal'
            AND Date >= DATEADD(DAY, -90, GETDATE())
            AND TransactionStatus = 'Completed'
    ) avg_w
    WHERE i.TransactionType = 'Withdrawal'
        AND i.Amount > (avg_w.AvgWithdrawal * @ThresholdMultiplier);
END;
go 

--



CREATE VIEW bank.vw_CustomerLoanExposure
AS
SELECT 
    c.CustomerID,
    c.FullName,
    COUNT(l.LoanID) AS TotalLoans,
    SUM(lp.RemainingBalance) AS TotalOutstandingBalance
FROM bank.customers c
LEFT JOIN bank.loans l ON c.CustomerID = l.CustomerID
LEFT JOIN bank.loan_payments lp ON l.LoanID = lp.LoanID
WHERE l.Status = 'Active' AND lp.Status = 'Completed'
GROUP BY c.CustomerID, c.FullName
HAVING SUM(lp.RemainingBalance) > 0;
GO
-- العملاء اللي رصيدهم المستحق أكتر من 10000
SELECT * FROM bank.vw_CustomerLoanExposure WHERE TotalOutstandingBalance > 10000;

go
CREATE PROCEDURE bank.sp_ListCardsNearingExpiry
    @DaysUntilExpiry int = 30
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        c.CardID,
        c.CardNumber,
        c.CardHolderName,
        c.ExpiryDate,
        a.AccountNumber,
        cu.FullName,
        cu.Email
    FROM bank.cards c
    JOIN bank.accounts a ON c.AccountID = a.AccountID
    JOIN bank.customers cu ON a.CustomerID = cu.CustomerID
    WHERE c.Status = 'Active'
    AND c.ExpiryDate <= DATEADD(DAY, @DaysUntilExpiry, CAST(GETDATE() AS date))
    AND c.ExpiryDate >= CAST(GETDATE() AS date)
    ORDER BY c.ExpiryDate;
END;
GO
select GetDate()
-- default 30 Days
EXEC bank.sp_ListCardsNearingExpiry;
-- 60 Days
EXEC bank.sp_ListCardsNearingExpiry @DaysUntilExpiry = 60;
go

CREATE PROCEDURE bank.sp_ListLowCashATMs
    @CashBalanceThreshold decimal(15,2) = 5000
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        a.ATMID,
        b.BranchName,
        a.LocationLat,
        a.LocationLong,
        a.CashBalance,
        a.LastMaintenanceDate
    FROM bank.atms a
    JOIN bank.branches b ON a.BranchID = b.BranchID
    WHERE a.CashBalance < @CashBalanceThreshold
    ORDER BY a.CashBalance ASC;
END;
GO

--To use the default threshold (5000):
EXEC bank.sp_ListLowCashATMs;

--To specify a different threshold 10,000:
EXEC bank.sp_ListLowCashATMs @CashBalanceThreshold = 10000;

go
CREATE PROCEDURE bank.sp_AnalyzeATMTransactionVolume
    @StartDate date,
    @EndDate date
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        a.ATMID,
        b.BranchName,
        a.LocationLat,
        a.LocationLong,
        COUNT(t.TransactionID) AS TransactionCount,
        SUM(t.Amount) AS TotalTransactionAmount
    FROM bank.atms a
    JOIN bank.branches b ON a.BranchID = b.BranchID
    LEFT JOIN bank.transactions t ON a.ATMID = t.AtmID
    WHERE t.Date BETWEEN @StartDate AND @EndDate
    AND t.TransactionStatus = 'Completed'
    GROUP BY a.ATMID, b.BranchName, a.LocationLat, a.LocationLong
    ORDER BY TransactionCount DESC;
END;
GO
--
EXEC bank.sp_AnalyzeATMTransactionVolume @StartDate = '2025-01-01', @EndDate = '2025-03-31';

