<cfset Variables.newPermissionStruct = StructNew()>

<cfinvoke Component="#Application.billingMapping#data.PermissionAction" Method="selectPermissionActionList" ReturnVariable="qry_selectPermissionActionList" />

<cfloop Query="qry_selectPermissionActionList">
	<cfset Variables.newPermissionStruct[qry_selectPermissionActionList.permissionAction] = StructNew()>
	<cfset Variables.newPermissionStruct[qry_selectPermissionActionList.permissionAction].permissionID = qry_selectPermissionActionList.permissionID>
	<cfset Variables.newPermissionStruct[qry_selectPermissionActionList.permissionAction].permissionCategoryID = qry_selectPermissionActionList.permissionCategoryID>
	<cfset Variables.newPermissionStruct[qry_selectPermissionActionList.permissionAction].permissionSuperuserOnly = qry_selectPermissionActionList.permissionSuperuserOnly>
	<cfset Variables.newPermissionStruct[qry_selectPermissionActionList.permissionAction].permissionBinaryNumber = qry_selectPermissionActionList.permissionBinaryNumber>
</cfloop>

<cflock Scope="Application" Timeout="5">
	<cfset Application.permissionStruct = Variables.newPermissionStruct>
</cflock>

