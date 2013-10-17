<cfinclude template="../../view/v_payment/var_paymentMethodList.cfm">

<cfif qry_selectPayment.paymentCategoryID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.PaymentCategory" Method="selectPaymentCategory" ReturnVariable="qry_selectPaymentCategory">
		<cfinvokeargument Name="paymentCategoryID" Value="#qry_selectPayment.paymentCategoryID#">
	</cfinvoke>
</cfif>

<cfset Variables.displayBank = False>
<cfif qry_selectPayment.bankID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Bank" Method="selectBank" ReturnVariable="qry_selectBank">
		<cfinvokeargument Name="bankID" Value="#qry_selectPayment.bankID#">
	</cfinvoke>

	<cfif qry_selectBank.RecordCount is not 0>
		<cfset Variables.displayBank = True>
	</cfif>
</cfif>

<cfset Variables.displayCreditCard = False>
<cfif qry_selectPayment.creditCardID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="selectCreditCard" ReturnVariable="qry_selectCreditCard">
		<cfinvokeargument Name="creditCardID" Value="#qry_selectPayment.creditCardID#">
	</cfinvoke>

	<cfif qry_selectCreditCard.RecordCount is not 0>
		<cfset Variables.displayCreditCard = True>
	</cfif>
</cfif>

<cfset Variables.displayMerchantAccount = False>
<cfif qry_selectPayment.merchantAccountID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.MerchantAccount" Method="selectMerchantAccount" ReturnVariable="qry_selectMerchantAccount">
		<cfinvokeargument Name="merchantAccountID" Value="#qry_selectPayment.merchantAccountID#">
		<cfinvokeargument Name="returnMerchantFields" Value="True">
	</cfinvoke>

	<cfif qry_selectMerchantAccount.RecordCount is not 0>
		<cfset Variables.displayMerchantAccount = True>
	</cfif>
</cfif>

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewCompany,viewUser,viewInvoice,viewSubscriber,viewProduct,viewSubscriptions,viewPaymentRefund")>

<cfinclude template="../../view/v_payment/dsp_selectPayment.cfm">

<cfif Variables.doAction is "viewPaymentRefund">
	<cfinvoke Component="#Application.billingMapping#data.PaymentRefundProduct" Method="selectPaymentRefundProductList" ReturnVariable="qry_selectPaymentRefundProductList">
		<cfinvokeargument Name="paymentID" Value="#URL.paymentID#">
		<cfinvokeargument Name="returnInvoiceLineItemFields" Value="True">
		<cfinvokeargument Name="returnSubscriptionFields" Value="True">
		<cfinvokeargument Name="returnProductFields" Value="True">
		<cfinvokeargument Name="returnPaymentRefundFields" Value="False">
	</cfinvoke>

	<cfif qry_selectPaymentRefundProductList.RecordCount is not 0>
		<cfinclude template="../../view/v_payment/dsp_selectPaymentRefundProductList.cfm">
	</cfif>
</cfif>
