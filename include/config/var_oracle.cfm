<cfset billingSql.sql_nowDateTime = "SysDate">
<!--- create sequence #primaryKey# increment by 1 start with 1; --->
<cfset billingSql.identityField_field = True>
<!--- 
primaryKeyField = sequence name 
CREATE SEQUENCE "SYSMAN"."EMPLOYEES_SEQTEST" NOCYCLE NOORDER CACHE 20 NOMAXVALUE MINVALUE 1 INCREMENT BY 1 START WITH 1
--->
<cfset billingSql.identityField_value = "primaryKeyField_SEQ.NextVal">
<cfset billingSql.identityField_select = "SELECT primaryKeyField_SEQ.CurrVal AS primaryKeyID FROM dual">
<cfset billingSql.cfSqlType_bit = "cf_sql_bit">
<cfset billingSql.randomID = "mod(DBMS_RANDOM.Random,50)">
<cfset billingSql.concatLastFirstName = "lastName || ', ' || firstName">
<cfset billingSql.castDateAsMonthDay = "TO_CHAR(<<DATEFIELD>>, 'MM/DD')">
<!---
SELECT *
FROM
	(
	SELECT LAST_NAME,
		RANK() OVER (ORDER BY LAST_NAME) nameRank
    FROM HR.EMPLOYEES
	WHERE ROWNUM < 6
	)
WHERE nameRank between 5 and 10


INSERT INTO HR.EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, HIRE_DATE, JOB_ID)
VALUES (HR.EMPLOYEES_SEQ.NextVal, 'Test', 'Dude', 'TDUDE', SysDate, 'SH_CLERK')

SELECT HR.EMPLOYEES_SEQ.CurrVal FROM dual
 --->