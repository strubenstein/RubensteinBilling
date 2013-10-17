<cfinclude template="../../include/function/act_urlToForm.cfm">

<cfparam Name="Form.queryOrderBy" Default="vendorName">
<cfparam Name="Form.queryPage" Default="1">
<cfparam Name="Form.queryDisplayPerPage" Default="20">

<cfparam Name="Form.vendorStatus" Default="">
<cfparam Name="Form.vendorHasCode" Default="">
<cfparam Name="Form.vendorHasCustomID" Default="">
<cfparam Name="Form.vendorHasURL" Default="">
<cfparam Name="Form.vendorNameIsCompanyName" Default="">
<cfparam Name="Form.vendorHasUser" Default="">

<cfparam Name="Form.searchText" Default="">
<cfparam Name="Form.searchField" Default="">
<cfparam Name="Form.statusID" Default="">
<cfparam Name="Form.groupID" Default="">
<cfparam Name="Form.companyID" Default="">
<cfparam Name="Form.userID" Default="">

<cfparam Name="Form.vendorIsExported" Default="-1">
<cfparam Name="Form.vendorDateExported_from" Default="">
<cfparam Name="Form.vendorDateExported_to" Default="">

<cfset Variables.fields_text = "searchText,searchField,vendorName,vendorCode,vendorID_custom,vendorURL,vendorDescription">
<cfset Variables.fields_boolean = "vendorHasCode,vendorHasCustomID,vendorStatus,vendorHasUser,vendorHasURL,vendorNameIsCompanyName">
<cfset Variables.fields_integerList = "companyID,groupID,vendorID,userID,statusID,vendorID_not">
<cfset Variables.fields_integer = "">
<cfset Variables.fields_numeric = "">
<cfset Variables.fields_date = "vendorDateExported_from,vendorDateExported_to">
