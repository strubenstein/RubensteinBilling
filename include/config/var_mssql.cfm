<cfset billingSql.sql_nowDateTime = "GetDate()">
<cfset billingSql.identityField_field = False>
<cfset billingSql.identityField_value = "">
<cfset billingSql.identityField_select = "SELECT @@identity AS primaryKeyID">
<cfset billingSql.cfSqlType_bit = "cf_sql_bit">
<cfset billingSql.randomID = "NewID()">
<cfset billingSql.concatLastFirstName = "lastName + ', ' + firstName">
<cfset billingSql.castDateAsMonthDay = "CAST(Month(<<DATEFIELD>>) AS varchar(10)) + '/' + Cast(Day(<<DATEFIELD>>) AS varchar(10))">

<cfif Not IsDefined("fn_convertCFdatepartToSQL")>
	<cfinclude template="var_mssql_cfscript.cfm">
</cfif>

<!--- 
select top 6 * from sysobjects where name not in (select top 4 name from sysobjects order by name) order by name
will return numbers 4 thru 10

FOUND_ROWS() / SQL_CALC_FOUND_ROWS
LIMIT 5,10;  Retrieve rows 6 thru 15
concat(firstName, ' ', lastName) as fullname
--->

