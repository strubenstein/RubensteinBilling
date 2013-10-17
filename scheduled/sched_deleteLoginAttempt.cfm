<cfquery Name="qry_deleteLoginAttempt_schedule" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	DELETE FROM avLoginAttempt
	WHERE loginAttemptDateUpdated <= #CreateODBCDateTime(DateAdd("h", -1, Now()))#
</cfquery>
