<cfif Variables.doAction is "updateStatus" and IsDefined("qry_selectStatus")>
	<cfparam Name="Form.statusOrder" Default="#qry_selectStatus.statusOrder#">
	<cfparam Name="Form.statusStatus" Default="#qry_selectStatus.statusStatus#">
	<cfparam Name="Form.statusName" Default="#qry_selectStatus.statusName#">
	<cfparam Name="Form.statusTitle" Default="#qry_selectStatus.statusTitle#">
	<cfparam Name="Form.statusDescription" Default="#qry_selectStatus.statusDescription#">
	<cfif Not IsDefined("Form.isFormSubmitted")>
		<cfparam Name="Form.statusDisplayToCustomer" Default="#qry_selectStatus.statusDisplayToCustomer#">
	</cfif>
	<cfparam Name="Form.statusID_custom" Default="#qry_selectStatus.statusID_custom#">
</cfif>

<cfparam Name="Form.statusOrder" Default="0">
<cfparam Name="Form.statusStatus" Default="1">
<cfparam Name="Form.statusName" Default="">
<cfparam Name="Form.statusTitle" Default="">
<cfparam Name="Form.statusDescription" Default="">
<cfparam Name="Form.statusID_custom" Default="">
<cfparam Name="Form.statusDisplayToCustomer" Default="0">
