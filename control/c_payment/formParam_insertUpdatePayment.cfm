<cfif URL.paymentID is not 0 and IsDefined("qry_selectPayment")>
	<cfparam Name="Form.merchantAccountID" Default="#qry_selectPayment.merchantAccountID#">
	<cfparam Name="Form.paymentID_custom" Default="#qry_selectPayment.paymentID_custom#">
	<cfparam Name="Form.paymentStatus" Default="#qry_selectPayment.paymentStatus#">
	<cfparam Name="Form.paymentApproved" Default="#qry_selectPayment.paymentApproved#">
	<cfparam Name="Form.paymentAmount" Default="#qry_selectPayment.paymentAmount#">
	<cfparam Name="Form.paymentDescription" Default="#qry_selectPayment.paymentDescription#">
	<cfparam Name="Form.paymentProcessed" Default="#qry_selectPayment.paymentProcessed#">
	<cfparam Name="Form.paymentCategoryID" Default="#qry_selectPayment.paymentCategoryID#">
	<cfparam Name="Form.subscriberID" Default="#qry_selectPayment.subscriberID#">
	<cfparam Name="Form.paymentIsRefund" Default="#qry_selectPayment.paymentIsRefund#">
	<cfparam Name="Form.paymentID_refund" Default="#qry_selectPayment.paymentID_refund#">

	<cfswitch expression="#qry_selectPayment.paymentMethod#">
	<cfcase value="check"><cfparam Name="Form.paymentCheckNumber_check" Default="#qry_selectPayment.paymentCheckNumber#"></cfcase>
	<cfcase value="cashier check"><cfparam Name="Form.paymentCheckNumber_cashier" Default="#qry_selectPayment.paymentCheckNumber#"></cfcase>
	<cfcase value="certified check"><cfparam Name="Form.paymentCheckNumber_certified" Default="#qry_selectPayment.paymentCheckNumber#"></cfcase>
	</cfswitch>

	<cfif Not ListFind(Variables.paymentMethodList_value, qry_selectPayment.paymentMethod)>
		<cfparam Name="Form.paymentMethod_select" Default="other">
		<cfif qry_selectPayment.paymentMethod is not "other">
			<cfparam Name="Form.paymentMethod_text" Default="#qry_selectPayment.paymentMethod#">
		</cfif>
	<cfelseif qry_selectPayment.paymentMethod is "creditCard" and qry_selectPayment.creditCardID is not 0 and ListFind(Variables.updatePaymentFieldList, "paymentMethod") and ListFind(ValueList(qry_selectCreditCardList.creditCardID), qry_selectPayment.creditCardID)>
		<cfparam Name="Form.paymentMethod_select" Default="creditCard#qry_selectPayment.creditCardID#">
	<cfelseif qry_selectPayment.paymentMethod is "bank" and qry_selectPayment.bankID is not 0 and ListFind(Variables.updatePaymentFieldList, "paymentMethod") and ListFind(ValueList(qry_selectBankList.bankID), qry_selectPayment.bankID)>
		<cfparam Name="Form.paymentMethod_select" Default="bank#qry_selectPayment.bankID#">
	<cfelse>
		<cfparam Name="Form.paymentMethod_select" Default="#qry_selectPayment.paymentMethod#">
	</cfif>

	<cfif Variables.doAction is not "insertPaymentRefund" or URL.paymentID is 0>
		<cfparam Name="Form.paymentDateReceived_date" Default="#DateFormat(qry_selectPayment.paymentDateReceived, 'mm/dd/yyyy')#">
		<cfparam Name="Form.paymentDateReceived_hh" Default="#ListFirst(fn_ConvertFrom24HourFormat(Hour(qry_selectPayment.paymentDateReceived)), '|')#">
		<cfparam Name="Form.paymentDateReceived_mm" Default="#Minute(qry_selectPayment.paymentDateReceived)#">
		<cfparam Name="Form.paymentDateReceived_tt" Default="#TimeFormat(qry_selectPayment.paymentDateReceived, 'tt')#">
	</cfif>

	<cfif IsDate(qry_selectPayment.paymentDateScheduled) and (Variables.doAction is not "insertPaymentRefund" or URL.paymentID is 0)>
		<cfparam Name="Form.paymentDateScheduled_date" Default="#DateFormat(qry_selectPayment.paymentDateScheduled, 'mm/dd/yyyy')#">
		<cfparam Name="Form.paymentDateScheduled_hh" Default="#ListFirst(fn_ConvertFrom24HourFormat(Hour(qry_selectPayment.paymentDateScheduled)), '|')#">
		<cfparam Name="Form.paymentDateScheduled_mm" Default="#Minute(qry_selectPayment.paymentDateScheduled)#">
		<cfparam Name="Form.paymentDateScheduled_tt" Default="#TimeFormat(qry_selectPayment.paymentDateScheduled, 'tt')#">
	</cfif>
