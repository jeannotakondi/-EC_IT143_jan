/*****************************************************************************************************************
NAME:    5.2 Final Project: My Communities Analysis—Create Answers
PURPOSE: My Answers for Simpsons Community

MODIFICATION LOG:
Ver      Date        Author        Description
-----   ----------   -----------   -------------------------------------------------------------------------------
1.0     07/30/2025  Jeannot Akondi       1. Answers script for Simpsons Community Questions


RUNTIME: 
Xm Xs
 
******************************************************************************************************************/
USE Simpsons
GO

-- 5. Total amount spent by Marge and by Homer (Note that Homer has not records in the Costmo table)
SELECT
    Member_Name,
    SUM(Debit) AS TotalSpent
FROM dbo.FBS_Viza_Costmo
WHERE Member_Name IN ('Marge Simpson')
GROUP BY Member_Name;

-- 6. Number of transactions in the "Other-Education" category
USE Simpsons
GO
SELECT
    COUNT(*) AS OtherEducationCount
FROM dbo.Planet_Express
WHERE Category = 'Other-Education';

-- 7. Average transaction amount for each category
USE Simpsons
GO
SELECT
    Category,
    AVG(Amount) AS AvgTransactionAmount
FROM dbo.Planet_Express
GROUP BY Category;

-- 8. Category with the highest total spend and top Card_Member
USE Simpsons
GO
WITH CategoryTotals AS (
    SELECT
        Category,
        SUM(Amount) AS TotalAmount
    FROM dbo.Planet_Express
    GROUP BY Category
),
TopCategory AS (
    SELECT TOP(1)
        Category,
        TotalAmount
    FROM CategoryTotals
    ORDER BY TotalAmount DESC
),
MemberTotals AS (
    SELECT
        pe.Card_Member,
        SUM(pe.Amount) AS MemberSpend
    FROM dbo.Planet_Express AS pe
    JOIN TopCategory AS tc
      ON pe.Category = tc.Category
    GROUP BY pe.Card_Member
)
SELECT
    tc.Category,
    tc.TotalAmount,
    mt.Card_Member,
    mt.MemberSpend
FROM TopCategory AS tc
LEFT JOIN MemberTotals AS mt
  ON 1=1
ORDER BY mt.MemberSpend DESC;
GO
