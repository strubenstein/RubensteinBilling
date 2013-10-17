<cfset Variables.dateCastedAsMonthDay = ReplaceNoCase(Application.billingSql.castDateAsMonthDay, "<<DATEFIELD>>", "avInvoicePaymentCredit.invoicePaymentCreditDate", "ALL")>
<cfquery Name="qry_selectAdminMain_paymentCreditProcessed" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT #PreserveSingleQuotes(Variables.dateCastedAsMonthDay)# AS invoicePaymentCreditDate,
		COUNT(avInvoicePaymentCredit.paymentCreditID) AS countInvoicePaymentCredit,
		SUM(avInvoicePaymentCredit.invoicePaymentCreditAmount) AS sumInvoicePaymentCreditAmount
	FROM avPaymentCredit, avCompany, avInvoicePaymentCredit
	WHERE avPaymentCredit.companyID = avCompany.companyID
		AND avPaymentCredit.paymentCreditID = avInvoicePaymentCredit.paymentCreditID
		AND avPaymentCredit.companyID_author = <cfqueryparam Value="#Session.companyID_author#" cfsqltype="cf_sql_integer">
		AND avPaymentCredit.paymentCreditStatus = <cfqueryparam Value="1" cfsqltype="cf_sql_tinyint">
		AND avInvoicePaymentCredit.invoicePaymentCreditDate BETWEEN
			#CreateODBCDateTime(DateAdd("d", -7, Now()))#
			AND
			#CreateODBCDateTime(CreateDateTime(Year(Now()), Month(Now()), Day(Now()), 23, 59, 00))#
		#Variables.qryParam_affCob#
	GROUP BY #PreserveSingleQuotes(Variables.dateCastedAsMonthDay)#
	ORDER BY #PreserveSingleQuotes(Variables.dateCastedAsMonthDay)#
</cfquery>
