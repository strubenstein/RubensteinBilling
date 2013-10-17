<cfcomponent DisplayName="PermissionTarget" Hint="Manages who has each permission">

<cffunction Name="insertPermissionTarget" Access="public" Output="No" ReturnType="boolean" Hint="Update permissions for a particular target (user/group)">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes"><!--- userID,groupID --->
	<cfargument Name="targetID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="permissionCategoryStruct" Type="struct" Required="No">

	<cfset var qry_selectMaxPermissionTargetOrder = QueryNew("blank")>
	<cfset var permissionTargetOrder = 0>
	<cfset var nowDateTime = CreateODBCDateTime(Now())>
	<cfset var permissionCategoryID = 0>

	<cftransaction>
	<cfquery Name="qry_selectMaxPermissionTargetOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT MAX(permissionTargetOrder) AS maxPermissionTargetOrder
		FROM avPermissionTarget
		WHERE primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
			AND targetID = <cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">
			AND permissionTargetStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
	</cfquery>

	<cfif qry_selectMaxPermissionTargetOrder.RecordCount is 0 or Not IsNumeric(qry_selectMaxPermissionTargetOrder.maxPermissionTargetOrder)>
		<cfset permissionTargetOrder = 1>
	<cfelse>
		<cfset permissionTargetOrder = qry_selectMaxPermissionTargetOrder.maxPermissionTargetOrder + 1>
	</cfif>

	<cfquery Name="qry_updatePermissionTargetStatus" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avPermissionTarget
		SET permissionTargetStatus = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			permissionTargetDateUpdated = <cfqueryparam Value="#nowDateTime#" cfsqltype="cf_sql_timestamp">
		WHERE primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
			AND targetID = <cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">
			AND permissionTargetStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">;

		<cfif StructKeyExists(Arguments, "permissionCategoryStruct")>
			<cfloop Collection="#Arguments.permissionCategoryStruct#" Item="permCat">
				<cfset permissionCategoryID = ListLast(permCat, "_")>
				INSERT INTO avPermissionTarget
				(
					permissionCategoryID, primaryTargetID, targetID, userID, permissionTargetOrder,
					permissionTargetBinaryTotal, permissionTargetStatus, permissionTargetDateCreated, permissionTargetDateUpdated
				)
				VALUES
				(
					<cfqueryparam Value="#permissionCategoryID#" cfsqltype="cf_sql_integer">,
					<cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">,
					<cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">,
					<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
					<cfqueryparam Value="#permissionTargetOrder#" cfsqltype="cf_sql_smallint">,
					<cfqueryparam Value="#StructFind(Arguments.permissionCategoryStruct, permCat)#" cfsqltype="cf_sql_integer">,
					<cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
					<cfqueryparam Value="#nowDateTime#" cfsqltype="cf_sql_timestamp">,
					<cfqueryparam Value="#nowDateTime#" cfsqltype="cf_sql_timestamp">
				);
			</cfloop>
		</cfif>
	</cfquery>
	</cftransaction>

	<cfreturn True>
</cffunction>

<cffunction Name="selectPermissionTargetList" Access="public" Output="No" ReturnType="query" Hint="Selects group permissions">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes"><!--- userID,groupID --->
	<cfargument Name="targetID" Type="numeric" Required="Yes">
	<cfargument Name="permissionTargetStatus" Type="numeric" Required="No">
	<cfargument Name="permissionCategoryID" Type="string" Required="No">
	<cfargument Name="permissionTargetOrder" Type="numeric" Required="No">

	<cfset var qry_selectPermissionTargetList = QueryNew("blank")>

	<cfif Not ListFind("userID,groupID,companyID", Application.fn_GetPrimaryTargetKey(Arguments.primaryTargetID)) or Not Application.fn_IsIntegerList(Arguments.targetID)>
		<cfreturn QueryNew("blank")>
	<cfelse>
		<cfquery Name="qry_selectPermissionTargetList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT permissionTargetID, permissionCategoryID, primaryTargetID, targetID, userID,
				permissionTargetBinaryTotal, permissionTargetStatus, permissionTargetOrder,
				permissionTargetDateCreated, permissionTargetDateUpdated
			FROM avPermissionTarget
			WHERE primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
				AND targetID = <cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">
				<cfif StructKeyExists(Arguments, "permissionCategoryID") and Application.fn_IsIntegerList(Arguments.permissionCategoryID)>
					AND permissionCategoryID IN (<cfqueryparam Value="#Arguments.permissionCategoryID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				</cfif>
				<cfif StructKeyExists(Arguments, "permissionTargetStatus") and ListFind("0,1", Arguments.permissionTargetStatus)>
					AND permissionTargetStatus = <cfqueryparam Value="#Arguments.permissionTargetStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				</cfif>
				<cfif StructKeyExists(Arguments, "permissionTargetOrder") and Application.fn_IsIntegerNonNegative(Arguments.permissionTargetOrder)>
					AND permissionTargetOrder = <cfqueryparam Value="#Arguments.permissionTargetOrder#" cfsqltype="cf_sql_smallint">
				</cfif>
		</cfquery>

		<cfreturn qry_selectPermissionTargetList>
	</cfif>
</cffunction>

<cffunction Name="selectPermissionTargetOrderList" Access="public" Output="No" ReturnType="query" Hint="Returns list of instances of permissions to enable viewing each instance separately.">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="targetID" Type="numeric" Required="Yes">

	<cfset var qry_selectPermissionTargetOrderList = QueryNew("blank")>

	<cfquery Name="qry_selectPermissionTargetOrderList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT DISTINCT(permissionTargetOrder), permissionTargetDateCreated, permissionTargetDateUpdated
		FROM avPermissionTarget
		WHERE primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
			AND targetID = <cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">
		GROUP BY permissionTargetOrder, permissionTargetDateCreated, permissionTargetDateUpdated
		ORDER BY permissionTargetOrder
	</cfquery>

	<cfreturn qry_selectPermissionTargetOrderList>
</cffunction>

</cfcomponent>
