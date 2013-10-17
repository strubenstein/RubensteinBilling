<cfif Not IsDefined("URL.invoiceID") or Not Application.fn_IsIntegerPositive(URL.invoiceID)
		or Not IsDefined("URL.paymentCreditID") or Not Application.fn_IsIntegerPositive(URL.paymentCreditID)
		or Not IsDefined("URL.invoicePaymentCreditID") or Not Application.fn_IsIntegerPositive(URL.invoicePaymentCreditID)>
	<cfset URL.error_paymentCredit = "noInvoice">
	<cfinclude template="../../view/v_paymentCredit/error_paymentCredit.cfm">
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.InvoicePaymentCredit" Method="selectInvoicePaymentCredit" ReturnVariable="qry_selectInvoicePaymentCredit">
		<cfinvokeargument Name="invoicePaymentCreditID" Value="#URL.invoicePaymentCreditID#">
	</cfinvoke>

	<cfinvoke component="#Application.billingMapping#data.InvoicePaymentCredit" method="maxlength_InvoicePaymentCredit" returnVariable="maxlength_InvoicePaymentCredit" />

	<!--- does payment credit / invoice combination exist? --->
	<cfif qry_selectInvoicePaymentCredit.RecordCount is not 1
			or qry_selectInvoicePaymentCredit.paymentCreditID is not URL.paymentCreditID
			or qry_selectInvoicePaymentCredit.invoiceID is not URL.invoiceID>
		<cfset URL.error_paymentCredit = Variables.doAction>
		<cfinclude template="../../view/v_paymentCredit/error_paymentCredit.cfm">

	<!--- form elements missing? --->
	<cfelseif Not IsDefined("Form.isFormSubmitted") or Not IsDefined("Form.invoicePaymentCreditText") or Not IsDefined("Form.submitInvoicePaymentCreditText")>
		<cfset URL.error_paymentCredit = "#Variables.doAction#_form">
		<cfinclude template="../../view/v_paymentCredit/error_paymentCredit.cfm">

	<!--- new value greater than maxlength? --->
	<cfelseif Len(Form.invoicePaymentCreditText) gt maxlength_InvoicePaymentCredit.invoicePaymentCreditText>
		<cfset URL.error_paymentCredit = "#Variables.doAction#_maxlength">
		<cfinclude template="../../view/v_paymentCredit/error_paymentCredit.cfm">

	<!--- update --->
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.InvoicePaymentCredit" Method="updateInvoicePaymentCredit" ReturnVariable="isInvoicePaymentCreditUpdated">
			<cfinvokeargument Name="invoicePaymentCreditID" Value="#URL.invoicePaymentCreditID#">
			<cfinvokeargument Name="invoicePaymentCreditText" Value="#Form.invoicePaymentCreditText#">
		</cfinvoke>

		<cfif FindNoCase("listPaymentCreditsForInvoice", CGI.HTTP_REFERER) and URL.control is "invoice">
			<cfset Variables.redirectURL = "index.cfm?method=#URL.control#.listPaymentCreditsForInvoice#Variables.urlParameters#">
		<cfelse>
			<cfset Variables.redirectURL = "index.cfm?method=#URL.control#.listInvoicesForPaymentCredit#Variables.urlParameters#&paymentCreditID=#URL.paymentCreditID#">
		</cfif>

		<cflocation url="#Variables.redirectURL#&confirm_paymentCredit=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>
