<cfif Not Application.fn_IsIntegerNonNegative(URL.permissionCategoryID)>
	<cflocation url="index.cfm?method=permission.listPermissionCategories&error_permission=noPermissionCategory" AddToken="No">
<cfelseif URL.permissionCategoryID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Permission" Method="selectPermissionCategory" ReturnVariable="qry_selectPermissionCategory">
		<cfinvokeargument Name="permissionCategoryID" Value="#URL.permissionCategoryID#">
	</cfinvoke>

	<cfif qry_selectPermissionCategory.RecordCount is 0>
		<cflocation url="index.cfm?method=permission.listPermissionCategories&error_permission=invalidPermissionCategory" AddToken="No">
	</cfif>
<cfelseif ListFind("updatePermissionCategory,movePermissionCategoryUp,movePermissionCategoryDown,insertPermission", Variables.doAction)>
	<cflocation url="index.cfm?method=permission.listPermissionCategories&error_permission=noPermissionCategory" AddToken="No">
</cfif>

<cfif Not Application.fn_IsIntegerNonNegative(URL.permissionID)>
	<cflocation url="index.cfm?method=permission.listPermissionCategories&error_permission=noPermission" AddToken="No">
<cfelseif URL.permissionID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Permission" Method="selectPermission" ReturnVariable="qry_selectPermission">
		<cfinvokeargument Name="permissionID" Value="#URL.permissionID#">
	</cfinvoke>

	<cfif qry_selectPermission.RecordCount is 0>
		<cflocation url="index.cfm?method=permission.listPermissionCategories&error_permission=invalidPermission" AddToken="No">
	</cfif>
<cfelseif ListFind("updatePermission,movePermissionUp,movePermissionDown", Variables.doAction)>
	<cflocation url="index.cfm?method=permission.listPermissionCategories&error_permission=noPermission" AddToken="No">
</cfif>

