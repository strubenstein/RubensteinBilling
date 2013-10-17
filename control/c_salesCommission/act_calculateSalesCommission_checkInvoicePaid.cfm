<!--- select invoice information --->
<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoice" ReturnVariable="qry_selectInvoice">
	<cfinvokeargument Name="invoiceID" Value="#Arguments.invoiceID#">
</cfinvoke>

<cfif qry_selectInvoice.RecordCount is 1
		and qry_selectInvoice.invoiceClosed is 1
		and qry_selectInvoice.invoicePaid is 1
		and IsDate(qry_selectInvoice.invoiceDatePaid)>
	<cfquery Name="qry_checkSalesCommissionForInvoice" MaxRows="1" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avSalesCommission.salesCommissionID
		FROM avSalesCommission, avSalesCommissionInvoice
		WHERE avSalesCommission.salesCommissionID = avSalesCommissionInvoice.salesCommissionID
			AND avSalesCommission.salesCommissionManual = 0
			AND avSalesCommissionInvoice.invoiceID = <cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfif qry_checkSalesCommissionForInvoice.RecordCount is 0>
		<cfset returnValue = True>
	</cfif>
</cfif>

