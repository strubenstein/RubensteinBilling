<cfcomponent DisplayName="Permission" Hint="Manages inserting, updating and viewing permisions">

<cffunction name="maxlength_Permission" access="public" output="no" returnType="struct">
	<cfset var maxlength_Permission = StructNew()>

	<cfset maxlength_Permission.permissionName = 100>
	<cfset maxlength_Permission.permissionTitle = 100>
	<cfset maxlength_Permission.permissionAction = 50>
	<cfset maxlength_Permission.permissionDescription = 255>

	<cfreturn maxlength_Permission>
</cffunction>

<!--- Permission --->
<cffunction Name="insertPermission" Access="public" Output="No" ReturnType="boolean" Hint="Inserts new permission. Returns True.">
	<cfargument Name="permissionCategoryID" Type="numeric" Required="Yes">
	<cfargument Name="permissionBinaryNumber" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="permissionName" Type="string" Required="Yes">
	<cfargument Name="permissionTitle" Type="string" Required="Yes">
	<cfargument Name="permissionDescription" Type="string" Required="No" Default="">
	<cfargument Name="permissionOrder" Type="numeric" Required="Yes">
	<cfargument Name="incrementPermissionOrder" Type="boolean" Required="No" Default="True">
	<cfargument Name="permissionStatus" Type="numeric" Required="Yes">
	<cfargument Name="permissionSuperuserOnly" Type="numeric" Required="No" Default="0">
	<cfargument Name="permissionAction" Type="string" Required="No" Default="">

	<cfset var count = 0>
	<cfset var newPermissionID = 0>
	<cfset var qry_insertPermission = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.Permission" method="maxlength_Permission" returnVariable="maxlength_Permission" />

	<cfquery Name="qry_insertPermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		<cfif Arguments.incrementPermissionOrder is True>
			UPDATE avPermission
			SET permissionOrder = permissionOrder + <cfqueryparam Value="1" cfsqltype="cf_sql_tinyint">
			WHERE permissionOrder >= <cfqueryparam Value="#Arguments.permissionOrder#" cfsqltype="cf_sql_tinyint">;
		</cfif>

		INSERT INTO avPermission
		(
			permissionCategoryID, permissionBinaryNumber, userID, permissionName, permissionTitle, permissionDescription,
			permissionOrder, permissionStatus, permissionSuperuserOnly, permissionDateCreated, permissionDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.permissionCategoryID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.permissionBinaryNumber#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.permissionName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Permission.permissionName#">,
			<cfqueryparam Value="#Arguments.permissionTitle#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Permission.permissionTitle#">,
			<cfqueryparam Value="#Arguments.permissionDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Permission.permissionDescription#">,
			<cfqueryparam Value="#Arguments.permissionOrder#" cfsqltype="cf_sql_tinyint">,
			<cfqueryparam Value="#Arguments.permissionStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.permissionSuperuserOnly#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "permissionID", "ALL")#;
	</cfquery>

	<cfif Arguments.permissionAction is not "">
		<cfinvoke Component="#Application.billingMapping#data.PermissionAction" Method="insertPermissionAction" ReturnVariable="isPermissionActionInserted">
			<cfinvokeargument Name="permissionID" Value="#qry_insertPermission.primaryKeyID#">
			<cfinvokeargument Name="permissionAction" Value="#Arguments.permissionAction#">
		</cfinvoke>
	</cfif>

	<cfreturn True>
</cffunction>


<cffunction Name="updatePermission" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing permission. Returns True.">
	<cfargument Name="permissionID" Type="numeric" Required="Yes">
	<cfargument Name="permissionCategoryID" Type="numeric" Required="No">
	<cfargument Name="permissionBinaryNumber" Type="numeric" Required="No">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="permissionName" Type="string" Required="No">
	<cfargument Name="permissionTitle" Type="string" Required="No">
	<cfargument Name="permissionDescription" Type="string" Required="No">
	<cfargument Name="permissionOrder" Type="numeric" Required="No">
	<cfargument Name="permissionStatus" Type="numeric" Required="No">
	<cfargument Name="permissionSuperuserOnly" Type="numeric" Required="No">
	<cfargument Name="permissionAction" Type="string" Required="No">

	<cfset var newPermissionID = Arguments.permissionID>

	<cfinvoke component="#Application.billingMapping#data.Permission" method="maxlength_Permission" returnVariable="maxlength_Permission" />

	<cfquery Name="qry_updatePermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avPermission
		SET
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "permissionCategoryID") and Application.fn_IsIntegerNonNegative(Arguments.permissionCategoryID)>permissionCategoryID = <cfqueryparam Value="#Arguments.permissionCategoryID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "permissionName")>permissionName = <cfqueryparam Value="#Arguments.permissionName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Permission.permissionName#">,</cfif>
			<cfif StructKeyExists(Arguments, "permissionTitle")>permissionTitle = <cfqueryparam Value="#Arguments.permissionTitle#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Permission.permissionTitle#">,</cfif>
			<cfif StructKeyExists(Arguments, "permissionDescription")>permissionDescription = <cfqueryparam Value="#Arguments.permissionDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Permission.permissionDescription#">,</cfif>
			<cfif StructKeyExists(Arguments, "permissionOrder") and Application.fn_IsIntegerNonNegative(Arguments.permissionOrder)>permissionOrder = <cfqueryparam Value="#Arguments.permissionOrder#" cfsqltype="cf_sql_tinyint">,</cfif>
			<cfif StructKeyExists(Arguments, "permissionStatus") and ListFind("0,1", Arguments.permissionStatus)>permissionStatus = <cfqueryparam Value="#Arguments.permissionStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "permissionSuperuserOnly") and ListFind("0,1", Arguments.permissionSuperuserOnly)>permissionSuperuserOnly = <cfqueryparam Value="#Arguments.permissionSuperuserOnly#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			permissionDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE permissionID = <cfqueryparam Value="#Arguments.permissionID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfquery Name="qry_deletePermissionAction" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		DELETE FROM avPermissionAction
		WHERE permissionID = <cfqueryparam Value="#Arguments.permissionID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfif Arguments.permissionAction is not "">
		<cfinvoke Component="#Application.billingMapping#data.PermissionAction" Method="insertPermissionAction" ReturnVariable="isPermissionActionInserted">
			<cfinvokeargument Name="permissionID" Value="#Arguments.permissionID#">
			<cfinvokeargument Name="permissionAction" Value="#Arguments.permissionAction#">
		</cfinvoke>
	</cfif>

	<cfreturn True>
