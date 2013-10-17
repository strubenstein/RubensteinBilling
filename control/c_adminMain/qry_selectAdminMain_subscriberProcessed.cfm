<cfset Variables.dateCastedAsMonthDay = ReplaceNoCase(Application.billingSql.castDateAsMonthDay, "<<DATEFIELD>>", "avSubscriberProcess.subscriberProcessDate", "ALL")>
<cfquery Name="qry_selectAdminMain_subscriberProcessed" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT #PreserveSingleQuotes(Variables.dateCastedAsMonthDay)# AS subscriberProcessDate,
		COUNT(avSubscriberProcess.subscriberProcessID) as countSubscriberProcess
	FROM avSubscriberProcess, avSubscriber, avCompany
	WHERE avSubscriberProcess.subscriberID = avSubscriber.subscriberID
		AND avSubscriber.companyID = avCompany.companyID
		AND avSubscriber.companyID_author = <cfqueryparam Value="#Session.companyID_author#" cfsqltype="cf_sql_integer">
		AND avSubscriberProcess.subscriberProcessStatus > <cfqueryparam Value="0" cfsqltype="cf_sql_tinyint">
		AND avSubscriberProcess.subscriberProcessDate BETWEEN
			#CreateODBCDateTime(DateAdd("d", -7, Now()))#
			AND
			#CreateODBCDateTime(CreateDateTime(Year(Now()), Month(Now()), Day(Now()), 23, 59, 00))#
		#Variables.qryParam_affCob#
	GROUP BY #PreserveSingleQuotes(Variables.dateCastedAsMonthDay)#
	ORDER BY #PreserveSingleQuotes(Variables.dateCastedAsMonthDay)#
</cfquery>

