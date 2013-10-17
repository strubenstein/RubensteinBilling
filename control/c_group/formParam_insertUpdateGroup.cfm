
<cfif URL.groupID gt 0 and IsDefined("qry_selectGroup")>
	<cfparam Name="Form.groupName" Default="#qry_selectGroup.groupName#">
	<cfparam Name="Form.groupCategory_select" Default="#qry_selectGroup.groupCategory#">
	<cfparam Name="Form.groupDescription" Default="#qry_selectGroup.groupDescription#">
	<cfparam Name="Form.groupStatus" Default="#qry_selectGroup.groupStatus#">
	<cfparam Name="Form.groupID_custom" Default="#qry_selectGroup.groupID_custom#">
</cfif>

<cfparam Name="Form.groupName" Default="">
<cfparam Name="Form.groupCategory_select" Default="">
<cfparam Name="Form.groupCategory_text" Default="">
<cfparam Name="Form.groupDescription" Default="">
<cfparam Name="Form.groupStatus" Default="1">
<cfparam Name="Form.groupID_custom" Default="">
