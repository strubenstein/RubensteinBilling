<cfinclude template="../../include/function/act_urlToForm.cfm">

<cfparam Name="Form.queryOrderBy" Default="">
<cfparam Name="Form.queryPage" Default="1">
<cfparam Name="Form.queryDisplayPerPage" Default="10">

<cfparam Name="Form.commissionID" Default="">
<cfparam Name="Form.primaryTargetID" Default="">
<cfparam Name="Form.targetID" Default="">
<cfparam Name="Form.salesCommissionAmount_min" Default="">
<cfparam Name="Form.salesCommissionAmount_max" Default="">
<cfparam Name="Form.salesCommissionFinalized" Default="">
<cfparam Name="Form.salesCommissionPaid" Default="-1">
<cfparam Name="Form.salesCommissionStatus" Default="">
<cfparam Name="Form.salesCommissionManual" Default="">

<cfparam Name="Form.salesCommissionDateType" Default="">
<cfparam Name="Form.salesCommissionDateFrom_date" Default="">
<cfparam Name="Form.salesCommissionDateFrom_hh" Default="12">
<cfparam Name="Form.salesCommissionDateFrom_mm" Default="00">
<cfparam Name="Form.salesCommissionDateFrom_tt" Default="am">
<cfparam Name="Form.salesCommissionDateTo_date" Default="">
<cfparam Name="Form.salesCommissionDateTo_hh" Default="12">
<cfparam Name="Form.salesCommissionDateTo_mm" Default="00">
<cfparam Name="Form.salesCommissionDateTo_tt" Default="am">

<cfparam Name="Form.salesCommissionBasisTotal_min" Default="">
<cfparam Name="Form.salesCommissionBasisTotal_max" Default="">
<cfparam Name="Form.returnSalesCommissionSum" Default="False">

<cfparam Name="Form.salesCommissionID" Default="">
<cfparam Name="Form.invoiceID" Default="">
<cfparam Name="Form.invoiceLineItemID" Default="">
<cfparam Name="Form.companyID" Default="">
<cfparam Name="Form.userID" Default="">
<cfparam Name="Form.subscriberID" Default="">
<cfparam Name="Form.subscriptionID" Default="">
<cfparam Name="Form.cobrandID" Default="">
<cfparam Name="Form.affiliateID" Default="">
<cfparam Name="Form.priceID" Default="">
<cfparam Name="Form.categoryID" Default="">
<cfparam Name="Form.productID" Default="">
<cfparam Name="Form.returnTargetName" Default="True">

<cfparam Name="Form.salesCommissionIsExported" Default="-1">
<cfparam Name="Form.salesCommissionDateExported_from" Default="">
<cfparam Name="Form.salesCommissionDateExported_to" Default="">

<!--- salesCommissionPaid,returnTargetName,returnSalesCommissionSum --->
<cfset Variables.fields_text = "salesCommissionDateType">
<cfset Variables.fields_boolean = "salesCommissionStatus,salesCommissionManual,salesCommissionFinalized">
<cfset Variables.fields_integerList = "commissionID,primaryTargetID,targetID,salesCommissionID,invoiceID,invoiceLineItemID,companyID,userID,subscriberID,subscriptionID,cobrandID,affiliateID,priceID,categoryID,productID">
<cfset Variables.fields_integer = "">
<cfset Variables.fields_numeric = "salesCommissionAmount_min,salesCommissionAmount_max,salesCommissionBasisTotal_min,salesCommissionBasisTotal_max">
<cfset Variables.fields_date = "salesCommissionDateFrom,salesCommissionDateTo,salesCommissionDateFinalized_from,salesCommissionDateFinalized_to,salesCommissionDatePaid_from,salesCommissionDatePaid_to,salesCommissionDateBegin_from,salesCommissionDateBegin_to,salesCommissionDateEnd_from,salesCommissionDateEnd_to,salesCommissionDateCreated_from,salesCommissionDateCreated_to,salesCommissionDateUpdated_from,salesCommissionDateUpdated_to,salesCommissionDateExported_from,salesCommissionDateExported_to">

