<cfcomponent displayName="CheckPermissionTarget" hint="Check permission for a target">

<cffunction name="checkPermissionUser" access="public" returnType="string" output="yes" hint="Returns the list of actions for which the user has permission">
	<cfargument name="userID" type="numeric" required="yes">
	<cfargument name="companyID" type="numeric" required="yes">
	<cfargument name="permissionAction" type="string" required="yes">

	<cfset var permissionActionList = "">
	<cfset var isPermission = False>
	<cfset var newPermissionStruct = StructNew()>

	<cfinvoke component="#Application.billingMapping#include.security.Login" Method="checkLoginGroup" ReturnVariable="qry_checkLoginGroup">
		<cfinvokeargument Name="userID" Value="#Arguments.userID#">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
	</cfinvoke>

	<cfinvoke component="#Application.billingMapping#include.security.Login" method="checkLoginPermission" returnVariable="qry_checkLoginPermission">
		<cfinvokeargument name="userID" value="#Arguments.userID#">
		<cfinvokeargument name="groupID" value="#ValueList(qry_checkLoginGroup.groupID)#">
	</cfinvoke>

	<cfloop Query="qry_checkLoginPermission">
		<cfif Not StructKeyExists(newPermissionStruct, "cat#permissionCategoryID#")>
			<cfset newPermissionStruct["cat#permissionCategoryID#"] = permissionTargetBinaryTotal>
		<cfelse>
			<cfset newPermissionStruct["cat#permissionCategoryID#"] = BitOr(newPermissionStruct["cat#permissionCategoryID#"], permissionTargetBinaryTotal)>
		</cfif>
	</cfloop>

	<cfloop index="thisPermissionAction" list="#Arguments.permissionAction#">
		<!--- if permission does not exist, user has permission by default --->
		<cfif Not StructKeyExists(Application.permissionStruct, thisPermissionAction)>
			<cfset isPermission = True>
		<!--- if permission requires being a superuser --->
		<cfelseif Application.permissionStruct[thisPermissionAction].permissionSuperuserOnly is 1 and Arguments.companyID is not Application.billingSuperuserCompanyID>
			<cfset isPermission = False>
		<!--- if user does not have permission for permission category that contains permission, return False --->
		<cfelseif Not StructKeyExists(newPermissionStruct, "cat#Application.permissionStruct[thisPermissionAction].permissionCategoryID#")>
			<cfset isPermission = False>
		<!--- if user has permission, return True --->
		<cfelseif BitAnd(newPermissionStruct["cat#Application.permissionStruct[thisPermissionAction].permissionCategoryID#"], Application.permissionStruct[thisPermissionAction].permissionBinaryNumber)>
			<cfset isPermission = True>
		<cfelse>
			<cfset isPermission = False>
		</cfif>

		<cfif isPermission is True>
			<cfset permissionActionList = ListAppend(permissionActionList, thisPermissionAction)>
		</cfif>
	</cfloop>

	<cfreturn permissionActionList>
</cffunction>

<cffunction name="getUsersWithPermission" access="public" returnType="string" output="no" hint="Returns userID's of users with a particular permnission">
	<cfargument name="companyID" type="numeric" required="yes">
	<cfargument name="permissionAction" type="string" required="yes">

	<cfset var userID_list = "">
	<cfset var qry_getUsersWithPermission = QueryNew("blank")>

	<cfif StructKeyExists(Application.permissionStruct, Arguments.permissionAction)>
		<!--- get users with this permission directly or via a group --->
		<cfquery name="qry_getUsersWithPermission" datasource="#Application.billingDsn#" username="#Application.billingDsnUsername#" password="#Application.billingDsnPassword#">
			SELECT DISTINCT(targetID)
			FROM
				(
				SELECT targetID
				FROM avPermissionTarget
				WHERE permissionTargetStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
					AND permissionCategoryID = <cfqueryparam value="#Application.permissionStruct[Arguments.permissionAction].permissionCategoryID#" cfsqltype="cf_sql_integer">
					AND permissionTargetBinaryTotal & <cfqueryparam value="#Application.permissionStruct[Arguments.permissionAction].permissionBinaryNumber#" cfsqltype="cf_sql_integer"> = <cfqueryparam value="#Application.permissionStruct[Arguments.permissionAction].permissionBinaryNumber#" cfsqltype="cf_sql_integer">
					AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('userID')#" cfsqltype="cf_sql_integer">
					AND targetID IN
						(
						SELECT userID
						FROM avUser
						WHERE userStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
							AND companyID = <cfqueryparam value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
						)
	
				UNION
	
				SELECT targetID
				FROM avGroupTarget
				WHERE groupTargetStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
					AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('userID')#" cfsqltype="cf_sql_integer">
					AND targetID IN
						(
						SELECT userID
						FROM avUser
						WHERE userStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
							AND companyID = <cfqueryparam value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
						)
					AND groupID IN
						(
						SELECT targetID
						FROM avPermissionTarget
						WHERE permissionTargetStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
							AND permissionCategoryID = <cfqueryparam value="#Application.permissionStruct[Arguments.permissionAction].permissionCategoryID#" cfsqltype="cf_sql_integer">
							AND permissionTargetBinaryTotal & <cfqueryparam value="#Application.permissionStruct[Arguments.permissionAction].permissionBinaryNumber#" cfsqltype="cf_sql_integer"> = <cfqueryparam value="#Application.permissionStruct[Arguments.permissionAction].permissionBinaryNumber#" cfsqltype="cf_sql_integer">
							AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('groupID')#" cfsqltype="cf_sql_integer">
							AND targetID IN
								(
								SELECT groupID
								FROM avGroup
								WHERE groupStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
									AND companyID = <cfqueryparam value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
								)
						)
				) AS T
		</cfquery>

		<cfset userID_list = ValueList(qry_getUsersWithPermission.targetID)>
	</cfif>

	<cfreturn userID_list>
</cffunction>

</cfcomponent>
