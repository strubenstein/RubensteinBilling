<cfset Variables.default_cobrandURL = "http://www.">

<cfif URL.cobrandID is not 0 and IsDefined("qry_selectCobrand")>
	<cfparam Name="Form.userID" Default="#qry_selectCobrand.userID#">
	<cfparam Name="Form.cobrandCode" Default="#qry_selectCobrand.cobrandCode#">
	<cfif qry_selectCobrand.cobrandURL is "">
		<cfparam Name="Form.cobrandURL" Default="#Variables.default_cobrandURL#">
	<cfelse>
		<cfparam Name="Form.cobrandURL" Default="#qry_selectCobrand.cobrandURL#">
	</cfif>
	<cfparam Name="Form.cobrandName" Default="#qry_selectCobrand.cobrandName#">
	<cfparam Name="Form.cobrandTitle" Default="#qry_selectCobrand.cobrandTitle#">
	<cfparam Name="Form.cobrandImage" Default="#qry_selectCobrand.cobrandImage#">
	<cfparam Name="Form.cobrandStatus" Default="#qry_selectCobrand.cobrandStatus#">
	<cfparam Name="Form.cobrandID_custom" Default="#qry_selectCobrand.cobrandID_custom#">
	<cfparam Name="Form.cobrandDomain" Default="#qry_selectCobrand.cobrandDomain#">
	<cfparam Name="Form.cobrandDirectory" Default="#qry_selectCobrand.cobrandDirectory#">
</cfif>

<cfparam Name="Form.userID" Default="#qry_selectCompany.userID#">
<cfparam Name="Form.cobrandCode" Default="">

<cfif qry_selectCompany.companyURL is "">
	<cfparam Name="Form.cobrandURL" Default="#Variables.default_cobrandURL#">
<cfelse>
	<cfparam Name="Form.cobrandURL" Default="#qry_selectCompany.companyURL#">
</cfif>

<cfparam Name="Form.cobrandName" Default="#qry_selectCompany.companyName#">
<cfparam Name="Form.cobrandTitle" Default="#qry_selectCompany.companyName#">
<cfparam Name="Form.cobrandDomain" Default="">
<cfparam Name="Form.cobrandDirectory" Default="">
<cfparam Name="Form.cobrandImage" Default="">
<cfparam Name="Form.cobrandStatus" Default="1">
<cfparam Name="Form.cobrandID_custom" Default="">

