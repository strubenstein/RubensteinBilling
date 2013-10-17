<cfif URL.phoneID is not 0 and IsDefined("qry_selectPhone")>
	<cfparam Name="Form.phoneStatus" Default="#qry_selectPhone.phoneStatus#">
	<cfparam Name="Form.phoneAreaCode" Default="#qry_selectPhone.phoneAreaCode#">
	<cfparam Name="Form.phoneNumber" Default="#qry_selectPhone.phoneNumber#">
	<cfparam Name="Form.phoneExtension" Default="#qry_selectPhone.phoneExtension#">
	<cfparam Name="Form.phoneType" Default="#qry_selectPhone.phoneType#">
	<cfparam Name="Form.phoneDescription" Default="#qry_selectPhone.phoneDescription#">
</cfif>

<cfparam Name="Form.phoneStatus" Default="1">
<cfparam Name="Form.phoneAreaCode" Default="">
<cfparam Name="Form.phoneNumber" Default="">
<cfparam Name="Form.phoneExtension" Default="">
<cfparam Name="Form.phoneType" Default="">
<cfparam Name="Form.phoneDescription" Default="">