</cfif>

<cfif ListFind("insertPayment,insertPaymentRefund", Variables.doAction) or ListFind(Variables.updatePaymentFieldList, "merchantAccountID")>
	<cfif qry_selectMerchantAccountList.RecordCount is 0>
		<cfparam Name="Form.merchantAccountID" Default="0">
	<cfelse>
		<cfparam Name="Form.merchantAccountID" Default="#qry_selectMerchantAccountList.merchantAccountID[1]#">
	</cfif>
</cfif>

<cfparam Name="Form.paymentCheckNumber_check" Default="">
<cfparam Name="Form.paymentCheckNumber_cashier" Default="">
<cfparam Name="Form.paymentCheckNumber_certified" Default="">

<cfif URL.paymentID is 0 and URL.control is "invoice" and Variables.invoiceID is not 0 and IsDefined("qry_selectInvoice") and Not FindNoCase("Refund", Variables.doAction)>
	<cfif IsNumeric(qry_selectInvoicePaymentAmountTotal.sumInvoicePaymentAmount)>
		<cfparam Name="Form.paymentAmount" Default="#qry_selectInvoice.invoiceTotal - qry_selectInvoicePaymentAmountTotal.sumInvoicePaymentAmount#">
	<cfelse>
		<cfparam Name="Form.paymentAmount" Default="#qry_selectInvoice.invoiceTotal#">
	</cfif>
<cfelse>
	<cfparam Name="Form.paymentAmount" Default="">
</cfif>

<cfparam Name="Form.paymentID_custom" Default="">
<cfparam Name="Form.paymentStatus" Default="1">
<cfparam Name="Form.paymentApproved" Default="">
<cfparam Name="Form.paymentDescription" Default="">
<cfparam Name="Form.paymentMethod_select" Default="other">
<cfparam Name="Form.paymentMethod_text" Default="">
<cfparam Name="Form.paymentCategoryID" Default="0">
<cfparam Name="Form.paymentProcessed" Default="0">

<cfparam Name="Form.subscriberID" Default="#Variables.subscriberID#">
<cfparam Name="Form.paymentID_refund" Default="0">
<cfif Find("Refund", Variables.doAction)>
	<cfset Form.paymentIsRefund = 1>
<cfelse>
	<cfset Form.paymentIsRefund = 0>
</cfif>

<cfparam Name="Form.paymentDateReceived_date" Default="#DateFormat(Now(), 'mm/dd/yyyy')#">
<cfparam Name="Form.paymentDateReceived_hh" Default="12">
<cfparam Name="Form.paymentDateReceived_mm" Default="00">
<cfparam Name="Form.paymentDateReceived_tt" Default="am">

<cfparam Name="Form.paymentDateScheduled_date" Default="">
<cfparam Name="Form.paymentDateScheduled_hh" Default="12">
<cfparam Name="Form.paymentDateScheduled_mm" Default="00">
<cfparam Name="Form.paymentDateScheduled_tt" Default="am">

<cfif Form.paymentCheckNumber_check is 0>
	<cfset Form.paymentCheckNumber_check = "">
</cfif>
<cfif Form.paymentCheckNumber_cashier is 0>
	<cfset Form.paymentCheckNumber_cashier = "">
</cfif>
<cfif Form.paymentCheckNumber_certified is 0>
	<cfset Form.paymentCheckNumber_certified = "">
</cfif>

<cfif Find("Refund", Variables.doAction)>
	<cfparam Name="Form.invoiceLineItemID" Default="">
	<cfparam Name="Form.subscriptionID" Default="">
</cfif>
