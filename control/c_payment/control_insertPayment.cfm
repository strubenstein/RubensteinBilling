<cfif Variables.doAction is "insertPayment" and URL.control is "invoice">
	<cfif qry_selectInvoice.invoicePaid is 1>
		<cflocation url="index.cfm?method=invoice.listPaymentsForInvoice&invoiceID=#URL.invoiceID#&error_payment=invoiceAlreadyPaid" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.InvoicePayment" Method="selectInvoicePaymentAmountTotal" ReturnVariable="qry_selectInvoicePaymentAmountTotal">
			<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
		</cfinvoke>

		<cfif IsNumeric(qry_selectInvoicePaymentAmountTotal.sumInvoicePaymentAmount)
				and qry_selectInvoicePaymentAmountTotal.sumInvoicePaymentAmount gte qry_selectInvoice.invoiceTotal>
			<!--- if necessary, mark invoice as paid --->
			<cfif qry_selectInvoice.invoicePaid is not 1>
				<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="updateInvoice" ReturnVariable="isInvoiceUpdated">
					<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
					<cfinvokeargument Name="invoicePaid" Value="1">
					<cfinvokeargument Name="invoiceDatePaid" Value="#CreateODBCDateTime(Now())#">
				</cfinvoke>
			</cfif>

			<cflocation url="index.cfm?method=invoice.listPaymentsForInvoice&invoiceID=#URL.invoiceID#&error_payment=invoiceAlreadyPaid" AddToken="No">
		</cfif>
	</cfif>
</cfif>

<cfinclude template="../../include/function/fn_datetime.cfm">
<cfinclude template="../../view/v_payment/var_paymentMethodList.cfm">

<cfinvoke Component="#Application.billingMapping#data.PaymentCategory" Method="selectPaymentCategoryList" ReturnVariable="qry_selectPaymentCategoryList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfif Variables.doAction is "insertPayment">
		<cfinvokeargument Name="paymentCategoryType" Value="payment">
	<cfelse>
		<cfinvokeargument Name="paymentCategoryType" Value="refund">
	</cfif>
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Bank" Method="selectBankList" ReturnVariable="qry_selectBankList">
	<cfinvokeargument Name="companyID" Value="#Variables.companyID#">
	<cfinvokeargument Name="bankStatus" Value="1">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="selectCreditCardList" ReturnVariable="qry_selectCreditCardList">
	<cfinvokeargument Name="companyID" Value="#Variables.companyID#">
	<cfinvokeargument Name="creditCardStatus" Value="1">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.MerchantAccount" Method="selectMerchantAccountList" ReturnVariable="qry_selectMerchantAccountList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	<cfinvokeargument Name="merchantAccountStatus" Value="1">
	<cfinvokeargument Name="returnMerchantFields" Value="True">
</cfinvoke>

<cfset displaySubscriberList = False>
<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="selectSubscriberList" ReturnVariable="qry_selectSubscriberList">
	<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
	<cfinvokeargument Name="companyID" Value="#Variables.companyID#">
	<cfinvokeargument Name="queryOrderBy" Value="subscriberName">
</cfinvoke>
<cfif qry_selectSubscriberList.RecordCount is not 0>
	<cfset displaySubscriberList = True>
</cfif>

<cfset displaySubscriptionList = False>
<cfset displayInvoiceLineItemList = False>
<cfif Variables.doAction is "insertPaymentRefund">
	<!--- 
	productID_subscriptionID - Retrieve list of products that may be the source of the refund:
	- If Variables.invoiceID: avInvoice.invoiceLineItemName
	- avSubscription.subscriptionName
	--->
	<cfif qry_selectSubscriberList.RecordCount is not 0>
		<cfinvoke Component="#Application.billingMapping#data.Subscription" Method="selectSubscriptionList" ReturnVariable="qry_selectSubscriptionList">
			<cfinvokeargument Name="subscriberID" Value="#ValueList(qry_selectSubscriberList.subscriberID)#">
			<cfinvokeargument Name="subscriptionID_parent" Value="0">
		</cfinvoke>

		<cfif qry_selectSubscriptionList.RecordCount is not 0>
			<cfset displaySubscriptionList = True>
		</cfif>
	</cfif>

	<cfif Variables.invoiceID is not 0>
		<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="selectInvoiceLineItemList" ReturnVariable="qry_selectInvoiceLineItemList">
			<cfinvokeargument Name="invoiceID" Value="#Variables.invoiceID#">
			<cfinvokeargument Name="invoiceLineItemStatus" Value="1">
		</cfinvoke>

		<cfif qry_selectInvoiceLineItemList.RecordCount is not 0>
			<cfset displayInvoiceLineItemList = True>
		</cfif>
	</cfif>
