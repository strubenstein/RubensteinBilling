<cfinvoke Component="#Application.billingMapping#data.Permission" Method="selectPermissionList" ReturnVariable="qry_selectPermissionList">
	<cfif URL.permissionCategoryID is not 0>
		<cfinvokeargument Name="permissionCategoryID" Value="#URL.permissionCategoryID#">
	</cfif>
</cfinvoke>

<cfinclude template="../../view/v_permission/lang_listPermissions.cfm">

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("updatePermissionCategory,insertPermission,movePermissionDown,movePermissionUp,updatePermission")>
<cfset Variables.columnHeaderList = Variables.lang_listPermissions_title.permissionOrder
		& "^" & Variables.lang_listPermissions_title.permissionName
		& "^" & Variables.lang_listPermissions_title.permissionTitle
		& "^" & Variables.lang_listPermissions_title.permissionSuperuser
		& "^" & Variables.lang_listPermissions_title.permissionDescription
		& "^" & Variables.lang_listPermissions_title.permissionStatus
		& "^" & Variables.lang_listPermissions_title.permissionDateCreated
		& "^" & Variables.lang_listPermissions_title.permissionDateUpdated>

<cfif ListFind(Variables.permissionActionList, "movePermissionDown") and ListFind(Variables.permissionActionList, "movePermissionUp")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listPermissions_title.switchPermissionOrder>
</cfif>
<cfif ListFind(Variables.permissionActionList, "updatePermission")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listPermissions_title.updatePermission>
</cfif>

<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>
<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../view/v_permission/dsp_selectPermissionList.cfm">
