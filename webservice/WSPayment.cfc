<cfcomponent DisplayName="WSPayment" Hint="Manages all payment and refund web services">

<cffunction Name="insertPayment" Access="remote" ReturnType="string" Hint="Insert new payment, including processing a transaction. Returns paymentID, paymentApproved and paymentMessage in XML string.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="useInvoiceTotalForPaymentAmount" Type="boolean">
	<cfargument Name="processPaymentViaMerchantAccount" Type="boolean">
	<cfargument Name="invoiceID" Type="string">
	<cfargument Name="invoiceID_custom" Type="string">
	<cfargument Name="companyID" Type="numeric">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="subscriberID" Type="numeric">
	<cfargument Name="subscriberID_custom" Type="string">
	<cfargument Name="paymentCategoryID" Type="numeric">
	<cfargument Name="paymentCategoryID_custom" Type="string">
	<cfargument Name="paymentCheckNumber" Type="numeric">
	<cfargument Name="paymentID_custom" Type="string">
	<cfargument Name="paymentStatus" Type="boolean">
	<cfargument Name="paymentApproved" Type="string">
	<cfargument Name="paymentAmount" Type="numeric">
	<cfargument Name="paymentDescription" Type="string">
	<cfargument Name="paymentMethod" Type="string">
	<cfargument Name="paymentProcessed" Type="string">
	<cfargument Name="paymentDateReceived" Type="string">
	<cfargument Name="paymentDateScheduled" Type="string">

	<cfset var returnValue = "">
	<cfset var returnError = "">

	<cfset var theCompanyID = 0>
	<cfset var theSubscriberID = 0>
	<cfset var theInvoiceID = 0>
	<cfset var invoiceTotalUnpaid = 0>
	<cfset var displaySubscriptionList = False>
	<cfset var displayInvoiceLineItemList = False>
	<cfset var displaySubscriberList = False>
	<cfset var theMerchantAccountID = 0>
	<cfset var theCreditCardID = 0>
	<cfset var theBankID = 0>

	<cfset var errorMessage_fields = StructNew()>
	<cfset var payCatRow = 0>
	<cfset var dateReceivedText = "">
	<cfset var dateBeginResponse = "">
	<cfset var checkVar = "">
	<cfset var isAllFormFieldsOk = False>

	<cfset var markInvoiceAsPaid_list = "">
	<cfset var paymentAmountRemaining = 0>
	<cfset var invoicePaymentAmount = 0>
	<cfset var paymentMessage = "">

	<cfinclude template="ws_payment/ws_insertPayment.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="insertPaymentRefund" Access="remote" ReturnType="string" Hint="Insert new refund, including processing a transaction. Returns paymentID, paymentApproved and paymentMessage in XML string.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="processPaymentViaMerchantAccount" Type="boolean">
	<cfargument Name="invoiceLineItemID" Type="string">
	<cfargument Name="companyID" Type="numeric">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="subscriberID" Type="numeric">
	<cfargument Name="subscriberID_custom" Type="string">
	<cfargument Name="subscriptionID" Type="string">
	<cfargument Name="subscriptionID_custom" Type="string">
	<cfargument Name="paymentID_refund" Type="numeric">
	<cfargument Name="paymentID_refund_custom" Type="string">
	<cfargument Name="paymentCategoryID" Type="numeric">
	<cfargument Name="paymentCategoryID_custom" Type="string">
	<cfargument Name="paymentCheckNumber" Type="numeric">
	<cfargument Name="paymentID_custom" Type="string">
	<cfargument Name="paymentStatus" Type="boolean">
	<cfargument Name="paymentApproved" Type="string">
	<cfargument Name="paymentAmount" Type="numeric">
	<cfargument Name="paymentDescription" Type="string">
	<cfargument Name="paymentMethod" Type="string">
	<cfargument Name="paymentProcessed" Type="string">
	<cfargument Name="paymentDateReceived" Type="string">
	<cfargument Name="paymentDateScheduled" Type="string">

	<cfset var returnValue = "">
	<cfset var returnError = "">

	<cfset var theCompanyID = 0>
	<cfset var theSubscriberID = 0>
	<cfset var displaySubscriptionList = True>
	<cfset var displayInvoiceLineItemList = True>
	<cfset var displaySubscriberList = False>
	<cfset var theMerchantAccountID = 0>
	<cfset var theInvoiceID = 0>
	<cfset var theCreditCardID = 0>
	<cfset var theBankID = 0>
	<cfset var theSubscriptionID = 0>
	<cfset var thePaymentID_refund = 0>
	<cfset var lineItemRow = 0>
	<cfset var subRow = 0>

	<cfset var errorMessage_fields = StructNew()>
	<cfset var payCatRow = 0>
	<cfset var dateReceivedText = "">
	<cfset var dateBeginResponse = "">
	<cfset var checkVar = "">
	<cfset var isAllFormFieldsOk = False>
	<cfset var markInvoiceAsPaid_list = "">
	<cfset var paymentMessage = "">

	<cfinclude template="ws_payment/ws_insertPaymentRefund.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectPayment" Access="remote" ReturnType="query" Hint="Returns existing payment.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="paymentID" Type="string">
	<cfargument Name="paymentID_custom" Type="string">

	<cfset var returnValue = QueryNew("error")>
	<cfset var returnError = "">
	<cfset var permissionActionList = "">
	<cfset var okToView = True>

	<cfinclude template="ws_payment/ws_selectPayment.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectPaymentList_count" Access="remote" ReturnType="numeric" Hint="Returns number of payments and/or refunds that meet criteria.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="searchFieldList" Type="string">
	<cfargument Name="affiliateID" Type="string">
	<cfargument Name="affiliateID_custom" Type="string">
	<cfargument Name="cobrandID" Type="string">
	<cfargument Name="cobrandID_custom" Type="string">
	<cfargument Name="userID" Type="string">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="companyID" Type="string">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="paymentID" Type="string">
	<cfargument Name="paymentID_custom" Type="string">
	<cfargument Name="invoiceID" Type="string">
	<cfargument Name="invoiceID_custom" Type="string">
	<cfargument Name="subscriberID" Type="string">
	<cfargument Name="subscriberID_custom" Type="string">
	<cfargument Name="productID" Type="string">
	<cfargument Name="productID_custom" Type="string">
	<cfargument Name="subscriptionID" Type="string">
	<cfargument Name="subscriptionID_custom" Type="string">
	<cfargument Name="paymentCategoryID" Type="string">
	<cfargument Name="paymentCategoryID_custom" Type="string">
	<cfargument Name="paymentAppliedToInvoice" Type="boolean">
	<cfargument Name="paymentAppliedToMultipleInvoices" Type="boolean">
	<cfargument Name="paymentManual" Type="boolean">
	<cfargument Name="paymentStatus" Type="boolean">
	<cfargument Name="paymentApproved" Type="string">
	<cfargument Name="paymentCheckNumber_min" Type="numeric">
	<cfargument Name="paymentCheckNumber_max" Type="numeric">
	<cfargument Name="creditCardID" Type="string">
	<cfargument Name="bankID" Type="string">
	<cfargument Name="merchantAccountID" Type="string">
	<cfargument Name="paymentIsScheduled" Type="boolean">
	<cfargument Name="paymentMessage" Type="string">
	<cfargument Name="paymentAmount_min" Type="numeric">
	<cfargument Name="paymentAmount_max" Type="numeric">
	<cfargument Name="paymentMethod" Type="string">
	<cfargument Name="paymentProcessed" Type="boolean">
	<cfargument Name="paymentDateReceived_from" Type="string">
	<cfargument Name="paymentDateReceived_to" Type="string">
	<cfargument Name="paymentDateCreated_from" Type="string">
	<cfargument Name="paymentDateCreated_to" Type="string">
	<cfargument Name="paymentDateUpdated_from" Type="string">
	<cfargument Name="paymentDateUpdated_to" Type="string">
	<cfargument Name="paymentDateScheduled_from" Type="string">
	<cfargument Name="paymentDateScheduled_to" Type="string">
	<cfargument Name="paymentHasBeenRefunded" Type="boolean">
	<cfargument Name="paymentIsRefund" Type="boolean">
	<cfargument Name="paymentIsExported" Type="string">

	<cfset var returnValue = -1>
	<cfset var returnError = "">
	<cfset var doAction = "">
	<cfset var qryParamStruct = StructNew()>

	<cfinclude template="ws_payment/ws_selectPaymentList_count.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectPaymentList" Access="remote" ReturnType="query" Hint="Returns payments and/or refunds that meet criteria.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="searchFieldList" Type="string">
	<cfargument Name="affiliateID" Type="string">
	<cfargument Name="affiliateID_custom" Type="string">
	<cfargument Name="cobrandID" Type="string">
	<cfargument Name="cobrandID_custom" Type="string">
	<cfargument Name="userID" Type="string">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="companyID" Type="string">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="paymentID" Type="string">
	<cfargument Name="paymentID_custom" Type="string">
	<cfargument Name="invoiceID" Type="string">
	<cfargument Name="invoiceID_custom" Type="string">
	<cfargument Name="subscriberID" Type="string">
	<cfargument Name="subscriberID_custom" Type="string">
	<cfargument Name="productID" Type="string">
	<cfargument Name="productID_custom" Type="string">
	<cfargument Name="subscriptionID" Type="string">
	<cfargument Name="subscriptionID_custom" Type="string">
	<cfargument Name="paymentCategoryID" Type="string">
	<cfargument Name="paymentCategoryID_custom" Type="string">
	<cfargument Name="paymentAppliedToInvoice" Type="boolean">
	<cfargument Name="paymentAppliedToMultipleInvoices" Type="boolean">
	<cfargument Name="paymentManual" Type="boolean">
	<cfargument Name="paymentStatus" Type="boolean">
	<cfargument Name="paymentApproved" Type="string">
	<cfargument Name="paymentCheckNumber_min" Type="numeric">
	<cfargument Name="paymentCheckNumber_max" Type="numeric">
	<cfargument Name="creditCardID" Type="string">
	<cfargument Name="bankID" Type="string">
	<cfargument Name="merchantAccountID" Type="string">
	<cfargument Name="paymentIsScheduled" Type="boolean">
	<cfargument Name="paymentMessage" Type="string">
	<cfargument Name="paymentAmount_min" Type="numeric">
	<cfargument Name="paymentAmount_max" Type="numeric">
	<cfargument Name="paymentMethod" Type="string">
	<cfargument Name="paymentProcessed" Type="boolean">
	<cfargument Name="paymentDateReceived_from" Type="string">
	<cfargument Name="paymentDateReceived_to" Type="string">
	<cfargument Name="paymentDateCreated_from" Type="string">
	<cfargument Name="paymentDateCreated_to" Type="string">
	<cfargument Name="paymentDateUpdated_from" Type="string">
	<cfargument Name="paymentDateUpdated_to" Type="string">
	<cfargument Name="paymentDateScheduled_from" Type="string">
	<cfargument Name="paymentDateScheduled_to" Type="string">
	<cfargument Name="paymentHasBeenRefunded" Type="boolean">
	<cfargument Name="paymentIsRefund" Type="boolean" Required="No">
	<cfargument Name="paymentIsExported" Type="string">
	<cfargument Name="queryDisplayPerPage" Type="numeric">
	<cfargument Name="queryPage" Type="numeric">
	<cfargument Name="queryOrderBy" Type="string">

	<cfset var returnValue = QueryNew("error")>
	<cfset var returnError = "">
	<cfset var doAction = "">
	<cfset var qryParamStruct = StructNew()>

	<cfinclude template="ws_payment/ws_selectPaymentList.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="updatePaymentIsExported" Access="public" Output="No" ReturnType="boolean" Hint="Updates whether payment records have been exported. Returns True.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="paymentID" Type="string" Required="Yes">
	<cfargument Name="paymentID_custom" Type="string" Required="Yes">
	<cfargument Name="paymentIsExported" Type="string" Required="Yes">

	<cfset var returnValue = False>
	<cfset var returnError = "">

	<cfinclude template="ws_payment/ws_updatePaymentIsExported.cfm">
	<cfreturn returnValue>
</cffunction>

</cfcomponent>
