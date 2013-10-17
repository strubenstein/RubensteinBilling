<cfinvoke Component="#Application.billingMapping#data.InvoicePaymentCredit" Method="selectInvoicePaymentCreditList" ReturnVariable="qry_selectInvoicePaymentCreditList">
	<cfinvokeargument Name="paymentCreditID" Value="#URL.paymentCreditID#">
	<cfinvokeargument Name="returnInvoiceFields" Value="True">
	<cfinvokeargument Name="returnPaymentCreditFields" Value="False">
</cfinvoke>

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewCompany,viewUser,viewInvoice,viewSubscriber,deleteInvoicePaymentCredit,updateInvoicePaymentCredit")>

<cfinvoke component="#Application.billingMapping#data.InvoicePaymentCredit" method="maxlength_InvoicePaymentCredit" returnVariable="maxlength_InvoicePaymentCredit" />
<cfinclude template="../../view/v_paymentCredit/dsp_listInvoicesForPaymentCredit.cfm">
