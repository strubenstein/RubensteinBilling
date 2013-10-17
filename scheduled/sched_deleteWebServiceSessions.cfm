<cfquery Name="qry_deleteWebServiceSession" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	DELETE FROM avWebServiceSession
	WHERE webServiceSessionDateUpdated <= <cfqueryparam Value="#CreateODBCDateTime(DateAdd('n', -121, Now()))#" cfsqltype="cf_sql_timestamp">
</cfquery>
