<cfcomponent DisplayName="PermissionCategory" Hint="Manages permission categories">

<cffunction name="maxlength_PermissionCategory" access="public" output="no" returnType="struct">
	<cfset var maxlength_PermissionCategory = StructNew()>

	<cfset maxlength_PermissionCategory.permissionCategoryName = 100>
	<cfset maxlength_PermissionCategory.permissionCategoryTitle = 100>
	<cfset maxlength_PermissionCategory.permissionCategoryDescription = 255>

	<cfreturn maxlength_PermissionCategory>
</cffunction>

<!--- Permission Category --->
<cffunction Name="insertPermissionCategory" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new permission category. Returns permissionCategoryID.">
	<cfargument Name="permissionCategoryName" Type="string" Required="Yes">
	<cfargument Name="permissionCategoryTitle" Type="string" Required="Yes">
	<cfargument Name="permissionCategoryDescription" Type="string" Required="No" Default="">
	<cfargument Name="permissionCategoryOrder" Type="numeric" Required="Yes">
	<cfargument Name="incrementPermissionCategoryOrder" Type="boolean" Required="No" Default="True">
	<cfargument Name="permissionCategoryStatus" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">

	<cfset var qry_insertPermissionCategory = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.PermissionCategory" method="maxlength_PermissionCategory" returnVariable="maxlength_PermissionCategory" />

	<cfquery Name="qry_insertPermissionCategory" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		<cfif Arguments.incrementPermissionCategoryOrder is True>
			UPDATE avPermissionCategory
			SET permissionCategoryOrder = permissionCategoryOrder + <cfqueryparam Value="1" cfsqltype="cf_sql_tinyint">
			WHERE permissionCategoryOrder >= <cfqueryparam Value="#Arguments.permissionCategoryOrder#" cfsqltype="cf_sql_tinyint">;
		</cfif>

		INSERT INTO avPermissionCategory
		(
			permissionCategoryName, permissionCategoryTitle, permissionCategoryOrder, permissionCategoryDescription,
			permissionCategoryStatus, userID, permissionCategoryDateCreated, permissionCategoryDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.permissionCategoryName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_PermissionCategory.permissionCategoryName#">,
			<cfqueryparam Value="#Arguments.permissionCategoryTitle#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_PermissionCategory.permissionCategoryTitle#">,
			<cfqueryparam Value="#Arguments.permissionCategoryOrder#" cfsqltype="cf_sql_tinyint">,
			<cfqueryparam Value="#Arguments.permissionCategoryDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_PermissionCategory.permissionCategoryDescription#">,
			<cfqueryparam Value="#Arguments.permissionCategoryStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "permissionCategoryID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertPermissionCategory.primaryKeyID>
</cffunction>

<cffunction Name="checkPermissionCategoryNameIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Check that permission category name is unique">
	<cfargument Name="permissionCategoryName" Type="string" Required="Yes">
	<cfargument Name="permissionCategoryID" Type="numeric" Required="No">

	<cfset var qry_checkPermissionCategoryNameIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkPermissionCategoryNameIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT permissionCategoryID
		FROM avPermissionCategory
		WHERE permissionCategoryName = <cfqueryparam Value="#Arguments.permissionCategoryName#" CFSQLType="cf_sql_varchar">
			<cfif StructKeyExists(Arguments, "permissionCategoryID") and Application.fn_IsIntegerNonNegative(Arguments.permissionCategoryID)>
				AND permissionCategoryID <> <cfqueryparam Value="#Arguments.permissionCategoryID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkPermissionCategoryNameIsUnique.RecordCount is not 0>
		<cfreturn False>
	<cfelse>
		<cfreturn True>
	</cfif>
</cffunction>

<cffunction Name="updatePermissionCategory" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing permission category. Returns True.">
	<cfargument Name="permissionCategoryID" Type="numeric" Required="Yes">
	<cfargument Name="permissionCategoryName" Type="string" Required="No">
	<cfargument Name="permissionCategoryTitle" Type="string" Required="No">
	<cfargument Name="permissionCategoryDescription" Type="string" Required="No">
	<cfargument Name="permissionCategoryOrder" Type="numeric" Required="No">
	<cfargument Name="permissionCategoryStatus" Type="numeric" Required="No">
	<cfargument Name="userID" Type="numeric" Required="No">

	<cfinvoke component="#Application.billingMapping#data.PermissionCategory" method="maxlength_PermissionCategory" returnVariable="maxlength_PermissionCategory" />

	<cfquery Name="qry_updatePermissionCategory" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avPermissionCategory
		SET
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "permissionCategoryName")>permissionCategoryName = <cfqueryparam Value="#Arguments.permissionCategoryName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_PermissionCategory.permissionCategoryName#">,</cfif>
			<cfif StructKeyExists(Arguments, "permissionCategoryTitle")>permissionCategoryTitle = <cfqueryparam Value="#Arguments.permissionCategoryTitle#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_PermissionCategory.permissionCategoryTitle#">,</cfif>
			<cfif StructKeyExists(Arguments, "permissionCategoryDescription")>permissionCategoryDescription = <cfqueryparam Value="#Arguments.permissionCategoryDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_PermissionCategory.permissionCategoryDescription#">,</cfif>
			<cfif StructKeyExists(Arguments, "permissionCategoryOrder") and Application.fn_IsIntegerNonNegative(Arguments.permissionCategoryOrder)>permissionCategoryOrder = <cfqueryparam Value="#Arguments.permissionCategoryOrder#" cfsqltype="cf_sql_tinyint">,</cfif>
			<cfif StructKeyExists(Arguments, "permissionCategoryStatus") and ListFind("0,1", Arguments.permissionCategoryStatus)>permissionCategoryStatus = <cfqueryparam Value="#Arguments.permissionCategoryStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			permissionCategoryDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE permissionCategoryID = <cfqueryparam Value="#Arguments.permissionCategoryID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="switchPermissionCategoryOrder" Access="public" Output="No" ReturnType="boolean" Hint="Switch order of existing permission categories">
	<cfargument Name="permissionCategoryID" Type="numeric" Required="Yes">
	<cfargument Name="permissionCategoryOrder_direction" Type="string" Required="Yes">

	<cfquery Name="qry_switchPermissionCategoryOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avPermissionCategory
		SET permissionCategoryOrder = permissionCategoryOrder 
			<cfif Arguments.permissionCategoryOrder_direction is "movePermissionCategoryDown"> + <cfelse> - </cfif> 
			<cfqueryparam Value="1" cfsqltype="cf_sql_tinyint">
		WHERE permissionCategoryID = <cfqueryparam Value="#Arguments.permissionCategoryID#" cfsqltype="cf_sql_integer">;

		<cfif Application.billingDatabase is "MySQL">
			UPDATE avPermissionCategory INNER JOIN avPermissionCategory AS avPermissionCategory2
			SET avPermissionCategory.permissionCategoryOrder = avPermissionCategory.permissionCategoryOrder 
				<cfif Arguments.permissionCategoryOrder_direction is "movePermissionCategoryDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_tinyint">
			WHERE avPermissionCategory.permissionCategoryOrder = avPermissionCategory2.permissionCategoryOrder
				AND avPermissionCategory.permissionCategoryID <> <cfqueryparam Value="#Arguments.permissionCategoryID#" cfsqltype="cf_sql_integer">
				AND avPermissionCategory2.permissionCategoryID = <cfqueryparam Value="#Arguments.permissionCategoryID#" cfsqltype="cf_sql_integer">;
		<cfelse>
			UPDATE avPermissionCategory
			SET permissionCategoryOrder = permissionCategoryOrder 
				<cfif Arguments.permissionCategoryOrder_direction is "movePermissionCategoryDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_tinyint">
			WHERE permissionCategoryID <> <cfqueryparam Value="#Arguments.permissionCategoryID#" cfsqltype="cf_sql_integer">
				AND permissionCategoryOrder = (SELECT permissionCategoryOrder FROM avPermissionCategory WHERE permissionCategoryID = <cfqueryparam Value="#Arguments.permissionCategoryID#" cfsqltype="cf_sql_integer">);
		</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectPermissionCategory" Access="public" Output="No" ReturnType="query" Hint="Selects existing permission category">
	<cfargument Name="permissionCategoryID" Type="numeric" Required="Yes">

	<cfset var qry_selectPermissionCategory = QueryNew("blank")>

	<cfquery Name="qry_selectPermissionCategory" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT permissionCategoryName, permissionCategoryTitle, userID,
			permissionCategoryOrder, permissionCategoryDescription, permissionCategoryStatus,
			permissionCategoryDateCreated, permissionCategoryDateUpdated
		FROM avPermissionCategory
		WHERE permissionCategoryID = <cfqueryparam Value="#Arguments.permissionCategoryID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectPermissionCategory>
