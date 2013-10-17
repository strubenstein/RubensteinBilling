<cfset Variables.dateCastedAsMonthDay = ReplaceNoCase(Application.billingSql.castDateAsMonthDay, "<<DATEFIELD>>", "avPaymentCredit.paymentCreditDateCreated", "ALL")>
<cfquery Name="qry_selectAdminMain_paymentCreditCreated" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT #PreserveSingleQuotes(Variables.dateCastedAsMonthDay)# AS paymentCreditDateCreated,
		COUNT(avPaymentCredit.paymentCreditID) AS countPaymentCredit,
		SUM(avPaymentCredit.paymentCreditAmount) AS sumPaymentCreditAmount
	FROM avPaymentCredit, avCompany
	WHERE avPaymentCredit.companyID = avCompany.companyID
		AND avPaymentCredit.companyID_author = <cfqueryparam Value="#Session.companyID_author#" cfsqltype="cf_sql_integer">
		AND avPaymentCredit.paymentCreditStatus = <cfqueryparam Value="1" cfsqltype="cf_sql_tinyint">
		AND avPaymentCredit.paymentCreditDateCreated BETWEEN
			#CreateODBCDateTime(DateAdd("d", -7, Now()))#
			AND
			#CreateODBCDateTime(CreateDateTime(Year(Now()), Month(Now()), Day(Now()), 23, 59, 00))#
		#Variables.qryParam_affCob#
	GROUP BY #PreserveSingleQuotes(Variables.dateCastedAsMonthDay)#
	ORDER BY #PreserveSingleQuotes(Variables.dateCastedAsMonthDay)#
</cfquery>
