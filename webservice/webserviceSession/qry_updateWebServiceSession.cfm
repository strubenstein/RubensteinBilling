<cfquery Name="qry_updateWebServiceSession" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	UPDATE avWebServiceSession
	SET
		<cfif StructKeyExists(Arguments, "webServiceSessionLastError") and Trim(Arguments.webServiceSessionLastError) is not "">
			webServiceSessionLastError = <cfqueryparam Value="#Left(Arguments.webServiceSessionLastError, 255)#" cfsqltype="cf_sql_varchar" Maxlength="255">,
		</cfif>
		webServiceSessionDateUpdated = #Application.billingSql.sql_nowDateTime#
	WHERE webServiceSessionID = <cfqueryparam Value="#Arguments.webServiceSessionID#" cfsqltype="cf_sql_integer">
</cfquery>
