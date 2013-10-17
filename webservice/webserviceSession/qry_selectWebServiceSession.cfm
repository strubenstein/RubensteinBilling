<cfquery Name="qry_selectWebServiceSession" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT webServiceSessionID, webServiceSessionUUID, userID, companyID, companyID_author,
		webServiceSessionPermissionStruct, webServiceSessionIPaddress, webServiceSessionLastError,
		webServiceSessionDateCreated, webServiceSessionDateUpdated
	FROM avWebServiceSession
	WHERE webServiceSessionUUID = <cfqueryparam Value="#Arguments.webServiceSessionUUID#" cfsqltype="cf_sql_varchar">
</cfquery>
