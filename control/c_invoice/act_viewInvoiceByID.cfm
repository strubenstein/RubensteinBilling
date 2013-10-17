<cfquery Name="qry_viewInvoiceByID" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT avInvoice.invoiceID, avInvoice.invoiceID_custom, avInvoice.invoiceDateCreated,
		avCompany.companyName, avSubscriber.subscriberName, avUser.firstName, avUser.lastName
	FROM avInvoice
		INNER JOIN avCompany ON avInvoice.companyID = avCompany.companyID
		LEFT OUTER JOIN avUser ON avInvoice.userID = avUser.userID
		LEFT OUTER JOIN avSubscriber ON avInvoice.subscriberID = avSubscriber.subscriberID
	WHERE avInvoice.companyID_author = <cfqueryparam Value="#Session.companyID_author#" cfsqltype="cf_sql_integer">
		AND (
			avInvoice.invoiceID_custom = <cfqueryparam Value="#URL.invoiceID#" cfsqltype="cf_sql_varchar">
			<cfif Application.fn_IsIntegerNonNegative(URL.invoiceID)>
				OR avInvoice.invoiceID = <cfqueryparam Value="#URL.invoiceID#" cfsqltype="cf_sql_integer">
			</cfif>
			)
	ORDER BY avInvoice.invoiceID_custom, avInvoice.invoiceDateCreated DESC, avCompany.companyName
</cfquery>

<cfif qry_viewInvoiceByID.RecordCount is 1>
	<cfset URL.invoiceID = qry_viewInvoiceByID.invoiceID>
<cfelseif qry_viewInvoiceByID.RecordCount gt 1>
	<cfset URL.invoiceID = qry_viewInvoiceByID.invoiceID[1]>
	<cfset Variables.displayViewByIDList = True>
</cfif>
