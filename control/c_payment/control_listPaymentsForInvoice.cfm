<cfinclude template="../../view/v_payment/var_paymentMethodList.cfm">

<cfinvoke Component="#Application.billingMapping#data.InvoicePayment" Method="selectInvoicePaymentList" ReturnVariable="qry_selectInvoicePaymentList">
	<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
	<cfinvokeargument Name="returnInvoiceFields" Value="False">
	<cfinvokeargument Name="returnPaymentFields" Value="True">
</cfinvoke>

<cfset Variables.displayBank = False>
<cfif REFind("[1-9]", ValueList(qry_selectInvoicePaymentList.bankID))>
	<cfinvoke Component="#Application.billingMapping#data.Bank" Method="selectBankList" ReturnVariable="qry_selectBankList">
		<cfinvokeargument Name="bankID" Value="#ValueList(qry_selectInvoicePaymentList.bankID)#">
	</cfinvoke>

	<cfif qry_selectBankList.RecordCount is not 0>
		<cfset Variables.displayBank = True>
	</cfif>
</cfif>

<cfset Variables.displayCreditCard = False>
<cfif REFind("[1-9]", ValueList(qry_selectInvoicePaymentList.creditCardID))>
	<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="selectCreditCardList" ReturnVariable="qry_selectCreditCardList">
		<cfinvokeargument Name="creditCardID" Value="#ValueList(qry_selectInvoicePaymentList.creditCardID)#">
	</cfinvoke>

	<cfif qry_selectCreditCardList.RecordCount is not 0>
		<cfset Variables.displayCreditCard = True>
	</cfif>
</cfif>

<cfset Variables.displayMerchantAccount = False>
<cfif REFind("[1-9]", ValueList(qry_selectInvoicePaymentList.merchantAccountID))>
	<cfinvoke Component="#Application.billingMapping#data.MerchantAccount" Method="selectMerchantAccountList" ReturnVariable="qry_selectMerchantAccountList">
		<cfinvokeargument Name="merchantAccountID" Value="#ValueList(qry_selectInvoicePaymentList.merchantAccountID)#">
		<cfinvokeargument Name="returnMerchantFields" Value="True">
	</cfinvoke>

	<cfif qry_selectMerchantAccountList.RecordCount is not 0>
		<cfset Variables.displayMerchantAccount = True>
	</cfif>
</cfif>

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewCompany,viewUser,deleteInvoicePayment,viewPayment")>

<cfinclude template="../../view/v_payment/dsp_listPaymentsForInvoice.cfm">
