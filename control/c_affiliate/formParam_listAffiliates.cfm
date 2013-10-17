<cfinclude template="../../include/function/act_urlToForm.cfm">

<cfparam Name="Form.queryOrderBy" Default="affiliateName">
<cfparam Name="Form.queryPage" Default="1">
<cfparam Name="Form.queryDisplayPerPage" Default="20">

<cfparam Name="Form.affiliateStatus" Default="">
<cfparam Name="Form.affiliateHasCode" Default="">
<cfparam Name="Form.affiliateHasCustomID" Default="">
<cfparam Name="Form.affiliateHasURL" Default="">
<cfparam Name="Form.affiliateHasCustomPricing" Default="">
<cfparam Name="Form.affiliateHasCommission" Default="">
<cfparam Name="Form.affiliateNameIsCompanyName" Default="">
<cfparam Name="Form.affiliateHasUser" Default="">
<cfparam Name="Form.affiliateHasCustomer" Default="">
<cfparam Name="Form.affiliateHasActiveSubscriber" Default="">

<cfparam Name="Form.searchText" Default="">
<cfparam Name="Form.searchField" Default="">
<cfparam Name="Form.statusID" Default="">
<cfparam Name="Form.groupID" Default="">
<cfparam Name="Form.companyID" Default="">
<cfparam Name="Form.userID" Default="">
<cfparam Name="Form.groupID" Default="">

<cfparam Name="Form.affiliateIsExported" Default="-1">
<cfparam Name="Form.affiliateDateExported_from" Default="">
<cfparam Name="Form.affiliateDateExported_to" Default="">

<!--- affiliateIsExported --->
<cfset Variables.fields_text = "searchText,searchField,affiliateName,affiliateCode,affiliateID_custom,affiliateURL">
<cfset Variables.fields_boolean = "affiliateHasCode,affiliateHasCustomID,affiliateStatus,affiliateHasCustomPricing,affiliateHasCommission,affiliateHasUser,affiliateHasURL,affiliateNameIsCompanyName,affiliateHasCustomer,affiliateHasActiveSubscriber">
<cfset Variables.fields_integerList = "companyID,groupID,affiliateID,userID,statusID,affiliateID_not">
<cfset Variables.fields_integer = "">
<cfset Variables.fields_numeric = "">
<cfset Variables.fields_date = "affiliateDateExported_from,affiliateDateExported_to">
