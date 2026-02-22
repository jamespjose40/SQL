
/* 1.Create a database named employee, then import data_science_team.csv proj_table.csv and
 emp_record_table.csv into the employee database from the given resources. */

CREATE DATABASE employee;
USE employee;

DROP TABLE IF EXISTS emp_record_table;
CREATE TABLE emp_record_table (
EMP_ID VARCHAR(10) NOT NULL,			-- ID of the employee
FIRST_NAME VARCHAR(50) DEFAULT NULL,	-- First name of the employee
LAST_NAME VARCHAR(50) DEFAULT NULL,		-- Last name of the employee
GENDER VARCHAR(1) DEFAULT NULL,			-- Gender of the employee
ROLE VARCHAR(50) DEFAULT NULL, 			-- Post of the employee
DEPT VARCHAR(50) DEFAULT NULL,			-- Field of the employee
EXP INT DEFAULT NULL,					-- Years of experience the employee has
COUNTRY VARCHAR(50) DEFAULT NULL,		-- Country in which the employee is presently living
CONTINENT VARCHAR(50) DEFAULT NULL,		-- Continent in which the country is
SALARY INT DEFAULT NULL, 				-- Salary of the employee
EMP_RATING INT DEFAULT NULL,			-- Performance rating of the employee
MANAGER_ID VARCHAR(10) DEFAULT NULL,	-- The manager under which the employee is assigned 
PROJ_ID VARCHAR(10) DEFAULT NULL, 		-- The project on which the employee is working or has worked on

PRIMARY KEY (EMP_ID)
);

DESCRIBE emp_record_table;
SELECT * FROM emp_record_table;			-- Import from emp_record_table.csv


DROP TABLE IF EXISTS proj_table;
CREATE TABLE proj_table (
PROJECT_ID VARCHAR(10) NOT NULL, 		-- ID for the project
PROJ_Name VARCHAR(50) DEFAULT NULL,		-- Name of the project
DOMAIN VARCHAR(50) DEFAULT NULL,		-- Field of the project
START_DATE DATE DEFAULT NULL,			-- Day the project began
CLOSURE_DATE DATE DEFAULT NULL,			-- Day the project was or will be completed
DEV_QTR VARCHAR(2) DEFAULT NULL,		-- Quarter in which the project was scheduled
STATUS VARCHAR(50) DEFAULT NULL		-- Status of the project currently
);

DESCRIBE proj_table;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Data/employee/1643891559_performance_mapping_datasets/proj_table.csv' 
INTO TABLE proj_table   
FIELDS TERMINATED BY ','  
OPTIONALLY ENCLOSED BY '"'  
LINES TERMINATED BY '\n'   
IGNORE 1 ROWS
(DOMAIN, @DATE, @DATE, DEV_QTR)
SET START_DATE = STR_TO_DATE(@DATE, '%m/%d/%Y'), CLOSURE_DATE = STR_TO_DATE(@Date, '%m/%d/%Y');  

SELECT *  FROM proj_table;




CREATE TABLE data_science_team (
EMP_ID VARCHAR(10) NOT NULL,			-- ID of the employee
FIRST_NAME VARCHAR(50) DEFAULT NULL, 	-- First name of the employee
LAST_NAME VARCHAR(50) DEFAULT NULL,		-- Last name of the employee
GENDER VARCHAR(1) DEFAULT NULL,			-- Gender of the employee
ROLE VARCHAR(50) DEFAULT NULL,			-- Post of the employee
DEPT VARCHAR(50) DEFAULT NULL,			-- Field of the employee
EXP INT DEFAULT NULL,					-- Years of experience the employee has
COUNTRY VARCHAR(50) DEFAULT NULL,		-- Country in which the employee is presently living
CONTINENT VARCHAR(50) DEFAULT NULL,		-- Continent in which the country is
PRIMARY KEY (EMP_ID)
);

DESCRIBE data_science_team;
SELECT * FROM data_science_team;


-- 2. Create an ER diagram for the given employee database.

/*3.	Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the 
employee record table, and make a list of employees and details of their department. */

@@ -21,138 +91,151 @@
   FROM emp_record_table;

or 
	SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM emp_record_table
WHERE EMP_RATING < 2;

SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM emp_record_table
WHERE EMP_RATING > 4;

SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM emp_record_table
WHERE EMP_RATING BETWEEN 2 AND 4
ORDER BY EMP_RATING;



/*5. Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the
 Finance department from the employee table and then give the resultant column alias as NAME. */

 SELECT FIRST_NAME,LAST_NAME,concat(FIRST_NAME,' ',LAST_NAME) As 'NAME',DEPT
 from emp_record_table where DEPT='FINANCE';

 /*6.	Write a query to list only those employees who have someone reporting
 to them. Also, show the number of reporters (including the President). */

 select EMP_ID,concat(FIRST_NAME,' ',LAST_NAME) as 'NAME',MANAGER_ID,ROLE,COUNT(EMP_ID) OVER 
 (PARTITION by MANAGER_ID)
 AS 'Total_reporters'
 from emp_record_table 
 where MANAGER_ID is NOT NULL
 ORDER by MANAGER_ID;

