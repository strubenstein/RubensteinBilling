<cfinclude template="../../include/function/act_urlToForm.cfm">

<cfparam Name="Form.queryOrderBy" Default="invoiceDateClosed_d">
<cfparam Name="Form.queryPage" Default="1">
<cfparam Name="Form.queryDisplayPerPage" Default="20">

<!--- 
invoiceID
invoiceID_custom

addressID_shipping - city, state, country
addressID_billing - city, state, country

productID
--->

<cfparam Name="Form.affiliateID" Default="">
<cfparam Name="Form.cobrandID" Default="">
<cfparam Name="Form.statusID" Default="">
<cfparam Name="Form.subscriberID" Default="">

<cfparam Name="Form.invoiceDateType" Default="">
<cfparam Name="Form.invoiceDateFrom_date" Default="">
<cfparam Name="Form.invoiceDateFrom_hh" Default="12">
<cfparam Name="Form.invoiceDateFrom_mm" Default="00">
<cfparam Name="Form.invoiceDateFrom_tt" Default="am">
<cfparam Name="Form.invoiceDateTo_date" Default="">
<cfparam Name="Form.invoiceDateTo_hh" Default="12">
<cfparam Name="Form.invoiceDateTo_mm" Default="00">
<cfparam Name="Form.invoiceDateTo_tt" Default="am">

<cfparam Name="Form.invoiceTotal_min" Default="">
<cfparam Name="Form.invoiceTotal_max" Default="">
<cfparam Name="Form.invoiceShippingMethod" Default="">
<cfparam Name="Form.invoiceInstructions" Default="">

<cfparam Name="Form.invoiceClosed" Default="">
<cfparam Name="Form.invoicePaid" Default="">
<cfparam Name="Form.invoiceStatus" Default="">
<cfparam Name="Form.invoiceShipped" Default="">
<cfparam Name="Form.invoiceCompleted" Default="">
<cfparam Name="Form.invoiceManual" Default="">
<cfparam Name="Form.invoiceSent" Default="">
<cfparam Name="Form.invoiceHasMultipleItems" Default="">
<cfparam Name="Form.invoiceHasCustomPrice" Default="">
<cfparam Name="Form.invoiceHasCustomID" Default="">
<cfparam Name="Form.invoiceHasInstructions" Default="">
<cfparam Name="Form.invoiceHasPaymentCredit" Default="">

<cfparam Name="Form.invoiceIsExported" Default="-1">
<cfparam Name="Form.invoiceDateExported_from" Default="">
<cfparam Name="Form.invoiceDateExported_to" Default="">

<!--- 
<cfparam Name="Form.searchText" Default="">
<cfparam Name="Form.searchField" Default="">
--->

<!--- 
invoiceDateDue
--->
