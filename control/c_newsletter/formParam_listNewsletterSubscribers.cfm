<cfinclude template="../../include/function/act_urlToForm.cfm">

<cfparam Name="Form.groupID" Default="">
<cfparam Name="Form.affiliateID" Default="">
<cfparam Name="Form.cobrandID" Default="">

<cfparam Name="Form.newsletterSubscriberDateType" Default="">
<cfparam Name="Form.newsletterSubscriberDateFrom_date" Default="">
<cfparam Name="Form.newsletterSubscriberDateFrom_hh" Default="12">
<cfparam Name="Form.newsletterSubscriberDateFrom_mm" Default="00">
<cfparam Name="Form.newsletterSubscriberDateFrom_tt" Default="am">
<cfparam Name="Form.newsletterSubscriberDateTo_date" Default="">
<cfparam Name="Form.newsletterSubscriberDateTo_hh" Default="12">
<cfparam Name="Form.newsletterSubscriberDateTo_mm" Default="00">
<cfparam Name="Form.newsletterSubscriberDateTo_tt" Default="am">

<cfif Not IsDefined("newsletterSubscriberEmail")>
	<cfparam Name="Form.newsletterSubscriberStatus" Default="1">
<cfelse>
	<cfparam Name="Form.newsletterSubscriberStatus" Default="">
</cfif>

<cfparam Name="Form.newsletterSubscriberEmail" Default="">
<cfparam Name="Form.subscriberIsUser" Default="">
<cfparam Name="Form.companyIsCustomer" Default="">
<cfparam Name="Form.companyIsCobrand" Default="">
<cfparam Name="Form.companyIsVendor" Default="">
<cfparam Name="Form.companyIsTaxExempt" Default="">
<cfparam Name="Form.companyIsAffiliate" Default="">
<cfparam Name="Form.newsletterSubscriberHtml" Default="">
<cfparam Name="Form.newsletterSubscriberRegistered" Default="">
<cfparam Name="Form.companyHasCustomPricing" Default="">
<cfparam Name="Form.companyHasMultipleUsers" Default="">
<cfparam Name="Form.userIsSalesperson" Default="">
<cfparam Name="Form.userIsInMyCompany" Default="">
<cfparam Name="Form.companyHasCustomID" Default="">
<cfparam Name="Form.userHasCustomID" Default="">

<cfparam Name="Form.newsletterSubscriberIsExported" Default="-1">
<cfparam Name="Form.newsletterSubscriberDateExported_from" Default="">
<cfparam Name="Form.newsletterSubscriberDateExported_to" Default="">

<cfparam Name="Form.queryOrderBy" Default="contactDateSent_d">
<cfparam Name="Form.queryPage" Default="1">
<cfparam Name="Form.queryDisplayPerPage" Default="20">
