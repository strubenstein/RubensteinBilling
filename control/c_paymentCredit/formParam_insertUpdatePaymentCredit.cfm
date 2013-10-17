<cfif URL.paymentCreditID is not 0 and IsDefined("qry_selectPaymentCredit")>
	<cfparam Name="Form.paymentCreditAmount" Default="#qry_selectPaymentCredit.paymentCreditAmount#">
	<cfparam Name="Form.paymentCreditStatus" Default="#qry_selectPaymentCredit.paymentCreditStatus#">
	<cfparam Name="Form.paymentCreditID_custom" Default="#qry_selectPaymentCredit.paymentCreditID_custom#">
	<cfparam Name="Form.paymentCreditDescription" Default="#qry_selectPaymentCredit.paymentCreditDescription#">
	<cfparam Name="Form.paymentCreditAppliedMaximum" Default="#qry_selectPaymentCredit.paymentCreditAppliedMaximum#">
	<cfparam Name="Form.paymentCreditAppliedCount" Default="#qry_selectPaymentCredit.paymentCreditAppliedCount#">
	<cfparam Name="Form.paymentCategoryID" Default="#qry_selectPaymentCredit.paymentCategoryID#">
	<cfparam Name="Form.paymentCreditRollover" Default="#qry_selectPaymentCredit.paymentCreditRollover#">
	<cfparam Name="Form.paymentCreditNegativeInvoice" Default="#qry_selectPaymentCredit.paymentCreditNegativeInvoice#">
	<cfparam Name="Form.paymentCreditName" Default="#qry_selectPaymentCredit.paymentCreditName#">
	<cfparam Name="Form.subscriberID" Default="#qry_selectPaymentCredit.subscriberID#">

	<cfif IsDate(qry_selectPaymentCredit.paymentCreditDateBegin)>
		<cfparam Name="Form.paymentCreditDateBegin_date" Default="#DateFormat(qry_selectPaymentCredit.paymentCreditDateBegin, 'mm/dd/yyyy')#">
	</cfif>
	<cfif IsDate(qry_selectPaymentCredit.paymentCreditDateEnd)>
		<cfparam Name="Form.paymentCreditDateEnd_date" Default="#DateFormat(qry_selectPaymentCredit.paymentCreditDateEnd, 'mm/dd/yyyy')#">
	</cfif>
</cfif>

<cfparam Name="Form.paymentCreditAmount" Default="">
<cfparam Name="Form.paymentCreditStatus" Default="1">
<cfparam Name="Form.paymentCreditName" Default="">
<cfparam Name="Form.paymentCreditID_custom" Default="">
<cfparam Name="Form.paymentCreditDescription" Default="">
<cfparam Name="Form.paymentCreditAppliedMaximum" Default="1">
<cfparam Name="Form.paymentCreditAppliedCount" Default="0">
<cfparam Name="Form.paymentCategoryID" Default="0">
<cfparam Name="Form.paymentCreditRollover" Default="0">
<cfparam Name="Form.paymentCreditNegativeInvoice" Default="0">

<cfparam Name="Form.paymentCreditDateBegin_date" Default="">
<cfparam Name="Form.paymentCreditDateEnd_date" Default="">
<cfparam Name="Form.subscriberID" Default="#Variables.subscriberID#">

<cfparam Name="Form.invoiceLineItemID" Default="">
<cfparam Name="Form.subscriptionID" Default="">

