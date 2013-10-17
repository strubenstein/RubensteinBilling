<cfif FindNoCase("listPaymentCreditsForInvoice", CGI.HTTP_REFERER) and URL.control is "invoice">
	<cfset Variables.redirectURL = "index.cfm?method=#URL.control#.listPaymentCreditsForInvoice#Variables.urlParameters#">
<cfelse>
	<cfset Variables.redirectURL = "index.cfm?method=#URL.control#.listInvoicesForPaymentCredit#Variables.urlParameters#&paymentID=#URL.paymentID#">
</cfif>

<cfinvoke Component="#Application.billingMapping#data.InvoicePaymentCredit" Method="selectInvoicePaymentCredit" ReturnVariable="qry_selectInvoicePaymentCredit">
	<cfinvokeargument Name="invoicePaymentCreditID" Value="#URL.invoicePaymentCreditID#">
</cfinvoke>

<cfif qry_selectInvoicePaymentCredit.RecordCount is not 1
		or qry_selectInvoicePaymentCredit.paymentCreditID is not URL.paymentCreditID
		or qry_selectInvoicePaymentCredit.invoiceID is not URL.invoiceID>
	<cfset URL.error_payment = Variables.doAction>
	<cflocation url="#Variables.redirectURL#&error_paymentCredit=#Variables.doAction#" AddToken="No">
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.InvoicePaymentCredit" Method="deleteInvoicePaymentCredit" ReturnVariable="isInvoicePaymentCreditDeleted">
		<cfinvokeargument Name="invoicePaymentCreditID" Value="#URL.invoicePaymentCreditID#">
		<!--- 
		<cfinvokeargument Name="paymentCreditID" Value="#URL.paymentCreditID#">
		<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
		--->
	</cfinvoke>

	<!--- check for trigger --->
	<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
		<cfinvokeargument name="companyID" value="#Session.companyID#">
		<cfinvokeargument name="doAction" value="#Variables.doAction#">
		<cfinvokeargument name="isWebService" value="False">
		<cfinvokeargument name="doControl" value="#Variables.doControl#">
		<cfinvokeargument name="primaryTargetKey" value="invoicePaymentCreditID">
		<cfinvokeargument name="targetID" value="#URL.invoicePaymentCreditID#">
	</cfinvoke>

	<cflocation url="#Variables.redirectURL#&confirm_paymentCredit=#Variables.doAction#" AddToken="No">
</cfif>
