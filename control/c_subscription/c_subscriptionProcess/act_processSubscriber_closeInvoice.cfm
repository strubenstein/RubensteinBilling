<!--- Close invoice --->
<!--- 
IF payment AND payment successful
invoiceCompleted
invoiceDateCompleted
--->
<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="updateInvoice" ReturnVariable="isInvoiceUpdated">
	<cfinvokeargument Name="invoiceID" Value="#Variables.invoiceID#">
	<cfinvokeargument Name="invoiceClosed" Value="1">
	<cfinvokeargument Name="invoiceDateClosed" Value="#CreateODBCDateTime(Now())#">
	<cfinvokeargument Name="subscriberID" Value="#Variables.subscriberID#">
</cfinvoke>
