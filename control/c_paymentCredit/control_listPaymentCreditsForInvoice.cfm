<cfinvoke Component="#Application.billingMapping#data.InvoicePaymentCredit" Method="selectInvoicePaymentCreditList" ReturnVariable="qry_selectInvoicePaymentCreditList">
	<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
	<cfinvokeargument Name="returnInvoiceFields" Value="False">
	<cfinvokeargument Name="returnPaymentCreditFields" Value="True">
</cfinvoke>

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewCompany,viewUser,viewPaymentCredit,updateInvoicePaymentCredit,deleteInvoicePaymentCredit")>
<cfinvoke component="#Application.billingMapping#data.InvoicePaymentCredit" method="maxlength_InvoicePaymentCredit" returnVariable="maxlength_InvoicePaymentCredit" />
<cfinclude template="../../view/v_paymentCredit/dsp_listPaymentCreditsForInvoice.cfm">

