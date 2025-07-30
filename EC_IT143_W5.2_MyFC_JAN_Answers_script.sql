/*****************************************************************************************************************
NAME:    5.2 Final Project: My Communities Analysis—Create Answers
PURPOSE: My Answers for MyFC Community

MODIFICATION LOG:
Ver      Date        Author        Description
-----   ----------   -----------   -------------------------------------------------------------------------------
1.0     07/30/2025  Jeannot Akondi       1. Answers script for MyFc Community Questions


RUNTIME: 
Xm Xs
 
******************************************************************************************************************/
USE MyFC
GO

-- 1. How many players are midfielders?
DECLARE @MidfielderID INT = 9;
SELECT
    COUNT(*) AS MidfielderCount
FROM dbo.tblPlayerDim
WHERE p_id = @MidfielderID;
GO

-- 2. How many players do we have at each position?
SELECT p_id            AS Position,
       COUNT(*)        AS PlayerCount
FROM dbo.tblPlayerDim
GROUP BY p_id;
GO

-- 3. What percentage of the squad are midfielders?
USE MyFC
DECLARE @MidfielderID INT = 9;
SELECT
    COUNT(CASE WHEN p_id = @MidfielderID THEN 1 END)                     AS MidfielderCount,
    COUNT(*)                                                            AS TotalPlayers,
    COUNT(CASE WHEN p_id = @MidfielderID THEN 1 END) * 100.0 / COUNT(*) AS MidfielderPercentage
FROM dbo.tblPlayerDim;

-- 4. For each player position, what is the average month-to-date salary across all dates?
USE MyFC
SELECT d.p_id               AS Position,
       AVG(f.mtd_salary)   AS AvgMTDSalary
FROM dbo.tblPlayerFact AS f
JOIN dbo.tblPlayerDim  AS d
  ON f.pl_id = d.pl_id
GROUP BY d.p_id;
GO
