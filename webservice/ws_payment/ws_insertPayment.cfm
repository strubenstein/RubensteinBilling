<cfinclude template="wslang_payment.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = -1>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("insertPayment", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = -1>
	<cfset returnError = Variables.wslang_payment.insertPayment>
<cfelse>
	<cfset returnValue = 0>
	<cfset Variables.doAction = "insertPayment">

	<cfloop Index="field" List="paymentStatus,paymentApproved,paymentProcessed">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfinclude template="wsact_insertPayment_validateCompanySubscriber.cfm">
	<cfinclude template="wsact_insertPayment_validateInvoice.cfm">

	<!--- validate that company, subscriber or invoice is specified to determine customer making payment --->
	<cfif returnValue is 0 and Arguments.companyID is 0 and Arguments.subscriberID is 0 and Arguments.invoiceID is 0>
		<cfset returnValue = -1>
		<cfset returnError = Variables.wslang_payment.noPaymentApplied>
	</cfif>

	<!--- validate and set payment amount if using invoice total --->
	<cfif returnValue is 0 and Arguments.useInvoiceTotalForPaymentAmount is True>
		<cfif invoiceTotalUnpaid is 0>
			<cfset returnValue = -1>
			<cfset returnError = Variables.wslang_payment.paymentZero>
		<cfelse>
			<cfset Arguments.paymentAmount = invoiceTotalUnpaid>
		</cfif>
	</cfif>

	<!--- if paying via merchant account, validate merchant account, credit card and/or bank account --->
	<cfinclude template="wsact_insertPayment_validateMerchant.cfm">

	<!--- validate and process payment --->
	<cfif returnValue is 0>
		<!--- 
		<cfset displaySubscriptionList = False>
		<cfset displayInvoiceLineItemList = False>
		<cfset displaySubscriberList = False>
		--->

		<cfinclude template="wsact_insertPayment_validateForm.cfm">

		<cfif isAllFormFieldsOk is False>
			<cfset returnValue = -1>
			<cfset returnError = "">
			<cfloop Collection="#errorMessage_fields#" Item="field">
				<cfset returnError = ListAppend(returnError, StructFind(errorMessage_fields, field), Chr(10))>
			</cfloop>
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.Payment" Method="insertPayment" ReturnVariable="newPaymentID">
				<cfinvokeargument Name="userID" Value="0">
				<cfinvokeargument Name="companyID" Value="#theCompanyID#">
				<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
				<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
				<cfinvokeargument Name="paymentManual" Value="1">
				<cfinvokeargument Name="creditCardID" Value="#Form.creditCardID#">
				<cfinvokeargument Name="bankID" Value="#Form.bankID#">
				<cfinvokeargument Name="merchantAccountID" Value="#Form.merchantAccountID#">
				<cfif Not IsNumeric(Form.paymentCheckNumber)>
					<cfinvokeargument Name="paymentCheckNumber" Value="0">
				<cfelse>
					<cfinvokeargument Name="paymentCheckNumber" Value="#Form.paymentCheckNumber#">
				</cfif>
				<cfinvokeargument Name="paymentID_custom" Value="#Form.paymentID_custom#">
				<cfinvokeargument Name="paymentStatus" Value="#Form.paymentStatus#">
				<cfinvokeargument Name="paymentApproved" Value="#Form.paymentApproved#">
				<cfinvokeargument Name="paymentAmount" Value="#Form.paymentAmount#">
				<cfinvokeargument Name="paymentDescription" Value="#Form.paymentDescription#">
				<cfinvokeargument Name="paymentMethod" Value="#Form.paymentMethod#">
				<cfinvokeargument Name="paymentProcessed" Value="#Form.paymentProcessed#">
				<cfinvokeargument Name="paymentDateReceived" Value="#Form.paymentDateReceived#">
				<cfinvokeargument Name="paymentDateScheduled" Value="#Form.paymentDateScheduled#">
				<cfinvokeargument Name="paymentCategoryID" Value="#Form.paymentCategoryID#">
				<cfinvokeargument Name="subscriberID" Value="#theSubscriberID#">
				<cfinvokeargument Name="paymentIsRefund" Value="0">
				<cfinvokeargument Name="paymentID_refund" Value="0">
				<!--- paymentMessage --->
				<cfif Form.creditCardID is not 0>
					<cfinvokeargument Name="paymentCreditCardType" Value="#qry_selectSubscriberPayment.creditCardType#">
					<cfinvokeargument Name="paymentCreditCardLast4" Value="#Right(qry_selectSubscriberPayment.creditCardNumber, 4)#">
				</cfif>
			</cfinvoke>

			<cfset returnValue = newPaymentID>
			<cfset markInvoiceAsPaid_list = "">
			<cfif theInvoiceID is not 0 and invoiceTotalUnpaid is not 0>
				<cfset paymentAmountRemaining = Form.paymentAmount>
				<cfloop Query="qry_selectInvoiceList">
					<cfif qry_selectInvoiceList.invoicePaid is not 1 and paymentAmountRemaining gt 0>
						<cfinvoke Component="#Application.billingMapping#data.InvoicePayment" Method="selectInvoicePaymentAmountTotal" ReturnVariable="qry_selectInvoicePaymentAmountTotal">
							<cfinvokeargument Name="invoiceID" Value="#qry_selectInvoiceList.invoiceID#">
						</cfinvoke>

						<cfif Not IsNumeric(qry_selectInvoicePaymentAmountTotal.sumInvoicePaymentAmount)>
							<cfset invoicePaymentAmount = Min(paymentAmountRemaining, qry_selectInvoiceList.invoiceTotal)>
							<cfif (invoicePaymentAmount gte qry_selectInvoiceList.invoiceTotal)>
								<cfset markInvoiceAsPaid_list = ListAppend(markInvoiceAsPaid_list, qry_selectInvoiceList.invoiceID)>
							</cfif>
						<cfelse>
							<cfset invoicePaymentAmount = Min(paymentAmountRemaining, qry_selectInvoiceList.invoiceTotal - qry_selectInvoicePaymentAmountTotal.sumInvoicePaymentAmount)>
							<cfif (invoicePaymentAmount + qry_selectInvoicePaymentAmountTotal.sumInvoicePaymentAmount) gte qry_selectInvoiceList.invoiceTotal>
								<cfset markInvoiceAsPaid_list = ListAppend(markInvoiceAsPaid_list, qry_selectInvoiceList.invoiceID)>
							</cfif>
						</cfif>

						<cfset paymentAmountRemaining = paymentAmountRemaining - invoicePaymentAmount>
						<cfinvoke Component="#Application.billingMapping#data.InvoicePayment" Method="insertInvoicePayment" ReturnVariable="isInvoicePaymentInserted">
							<cfinvokeargument Name="userID" Value="#qry_selectWebServiceSession.userID#">
							<cfinvokeargument Name="invoicePaymentManual" Value="1">
							<cfinvokeargument Name="paymentID" Value="#newPaymentID#">
							<cfinvokeargument Name="invoiceID" Value="#qry_selectInvoiceList.invoiceID#">
							<cfinvokeargument Name="invoicePaymentAmount" Value="#invoicePaymentAmount#">
						</cfinvoke>
					</cfif><!--- if invoice is not already fully paid and payment amount remaining --->
				</cfloop><!--- /loop thru invoices --->
			</cfif><!--- /if invoices(s) is specified --->

			<cfif Form.paymentProcessed is 0>
				<!--- update invoice as paid, if necessary --->
				<cfset Arguments.paymentApproved = Form.paymentApproved>
				<cfset paymentMessage = "">
			<cfelse><!--- process payment via merchant account --->
				<cfmodule Template="../../include/merchant/act_processPayment.cfm" paymentID="#newPaymentID#">

				<cfif isPaymentApproved is 1><!--- payment is approved --->
					<cfinvoke Component="#Application.billingMapping#data.Payment" Method="selectPayment" ReturnVariable="qry_selectPayment">
						<cfinvokeargument Name="paymentID" Value="#newPaymentID#">
					</cfinvoke>

					<cfset Arguments.paymentApproved = 1>
					<cfset paymentMessage = "">
				<cfelse>
					<cfset returnError = Variables.wslang_payment.paymentRejected>
					<cfset markInvoiceAsPaid_list = "">
					<cfset Arguments.paymentApproved = 0>
					<cfset paymentMessage = qry_selectPayment.paymentMessage>
				</cfif>
			</cfif>

			<cfif markInvoiceAsPaid_list is not "">
				<cfloop Index="thisInvoiceID" List="#markInvoiceAsPaid_list#">
					<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="updateInvoice" ReturnVariable="isInvoiceUpdated">
						<cfinvokeargument Name="invoiceID" Value="#thisInvoiceID#">
						<cfinvokeargument Name="invoicePaid" Value="1">
						<cfinvokeargument Name="invoiceDatePaid" Value="#CreateODBCDateTime(Now())#">
					</cfinvoke>
				</cfloop>
			</cfif>

			<!--- check for trigger --->
			<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
				<cfinvokeargument name="companyID" value="#qry_selectWebServiceSession.companyID#">
				<cfinvokeargument name="doAction" value="insertPayment">
				<cfinvokeargument name="isWebService" value="True">
				<cfinvokeargument name="doControl" value="company">
				<cfinvokeargument name="primaryTargetKey" value="paymentID">
				<cfinvokeargument name="targetID" value="#newPaymentID#">
			</cfinvoke>
	</cfif><!---- /payment is valid --->
	</cfif><!--- /validate and process payment --->
</cfif><!--- user is logged in and has insertPayment permission --->

<cfif returnValue is -1>
	<cfset paymentMessage = "">
	<cfset Arguments.paymentApproved = 0>
</cfif>

<cfset returnValue = "<xml><paymentID>" & returnValue & "</paymentID>"
		& "<paymentApproved>" & Arguments.paymentApproved & "</paymentApproved>"
		& "<paymentMessage>" & paymentMessage & "</paymentMessage></xml>">

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

