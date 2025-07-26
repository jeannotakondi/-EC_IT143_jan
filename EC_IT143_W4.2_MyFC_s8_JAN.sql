/* =========================================================
Script: EC_IT143_W4.2_MyFC_s1_JAN.sql
Author: JAN
Date: 2025-07-26
Purpose: Define the simplest possible question.
-----------------------------------------------------------
Database: MyFC
Base table: dbo.tblPlayerDim
Key column: p_id (position id), where 3 = midfielder

Question (final, simple, singular):
How many players are midfielders?

Why this is simple:
- Brevity: one metric (count of midfielders).
- Precision: one source table and one condition (p_id = 3).
- Singular focus: no joins, no extra filters, no breakdowns.

========================================================= */
USE MyFC;
GO

-- Step 3
USE MyFC
GO
SELECT COUNT(*) AS total_midfielders
FROM dbo.tblPlayerDim
WHERE p_id = 3;   -- 3 = midfielder

-- Step 4
USE MyFC
GO
CREATE OR ALTER VIEW dbo.v_midfielder_count_JAN
AS
SELECT CAST(COUNT(*) AS BIGINT) AS total_midfielders
FROM dbo.tblPlayerDim
WHERE p_id = 3;   -- 3 = midfielder
GO

-- Step 5
USE MyFC
GO
IF OBJECT_ID('dbo.t_midfielder_count_JAN','U') IS NOT NULL
    DROP TABLE dbo.t_midfielder_count_JAN;

USE MyFC
GO
SELECT *
INTO dbo.t_midfielder_count_JAN
FROM dbo.v_midfielder_count_JAN;

USE MyFC
GO
IF OBJECT_ID('dbo.t_midfielder_count_JAN','U') IS NOT NULL
    DROP TABLE dbo.t_midfielder_count_JAN;

USE MyFC
GO
CREATE TABLE dbo.t_midfielder_count_JAN
(
    snapshot_id    INT IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_t_midfielder_count_JAN PRIMARY KEY,
    snapshot_utc   DATETIME2(0)      NOT NULL
        CONSTRAINT DF_t_midfielder_count_JAN_snapshot_utc
        DEFAULT (SYSUTCDATETIME()),
    total_midfielders BIGINT         NOT NULL
);

-- Step 6
USE MyFC
GO
TRUNCATE TABLE dbo.t_midfielder_count_JAN;
USE MyFC
GO
INSERT INTO dbo.t_midfielder_count_JAN (total_midfielders)
SELECT total_midfielders
FROM dbo.v_midfielder_count_JAN;

-- Step 7

USE MyFC
GO
CREATE OR ALTER PROCEDURE dbo.usp_load_midfielder_count_JAN
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE dbo.t_midfielder_count_JAN;

    INSERT INTO dbo.t_midfielder_count_JAN (total_midfielders)
    SELECT total_midfielders
    FROM dbo.v_midfielder_count_JAN;
END;
GO

-- Step 8
USE MyFC
GO
EXEC dbo.usp_load_midfielder_count_JAN;