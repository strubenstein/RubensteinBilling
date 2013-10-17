<!--- select subscriber payment method --->
<cfinvoke Component="#Application.billingMapping#data.SubscriberPayment" Method="selectSubscriberPaymentList" ReturnVariable="qry_selectSubscriberPayment">
	<cfinvokeargument Name="subscriberID" Value="#Variables.subscriberID#">
	<cfinvokeargument Name="subscriberPaymentStatus" Value="1">
	<cfinvokeargument Name="selectCreditCardInfo" Value="True">
</cfinvoke>

<!--- if paying by bank ACH or credit card, process payment --->
<cfif qry_selectSubscriberPayment.RecordCount is not 0 and (qry_selectSubscriberPayment.creditCardID is not 0 or qry_selectSubscriberPayment.bankID is not 0)>
	<!--- select invoice total to determine how much to charge --->
	<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoice" ReturnVariable="qry_selectInvoice">
		<cfinvokeargument Name="invoiceID" Value="#Variables.invoiceID#">
	</cfinvoke>

	<cfif qry_selectInvoice.invoiceTotal gt 0 and qry_selectInvoice.invoicePaid is not 1>
		<cfif qry_selectSubscriberPayment.creditCardID is not 0>
			<cfset Variables.paymentMethod = "credit card">
		<cfelse>
			<cfset Variables.paymentMethod = "bank">
		</cfif>

		<!--- determine payment category based on automated payment method --->
		<cfinvoke Component="#Application.billingMapping#data.PaymentCategory" Method="selectPaymentCategoryList" ReturnVariable="qry_selectPaymentCategoryList">
			<cfinvokeargument Name="companyID" Value="#qry_selectSubscriber.companyID_author#">
			<cfinvokeargument Name="paymentCategoryStatus" Value="1">
			<cfinvokeargument Name="paymentCategoryType" Value="payment">
			<cfinvokeargument Name="paymentCategoryAutoMethod" Value="#Variables.paymentMethod#">
		</cfinvoke>

		<cfif qry_selectPaymentCategoryList.RecordCount is 1>
			<cfset Variables.paymentCategoryID = qry_selectPaymentCategoryList.paymentCategoryID>
		<cfelse>
			<cfset Variables.paymentCategoryID = 0>
		</cfif>

		<!--- Determiner merchant account based on automated payment method --->
		<cfinvoke Component="#Application.billingMapping#data.MerchantAccount" Method="selectMerchantAccountList" ReturnVariable="qry_selectMerchantAccountList">
			<cfinvokeargument Name="companyID" Value="#qry_selectSubscriber.companyID_author#">
			<cfinvokeargument Name="merchantAccountStatus" Value="1">
			<cfif Variables.paymentMethod is "credit card">
				<cfinvokeargument Name="merchantAccountCreditCard" Value="1">
			<cfelse>
				<cfinvokeargument Name="merchantAccountBank" Value="1">
			</cfif>
		</cfinvoke>

		<cfif qry_selectMerchantAccountList.RecordCount is not 0>
			<!--- determine payment amount --->
			<cfinvoke Component="#Application.billingMapping#data.InvoicePayment" Method="selectInvoicePaymentAmountTotal" ReturnVariable="qry_selectInvoicePaymentAmountTotal">
				<cfinvokeargument Name="invoiceID" Value="#Variables.invoiceID#">
			</cfinvoke>

			<cfif Not IsNumeric(qry_selectInvoicePaymentAmountTotal.sumInvoicePaymentAmount)>
				<cfset Variables.paymentAmount = qry_selectInvoice.invoiceTotal>
			<cfelse>
				<cfset Variables.paymentAmount = qry_selectInvoice.invoiceTotal - qry_selectInvoicePaymentAmountTotal.sumInvoicePaymentAmount>
			</cfif>

			<!--- determine whether to process payment now or schedule for later --->
			<cfif Variables.payflowID is 0>
				<cfset Variables.paymentDateScheduled = "">
			<cfelseif qry_selectPayflow.payflowChargeDaysFromSubscriberDate is 0>
				<cfset Variables.paymentDateScheduled = "">
			<cfelse>
				<cfset Variables.paymentDateScheduled = DateAdd("d", qry_selectPayflow.payflowChargeDaysFromSubscriberDate, Now())>
			</cfif>

			<cfinvoke Component="#Application.billingMapping#data.Payment" Method="insertPayment" ReturnVariable="newPaymentID">
				<cfinvokeargument Name="userID" Value="#qry_selectSubscriber.userID#">
				<cfinvokeargument Name="companyID" Value="#qry_selectSubscriber.companyID#">
				<cfinvokeargument Name="userID_author" Value="0">
				<cfinvokeargument Name="companyID_author" Value="#qry_selectSubscriber.companyID_author#">
				<cfinvokeargument Name="paymentManual" Value="0">
				<cfinvokeargument Name="creditCardID" Value="#qry_selectSubscriberPayment.creditCardID#">
				<cfinvokeargument Name="bankID" Value="#qry_selectSubscriberPayment.bankID#">
				<cfinvokeargument Name="merchantAccountID" Value="#qry_selectMerchantAccountList.merchantAccountID#">
				<cfinvokeargument Name="paymentCheckNumber" Value="0">
				<cfinvokeargument Name="paymentID_custom" Value="">
				<cfinvokeargument Name="paymentStatus" Value="1">
				<cfinvokeargument Name="paymentApproved" Value="">
				<cfinvokeargument Name="paymentAmount" Value="#Variables.paymentAmount#">
				<cfinvokeargument Name="paymentDescription" Value="">
				<cfinvokeargument Name="paymentMethod" Value="#Variables.paymentMethod#">
				<cfinvokeargument Name="paymentProcessed" Value="1">
				<cfinvokeargument Name="paymentDateReceived" Value="#Now()#">
				<cfinvokeargument Name="paymentDateScheduled" Value="#Variables.paymentDateScheduled#">
				<cfinvokeargument Name="paymentCategoryID" Value="#Variables.paymentCategoryID#">
				<cfinvokeargument Name="subscriberID" Value="#Variables.subscriberID#">
				<cfinvokeargument Name="paymentIsRefund" Value="0">
				<cfinvokeargument Name="paymentID_refund" Value="0">
				<cfif qry_selectSubscriberPayment.creditCardID is not 0>
					<cfinvokeargument Name="paymentCreditCardType" Value="#qry_selectSubscriberPayment.creditCardType#">
					<cfinvokeargument Name="paymentCreditCardLast4" Value="#Right(qry_selectSubscriberPayment.creditCardNumber, 4)#">
				</cfif>
			</cfinvoke>

			<cfinvoke Component="#Application.billingMapping#data.InvoicePayment" Method="insertInvoicePayment" ReturnVariable="isInvoicePaymentInserted">
				<cfinvokeargument Name="userID" Value="0">
				<cfinvokeargument Name="invoicePaymentManual" Value="0">
				<cfinvokeargument Name="paymentID" Value="#newPaymentID#">
				<cfinvokeargument Name="invoiceID" Value="#Variables.invoiceID#">
				<cfinvokeargument Name="invoicePaymentAmount" Value="#Variables.paymentAmount#">
			</cfinvoke>

			<!--- if payment is not scheduled, process now --->
			<cfif Variables.paymentDateScheduled is "">
				<cfmodule Template="../../../include/merchant/act_processPayment.cfm" paymentID="#newPaymentID#">

				<cfif isPaymentApproved is 1><!--- payment is approved --->
					<!--- update invoice as paid, if necessary --->
					<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="updateInvoice" ReturnVariable="isInvoiceUpdated">
						<cfinvokeargument Name="invoiceID" Value="#Variables.invoiceID#">
						<cfinvokeargument Name="invoicePaid" Value="1">
						<cfinvokeargument Name="invoiceDatePaid" Value="#CreateODBCDateTime(Now())#">
					</cfinvoke>
				</cfif>
			</cfif>
		</cfif>
	</cfif>
</cfif>
