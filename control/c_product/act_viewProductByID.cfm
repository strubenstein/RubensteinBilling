<cfquery Name="qry_viewProductByID" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT productID, productID_custom, productName
	FROM avProduct
	WHERE companyID = <cfqueryparam Value="#Session.companyID#" cfsqltype="cf_sql_integer">
		AND (
			productID_custom = <cfqueryparam Value="#URL.productID#" cfsqltype="cf_sql_varchar">
			<cfif Application.fn_IsIntegerNonNegative(URL.productID)>
				OR productID = <cfqueryparam Value="#URL.productID#" cfsqltype="cf_sql_integer">
			</cfif>
			)
	ORDER BY productID_custom, productName
</cfquery>

<cfif qry_viewProductByID.RecordCount is 1>
	<cfset URL.productID = qry_viewProductByID.productID>
<cfelseif qry_viewProductByID.RecordCount gt 1>
	<cfset URL.productID = qry_viewProductByID.productID[1]>
	<cfset Variables.displayViewByIDList = True>
</cfif>
