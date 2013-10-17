<cfquery Name="qry_viewCompanyByID" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT companyID, companyID_custom, companyName
	FROM avCompany
	WHERE companyID_author = <cfqueryparam Value="#Session.companyID#" cfsqltype="cf_sql_integer">
		AND (
			companyID_custom = <cfqueryparam Value="#URL.companyID#" cfsqltype="cf_sql_varchar">
			<cfif Application.fn_IsIntegerNonNegative(URL.companyID)>
				OR companyID = <cfqueryparam Value="#URL.companyID#" cfsqltype="cf_sql_integer">
			</cfif>
			)
	ORDER BY companyID_custom, companyName
</cfquery>

<cfif qry_viewCompanyByID.RecordCount is 1>
	<cfset URL.companyID = qry_viewCompanyByID.companyID>
<cfelseif qry_viewCompanyByID.RecordCount gt 1>
	<cfset URL.companyID = qry_viewCompanyByID.companyID[1]>
	<cfset Variables.displayViewByIDList = True>
</cfif>
