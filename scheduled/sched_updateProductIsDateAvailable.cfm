<!--- ensure product is listed as restricted if product date availability records exist --->
<cfquery Name="qry_updateProductIsDateRestricted_dateExists" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	UPDATE avProduct
	SET productIsDateRestricted = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
	WHERE productIsDateRestricted = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		AND productID IN
			(
			SELECT productID
			FROM avProductDate
			)
</cfquery>

<!--- ensure product is NOT listed as restricted if product date availability records do not exist --->
<cfquery Name="qry_updateProductIsDateRestricted_noDateExists" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	UPDATE avProduct
	SET productIsDateRestricted = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
	WHERE productIsDateRestricted = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		AND productID NOT IN
			(
			SELECT productID
			FROM avProductDate
			)
</cfquery>

<!--- list product as available if not date restricted --->
<cfquery Name="qry_updateProductIsDateAvailable_notRestricted" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	UPDATE avProduct
	SET productIsDateAvailable = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
	WHERE productIsDateAvailable = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		AND productIsDateRestricted = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
</cfquery>

<!--- list product as NOT available if date restricted and NOT within date ranges --->
<cfquery Name="qry_updateProductIsDateAvailable_isInRange" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	UPDATE avProduct
	SET productIsDateAvailable = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
	WHERE productIsDateAvailable = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		AND productIsDateRestricted = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		AND productID IN
			(
			SELECT productID
			FROM avProductDate
			WHERE productDateStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				AND productDateBegin <= #Application.billingSql.sql_nowDateTime#
				AND (productDateEnd IS NULL OR productDateEnd > #Application.billingSql.sql_nowDateTime#)
			)
</cfquery>

<!--- list product as available if date restricted, but within date ranges --->
<cfquery Name="qry_updateProductIsDateAvailable_notInRange" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	UPDATE avProduct
	SET productIsDateAvailable = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
	WHERE productIsDateAvailable = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		AND productIsDateRestricted = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		AND productID NOT IN
			(
			SELECT productID
			FROM avProductDate
			WHERE productDateStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				AND productDateBegin <= #Application.billingSql.sql_nowDateTime#
				AND (productDateEnd IS NULL OR productDateEnd > #Application.billingSql.sql_nowDateTime#)
			)
</cfquery>
