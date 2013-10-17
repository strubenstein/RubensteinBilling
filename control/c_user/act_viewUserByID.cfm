<cfquery Name="qry_viewUserByID" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT avUser.userID, avUser.userID_custom, avUser.username, avUser.firstName, avUser.lastName,
		avCompany.companyName
	FROM avUser, avCompany
	WHERE avUser.companyID = avCompany.companyID
		AND avCompany.companyID_author = <cfqueryparam Value="#Session.companyID_author#" cfsqltype="cf_sql_integer">
		AND (
			avUser.userID_custom = <cfqueryparam Value="#URL.userID#" cfsqltype="cf_sql_varchar">
			OR avUser.username = <cfqueryparam Value="#URL.userID#" cfsqltype="cf_sql_varchar">
			<cfif Application.fn_IsIntegerNonNegative(URL.userID)>
				OR avUser.userID = <cfqueryparam Value="#URL.userID#" cfsqltype="cf_sql_integer">
			</cfif>
			)
	ORDER BY avUser.userID_custom, avUser.username, avUser.lastName, avUser.firstName
</cfquery>

<cfif qry_viewUserByID.RecordCount is 1>
	<cfset URL.userID = qry_viewUserByID.userID>
<cfelseif qry_viewUserByID.RecordCount gt 1>
	<cfset URL.userID = qry_viewUserByID.userID[1]>
	<cfset Variables.displayViewByIDList = True>
</cfif>
