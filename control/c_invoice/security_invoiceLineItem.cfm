<cfif ListFind("insertInvoiceLineItem,updateInvoiceLineItem,updateInvoiceLineItemStatus,moveInvoiceLineItemUp,moveInvoiceLineItemDown,viewInvoiceLineItem", Variables.doAction)>
	<cfset Variables.invoiceActionView = "index.cfm?method=#URL.control#.viewInvoice&invoiceID=#URL.invoiceID#">
	<cfif URL.invoiceID is 0>
		<cflocation url="#Variables.invoiceActionList#&error_invoice=noInvoice" AddToken="No">
	<cfelseif Not IsDefined("URL.invoiceLineItemID")>
		<cfif Variables.doAction is not "insertInvoiceLineItem">
			<cflocation url="#Variables.invoiceActionView#&error_invoice=noInvoiceLineItem" AddToken="No">
		</cfif>
	<cfelseif Not Application.fn_IsIntegerPositive(URL.invoiceLineItemID)>
		<cflocation url="#Variables.invoiceActionView#&error_invoice=invalidInvoiceLineItem" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="selectInvoiceLineItem" ReturnVariable="qry_selectInvoiceLineItem">
			<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
			<cfinvokeargument Name="invoiceLineItemID" Value="#URL.invoiceLineItemID#">
		</cfinvoke>

		<cfif qry_selectInvoiceLineItem.RecordCount is not 1 or qry_selectInvoiceLineItem.invoiceID is not URL.invoiceID>
			<cflocation url="#Variables.invoiceActionView#&error_invoice=invalidInvoiceLineItem" AddToken="No">
		<cfelseif Variables.doAction is "updateInvoiceLineItem" and qry_selectInvoiceLineItem.invoiceLineItemStatus is 0>
			<cflocation url="#Variables.invoiceActionView#&error_invoice=updateInactiveLineItem" AddToken="No">
		</cfif>
	</cfif>
</cfif>
