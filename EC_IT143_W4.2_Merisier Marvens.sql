/*****************************************************************************************************************
NAME:    EC_IT143_W4.2_EPL_s4_mm.sql


MODIFICATION LOG:
Ver      Date        Author        Description
-----   ----------   -----------   -------------------------------------------------------------------------------
1.0     09/27/2026   MM      1. Built this script for EC IT440


RUNTIME: 
Xm Xs

NOTES: 
This is where I talk about what this script is, why I built it, and other stuff...
 
******************************************************************************************************************/

-- Step 1: Start with a question
-- Question: How many total goals did each team score at home?

-- ---------------------------------------------------------------------
-- Step 2: Begin creating an answer

-- ---------------------------------------------------------------------
-- A: Group the FTHG (Full Time Home Goals) column
--                      by HomeTeam.
-- A: Sum the goals for each team to get the total.


-- ---------------------------------------------------------------------
-- Step 3: Create an ad hoc SQL query

SELECT
    HomeTeam,
    SUM(FTHG) AS TotalHomeGoals
FROM [dbo].[epl_results_2022-23]
GROUP BY HomeTeam;


-- ---------------------------------------------------------------------
-- Step 4: Turn the ad hoc SQL query into a view

CREATE VIEW vw_EPL_TotalHomeGoals AS
SELECT
    HomeTeam,
    SUM(FTHG) AS TotalHomeGoals
FROM [dbo].[epl_results_2022-23]
GROUP BY HomeTeam;
GO

-- ---------------------------------------------------------------------
-- Step 5.1: Turn the view into a table

SELECT *
INTO tbl_EPL_TotalHomeGoals
FROM vw_EPL_TotalHomeGoals;

-- ---------------------------------------------------------------------
-- Step 5.2: Refine the table architecture

DROP TABLE IF EXISTS tbl_EPL_TotalHomeGoals;

CREATE TABLE tbl_EPL_TotalHomeGoals (
    HomeTeam        VARCHAR(50) NOT NULL PRIMARY KEY,
    TotalHomeGoals  INT         NOT NULL DEFAULT 0
);


-- ---------------------------------------------------------------------
-- Step 6: Load the table from the view using an ad hoc SQL script

TRUNCATE TABLE tbl_EPL_TotalHomeGoals;

INSERT INTO tbl_EPL_TotalHomeGoals (HomeTeam, TotalHomeGoals)
SELECT HomeTeam, TotalHomeGoals
FROM vw_EPL_TotalHomeGoals;

-- ---------------------------------------------------------------------
-- Step 7: Turn the ad hoc SQL script into a stored procedure

CREATE PROCEDURE sp_LoadEPL_TotalHomeGoals
AS
BEGIN
    TRUNCATE TABLE tbl_EPL_TotalHomeGoals;

    INSERT INTO tbl_EPL_TotalHomeGoals (HomeTeam, TotalHomeGoals)
    SELECT HomeTeam, TotalHomeGoals
    FROM vw_EPL_TotalHomeGoals;
END;
GO

-- ---------------------------------------------------------------------
-- Step 8: Call the stored procedure

EXEC sp_LoadEPL_TotalHomeGoals;



/* =====================================================================
   COMMUNITY 2: NBA
   Data set: dbo.NBA
   Question: What is the total number of points scored by each team?
   ===================================================================== */

-- ---------------------------------------------------------------------
-- Step 1: Start with a question
-- ---------------------------------------------------------------------
-- Question: What is the total number of points scored by each team?


-- ---------------------------------------------------------------------
-- Step 2: Begin creating an answer
-- ---------------------------------------------------------------------
-- 1 sub-answer: Group the Total column (team points per game)
--                      by Team.
-- 2 sub-answer: Sum the Total column for each team to get the
--                      season total points.


-- ---------------------------------------------------------------------
-- Step 3: Create an ad hoc SQL query

SELECT
    Team,
    SUM(Total) AS TotalPoints
FROM [dbo].[NBA]
GROUP BY Team;


-- ---------------------------------------------------------------------

-- Step 4: Turn the ad hoc SQL query into a view
CREATE VIEW vw_NBA_TotalPoints AS
SELECT
    Team,
    SUM(Total) AS TotalPoints
FROM [dbo].[NBA]
GROUP BY Team;
GO


-- ---------------------------------------------------------------------
-- Step 5.1: Turn the view into a table

-- ---------------------------------------------------------------------
SELECT *
INTO tbl_NBA_TotalPoints
FROM vw_NBA_TotalPoints;


-- ---------------------------------------------------------------------
-- Step 5.2: Refine the table architecture

DROP TABLE IF EXISTS tbl_NBA_TotalPoints;

CREATE TABLE tbl_NBA_TotalPoints (
    Team         VARCHAR(50) NOT NULL PRIMARY KEY,
    TotalPoints  INT         NOT NULL DEFAULT 0
);


-- ---------------------------------------------------------------------
-- Step 6: Load the table from the view using an ad hoc SQL script

-- ---------------------------------------------------------------------
TRUNCATE TABLE tbl_NBA_TotalPoints;

INSERT INTO tbl_NBA_TotalPoints (Team, TotalPoints)
SELECT Team, TotalPoints
FROM vw_NBA_TotalPoints;


-- ---------------------------------------------------------------------
-- Step 7: Turn the ad hoc SQL script into a stored procedure

-- Purpose: Refreshes tbl_NBA_TotalPoints with the latest data from
--          vw_NBA_TotalPoints.

CREATE PROCEDURE sp_LoadNBA_TotalPoints
AS
BEGIN
    TRUNCATE TABLE tbl_NBA_TotalPoints;

    INSERT INTO tbl_NBA_TotalPoints (Team, TotalPoints)
    SELECT Team, TotalPoints
    FROM vw_NBA_TotalPoints;
END;
GO

-- ---------------------------------------------------------------------

-- Step 8: Call the stored procedure

EXEC sp_LoadNBA_TotalPoints;
