<cfif URL.companyID is 0 or (URL.companyID is Session.companyID and URL.control is not "company")>
	<cfset URL.companyID = "">
</cfif>
<cfinclude template="../../include/function/act_urlToForm.cfm">

<cfparam Name="Form.returnMyCompanyUsersOnly" Default="">
<cfparam Name="Form.queryDisplayResults" Default="True">
<cfparam Name="Form.queryOrderBy" Default="lastName">
<cfparam Name="Form.queryPage" Default="1">
<cfparam Name="Form.queryDisplayPerPage" Default="20">

<cfparam Name="Form.cobrandID" Default="">
<cfparam Name="Form.companyID" Default="">
<cfparam Name="Form.affiliateID" Default="">

<cfparam Name="Form.statusID" Default="">
<!--- <cfparam Name="Form.userID_custom" Default=""> --->
<cfparam Name="Form.jobDepartment" Default="">

<cfparam Name="Form.groupID" Default="">
<cfparam Name="Form.vendorID" Default="">

<cfparam Name="Form.userStatus" Default="">
<cfparam Name="Form.companyIsCustomer" Default="">
<cfparam Name="Form.userIsPrimaryContact" Default="">
<cfparam Name="Form.companyIsVendor" Default="">
<cfparam Name="Form.companyIsTaxExempt" Default="">
<cfparam Name="Form.userHasCustomID" Default="">
<cfparam Name="Form.companyIsAffiliate" Default="">
<cfparam Name="Form.userHasCustomPricing" Default="">
<cfparam Name="Form.companyIsCobrand" Default="">
<cfparam Name="Form.userNewsletterStatus" Default="">
<cfparam Name="Form.userNewsletterHtml" Default="">
<cfparam Name="Form.userIsActiveSubscriber" Default="">

<cfparam Name="Form.addressID" Default="">
<cfparam Name="Form.taskID" Default="">
<cfparam Name="Form.bankID" Default="">
<cfparam Name="Form.contactID" Default="">
<cfparam Name="Form.creditCardID" Default="">
<cfparam Name="Form.invoiceID_purchase" Default="-1">
<cfparam Name="Form.invoiceID_abandon" Default="-1">
<cfparam Name="Form.productID_purchase" Default="-1">
<cfparam Name="Form.productID_abandon" Default="-1">
<cfparam Name="Form.userID_manager" Default="-1">
<cfparam Name="Form.invoiceID" Default="-1">
<cfparam Name="Form.phoneID" Default="-1">

<cfparam Name="Form.searchText" Default="">
<cfparam Name="Form.searchField" Default="">

<cfparam Name="Form.returnCompanyFields" Default="True">

<cfparam Name="Form.userIsExported" Default="-1">
<cfparam Name="Form.userDateExported_from" Default="">
<cfparam Name="Form.userDateExported_to" Default="">


