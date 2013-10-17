<cfinclude template="../../include/function/act_urlToForm.cfm">

<cfparam Name="Form.paymentIsRefund" Default="">
<cfif Variables.doAction is "listPayments">
	<cfset Form.paymentIsRefund = 0>
<cfelse><!--- listPaymentRefunds --->
	<cfset Form.paymentIsRefund = 1>
</cfif>

<cfparam Name="Form.searchText" Default="">
<cfparam Name="Form.searchField" Default="">

<cfparam Name="Form.paymentDateType" Default="">
<cfparam Name="Form.paymentDateFrom_date" Default="">
<cfparam Name="Form.paymentDateFrom_hh" Default="12">
<cfparam Name="Form.paymentDateFrom_mm" Default="00">
<cfparam Name="Form.paymentDateFrom_tt" Default="am">
<cfparam Name="Form.paymentDateTo_date" Default="">
<cfparam Name="Form.paymentDateTo_hh" Default="12">
<cfparam Name="Form.paymentDateTo_mm" Default="00">
<cfparam Name="Form.paymentDateTo_tt" Default="am">

<cfparam Name="Form.affiliateID" Default="">
<cfparam Name="Form.cobrandID" Default="">
<cfparam Name="Form.userID_author" Default="">
<cfparam Name="Form.merchantAccountID" Default="">
<cfparam Name="Form.paymentCategoryID" Default="">

<cfparam Name="Form.paymentApproved" Default="-1">

<cfparam Name="Form.paymentManual" Default="">
<cfparam Name="Form.paymentStatus" Default="">
<cfparam Name="Form.paymentIsScheduled" Default="">
<cfparam Name="Form.paymentAppliedToInvoice" Default="">
<cfparam Name="Form.paymentAppliedToMultipleInvoices" Default="">
<cfparam Name="Form.paymentHasCustomID" Default="">
<cfparam Name="Form.paymentHasCreditCardID" Default="">
<cfparam Name="Form.paymentHasBankID" Default="">
<cfparam Name="Form.paymentHasCheckNumber" Default="">
<cfparam Name="Form.paymentProcessed" Default="">
<cfparam Name="Form.paymentHasDescription" Default="">
<cfparam Name="Form.paymentHasMessage" Default="">
<cfparam Name="Form.paymentHasBeenRefunded" Default="">
<cfparam Name="Form.paymentIsFullyApplied" Default="">

<cfparam Name="Form.paymentMethod" Default="">
<cfparam Name="Form.paymentMethod_select" Default="">
<cfparam Name="Form.paymentMethod_text" Default="">

<cfparam Name="Form.paymentCheckNumber_min" Default="">
<cfparam Name="Form.paymentCheckNumber_max" Default="">

<cfparam Name="Form.paymentAmount_min" Default="">
<cfparam Name="Form.paymentAmount_max" Default="">

<cfparam Name="Form.paymentIsExported" Default="-1">
<cfparam Name="Form.paymentDateExported_from" Default="">
<cfparam Name="Form.paymentDateExported_to" Default="">

<!--- 
<cfparam Name="Form.paymentID" Default="">
<cfparam Name="Form.invoiceID" Default="">
<cfparam Name="Form.creditCardID" Default="">
<cfparam Name="Form.bankID" Default="">

<cfparam Name="Form.paymentAmount" Default="">
<cfparam Name="Form.paymentCheckNumber" Default="">
<cfparam Name="Form.paymentID_custom" Default="">
<cfparam Name="Form.paymentDescription" Default="">
<cfparam Name="Form.paymentMessage" Default="">

<cfparam Name="Form.paymentDateReceived_from" Default="">
<cfparam Name="Form.paymentDateReceived_to" Default="">
<cfparam Name="Form.paymentDateCreated_from" Default="">
<cfparam Name="Form.paymentDateCreated_to" Default="">
<cfparam Name="Form.paymentDateUpdated_from" Default="">
<cfparam Name="Form.paymentDateUpdated_to" Default="">
<cfparam Name="Form.paymentDateScheduled_from" Default="">
<cfparam Name="Form.paymentDateScheduled_to" Default="">
--->

<cfparam Name="Form.queryOrderBy" Default="paymentDateCreated_d">
<cfparam Name="Form.queryPage" Default="1">
<cfparam Name="Form.queryDisplayPerPage" Default="20">

<cfset Variables.fields_text = "searchText,searchField,paymentDateType,paymentID_custom,paymentDescription,paymentMessage,paymentMethod">
<cfset Variables.fields_boolean = "paymentIsScheduled,paymentManual,paymentStatus,paymentAppliedToInvoice,paymentAppliedToMultipleInvoices,paymentHasCustomID,paymentHasCreditCardID,paymentHasBankID,paymentHasCheckNumber,paymentProcessed,paymentHasDescription,paymentHasMessage,paymentIsRefund,paymentHasBeenRefunded,paymentIsFullyApplied">
<cfset Variables.fields_integerList = "affiliateID,cobrandID,userID_author,invoiceID,creditCardID,bankID,merchantAccountID,paymentCheckNumber,paymentID_not,paymentCategoryID,subscriberID,productID,subscriptionID,subscriberProcessID">
<cfset Variables.fields_integer = "paymentCheckNumber_min,paymentCheckNumber_max">
<cfset Variables.fields_numeric = "paymentAmount,paymentAmount_min,paymentAmount_max">
<cfset Variables.fields_date = "paymentDateFrom,paymentDateTo,paymentDateReceived_from,paymentDateReceived_to,paymentDateCreated_from,paymentDateCreated_to,paymentDateUpdated_from,paymentDateUpdated_to,paymentDateScheduled_from,paymentDateScheduled_to,paymentDateExported_from,paymentDateExported_to">

