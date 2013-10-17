<cfinclude template="../../include/function/act_urlToForm.cfm">

<cfparam Name="Form.queryOrderBy" Default="cobrandName">
<cfparam Name="Form.queryPage" Default="1">
<cfparam Name="Form.queryDisplayPerPage" Default="20">

<cfparam Name="Form.cobrandStatus" Default="">
<cfparam Name="Form.cobrandHasCode" Default="">
<cfparam Name="Form.cobrandHasCustomID" Default="">
<cfparam Name="Form.cobrandHasURL" Default="">
<cfparam Name="Form.cobrandHasCustomPricing" Default="">
<cfparam Name="Form.cobrandHasCommission" Default="">
<cfparam Name="Form.cobrandNameIsCompanyName" Default="">
<cfparam Name="Form.cobrandHasUser" Default="">
<cfparam Name="Form.cobrandHasCustomer" Default="">
<cfparam Name="Form.cobrandHasActiveSubscriber" Default="">

<cfparam Name="Form.searchText" Default="">
<cfparam Name="Form.searchField" Default="">
<cfparam Name="Form.statusID" Default="">
<cfparam Name="Form.groupID" Default="">
<cfparam Name="Form.companyID" Default="">
<cfparam Name="Form.userID" Default="">
<cfparam Name="Form.groupID" Default="">

<cfparam Name="Form.cobrandIsExported" Default="-1">
<cfparam Name="Form.cobrandDateExported_from" Default="">
<cfparam Name="Form.cobrandDateExported_to" Default="">

<cfset Variables.fields_text = "searchText,searchField,cobrandName,cobrandCode,cobrandURL,cobrandID_custom,cobrandTitle,cobrandDomain,cobrandDirectory">
<cfset Variables.fields_boolean = "cobrandHasCode,cobrandHasCustomID,cobrandStatus,cobrandHasCustomPricing,cobrandHasCommission,cobrandHasUser,cobrandHasURL,cobrandNameIsCompanyName,cobrandHasCustomer,cobrandHasActiveSubscriber">
<cfset Variables.fields_integerList = "companyID,groupID,cobrandID,userID,statusID,cobrandID_not">
<cfset Variables.fields_integer = "">
<cfset Variables.fields_numeric = "">
<cfset Variables.fields_date = "cobrandDateExported_from,cobrandDateExported_to">
