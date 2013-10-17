<!--- if no subscriberProcessID, create it now --->
<cfif Variables.subscriberProcessID is 0>
	<cfinvoke Component="#Application.billingMapping#data.SubscriberProcess" Method="insertSubscriberProcess" ReturnVariable="newSubscriberProcessID">
		<cfinvokeargument Name="subscriberID" Value="#Variables.subscriberID#">
		<cfinvokeargument Name="subscriberProcessCurrent" Value="1">
		<cfinvokeargument Name="subscriberProcessDate" Value="#CreateODBCDateTime(Now())#">
		<cfinvokeargument Name="invoiceID" Value="#Variables.invoiceID#">
		<cfinvokeargument Name="subscriberProcessExistingInvoice" Value="#Variables.subscriberProcessExistingInvoice#">
		<cfinvokeargument Name="subscriberProcessStatus" Value="1">
		<cfinvokeargument Name="subscriberProcessAllQuantitiesEntered" Value="1">
	</cfinvoke>

	<cfset Variables.subscriberProcessID = newSubscriberProcessID>

<!--- otherwise update current subscriber process with invoiceID --->
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.SubscriberProcess" Method="updateSubscriberProcess" ReturnVariable="isSubscriberProcessUpdated">
		<cfinvokeargument Name="subscriberProcessID" Value="#Variables.subscriberProcessID#">
		<cfinvokeargument Name="invoiceID" Value="#Variables.invoiceID#">
		<cfinvokeargument Name="subscriberProcessExistingInvoice" Value="#Variables.subscriberProcessExistingInvoice#">
	</cfinvoke>
</cfif>
