<cfcomponent DisplayName="PermissionAction" Hint="Manages actions associated with each permission">

<cffunction name="maxlength_PermissionAction" access="public" output="no" returnType="struct">
	<cfset var maxlength_PermissionAction = StructNew()>

	<cfset maxlength_PermissionAction.permissionAction = 50>

	<cfreturn maxlength_PermissionAction>
</cffunction>

<!--- Permission Action --->
<cffunction Name="insertPermissionAction" Access="public" Output="No" ReturnType="boolean" Hint="Inserts permission action(s) for a permission. Returns True.">
	<cfargument Name="permissionID" Type="numeric" Required="Yes">
	<cfargument Name="permissionAction" Type="string" Required="No" Default="">

	<cfinvoke component="#Application.billingMapping#data.PermissionAction" method="maxlength_PermissionAction" returnVariable="maxlength_PermissionAction" />

	<cfif Trim(Arguments.permissionAction) is not "">
		<cfquery Name="qry_insertPermissionAction" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			<cfloop Index="thisAction" List="#Arguments.permissionAction#" Delimiters=",#Chr(10)#">
				INSERT INTO avPermissionAction
				(
					permissionID, permissionAction
				)
				VALUES
				(
					<cfqueryparam Value="#Arguments.permissionID#" cfsqltype="cf_sql_integer">,
					<cfqueryparam Value="#Trim(thisAction)#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_PermissionAction.permissionAction#">
				);
			</cfloop>
		</cfquery>
	</cfif>

	<cfreturn True>
</cffunction>

<cffunction Name="selectPermissionAction" Access="public" Output="No" ReturnType="query" Hint="Selects actions for existing permission">
	<cfargument Name="permissionID" Type="numeric" Required="Yes">

	<cfset var qry_selectPermissionAction = QueryNew("blank")>

	<cfquery Name="qry_selectPermissionAction" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT permissionAction
		FROM avPermissionAction
		WHERE permissionID = <cfqueryparam Value="#Arguments.permissionID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectPermissionAction>
</cffunction>

<cffunction Name="selectPermissionActionList" Access="public" Output="No" ReturnType="query" Hint="Selects all existing permission actions">
	<cfset var qry_selectPermissionActionList = QueryNew("blank")>

	<cfquery Name="qry_selectPermissionActionList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avPermissionAction.permissionID, avPermissionAction.permissionAction,
			avPermission.permissionCategoryID, avPermission.permissionBinaryNumber,
			avPermission.permissionSuperuserOnly
		FROM avPermissionAction, avPermission, avPermissionCategory
		WHERE avPermissionAction.permissionID = avPermission.permissionID
			AND avPermission.permissionCategoryID = avPermissionCategory.permissionCategoryID
			AND avPermission.permissionStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			AND avPermissionCategory.permissionCategoryStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		ORDER BY avPermission.permissionCategoryID, avPermissionAction.permissionAction
	</cfquery>

	<cfreturn qry_selectPermissionActionList>
</cffunction>

<cffunction Name="checkPermissionActionIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Checks that action is not already being used for an existing permission">
	<cfargument Name="permissionAction" Type="string" Required="Yes">
	<cfargument Name="permissionID" Type="numeric" Required="No" Default="0">

	<cfset var qry_checkPermissionActionIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkPermissionActionIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT permissionID
		FROM avPermissionAction
		WHERE permissionAction = <cfqueryparam Value="#Arguments.permissionAction#" cfsqltype="cf_sql_varchar">
		<cfif Arguments.permissionID is not 0>
			AND permissionID <> <cfqueryparam Value="#Arguments.permissionID#" cfsqltype="cf_sql_integer">
		</cfif>
	</cfquery>

	<cfif qry_checkPermissionActionIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

</cfcomponent>