</cffunction>

<cffunction Name="selectPermissionCategoryList" Access="public" Output="No" ReturnType="query" Hint="Selects list of existing permission categories">
	<cfargument Name="permissionCategoryID" Type="string" Required="No">
	<cfargument Name="permissionCategoryStatus" Type="numeric" Required="No">

	<cfset var qry_selectPermissionCategoryList = QueryNew("blank")>
	<cfset var displayAnd = False>

	<cfquery Name="qry_selectPermissionCategoryList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT permissionCategoryID, permissionCategoryName, permissionCategoryTitle, userID,
			permissionCategoryOrder, permissionCategoryDescription, permissionCategoryStatus,
			permissionCategoryDateCreated, permissionCategoryDateUpdated
		FROM avPermissionCategory
		<cfif StructKeyExists(Arguments, "permissionCategoryID") and Arguments.permissionCategoryID is not "" and Application.fn_IsIntegerList(Arguments.permissionCategoryID)>
			<cfif displayAnd is True>AND<cfelse>WHERE<cfset displayAnd = True></cfif>
			permissionCategoryID IN (<cfqueryparam Value="#Arguments.permissionCategoryID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfif>
		<cfif StructKeyExists(Arguments, "permissionCategoryStatus") and ListFind("0,1", Arguments.permissionCategoryStatus)>
			<cfif displayAnd is True>AND<cfelse>WHERE<cfset displayAnd = True></cfif>
			permissionCategoryStatus = <cfqueryparam Value="#Arguments.permissionCategoryStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		</cfif>
		ORDER BY permissionCategoryOrder
	</cfquery>

	<cfreturn qry_selectPermissionCategoryList>
</cffunction>

</cfcomponent>
