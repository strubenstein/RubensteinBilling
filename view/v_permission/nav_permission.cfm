<cfif URL.permissionCategoryID is not 0>
	<cfset Variables.navPermissionCategoryID = URL.permissionCategoryID>
<cfelseif IsDefined("qry_selectPermission.permissionCategoryID")>
	<cfset Variables.navPermissionCategoryID = qry_selectPermission.permissionCategoryID>
<cfelse>
	<cfset Variables.navPermissionCategoryID = 0>
</cfif>

<cfoutput>
<div class="SubNav">
<span class="SubNavTitle">Permissions: </span>
<cfif Application.fn_IsUserAuthorized("listPermissionCategories")><a href="index.cfm?method=permission.listPermissionCategories" title="List all permission categories" class="SubNavLink<cfif Variables.doAction is "listPermissionCategories">On</cfif>">List Existing Permission Categories</a></cfif>
<cfif Application.fn_IsUserAuthorized("listPermissionsAll")> | <a href="index.cfm?method=permission.listPermissionsAll" title="List all permissions in all categories" class="SubNavLink<cfif Variables.doAction is "listPermissionsAll">On</cfif>">List All Existing Permissions</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertPermissionCategory")> | <a href="index.cfm?method=permission.insertPermissionCategory" title="Create new permission category" class="SubNavLink<cfif Variables.doAction is "insertPermissionCategory">On</cfif>">Create New Permission Category</a></cfif>
<cfif Variables.navPermissionCategoryID is not 0 and IsDefined("qry_selectPermissionCategory")>
	<br><img src="#Application.billingUrlRoot#/images/grayline.jpg" width="100%" height="1" vspace="3" alt="" border="0"><br>
	<span class="SubNavObject">Permission Category:</span> <span class="SubNavName">#qry_selectPermissionCategory.permissionCategoryName#</span><br>
	<cfif Application.fn_IsUserAuthorized("updatePermissionCategory")><a href="index.cfm?method=permission.updatePermissionCategory&permissionCategoryID=#Variables.navPermissionCategoryID#" title="Update permission category information" class="SubNavLink<cfif Variables.doAction is "updatePermissionCategory">On</cfif>">Update Category</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("listPermissions")><a href="index.cfm?method=permission.listPermissions&permissionCategoryID=#Variables.navPermissionCategoryID#" title="List existing permissions in this category" class="SubNavLink<cfif Variables.doAction is "listPermissions">On</cfif>">List Existing Permissions In Category</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("insertPermission")><a href="index.cfm?method=permission.insertPermission&permissionCategoryID=#Variables.navPermissionCategoryID#" title="Add new permission to this permission category" class="SubNavLink<cfif Variables.doAction is "insertPermission" and URL.permissionCategoryID is 0>On</cfif>">Create New Permission In Category</a></cfif>
</cfif>
</div><br>
</cfoutput>

