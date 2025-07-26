/* =========================================================
Script: EC_IT143_W4.2_hello_world_s1_JAN.sql
Author: JAN
Date: 2025-07-26
Purpose: Define the simplest possible question.
-----------------------------------------------------------
Question (final, simple, singular):
How many rows are in dbo.t_w3_schools_customers?

Why this is simple:
- Brevity: a single metric (row count).
- Precision: a single source table.
- Singular focus: no filters, no joins, no breakdowns.

========================================================= */

-- Step 3

SELECT COUNT(*) AS total_rows
FROM dbo.t_w3_schools_customers;

-- Step 4

CREATE OR ALTER VIEW dbo.v_hello_world_count_JAN
AS
SELECT COUNT(*) AS total_rows
FROM dbo.t_w3_schools_customers;
GO

-- Step 5

IF OBJECT_ID('dbo.t_hello_world_count_JAN','U') IS NOT NULL
    DROP TABLE dbo.t_hello_world_count_JAN;

SELECT *
INTO dbo.t_hello_world_count_JAN
FROM dbo.v_hello_world_count_JAN;

IF OBJECT_ID('dbo.t_hello_world_count_JAN','U') IS NOT NULL
    DROP TABLE dbo.t_hello_world_count_JAN;


CREATE TABLE dbo.t_hello_world_count_JAN
(
    snapshot_id   INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_t_hello_world_count_JAN PRIMARY KEY,
    snapshot_utc  DATETIME2(0)      NOT NULL CONSTRAINT DF_t_hello_world_count_JAN_snapshot_utc DEFAULT (SYSUTCDATETIME()),
    total_rows    BIGINT            NOT NULL
);

--Step 6

TRUNCATE TABLE dbo.t_hello_world_count_JAN;

INSERT INTO dbo.t_hello_world_count_JAN (total_rows)
SELECT total_rows
FROM dbo.v_hello_world_count_JAN;

-- Step 7

CREATE PROCEDURE dbo.usp_load_hello_world_count_JAN
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE dbo.t_hello_world_count_JAN;

    INSERT INTO dbo.t_hello_world_count_JAN (total_rows)
    SELECT total_rows
    FROM dbo.v_hello_world_count_JAN;
END;
GO

-- Step 8

EXEC dbo.usp_load_hello_world_count_JAN;

SELECT TOP (6) *
FROM dbo.t_hello_world_count_JAN
ORDER BY snapshot_id DESC;