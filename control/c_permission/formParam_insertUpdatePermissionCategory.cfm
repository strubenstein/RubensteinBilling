<cfif URL.permissionCategoryID is not 0 and IsDefined("qry_selectPermissionCategory")>
	<cfparam Name="Form.permissionCategoryName" Default="#qry_selectPermissionCategory.permissionCategoryName#">
	<cfparam Name="Form.permissionCategoryTitle" Default="#qry_selectPermissionCategory.permissionCategoryTitle#">
	<cfparam Name="Form.permissionCategoryDescription" Default="#qry_selectPermissionCategory.permissionCategoryDescription#">
	<cfparam Name="Form.permissionCategoryOrder" Default="#qry_selectPermissionCategory.permissionCategoryOrder#">
	<cfparam Name="Form.permissionCategoryStatus" Default="#qry_selectPermissionCategory.permissionCategoryStatus#">
</cfif>

<cfparam Name="Form.permissionCategoryName" Default="">
<cfparam Name="Form.permissionCategoryTitle" Default="">
<cfparam Name="Form.permissionCategoryDescription" Default="">
<cfparam Name="Form.permissionCategoryOrder" Default="0">
<cfparam Name="Form.permissionCategoryStatus" Default="1">

