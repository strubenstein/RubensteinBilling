<cfif Not Application.fn_IsIntegerNonNegative(URL.paymentCreditID)>
	<cflocation url="index.cfm?method=#URL.control#.listPaymentCredits#Variables.urlParameters#&error_paymentCredit=invalidPaymentCredit" AddToken="No">
<cfelseif URL.paymentCreditID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.PaymentCredit" Method="checkPaymentCreditPermission" ReturnVariable="isPaymentCreditPermission">
		<cfinvokeargument Name="paymentCreditID" Value="#URL.paymentCreditID#">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
	</cfinvoke>

	<cfif isPaymentCreditPermission is False>
		<cflocation url="index.cfm?method=#URL.control#.listPaymentCredits#Variables.urlParameters#&error_paymentCredit=invalidPaymentCredit" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.PaymentCredit" Method="selectPaymentCredit" ReturnVariable="qry_selectPaymentCredit">
			<cfinvokeargument Name="paymentCreditID" Value="#URL.paymentCreditID#">
		</cfinvoke>
	</cfif>
<cfelseif Not ListFind("listPaymentCredits,insertPaymentCredit,listPaymentCreditsForInvoice,applyPaymentCreditsToInvoice,deleteInvoicePaymentCredit,updateInvoicePaymentCredit", Variables.doAction)>
	<cflocation url="index.cfm?method=#URL.control#.listPaymentCredits#Variables.urlParameters#&error_paymentCredit=noPaymentCredit" AddToken="No">
</cfif>

