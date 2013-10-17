<cfset Variables.dateCastedAsMonthDay = ReplaceNoCase(Application.billingSql.castDateAsMonthDay, "<<DATEFIELD>>", "avInvoice.invoiceDateClosed", "ALL")>
<cfquery Name="qry_selectAdminMain_invoiceUnpaid" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT #PreserveSingleQuotes(Variables.dateCastedAsMonthDay)# AS invoiceDateClosed,
		COUNT(avInvoice.invoiceID) as countInvoice,
		SUM(avInvoice.invoiceTotalLineItem) AS invoiceTotalLineItemSum
	FROM avInvoice, avCompany
	WHERE avInvoice.companyID = avCompany.companyID
		AND avInvoice.invoiceClosed = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		AND avCompany.companyID_author = <cfqueryparam Value="#Session.companyID_author#" cfsqltype="cf_sql_integer">
		#Variables.qryParam_affCob#
		AND avInvoice.invoiceDateClosed > #CreateODBCDateTime(DateAdd("d", -7, Now()))#
		AND (avInvoice.invoicePaid = 0 OR avInvoice.invoicePaid IS NULL)
	GROUP BY #PreserveSingleQuotes(Variables.dateCastedAsMonthDay)#
	ORDER BY #PreserveSingleQuotes(Variables.dateCastedAsMonthDay)#
</cfquery>
