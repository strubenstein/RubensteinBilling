<cfif URL.control is not "invoice" or Not Application.fn_IsIntegerNonNegative(URL.invoiceID)>
	<cflocation url="index.cfm?method=invoice.listInvoices&error_invoice=invalidInvoice" AddToken="No">
<cfelseif Not Application.fn_IsIntegerNonNegative(URL.shippingID)>
	<cflocation url="#Variables.shippingActionList#&error_shipping=noShipping" AddToken="No">
<cfelseif URL.shippingID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Shipping" Method="checkShippingPermission" ReturnVariable="isShippingPermission">
		<cfinvokeargument Name="shippingID" Value="#URL.shippingID#">
		<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
	</cfinvoke>

	<cfif isShippingPermission is False>
		<cflocation url="#Variables.shippingActionList#&error_shipping=invalidShipping" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Shipping" Method="selectShipping" ReturnVariable="qry_selectShipping">
			<cfinvokeargument Name="shippingID" Value="#URL.shippingID#">
		</cfinvoke>
	</cfif>
<cfelseif Not ListFind("listShipping,insertShipping", Variables.doAction)>
	<cflocation url="#Variables.shippingActionList#&error_shipping=noShipping" AddToken="No">
</cfif>
