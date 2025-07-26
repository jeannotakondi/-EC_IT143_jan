/* =========================================================
Script: EC_IT143_W4.2_Simpsons_s1_JAN.sql
Author: JAN
Date: 2025-07-26
Purpose: Define the simplest possible question.
-----------------------------------------------------------
Database: (set the correct DB in SSMS before running Step 3+)
Base table: dbo.Planet_Express
Key column: Category (text describing purchase)

Question (final, simple, singular):
How many transactions are "Other-Education" purchases?

Why this is simple:
- Brevity: one metric (count of Other-Education transactions).
- Precision: one table, one exact condition (Category = 'Other-Education').
- Singular focus: no joins, no extra filters, no grouping.
========================================================= */

--Step 3
USE Simpsons
GO
SELECT COUNT(*) AS total_other_education_txns
FROM dbo.Planet_Express
WHERE Category = 'Other-Education';  -- exact match on Category

-- Step 4

CREATE OR ALTER VIEW dbo.v_other_education_txn_count_JAN
AS
SELECT CAST(COUNT(*) AS BIGINT) AS total_other_education_txns
FROM dbo.Planet_Express
WHERE Category = 'Other-Education';
GO

-- Step 5

IF OBJECT_ID('dbo.t_other_education_txn_count_JAN','U') IS NOT NULL
    DROP TABLE dbo.t_other_education_txn_count_JAN;

SELECT *
INTO dbo.t_other_education_txn_count_JAN
FROM dbo.v_other_education_txn_count_JAN;

IF OBJECT_ID('dbo.t_other_education_txn_count_JAN','U') IS NOT NULL
    DROP TABLE dbo.t_other_education_txn_count_JAN;

CREATE TABLE dbo.t_other_education_txn_count_JAN
(
    snapshot_id      INT IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_t_other_education_txn_count_JAN PRIMARY KEY,
    snapshot_utc     DATETIME2(0)      NOT NULL
        CONSTRAINT DF_t_other_education_txn_count_JAN_snapshot_utc
        DEFAULT (SYSUTCDATETIME()),
    total_other_education_txns BIGINT  NOT NULL
);


-- Step 6

TRUNCATE TABLE dbo.t_other_education_txn_count_JAN;

INSERT INTO dbo.t_other_education_txn_count_JAN (total_other_education_txns)
SELECT total_other_education_txns
FROM dbo.v_other_education_txn_count_JAN;

-- Step 7

CREATE OR ALTER PROCEDURE dbo.usp_load_other_education_txn_count_JAN
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE dbo.t_other_education_txn_count_JAN;

    INSERT INTO dbo.t_other_education_txn_count_JAN (total_other_education_txns)
    SELECT total_other_education_txns
    FROM dbo.v_other_education_txn_count_JAN;
END;
GO

-- Step 8

EXEC dbo.usp_load_other_education_txn_count_JAN;