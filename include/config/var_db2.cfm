<cfset billingSql.sql_nowDateTime = "CURRENT TIMESTAMP">
<!--- create sequence #primaryKey# increment by 1 start with 1; --->
<cfset billingSql.identityField_field = "False">
<cfset billingSql.identityField_value = "">
<cfset billingSql.identityField_select = "VALUES IDENTITY_VAL_LOCAL() INTO :primaryKeyID">
<cfset billingSql.cfSqlType_bit = "cf_sql_bit">
<cfset billingSql.randomID = "RAND()">
<cfset billingSql.concatLastFirstName = "lastName || ', ' || firstName">
<cfset billingSql.castDateAsMonthDay = "DATEFORMAT(<<DATEFIELD>>, 'MM/DD')">
<!--- ROWNUMBER (OR ROW_NUMBER) --->