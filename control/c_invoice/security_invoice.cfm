<!--- 
<cfif Not Application.fn_IsIntegerNonNegative(URL.invoiceID)>
	<cflocation url="#Variables.invoiceActionList#&error_invoice=noInvoice" AddToken="No">
--->
<cfif Trim(URL.invoiceID) is "">
	<cflocation url="#Variables.invoiceActionList#&error_invoice=noInvoice" AddToken="No">
<cfelseif Not Application.fn_IsIntegerNonNegative(URL.companyID) or (URL.companyID is not 0 and Not ListFind("company,user,subscription", URL.control))>
	<cflocation url="#Variables.invoiceActionList#&error_invoice=invalidCompany" AddToken="No">
<cfelseif Not Application.fn_IsIntegerNonNegative(URL.userID) or (URL.userID is not 0 and Not ListFind("user,company,subscription", URL.control))>
	<cflocation url="#Variables.invoiceActionList#&error_invoice=invalidUser" AddToken="No">
<cfelseif Variables.doAction is "insertInvoice" and Not ListFind("user,company,subscription", URL.control)>
	<cflocation url="#Variables.invoiceActionList#&error_invoice=insertInvoice" AddToken="No">
<cfelseif URL.invoiceID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="checkInvoicePermission" ReturnVariable="isInvoicePermission">
		<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
		<cfif URL.companyID is not 0>
			<cfinvokeargument Name="companyID" Value="#URL.companyID#">
		</cfif>
		<cfif URL.userID is not 0>
			<cfinvokeargument Name="userID" Value="#URL.userID#">
		</cfif>
		<cfif Session.companyID is not Session.companyID_author>
			<cfinvokeargument Name="cobrandID" Value="#Session.cobrandID_list#">
			<cfinvokeargument Name="affiliateID" Value="#Session.affiliateID_list#">
		</cfif>
	</cfinvoke>

	<cfif isInvoicePermission is False>
		<cflocation url="#Variables.invoiceActionList#&error_invoice=invalidInvoice" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoice" ReturnVariable="qry_selectInvoice">
			<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
		</cfinvoke>

		<!--- 
		<cfif qry_selectInvoice.companyID is not URL.companyID and qry_selectInvoice.userID is not URL.userID>
			<cflocation url="#Variables.invoiceActionList#&error_invoice=invalidInvoice" AddToken="No">
		--->
		<cfif URL.invoiceID is qry_selectInvoice.invoiceID_custom>
			<cfset URL.invoiceID = qry_selectInvoice.invoiceID>
		</cfif>
	</cfif>
<cfelseif Not ListFind("listInvoices,insertInvoice", Variables.doAction)>
	<cflocation url="#Variables.invoiceActionList#&error_invoice=noInvoice" AddToken="No">
</cfif>
