<cfinvoke component="#Application.billingMapping#control.c_export.ExportQueryForCompany" method="exportQueryForCompany" returnVariable="isExported">
	<cfinvokeargument name="exportResultsMethod" value="#Form.exportResultsMethod#">
	<cfinvokeargument name="exportResultsFormat" value="#Form.exportResultsFormat#">
	<cfinvokeargument name="xmlTagPlural" value="invoices">
	<cfinvokeargument name="xmlTagSingle" value="invoice">
	<cfinvokeargument name="fileNamePrefix" value="invoices">
	<cfinvokeargument name="exportQueryName" value="qry_selectInvoiceList">
	<cfinvokeargument name="qry_exportTargetList" value="#qry_selectInvoiceList#">
	<cfif Form.exportResultsFormat is "display">
		<cfinvokeargument name="fieldsWithCustomDisplay" value="invoiceTotal,invoiceTotalTax,invoiceTotalLineItem,invoiceTotalPaymentCredit,invoiceTotalShipping,invoiceStatus,invoiceSent,invoiceClosed,invoiceDateClosed,invoicePaid,invoiceDatePaid,invoiceShipped,invoiceCompleted,invoiceDateCompleted,invoiceDateCreated,invoiceDateUpdated">
	<cfelse><!--- data --->
		<cfinvokeargument name="fieldsWithCustomDisplay" value="">
	</cfif>
</cfinvoke>

