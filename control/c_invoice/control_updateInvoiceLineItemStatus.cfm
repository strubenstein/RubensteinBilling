<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="updateInvoiceLineItem" ReturnVariable="isInvoiceLineItemStatusUpdated">
	<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
	<cfinvokeargument Name="invoiceLineItemID" Value="#URL.invoiceLineItemID#">
	<cfinvokeargument Name="userID_cancel" Value="#Session.userID#">
	<cfinvokeargument Name="invoiceLineItemStatus" Value="0">
	<cfinvokeargument Name="isUpdateInvoiceTotal" Value="True">
</cfinvoke>

<cfif Not IsDefined("URL.redirectAction") or URL.redirectAction is not "viewInvoiceLineItemsAll" or Not Application.fn_IsUserAuthorized("viewInvoiceLineItemsAll")>
	<cfset URL.redirectAction = "viewInvoiceLineItems">
</cfif>

<cflocation url="index.cfm?method=invoice.#URL.redirectAction#&invoiceID=#URL.invoiceID#&confirm_invoice=#Variables.doAction#" AddToken="No">
