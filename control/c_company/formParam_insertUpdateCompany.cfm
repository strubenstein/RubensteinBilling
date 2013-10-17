<cfset Variables.default_companyURL = "http://www.">

<cfif URL.companyID gt 0 and IsDefined("qry_selectCompany")>
	<cfparam Name="Form.userID" Default="#qry_selectCompany.userID#">
	<cfparam Name="Form.companyName" Default="#qry_selectCompany.companyName#">
	<cfparam Name="Form.companyDBA" Default="#qry_selectCompany.companyDBA#">

	<cfif qry_selectCompany.companyURL is "">
		<cfparam Name="Form.companyURL" Default="#Variables.default_companyURL#">
	<cfelse>
		<cfparam Name="Form.companyURL" Default="#qry_selectCompany.companyURL#">
	</cfif>

	<cfparam Name="Form.companyID_custom" Default="#qry_selectCompany.companyID_custom#">
	<cfparam Name="Form.companyStatus" Default="#qry_selectCompany.companyStatus#">
	<cfparam Name="Form.companyIsCobrand" Default="#qry_selectCompany.companyIsCobrand#">
	<cfparam Name="Form.companyIsAffiliate" Default="#qry_selectCompany.companyIsAffiliate#">
	<cfparam Name="Form.companyIsVendor" Default="#qry_selectCompany.companyIsVendor#">
	<cfparam Name="Form.companyIsTaxExempt" Default="#qry_selectCompany.companyIsTaxExempt#">
	<cfparam Name="Form.affiliateID" Default="#qry_selectCompany.affiliateID#">
	<cfparam Name="Form.cobrandID" Default="#qry_selectCompany.cobrandID#">
	<cfif Not IsDefined("Form.isFormSubmitted")>
		<cfparam Name="Form.companyIsCustomer" Default="#qry_selectCompany.companyIsCustomer#">
	</cfif>
</cfif>

<cfparam Name="Form.userID" Default="0">
<cfparam Name="Form.companyName" Default="">
<cfparam Name="Form.companyDBA" Default="">
<cfparam Name="Form.companyURL" Default="#Variables.default_companyURL#">
<cfparam Name="Form.companyID_custom" Default="">
<cfparam Name="Form.companyStatus" Default="1">
<cfparam Name="Form.companyIsCobrand" Default="0">
<cfparam Name="Form.companyIsAffiliate" Default="0">
<cfparam Name="Form.companyIsVendor" Default="0">
<cfparam Name="Form.companyIsCustomer" Default="0">
<cfparam Name="Form.companyIsTaxExempt" Default="0">
<cfparam Name="Form.companyDirectory" Default="">

<cfif IsDefined("Session") and StructKeyExists(Session, "affiliateID_list")>
	<cfparam Name="Form.affiliateID" Default="#ListFirst(Session.affiliateID_list)#">
<cfelse>
	<cfparam Name="Form.affiliateID" Default="0">
</cfif>

<cfif IsDefined("Session") and StructKeyExists(Session, "cobrandID_list")>
	<cfparam Name="Form.cobrandID" Default="#ListFirst(Session.cobrandID_list)#">
<cfelse>
	<cfparam Name="Form.cobrandID" Default="0">
</cfif>

<cfif Form.companyURL is "">
	<cfset Form.companyURL = Variables.default_companyURL>
</cfif>

