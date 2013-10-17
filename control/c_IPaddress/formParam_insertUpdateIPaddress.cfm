<cfif Variables.doAction is "updateIPaddress" and IsDefined("qry_selectIPaddress")>
	<cfparam Name="Form.IPaddress" Default="#qry_selectIPaddress.IPaddress#">
	<cfparam Name="Form.IPaddress_max" Default="#qry_selectIPaddress.IPaddress_max#">
	<cfif Not IsDefined("Form.isFormSubmitted")>
		<cfparam Name="Form.IPaddressBrowser" Default="#qry_selectIPaddress.IPaddressBrowser#">
		<cfparam Name="Form.IPaddressWebService" Default="#qry_selectIPaddress.IPaddressWebService#">
	</cfif>
</cfif>

<cfparam Name="Form.IPaddress" Default="">
<cfparam Name="Form.IPaddress_max" Default="">
<cfparam Name="Form.IPaddressBrowser" Default="0">
<cfparam Name="Form.IPaddressWebService" Default="0">
