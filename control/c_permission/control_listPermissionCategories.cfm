<cfinclude template="../../view/v_permission/lang_listPermissionCategories.cfm">

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("movePermissionCategoryDown,movePermissionCategoryUp,updatePermissionCategory,listPermissions,insertPermission")>
<cfset Variables.columnHeaderList = Variables.lang_listPermissionCategories_title.permissionCategoryOrder
		& "^" & Variables.lang_listPermissionCategories_title.permissionCategoryName
		& "^" & Variables.lang_listPermissionCategories_title.permissionCategoryTitle
		& "^" & Variables.lang_listPermissionCategories_title.permissionCategoryDescription
		& "^" & Variables.lang_listPermissionCategories_title.permissionCategoryStatus
		& "^" & Variables.lang_listPermissionCategories_title.permissionCategoryDateCreated
		& "^" & Variables.lang_listPermissionCategories_title.permissionCategoryDateUpdated>

<cfif ListFind(Variables.permissionActionList, "movePermissionCategoryDown") and ListFind(Variables.permissionActionList, "movePermissionCategoryUp")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listPermissionCategories_title.switchPermissionCategoryOrder>
</cfif>
<cfif ListFind(Variables.permissionActionList, "updatePermissionCategory")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listPermissionCategories_title.updatePermissionCategory>
</cfif>
<cfif ListFind(Variables.permissionActionList, "listPermissions")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listPermissionCategories_title.listPermissions>
</cfif>
<cfif ListFind(Variables.permissionActionList, "insertPermission")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listPermissionCategories_title.insertPermission>
</cfif>

<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../view/v_permission/dsp_selectPermissionCategoryList.cfm">
