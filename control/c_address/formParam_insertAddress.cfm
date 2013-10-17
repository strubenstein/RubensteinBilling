<cfif URL.addressID is not 0 and IsDefined("qry_selectAddress")>
	<cfparam Name="Form.addressStatus" Default="#qry_selectAddress.addressStatus#">
	<cfparam Name="Form.addressName" Default="#qry_selectAddress.addressName#">
	<cfparam Name="Form.addressDescription" Default="#qry_selectAddress.addressDescription#">
	<cfparam Name="Form.address" Default="#qry_selectAddress.address#">
	<cfparam Name="Form.address2" Default="#qry_selectAddress.address2#">
	<cfparam Name="Form.address3" Default="#qry_selectAddress.address3#">
	<cfparam Name="Form.city" Default="#qry_selectAddress.city#">
	<cfparam Name="Form.state" Default="#qry_selectAddress.state#">
	<cfparam Name="Form.zipCode" Default="#qry_selectAddress.zipCode#">
	<cfparam Name="Form.zipCodePlus4" Default="#qry_selectAddress.zipCodePlus4#">
	<cfparam Name="Form.county" Default="#qry_selectAddress.county#">
	<cfparam Name="Form.country" Default="#qry_selectAddress.country#">
	<cfparam Name="Form.regionID" Default="#qry_selectAddress.regionID#">

	<cfif Not IsDefined("Form.isFormSubmitted")>
		<cfparam Name="Form.addressTypeShipping" Default="#qry_selectAddress.addressTypeShipping#">
		<cfparam Name="Form.addressTypeBilling" Default="#qry_selectAddress.addressTypeBilling#">
	</cfif>
</cfif>

<cfparam Name="Form.addressStatus" Default="1">
<cfparam Name="Form.addressName" Default="">
<cfparam Name="Form.addressDescription" Default="">
<cfparam Name="Form.addressTypeShipping" Default="0">
<cfparam Name="Form.addressTypeBilling" Default="0">
<cfparam Name="Form.address" Default="">
<cfparam Name="Form.address2" Default="">
<cfparam Name="Form.address3" Default="">
<cfparam Name="Form.city" Default="">
<cfparam Name="Form.state" Default="">
<cfparam Name="Form.stateOther" Default="">
<cfparam Name="Form.zipCode" Default="">
<cfparam Name="Form.zipCodePlus4" Default="">
<cfparam Name="Form.county" Default="">
<cfparam Name="Form.country" Default="United States">
<cfparam Name="Form.countryOther" Default="">
<cfparam Name="Form.regionID" Default="0">

