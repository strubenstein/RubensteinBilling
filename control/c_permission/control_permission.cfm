<!---
max of 32 permissions in each category
max of 256 categories
--->

<cfparam Name="URL.permissionID" Default="0">
<cfparam Name="URL.permissionCategoryID" Default="0">

<cfif Not ListFind("insertPermissionTarget,viewPermissionTarget", Variables.doAction)>
	<cfinclude template="security_permission.cfm">
	<cfif URL.permissionID is not 0>
		<cfset URL.permissionCategoryID = qry_selectPermission.permissionCategoryID>
	</cfif>
	<cfif URL.permissionCategoryID is not 0>
		<cfinvoke Component="#Application.billingMapping#data.Permission" Method="selectPermissionCategory" ReturnVariable="qry_selectPermissionCategory">
			<cfinvokeargument Name="permissionCategoryID" Value="#URL.permissionCategoryID#">
		</cfinvoke>
	</cfif>
	<cfinclude template="../../view/v_permission/nav_permission.cfm">
</cfif>
<cfif IsDefined("URL.confirm_permission")>
	<cfinclude template="../../view/v_permission/confirm_permission.cfm">
</cfif>
<cfif IsDefined("URL.error_permission")>
	<cfinclude template="../../view/v_permission/error_permission.cfm">
</cfif>

<cfinvoke Component="#Application.billingMapping#data.PermissionCategory" Method="selectPermissionCategoryList" ReturnVariable="qry_selectPermissionCategoryList" />

<cfswitch expression="#Variables.doAction#">
<cfcase value="listPermissionCategories">
	<cfinclude template="control_listPermissionCategories.cfm">
</cfcase>

<cfcase value="insertPermissionCategory">
	<cfinclude template="control_insertPermissionCategory.cfm">
</cfcase>

<cfcase value="updatePermissionCategory">
	<cfinclude template="control_updatePermissionCategory.cfm">
</cfcase>

<cfcase value="movePermissionCategoryUp,movePermissionCategoryDown">
	<cfinvoke Component="#Application.billingMapping#data.Permission" Method="switchPermissionCategoryOrder" ReturnVariable="isPermissionCategoryMoved">
		<cfinvokeargument Name="permissionCategoryID" Value="#URL.permissionCategoryID#">
		<cfinvokeargument Name="permissionCategoryOrder_direction" Value="#Variables.doAction#">
	</cfinvoke>

	<cflocation url="index.cfm?method=permission.listPermissionCategories&confirm_permission=#Variables.doAction#" AddToken="No">
</cfcase>

<cfcase value="listPermissions,listPermissionsAll">
	<cfinclude template="control_listPermissions.cfm">
</cfcase>

<cfcase value="insertPermission">
	<cfif qry_selectPermissionCategoryList.RecordCount is 0>
		<cflocation url="index.cfm?method=permission.insertPermissionCategory&error_permission=insertPermission_noCategory" AddToken="No">
	<cfelse>
		<cfinclude template="control_insertPermission.cfm">
	</cfif>
</cfcase>

<cfcase value="updatePermission">
	<cfinclude template="control_updatePermission.cfm">
</cfcase>

<cfcase value="movePermissionUp,movePermissionDown">
	<cfinvoke Component="#Application.billingMapping#data.Permission" Method="switchPermissionOrder" ReturnVariable="isPermissionCategoryMoved">
		<cfinvokeargument Name="permissionID" Value="#URL.permissionID#">
		<cfinvokeargument Name="permissionOrder_direction" Value="#Variables.doAction#">
	</cfinvoke>

	<cflocation url="index.cfm?method=permission.listPermissions&permissionCategoryID=#qry_selectPermission.permissionCategoryID#&confirm_permission=#Variables.doAction#" AddToken="No">
</cfcase>

<cfcase value="insertPermissionTarget,viewPermissionTarget">
	<cfif URL.control is "permission" or Not IsDefined("Variables.primaryTargetID") or Not IsDefined("Variables.targetID")>
		<cfset URL.error_permission = "invalidTarget">
		<cfinclude template="../../view/v_permission/error_permission.cfm">
	<cfelse>
		<cfinclude template="control_insertPermissionTarget.cfm">
	</cfif>
</cfcase>

<cfdefaultcase>
	<cfset URL.error_permission = "invalidAction">
	<cfinclude template="../../view/v_permission/error_permission.cfm">
</cfdefaultcase>
</cfswitch>

