<cfif Not IsDefined("URL.invoiceID") or Not Application.fn_IsIntegerPositive(URL.invoiceID)>
	<cfset URL.error_payment = "invalidAction">
	<cfinclude template="../../view/v_payment/error_payment.cfm">
<cfelse>
	<cfif FindNoCase("listPaymentsForInvoice", CGI.HTTP_REFERER) and URL.control is "invoice">
		<cfset Variables.redirectURL = "index.cfm?method=#URL.control#.listPaymentsForInvoice#Variables.urlParameters#">
	<cfelse>
		<cfset Variables.redirectURL = "index.cfm?method=#URL.control#.listInvoicesForPayment#Variables.urlParameters#&paymentID=#URL.paymentID#">
	</cfif>

	<cfinvoke Component="#Application.billingMapping#data.InvoicePayment" Method="selectInvoicePayment" ReturnVariable="qry_selectInvoicePayment">
		<cfinvokeargument Name="paymentID" Value="#URL.paymentID#">
		<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
	</cfinvoke>

	<cfif qry_selectInvoicePayment.RecordCount is not 1>
		<cfset URL.error_payment = Variables.doAction>
		<cflocation url="#Variables.redirectURL#&error_payment=#Variables.doAction#" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.InvoicePayment" Method="deleteInvoicePayment" ReturnVariable="isInvoicePaymentDeleted">
			<cfinvokeargument Name="paymentID" Value="#URL.paymentID#">
			<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
		</cfinvoke>

		<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoice" ReturnVariable="isInvoiceUpdated">
			<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
		</cfinvoke>

		<cfif qry_selectInvoice.invoicePaid is 1 and qry_selectInvoice.invoiceTotal is not 0>
			<cfinvoke Component="#Application.billingMapping#data.InvoicePayment" Method="selectInvoicePaymentAmountTotal" ReturnVariable="qry_selectInvoicePaymentAmountTotal">
				<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
			</cfinvoke>

			<cfif Not IsNumeric(qry_selectInvoicePaymentAmountTotal.sumInvoicePaymentAmount) or qry_selectInvoicePaymentAmountTotal.sumInvoicePaymentAmount lt qry_selectInvoice.invoiceTotal>
				<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="updateInvoice" ReturnVariable="isInvoiceUpdated">
					<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
					<cfif IsNumeric(qry_selectInvoicePaymentAmountTotal.sumInvoicePaymentAmount)>
						<cfinvokeargument Name="invoicePaid" Value="0">
					<cfelse>
						<cfinvokeargument Name="invoicePaid" Value="">
					</cfif>
					<cfinvokeargument Name="invoiceDatePaid" Value="">
				</cfinvoke>
			</cfif>
		</cfif>

		<!--- check for trigger --->
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#Session.companyID#">
			<cfinvokeargument name="doAction" value="#Variables.doAction#">
			<cfinvokeargument name="isWebService" value="False">
			<cfinvokeargument name="doControl" value="#Variables.doControl#">
			<cfinvokeargument name="primaryTargetKey" value="paymentID">
			<cfinvokeargument name="targetID" value="#URL.paymentID#">
		</cfinvoke>

		<cflocation url="#Variables.redirectURL#&confirm_payment=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>