/*7.Write a query to list down all the employees 
from the healthcare and finance departments using union. Take data from the employee record table.*/

Select * from emp_record_table
where DEPT='FINANCE'
UNION(
Select * from emp_record_table
where DEPT='HEALTHCARE');

/*8.	Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, 
ROLE, DEPARTMENT, and EMP_RATING grouped
 by dept. Also include the respective employee rating along with the max emp rating for the department.*/

 Select EMP_ID,concat(FIRST_NAME,' ',LAST_NAME) AS 'NAME','ROLE',
 DEPT,EMP_RATING, MAX(EMP_RATING) OVER (PARTITION by DEPT) AS 'MAX rating employee'
 from emp_record_table;

/*9.	Write a query to calculate the minimum and the maximum salary of the employees in each role. 
Take data from the employee record table.*/
SELECT EMP_ID,concat(FIRST_NAME,' ',LAST_NAME) AS 'NAME',ROLE,SALARY,
MAX(SALARY) over (partition by role),MIN(SALARY) over( partition by role order by ROLE) From emp_record_table;

/* 10.	Write a query to assign ranks to each employee based on their experience. 
Take data from the employee record table.
*/
SELECT EMP_ID,concat(FIRST_NAME,' ',LAST_NAME) AS 'NAME',EXP,RANK() 
OVER (order by EXP DESC) AS 'RANK'
from emp_record_table;

/*
11.	Write a query to create a view that displays employees in various
 countries whose salary is more than six thousand. Take data from the employee record table.*/

 CREATE VIEW Employee_view As
 Select EMP_ID,concat(FIRST_NAME,' ',LAST_NAME) AS 'NAME',COUNTRY,SALARY
 From
 emp_record_table
 group by COUNTRY having SALARY > 6000;

 /*12.	Write a nested query to find employees with experience of more than ten years. 
 Take data from the employee record table. */
 Select * from emp_record_table 
 where EXP
 in (Select  EXP from emp_record_table where  EXP> 10);

 /*13.	Write a query to create a stored procedure to retrieve the details 
 of the employees whose experience is more than three years. 
 Take data from the employee record table.*/

 DELIMITER &&  
 CREATE PROCEDURE EMP_PROC()
 BEGIN
 SELECT * from emp_record_table Where EXP > 3;
 END &&

 Call EMP_PROC();

/*14.	Write a query using stored functions in the project table to 
check whether the job profile assigned to each employee in the data science
 team matches the organization’s set standard.

The standard being:
For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
For an employee with the experience of 12 to 16 years assign 'MANAGER'. */
DELIMITER //
CREATE FUNCTION ROLE_CATEGORY(EXP int)
RETURNS VARCHAR(30) DETERMINISTIC
BEGIN
DECLARE ROLE varchar(30);

if EXP <= 2 THEN
SET ROLE = 'JUNIOR DATA SCIENTIST';
ELSEIF EXP between 2 and 5 THEN
SET ROLE = 'ASSOCIATE DATA SCIENTIST';
ELSEIF EXP between 5 AND 10 THEN
SET ROLE = 'SENIOR DATA SCIENTIST';
ELSEIF EXP between 10 AND 12 THEN
SET ROLE = 'LEAD DATA SCIENTIST';
ELSEif  EXP between 12 AND 16 THEN
SET ROLE = 'MANAGER';
Else SET ROLE = 'OTHERS';
END IF;
return(ROLE);
END //
DELIMITER ;

Show function status;
SELECT 
	EMP_ID,
    concat(FIRST_NAME,' ',LAST_NAME) AS 'NAME',EXP,
    ROLE_CATEGORY(EXP)
FROM
    emp_record_table;

/*15.	Create an index to improve the cost and performance of the query to
    find the employee whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan.*/

    CREATE INDEX on emp_record_table(FIRST_NAME);
/*16.	Write a query to calculate the bonus for all the employees, based on their ratings and
 salaries 
(Use the formula: 5% of salary * employee rating). */

 SELECT concat(FIRST_NAME,' ',LAST_NAME) as 'Name',SALARY,EMP_RATING,(SALARY*.05)*EMP_RATING AS 'Bonus'
 from emp_record_table
 order by EMP_RATING desc;

 /*17.	Write a query to calculate the average salary distribution based on the continent and country. 
 Take data from the employee record table.*/

 SELECT concat(FIRST_NAME,' ',LAST_NAME) as 'Name',COUNTRY,CONTINENT,SALARY,
 AVG(SALARY) over(PARTITION BY COUNTRY,CONTINENT)
 AS 'Average_Salary' 
 from emp_record_table;
