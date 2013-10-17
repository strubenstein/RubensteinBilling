<cfinvoke Component="#Application.billingMapping#data.InvoicePayment" Method="selectInvoicePaymentList" ReturnVariable="qry_selectInvoicePaymentList">
	<cfinvokeargument Name="paymentID" Value="#URL.paymentID#">
	<cfinvokeargument Name="returnInvoiceFields" Value="True">
	<cfinvokeargument Name="returnPaymentFields" Value="False">
</cfinvoke>

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewCompany,viewUser,viewInvoice,viewSubscriber,deleteInvoicePayment")>

<cfinclude template="../../view/v_payment/dsp_listInvoicesForPayment.cfm">
