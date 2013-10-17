<cfquery Name="qry_viewCobrandByID" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT avCobrand.cobrandID, avCobrand.cobrandID_custom, avCobrand.cobrandCode, avCobrand.cobrandName,
		avCompany.companyName
	FROM avCobrand, avCompany
	WHERE avCobrand.companyID = avCompany.companyID
		AND avCobrand.companyID_author = <cfqueryparam Value="#Session.companyID#" cfsqltype="cf_sql_integer">
		AND (
			avCobrand.cobrandID_custom = <cfqueryparam Value="#URL.cobrandID#" cfsqltype="cf_sql_varchar">
			OR
			avCobrand.cobrandCode = <cfqueryparam Value="#URL.cobrandID#" cfsqltype="cf_sql_varchar">
			<cfif Application.fn_IsIntegerNonNegative(URL.cobrandID)>
				OR avCobrand.cobrandID = <cfqueryparam Value="#URL.cobrandID#" cfsqltype="cf_sql_integer">
			</cfif>
			)
	ORDER BY avCobrand.cobrandID_custom, avCobrand.cobrandName, avCompany.companyName
</cfquery>

<cfif qry_viewCobrandByID.RecordCount is 1>
	<cfset URL.cobrandID = qry_viewCobrandByID.cobrandID>
<cfelseif qry_viewCobrandByID.RecordCount gt 1>
	<cfset URL.cobrandID = qry_viewCobrandByID.cobrandID[1]>
	<cfset Variables.displayViewByIDList = True>
</cfif>
