<cfset Variables.dateCastedAsMonthDay = ReplaceNoCase(Application.billingSql.castDateAsMonthDay, "<<DATEFIELD>>", "avSubscriber.subscriberDateProcessNext", "ALL")>
<cfquery Name="qry_selectAdminMain_subscriberScheduled" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT #PreserveSingleQuotes(Variables.dateCastedAsMonthDay)# AS subscriberDateProcessNext,
		COUNT(avSubscriber.subscriberID) as countSubscriber
	FROM avSubscriber, avCompany
	WHERE avSubscriber.companyID = avCompany.companyID
		AND avSubscriber.subscriberStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		AND avSubscriber.companyID_author = <cfqueryparam Value="#Session.companyID_author#" cfsqltype="cf_sql_integer">
		#Variables.qryParam_affCob#
		AND avSubscriber.subscriberDateProcessNext < #CreateODBCDateTime(DateAdd("d", 7, Now()))#
	GROUP BY #PreserveSingleQuotes(Variables.dateCastedAsMonthDay)#
	ORDER BY #PreserveSingleQuotes(Variables.dateCastedAsMonthDay)#
</cfquery>

