<cfquery Name="qry_selectAdminMain_user" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT avUser.firstName, avUser.lastName, avCompany.companyName
	FROM avUser LEFT OUTER JOIN avCompany
		ON avUser.companyID = avCompany.companyID
	WHERE avUser.userID = <cfqueryparam Value="#Session.userID#" cfsqltype="cf_sql_integer">
</cfquery>

