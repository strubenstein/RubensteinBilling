<cfset Variables.dateCastedAsMonthDay = ReplaceNoCase(Application.billingSql.castDateAsMonthDay, "<<DATEFIELD>>", "avPayment.paymentDateReceived", "ALL")>
<cfquery Name="qry_selectAdminMain_paymentReject" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT #PreserveSingleQuotes(Variables.dateCastedAsMonthDay)# AS paymentDateReceived,
		COUNT(avPayment.paymentID) AS countPayment,
		SUM(avPayment.paymentAmount) AS sumPaymentAmount
	FROM avPayment, avCompany
	WHERE avPayment.companyID = avCompany.companyID
		AND avPayment.companyID_author = <cfqueryparam Value="#Session.companyID_author#" cfsqltype="cf_sql_integer">
		AND avPayment.paymentStatus = <cfqueryparam Value="1" cfsqltype="cf_sql_tinyint">
		AND avPayment.paymentApproved = <cfqueryparam Value="0" cfsqltype="cf_sql_tinyint">
		AND avPayment.paymentID_refund = <cfqueryparam Value="0" cfsqltype="cf_sql_tinyint">
		AND avPayment.paymentDateReceived BETWEEN
			#CreateODBCDateTime(DateAdd("d", -7, Now()))#
			AND
			#CreateODBCDateTime(CreateDateTime(Year(Now()), Month(Now()), Day(Now()), 23, 59, 00))#
		#Variables.qryParam_affCob#
	GROUP BY #PreserveSingleQuotes(Variables.dateCastedAsMonthDay)#
	ORDER BY #PreserveSingleQuotes(Variables.dateCastedAsMonthDay)#
</cfquery>
