<cfset Variables.default_affiliateURL = "http://www.">

<cfif URL.affiliateID is not 0 and IsDefined("qry_selectAffiliate")>
	<cfparam Name="Form.userID" Default="#qry_selectAffiliate.userID#">
	<cfparam Name="Form.affiliateCode" Default="#qry_selectAffiliate.affiliateCode#">
	<cfparam Name="Form.affiliateName" Default="#qry_selectAffiliate.affiliateName#">
	<cfparam Name="Form.affiliateURL" Default="#qry_selectAffiliate.affiliateURL#">
	<cfparam Name="Form.affiliateStatus" Default="#qry_selectAffiliate.affiliateStatus#">
	<cfparam Name="Form.affiliateID_custom" Default="#qry_selectAffiliate.affiliateID_custom#">
</cfif>

<cfparam Name="Form.userID" Default="#qry_selectCompany.userID#">
<cfparam Name="Form.affiliateCode" Default="">
<cfparam Name="Form.affiliateName" Default="#qry_selectCompany.companyName#">
<cfparam Name="Form.affiliateStatus" Default="1">
<cfparam Name="Form.affiliateID_custom" Default="">

<cfif qry_selectCompany.companyURL is "">
	<cfparam Name="Form.affiliateURL" Default="#Variables.default_affiliateURL#">
<cfelse>
	<cfparam Name="Form.affiliateURL" Default="#qry_selectCompany.companyURL#">
</cfif>

