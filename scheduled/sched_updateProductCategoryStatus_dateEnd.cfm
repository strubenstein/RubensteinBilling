<!--- disable product in category if past expiration date --->
<cfquery Name="qry_updateProductCategoryStatus_dateEnd" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	UPDATE avProductCategory
	SET productCategoryStatus = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
	WHERE productCategoryStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		AND productCategoryDateEnd IS NOT NULL
		AND productCategoryDateEnd <= #Application.billingSql.sql_nowDateTime#
</cfquery>
