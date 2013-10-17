<cfquery Name="qry_insertWebServiceSession" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	INSERT INTO avWebServiceSession
	(
		webServiceSessionUUID,
		userID,
		companyID,
		companyID_author,
		webServiceSessionPermissionStruct,
		webServiceSessionIPaddress,
		webServiceSessionLastError,
		webServiceSessionDateCreated,
		webServiceSessionDateUpdated
	)
	VALUES
	(
		<cfqueryparam Value="#Arguments.webServiceSessionUUID#" cfsqltype="cf_sql_varchar" Maxlength="50">,
		<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
		<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
		<cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">,
		<cfqueryparam Value="#Arguments.webServiceSessionPermissionStruct#" cfsqltype="cf_sql_varchar" Maxlength="255">,
		<cfqueryparam Value="#Arguments.webServiceSessionIPaddress#" cfsqltype="cf_sql_varchar" Maxlength="50">,
		<cfqueryparam Value="#Left(Arguments.webServiceSessionLastError, 255)#" cfsqltype="cf_sql_varchar" Maxlength="255">,
		#Application.billingSql.sql_nowDateTime#,
		#Application.billingSql.sql_nowDateTime#
	)
</cfquery>
