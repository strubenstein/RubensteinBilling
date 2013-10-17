<cfif qry_selectPaymentCredit.paymentCategoryID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.PaymentCategory" Method="selectPaymentCategory" ReturnVariable="qry_selectPaymentCategory">
		<cfinvokeargument Name="paymentCategoryID" Value="#qry_selectPaymentCredit.paymentCategoryID#">
	</cfinvoke>
</cfif>

<cfinvoke Component="#Application.billingMapping#data.PaymentCreditProduct" Method="selectPaymentCreditProductList" ReturnVariable="qry_selectPaymentCreditProductList">
	<cfinvokeargument Name="paymentCreditID" Value="#URL.paymentCreditID#">
	<cfinvokeargument Name="returnInvoiceLineItemFields" Value="True">
	<cfinvokeargument Name="returnSubscriptionFields" Value="True">
	<cfinvokeargument Name="returnProductFields" Value="True">
	<cfinvokeargument Name="returnPaymentCreditFields" Value="False">
</cfinvoke>

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewCompany,viewSubscriber,viewUser,viewInvoice,viewProduct,viewSubscriptions")>

<cfinclude template="../../view/v_paymentCredit/dsp_selectPaymentCredit.cfm">

<cfif qry_selectPaymentCreditProductList.RecordCount is not 0>
	<cfinclude template="../../view/v_paymentCredit/dsp_selectPaymentCreditProductList.cfm">
</cfif>

