<cfif URL.permissionID is not 0 and IsDefined("qry_selectPermission") and IsDefined("qry_selectPermissionAction")>
	<cfparam Name="Form.permissionName" Default="#qry_selectPermission.permissionName#">
	<cfparam Name="Form.permissionTitle" Default="#qry_selectPermission.permissionTitle#">
	<cfparam Name="Form.permissionDescription" Default="#qry_selectPermission.permissionDescription#">
	<cfif Not IsDefined("Form.isFormSubmitted")>
		<cfparam Name="Form.permissionSuperuserOnly" Default="#qry_selectPermission.permissionSuperuserOnly#">
	</cfif>
	<cfparam Name="Form.permissionOrder" Default="#qry_selectPermission.permissionOrder#">
	<cfparam Name="Form.permissionStatus" Default="#qry_selectPermission.permissionStatus#">
	<cfparam Name="Form.permissionAction" Default="#ListChangeDelims(ValueList(qry_selectPermissionAction.permissionAction), Chr(10))#">
</cfif>

<cfparam Name="Form.permissionName" Default="">
<cfparam Name="Form.permissionTitle" Default="">
<cfparam Name="Form.permissionDescription" Default="">
<cfparam Name="Form.permissionSuperuserOnly" Default="0">
<cfparam Name="Form.permissionOrder" Default="0">
<cfparam Name="Form.permissionStatus" Default="1">
<cfparam Name="Form.permissionAction" Default="">

