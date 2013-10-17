<cfinclude template="../../include/function/act_urlToForm.cfm">
<cfset Variables.fields_boolean = "companyStatus,companyIsCustomer,companyHasCustomPricing,companyIsAffiliate,companyIsCobrand,companyIsVendor,companyIsTaxExempt,companyHasName,companyHasDBA,companyHasURL,companyHasUser,companyHasMultipleUsers,companyHasCustomID,companyIsActiveSubscriber,companyPrimary">

<cfparam Name="Form.queryOrderBy" Default="companyName">
<cfparam Name="Form.queryPage" Default="1">
<cfparam Name="Form.queryDisplayPerPage" Default="20">

<cfparam Name="Form.companyStatus" Default="">
<cfparam Name="Form.companyIsCustomer" Default="">
<cfparam Name="Form.companyIsCobrand" Default="">
<cfparam Name="Form.companyIsAffiliate" Default="">
<cfparam Name="Form.companyIsVendor" Default="">
<cfparam Name="Form.companyIsTaxExempt" Default="">
<cfparam Name="Form.companyHasCustomPricing" Default="">

<cfparam Name="Form.companyHasName" Default="">
<cfparam Name="Form.companyHasDBA" Default="">
<cfparam Name="Form.companyHasURL" Default="">
<cfparam Name="Form.companyHasUser" Default="">
<cfparam Name="Form.companyHasCustomID" Default="">
<cfparam Name="Form.companyHasMultipleUsers" Default="">
<cfparam Name="Form.companyIsActiveSubscriber" Default="">

<cfparam Name="Form.companyIsExported" Default="-1">
<cfparam Name="Form.companyDateExported_from" Default="">
<cfparam Name="Form.companyDateExported_to" Default="">

<cfif Session.companyID is not Application.billingSuperuserCompanyID or URL.control is not "company">
	<cfset Form.companyPrimary = "">
<!--- 
<cfelseif Not IsDefined("Form.isFormSubmitted")>
	<cfparam Name="Form.companyPrimary" Default="1">
--->
<cfelse>
	<cfparam Name="Form.companyPrimary" Default="">
</cfif>

<cfparam Name="Form.statusID" Default="">
<cfparam Name="Form.groupID" Default="">
<cfparam Name="Form.affiliateID" Default="">
<cfparam Name="Form.cobrandID" Default="">

<cfparam Name="Form.searchText" Default="">
<cfparam Name="Form.searchField" Default="">

<!--- 
companyName
companyDBA
companyURL
companyPrimary
companyID_custom
companyID_parent
languageID
--->

