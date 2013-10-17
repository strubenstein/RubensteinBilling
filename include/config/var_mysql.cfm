<cfset billingSql.sql_nowDateTime = "Now()">
<cfset billingSql.identityField_field = False>
<cfset billingSql.identityField_value = "">
<cfset billingSql.identityField_select = "SELECT last_insert_id() AS primaryKeyID"><!--- mysql_insert_id() --->
<cfset billingSql.cfSqlType_bit = "cf_sql_tinyint">
<cfset billingSql.randomID = "Rand()">
<cfset billingSql.concatLastFirstName = "CONCAT(lastName, ', ', firstName)">
<cfset billingSql.castDateAsMonthDay = "DATE_FORMAT(<<DATEFIELD>>, '%c/%e')">

<cfif Not IsDefined("fn_convertCFdatepartToSQL")>
	<cfinclude template="var_mysql_cfscript.cfm">
</cfif>

<!--- 
AES_Encrypt(string, key) / AES_Decrypt
DES_
Encode/Decode
--->
