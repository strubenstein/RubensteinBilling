<cfinclude template="wslang_payment.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = -1>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("insertPaymentRefund", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = -1>
	<cfset returnError = Variables.wslang_payment.insertPaymentRefund>
<cfelse>
	<cfset returnValue = 0>
	<cfset Variables.doAction = "insertPaymentRefund">

	<cfloop Index="field" List="paymentStatus,paymentApproved,paymentProcessed">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfinclude template="wsact_insertPayment_validateCompanySubscriber.cfm">
	<cfinclude template="wsact_insertPaymentRefund_validateLineItem.cfm">
	<cfinclude template="wsact_insertPaymentRefund_validateSubscription.cfm">
	<cfinclude template="wsact_insertPaymentRefund_validatePayment.cfm">

	<!--- validate that company or subscriber is specified to determine customer receiving refund --->
	<cfif returnValue is 0 and Arguments.companyID is 0 and Arguments.subscriberID is 0>
		<cfset returnValue = -1>
		<cfset returnError = Variables.wslang_payment.noRefundCustomer>
	</cfif>

	<!--- if paying via merchant account, validate merchant account, credit card and/or bank account --->
	<cfinclude template="wsact_insertPayment_validateMerchant.cfm">

	<!--- validate and process payment --->
	<cfif returnValue is 0>
		<cfif Arguments.invoiceLineItemID is 0>
			<cfset Form.invoiceLineItemID = "">
		<cfelse>
			<cfset Form.invoiceLineItemID = Arguments.invoiceLineItemID>
		</cfif>

		<cfif theSubscriptionID is 0>
			<cfset Form.subscriptionID = "">
		<cfelse>
			<cfset Form.subscriptionID = Arguments.subscriptionID>
		</cfif>

		<!--- 
		<cfset displaySubscriptionList = True>
		<cfset displayInvoiceLineItemList = True>
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
				<cfinvokeargument Name="paymentIsRefund" Value="1">
				<cfinvokeargument Name="paymentID_refund" Value="0">
				<!--- paymentMessage --->
				<cfif Form.creditCardID is not 0>
					<cfinvokeargument Name="paymentCreditCardType" Value="#qry_selectSubscriberPayment.creditCardType#">
					<cfinvokeargument Name="paymentCreditCardLast4" Value="#Right(qry_selectSubscriberPayment.creditCardNumber, 4)#">
				</cfif>
			</cfinvoke>

			<cfset returnValue = newPaymentID>

			<cfif Form.invoiceLineItemID is not "">
				<cfloop Index="lineItemID" List="#Form.invoiceLineItemID#">
					<cfset lineItemRow = ListFind(ValueList(qry_selectInvoiceLineItemList.invoiceLineItemID), lineItemID)>
					<cfinvoke Component="#Application.billingMapping#data.PaymentRefundProduct" Method="insertPaymentRefundProduct" ReturnVariable="isPaymentRefundProductInserted">
						<cfinvokeargument Name="paymentID" Value="#newPaymentID#">
						<cfinvokeargument Name="productID" Value="#qry_selectInvoiceLineItemList.productID[lineItemRow]#">
						<cfinvokeargument Name="subscriptionID" Value="#qry_selectInvoiceLineItemList.subscriptionID[lineItemRow]#">
						<cfinvokeargument Name="invoiceLineItemID" Value="#lineItemID#">
					</cfinvoke>
				</cfloop>
			</cfif>

			<cfif Form.subscriptionID is not "">
				<cfloop Index="subID" List="#Form.subscriptionID#">
					<cfset subRow = ListFind(ValueList(qry_selectSubscriptionList.subscriptionID), subID)>
					<cfinvoke Component="#Application.billingMapping#data.PaymentRefundProduct" Method="insertPaymentRefundProduct" ReturnVariable="isPaymentRefundProductInserted">
						<cfinvokeargument Name="paymentID" Value="#newPaymentID#">
						<cfinvokeargument Name="productID" Value="#qry_selectSubscriptionList.productID[subRow]#">
						<cfinvokeargument Name="subscriptionID" Value="#subID#">
						<cfinvokeargument Name="invoiceLineItemID" Value="0">
					</cfinvoke>
				</cfloop>
			</cfif>

			<!--- if refunding a specified payment, update payment to reflect it is refunded --->
			<cfif Arguments.paymentID_refund is not 0>
				<cfinvoke Component="#Application.billingMapping#data.Payment" Method="updatePayment" ReturnVariable="isPaymentUpdated">
					<cfinvokeargument Name="paymentID" Value="#Arguments.paymentID_refund#">
					<cfinvokeargument Name="paymentID_refund" Value="#newPaymentID#">
				</cfinvoke>
			</cfif>

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
					<cfset returnError = Variables.wslang_payment.refundRejected>
					<cfset markInvoiceAsPaid_list = "">
					<cfset Arguments.paymentApproved = 0>
					<cfset paymentMessage = qry_selectPayment.paymentMessage>
				</cfif>
			</cfif>

			<!--- check for trigger --->
			<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
				<cfinvokeargument name="companyID" value="#qry_selectWebServiceSession.companyID#">
				<cfinvokeargument name="doAction" value="insertPaymentRefund">
				<cfinvokeargument name="isWebService" value="True">
				<cfinvokeargument name="doControl" value="company">
				<cfinvokeargument name="primaryTargetKey" value="paymentID">
				<cfinvokeargument name="targetID" value="#newPaymentID#">
			</cfinvoke>
		</cfif><!---- /refund is valid --->
	</cfif><!--- /validate and process refund --->
</cfif><!--- user is logged in and has insertPaymentRefund permission --->

<cfif returnValue lte -1>
	<cfset paymentMessage = "">
	<cfset Arguments.paymentApproved = 0>
</cfif>

<cfset returnValue = "<xml><paymentID>" & returnValue & "</paymentID>"
		& "<paymentApproved>" & Arguments.paymentApproved & "</paymentApproved>"
		& "<paymentMessage>" & paymentMessage & "</paymentMessage></xml>">

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">


