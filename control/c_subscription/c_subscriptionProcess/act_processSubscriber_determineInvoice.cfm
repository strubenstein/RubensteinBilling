<!--- check whether an open invoice exists --->
<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoiceList" ReturnVariable="qry_selectInvoiceList">
	<cfinvokeargument Name="companyID_author" Value="#qry_selectSubscriber.companyID_author#">
	<cfinvokeargument Name="companyID" Value="#qry_selectSubscriber.companyID#">
	<cfinvokeargument Name="userID" Value="#qry_selectSubscriber.userID#">
	<cfinvokeargument Name="subscriberID" Value="#Variables.subscriberID#">
	<cfinvokeargument Name="invoiceStatus" Value="1">
	<cfinvokeargument Name="invoiceCompleted" Value="0">
	<cfinvokeargument Name="addressID_billing" Value="#qry_selectSubscriber.addressID_billing#">
	<cfinvokeargument Name="addressID_shipping" Value="#qry_selectSubscriber.addressID_shipping#">
	<cfinvokeargument Name="queryOrderBy" Value="invoiceDateCreated_d">
	<cfinvokeargument Name="queryDisplayPerPage" Value="1">
	<cfinvokeargument Name="queryPage" Value="1">
</cfinvoke>

<cfif qry_selectInvoiceList.RecordCount is not 0>
	<cfset Variables.invoiceID = qry_selectInvoiceList.invoiceID[1]>
	<cfset Variables.subscriberProcessExistingInvoice = 1>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="insertInvoice" ReturnVariable="newInvoiceID">
		<cfinvokeargument Name="companyID_author" Value="#qry_selectSubscriber.companyID_author#">
		<cfinvokeargument Name="companyID" Value="#qry_selectSubscriber.companyID#">
		<cfinvokeargument Name="subscriberID" Value="#Variables.subscriberID#">
		<cfinvokeargument Name="userID" Value="#qry_selectSubscriber.userID#">
	</cfinvoke>

	<cfset Variables.invoiceID = newInvoiceID>
	<cfset Variables.subscriberProcessExistingInvoice = 0>
</cfif>
