<cfinclude template="../../include/function/act_urlToForm.cfm">

<cfparam Name="Form.searchText" Default="">
<cfparam Name="Form.searchField" Default="">
<cfparam Name="Form.paymentCreditName" Default="">

<cfparam Name="Form.paymentCreditDateType" Default="">
<cfparam Name="Form.paymentCreditDateFrom_date" Default="">
<cfparam Name="Form.paymentCreditDateFrom_hh" Default="12">
<cfparam Name="Form.paymentCreditDateFrom_mm" Default="00">
<cfparam Name="Form.paymentCreditDateFrom_tt" Default="am">
<cfparam Name="Form.paymentCreditDateTo_date" Default="">
<cfparam Name="Form.paymentCreditDateTo_hh" Default="12">
<cfparam Name="Form.paymentCreditDateTo_mm" Default="00">
<cfparam Name="Form.paymentCreditDateTo_tt" Default="am">

<cfparam Name="Form.affiliateID" Default="">
<cfparam Name="Form.cobrandID" Default="">
<cfparam Name="Form.userID_author" Default="">
<cfparam Name="Form.paymentCategoryID" Default="">

<cfparam Name="Form.paymentCreditStatus" Default="">
<cfparam Name="Form.paymentCreditHasName" Default="">
<cfparam Name="Form.paymentCreditHasCustomID" Default="">
<cfparam Name="Form.paymentCreditHasDescription" Default="">
<cfparam Name="Form.paymentCreditApplied" Default="">
<cfparam Name="Form.paymentCreditHasBeginDate" Default="">
<cfparam Name="Form.paymentCreditHasEndDate" Default="">
<cfparam Name="Form.paymentCreditAppliedMaximumMultiple" Default="">
<cfparam Name="Form.paymentCreditAppliedCountMultiple" Default="">
<cfparam Name="Form.paymentCreditAppliedRemaining" Default="">
<cfparam Name="Form.paymentCreditRollover" Default="">
<cfparam Name="Form.paymentCreditNegativeInvoice" Default="">
<cfparam Name="Form.paymentCreditCompleted" Default="">
<cfparam Name="Form.paymentCreditHasRolledOver" Default="">

<cfparam Name="Form.paymentCreditAmount_min" Default="">
<cfparam Name="Form.paymentCreditAmount_max" Default="">
<cfparam Name="Form.paymentCreditAppliedMaximum_min" Default="">
<cfparam Name="Form.paymentCreditAppliedMaximum_max" Default="">
<cfparam Name="Form.paymentCreditAppliedCount_min" Default="">
<cfparam Name="Form.paymentCreditAppliedCount_max" Default="">

<cfparam Name="Form.queryOrderBy" Default="paymentDateCreated_d">
<cfparam Name="Form.queryPage" Default="1">
<cfparam Name="Form.queryDisplayPerPage" Default="20">

<cfparam Name="Form.paymentCreditIsExported" Default="-1">
<cfparam Name="Form.paymentCreditDateExported_from" Default="">
<cfparam Name="Form.paymentCreditDateExported_to" Default="">

<cfset Variables.fields_text = "paymentCreditName,paymentCreditID_custom,paymentCreditDescription,searchText,searchField,paymentCreditDateType">
<cfset Variables.fields_numeric = "paymentCreditAmount,paymentCreditAmount_min,paymentCreditAmount_max,paymentCreditAppliedMaximum,paymentCreditAppliedMaximum_min,paymentCreditAppliedMaximum_max,paymentCreditAppliedCount,paymentCreditAppliedCount_min,paymentCreditAppliedCount_max">
<cfset Variables.fields_integer = "">
<cfset Variables.fields_integerList = "userID_author,affiliateID,cobrandID,paymentCreditID_not,invoiceID,paymentID,paymentCategoryID,subscriberID,productID,subscriptionID">
<cfset Variables.fields_boolean = "paymentCreditStatus,paymentCreditHasName,paymentCreditHasCustomID,paymentCreditHasDescription,paymentCreditApplied,paymentCreditHasBeginDate,paymentCreditHasEndDate,paymentCreditAppliedMaximumMultiple,paymentCreditAppliedCountMultiple,paymentCreditAppliedRemaining,paymentCreditRollover,paymentCreditCompleted,paymentCreditHasRolledOver,paymentCreditNegativeInvoice">
<cfset Variables.fields_date = "paymentCreditDateBegin,paymentCreditDateBegin_from,paymentCreditDateBegin_to,paymentCreditDateEnd,paymentCreditDateEnd_from,paymentCreditDateEnd_to,paymentCreditDateCreated_from,paymentCreditDateCreated_to,paymentCreditDateUpdated_from,paymentCreditDateUpdated_to,paymentCreditDateFrom,paymentCreditDateTo,paymentCreditDateExported_from,paymentCreditDateExported_to">