</cffunction>

<cffunction Name="checkPermissionNameIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Check that permission name is unique">
	<cfargument Name="permissionName" Type="string" Required="Yes">
	<cfargument Name="permissionID" Type="numeric" Required="No">

	<cfset var qry_checkPermissionNameIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkPermissionNameIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT permissionID
		FROM avPermission
		WHERE permissionName = <cfqueryparam Value="#Arguments.permissionName#" CFSQLType="cf_sql_varchar">
			<cfif StructKeyExists(Arguments, "permissionID") and Application.fn_IsIntegerNonNegative(Arguments.permissionID)>
				AND permissionID <> <cfqueryparam Value="#Arguments.permissionID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkPermissionNameIsUnique.RecordCount is not 0>
		<cfreturn False>
	<cfelse>
		<cfreturn True>
	</cfif>
</cffunction>

<cffunction Name="switchPermissionOrder" Access="public" Output="No" ReturnType="boolean" Hint="Switch order of existing permission listings">
	<cfargument Name="permissionID" Type="numeric" Required="Yes">
	<cfargument Name="permissionOrder_direction" Type="string" Required="Yes">

	<cfquery Name="qry_switchPermissionOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avPermission
		SET permissionOrder = permissionOrder 
			<cfif Arguments.permissionOrder_direction is "movePermissionDown"> + <cfelse> - </cfif> 
			<cfqueryparam Value="1" cfsqltype="cf_sql_tinyint">
		WHERE permissionID = <cfqueryparam Value="#Arguments.permissionID#" cfsqltype="cf_sql_integer">;

		<cfif Application.billingDatabase is "MySQL">
			UPDATE avPermission INNER JOIN avPermission AS avPermission2
			SET avPermission.permissionOrder = avPermission.permissionOrder 
				<cfif Arguments.permissionOrder_direction is "movePermissionDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_tinyint">
			WHERE avPermission.permissionOrder = avPermission2.permissionOrder 
				AND avPermission.permissionID <> <cfqueryparam Value="#Arguments.permissionID#" cfsqltype="cf_sql_integer">
				AND avPermission2.permissionID = <cfqueryparam Value="#Arguments.permissionID#" cfsqltype="cf_sql_integer">;
		<cfelse>
			UPDATE avPermission
			SET permissionOrder = permissionOrder 
				<cfif Arguments.permissionOrder_direction is "movePermissionDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_tinyint">
			WHERE permissionID <> <cfqueryparam Value="#Arguments.permissionID#" cfsqltype="cf_sql_integer">
				AND permissionOrder = (SELECT permissionOrder FROM avPermission WHERE permissionID = <cfqueryparam Value="#Arguments.permissionID#" cfsqltype="cf_sql_integer">)
				AND permissionCategoryID = (SELECT permissionCategoryID FROM avPermission WHERE permissionID = <cfqueryparam Value="#Arguments.permissionID#" cfsqltype="cf_sql_integer">);
		</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectPermission" Access="public" Output="No" ReturnType="query" Hint="Selects existing permission">
	<cfargument Name="permissionID" Type="numeric" Required="Yes">

	<cfset var qry_selectPermission = QueryNew("blank")>

	<cfquery Name="qry_selectPermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT permissionCategoryID, permissionBinaryNumber, userID, permissionName,
			permissionTitle, permissionDescription, permissionOrder, permissionStatus,
			permissionSuperuserOnly, permissionDateCreated, permissionDateUpdated
		FROM avPermission
		WHERE permissionID = <cfqueryparam Value="#Arguments.permissionID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectPermission>
