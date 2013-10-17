<cfset Variables.default_vendorURL = "http://www.">

<cfif URL.vendorID is not 0 and IsDefined("qry_selectVendor")>
	<cfparam Name="Form.userID" Default="#qry_selectVendor.userID#">
	<cfparam Name="Form.vendorCode" Default="#qry_selectVendor.vendorCode#">
	<cfparam Name="Form.vendorDescription" Default="#qry_selectVendor.vendorDescription#">
	<cfparam Name="Form.vendorDescriptionHtml" Default="#qry_selectVendor.vendorDescriptionHtml#">
	<cfparam Name="Form.vendorDescriptionDisplay" Default="#qry_selectVendor.vendorDescriptionDisplay#">
	<cfif qry_selectVendor.vendorURL is "">
		<cfparam Name="Form.vendorURL" Default="#Variables.default_vendorURL#">
	<cfelse>
		<cfparam Name="Form.vendorURL" Default="#qry_selectVendor.vendorURL#">
	</cfif>
	<cfparam Name="Form.vendorURLdisplay" Default="#qry_selectVendor.vendorURLdisplay#">
	<cfparam Name="Form.vendorName" Default="#qry_selectVendor.vendorName#">
	<cfparam Name="Form.vendorImage" Default="#qry_selectVendor.vendorImage#">
	<cfparam Name="Form.vendorStatus" Default="#qry_selectVendor.vendorStatus#">
	<cfparam Name="Form.vendorID_custom" Default="#qry_selectVendor.vendorID_custom#">
</cfif>

<cfparam Name="Form.userID" Default="#qry_selectCompany.userID#">
<cfparam Name="Form.vendorCode" Default="">
<cfparam Name="Form.vendorDescription" Default="">
<cfparam Name="Form.vendorDescriptionHtml" Default="0">
<cfparam Name="Form.vendorDescriptionDisplay" Default="0">

<cfif qry_selectCompany.companyURL is "">
	<cfparam Name="Form.vendorURL" Default="#Variables.default_vendorURL#">
<cfelse>
	<cfparam Name="Form.vendorURL" Default="#qry_selectCompany.companyURL#">
</cfif>

<cfparam Name="Form.vendorURLdisplay" Default="0">
<cfparam Name="Form.vendorName" Default="#qry_selectCompany.companyName#">
<cfparam Name="Form.vendorImage" Default="">
<cfparam Name="Form.vendorStatus" Default="1">
<cfparam Name="Form.vendorID_custom" Default="">