</cfif>

<cfset Variables.updatePaymentFieldList = "">
<cfinclude template="formParam_insertUpdatePayment.cfm">
<cfinvoke component="#Application.billingMapping#data.Payment" method="maxlength_Payment" returnVariable="maxlength_Payment" />
<cfinclude template="../../view/v_payment/lang_insertUpdatePayment.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitPayment")>
	<cfinclude template="formValidate_insertUpdatePayment.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Payment" Method="insertPayment" ReturnVariable="newPaymentID">
			<cfinvokeargument Name="userID" Value="#Variables.userID#">
			<cfinvokeargument Name="companyID" Value="#Variables.companyID#">
			<cfinvokeargument Name="userID_author" Value="#Session.userID#">
			<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
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
			<cfinvokeargument Name="subscriberID" Value="#Form.subscriberID#">
			<cfinvokeargument Name="paymentIsRefund" Value="#Form.paymentIsRefund#">
			<cfinvokeargument Name="paymentID_refund" Value="0">
			<!--- paymentMessage --->
			<cfif Form.creditCardID is not 0>
				<cfset ccRow = ListFind(ValueList(qry_selectCreditCardList.creditCardID), Form.creditCardID)>
				<cfinvokeargument Name="paymentCreditCardType" Value="#qry_selectCreditCardList.creditCardType[ccRow]#">
				<cfinvokeargument Name="paymentCreditCardLast4" Value="#Right(qry_selectCreditCardList.creditCardNumber[ccRow], 4)#">
			</cfif>
		</cfinvoke>

		<cfset Variables.markInvoiceAsPaid = False>
		<cfif Variables.doAction is "insertPayment" and URL.control is "invoice"><!---  and IsDefined("URL.invoiceID") and Application.fn_IsIntegerPositive(URL.invoiceID) --->
			<cfif Not IsNumeric(qry_selectInvoicePaymentAmountTotal.sumInvoicePaymentAmount)>
				<cfset Variables.invoicePaymentAmount = Min(Form.paymentAmount, qry_selectInvoice.invoiceTotal)>
				<cfif (Variables.invoicePaymentAmount gte qry_selectInvoice.invoiceTotal)>
					<cfset Variables.markInvoiceAsPaid = True>
				</cfif>
			<cfelse>
				<cfset Variables.invoicePaymentAmount = Min(Form.paymentAmount, qry_selectInvoice.invoiceTotal - qry_selectInvoicePaymentAmountTotal.sumInvoicePaymentAmount)>
				<cfif (Variables.invoicePaymentAmount + qry_selectInvoicePaymentAmountTotal.sumInvoicePaymentAmount) gte qry_selectInvoice.invoiceTotal>
					<cfset Variables.markInvoiceAsPaid = True>
				</cfif>
			</cfif>

			<cfinvoke Component="#Application.billingMapping#data.InvoicePayment" Method="insertInvoicePayment" ReturnVariable="isInvoicePaymentInserted">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="invoicePaymentManual" Value="1">
				<cfinvokeargument Name="paymentID" Value="#newPaymentID#">
				<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
				<cfinvokeargument Name="invoicePaymentAmount" Value="#Variables.invoicePaymentAmount#">
			</cfinvoke>
		</cfif>

		<cfif Variables.doAction is "insertPaymentRefund">
			<cfif Form.invoiceLineItemID is not "">
				<cfloop Index="lineItemID" List="#Form.invoiceLineItemID#">
					<cfset Variables.lineItemRow = ListFind(ValueList(qry_selectInvoiceLineItemList.invoiceLineItemID), lineItemID)>
					<cfinvoke Component="#Application.billingMapping#data.PaymentRefundProduct" Method="insertPaymentRefundProduct" ReturnVariable="isPaymentRefundProductInserted">
						<cfinvokeargument Name="paymentID" Value="#newPaymentID#">
						<cfinvokeargument Name="productID" Value="#qry_selectInvoiceLineItemList.productID[Variables.lineItemRow]#">
						<cfinvokeargument Name="subscriptionID" Value="#qry_selectInvoiceLineItemList.subscriptionID[Variables.lineItemRow]#">
						<cfinvokeargument Name="invoiceLineItemID" Value="#lineItemID#">
					</cfinvoke>
				</cfloop>
			</cfif>

			<cfif Form.subscriptionID is not "">
				<cfloop Index="subID" List="#Form.subscriptionID#">
					<cfset Variables.subRow = ListFind(ValueList(qry_selectSubscriptionList.subscriptionID), subID)>
					<cfinvoke Component="#Application.billingMapping#data.PaymentRefundProduct" Method="insertPaymentRefundProduct" ReturnVariable="isPaymentRefundProductInserted">
						<cfinvokeargument Name="paymentID" Value="#newPaymentID#">
						<cfinvokeargument Name="productID" Value="#qry_selectSubscriptionList.productID[Variables.subRow]#">
						<cfinvokeargument Name="subscriptionID" Value="#subID#">
						<cfinvokeargument Name="invoiceLineItemID" Value="0">
					</cfinvoke>
				</cfloop>
			</cfif>

			<!--- if refunding a specified payment, update payment to reflect it is refunded --->
			<cfif URL.paymentID is not 0>
				<cfinvoke Component="#Application.billingMapping#data.Payment" Method="updatePayment" ReturnVariable="isPaymentUpdated">
					<cfinvokeargument Name="paymentID" Value="#URL.paymentID#">
					<cfinvokeargument Name="paymentID_refund" Value="#newPaymentID#">
				</cfinvoke>
			</cfif>
		</cfif>

		<cfif Form.paymentProcessed is 0>
			<!--- update invoice as paid, if necessary --->
			<cfif Variables.markInvoiceAsPaid is True and Form.paymentApproved is 1>
				<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="updateInvoice" ReturnVariable="isInvoiceUpdated">
					<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
					<cfinvokeargument Name="invoicePaid" Value="1">
					<cfinvokeargument Name="invoiceDatePaid" Value="#CreateODBCDateTime(Now())#">
				</cfinvoke>
			</cfif>

			<!--- check for trigger --->
			<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
				<cfinvokeargument name="companyID" value="#Session.companyID#">
				<cfinvokeargument name="doAction" value="#Variables.doAction#">
				<cfinvokeargument name="isWebService" value="False">
				<cfinvokeargument name="doControl" value="#Variables.doControl#">
				<cfinvokeargument name="primaryTargetKey" value="paymentID">
				<cfinvokeargument name="targetID" value="#newPaymentID#">
			</cfinvoke>

			<cfif Variables.markInvoiceAsPaid is True and Form.paymentApproved is 1>
				<cflocation url="index.cfm?method=#URL.control#.viewPayment#Variables.urlParameters#&confirm_payment=#Variables.doAction#" AddToken="No">
			<cfelse>
				<cflocation url="index.cfm?method=#URL.control#.#Variables.doAction##Variables.urlParameters#&confirm_payment=#Variables.doAction#" AddToken="No">
			</cfif>
		<cfelse><!--- process payment via merchant account --->
			<cfmodule Template="../../include/merchant/act_processPayment.cfm" paymentID="#newPaymentID#">
			<cfif Variables.doAction is "updatePayment">
				<cfset Variables.redirectAction = "viewPayment">
			<cfelse>
				<cfset Variables.redirectAction = "viewPaymentRefund">
			</cfif>

			<cfif isPaymentApproved is 1><!--- payment is approved --->
				<!--- update invoice as paid, if necessary --->
				<cfif Variables.markInvoiceAsPaid is True>
					<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="updateInvoice" ReturnVariable="isInvoiceUpdated">
						<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
						<cfinvokeargument Name="invoicePaid" Value="1">
						<cfinvokeargument Name="invoiceDatePaid" Value="#CreateODBCDateTime(Now())#">
					</cfinvoke>
				</cfif>
			</cfif>

			<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
				<cfinvokeargument name="companyID" value="#Session.companyID#">
				<cfinvokeargument name="doAction" value="#Variables.doAction#">
				<cfinvokeargument name="isWebService" value="False">
				<cfinvokeargument name="doControl" value="#Variables.doControl#">
				<cfinvokeargument name="primaryTargetKey" value="paymentID">
				<cfinvokeargument name="targetID" value="#newPaymentID#">
			</cfinvoke>

			<cfif isPaymentApproved is 1><!--- payment is approved --->
				<cflocation url="index.cfm?method=#URL.control#.#Variables.redirectAction##Variables.urlParameters#&paymentID=#newPaymentID#&confirm_payment=#Variables.doAction#_approve" AddToken="No">
			<cfelse>
				<cflocation url="index.cfm?method=#URL.control#.#Variables.redirectAction##Variables.urlParameters#&paymentID=#newPaymentID#&confirm_payment=#Variables.doAction#_reject" AddToken="No">
			</cfif>
		</cfif>
	</cfif>
</cfif>

<cfset Variables.formName = "insertPayment">
<cfif Variables.doAction is "insertPayment">
	<cfset Variables.formSubmitValue = Variables.lang_insertUpdatePayment.formSubmitValue_insertPayment>
<cfelse>
	<cfset Variables.formSubmitValue = Variables.lang_insertUpdatePayment.formSubmitValue_insertRefund>
</cfif>

<cfinclude template="../../view/v_payment/form_insertUpdatePayment.cfm">