</cffunction>

<cffunction Name="selectPermissionList" Access="public" Output="No" ReturnType="query" Hint="Selects list of existing permissions">
	<cfargument Name="permissionID" Type="string" Required="No">
	<cfargument Name="permissionCategoryID" Type="string" Required="No">
	<cfargument Name="permissionStatus" Type="numeric" Required="No">
	<cfargument Name="permissionSuperuserOnly" Type="numeric" Required="No">
	<cfargument Name="permissionAction" Type="string" Required="No">

	<cfset var qry_selectPermissionList = QueryNew("blank")>

	<cfquery Name="qry_selectPermissionList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avPermission.permissionID, avPermission.permissionBinaryNumber,
			avPermission.userID, avPermission.permissionName, avPermission.permissionTitle,
			avPermission.permissionDescription, avPermission.permissionOrder,
			avPermission.permissionStatus, avPermission.permissionSuperuserOnly,
			avPermission.permissionDateCreated, avPermission.permissionDateUpdated,
			avPermissionCategory.permissionCategoryID, avPermissionCategory.permissionCategoryOrder
		FROM avPermission, avPermissionCategory
		WHERE avPermission.permissionCategoryID = avPermissionCategory.permissionCategoryID
		<cfif StructKeyExists(Arguments, "permissionID") and Application.fn_IsIntegerList(Arguments.permissionID)>AND avPermission.permissionID IN (<cfqueryparam Value="#Arguments.permissionID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)</cfif>
		<cfif StructKeyExists(Arguments, "permissionCategoryID") and Arguments.permissionCategoryID is not "" and Application.fn_IsIntegerList(Arguments.permissionCategoryID)>AND avPermission.permissionCategoryID IN (<cfqueryparam Value="#Arguments.permissionCategoryID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)</cfif>
		<cfif StructKeyExists(Arguments, "permissionStatus") and ListFind("0,1", Arguments.permissionStatus)>AND avPermission.permissionStatus = <cfqueryparam Value="#Arguments.permissionStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
		<cfif StructKeyExists(Arguments, "permissionSuperuserOnly") and ListFind("0,1", Arguments.permissionSuperuserOnly)>AND avPermission.permissionSuperuserOnly = <cfqueryparam Value="#Arguments.permissionSuperuserOnly#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
		ORDER BY avPermissionCategory.permissionCategoryOrder, avPermissionCategory.permissionCategoryID, avPermission.permissionOrder
	</cfquery>

	<cfreturn qry_selectPermissionList>
</cffunction>

</cfcomponent>
