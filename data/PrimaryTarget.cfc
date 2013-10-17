<cfcomponent DisplayName="PrimaryTarget" Hint="Manages inserting viewing primary target types (tables)">

<cffunction name="maxlength_PrimaryTarget" access="public" output="no" returnType="struct">
	<cfset var maxlength_PrimaryTarget = StructNew()>

	<cfset maxlength_PrimaryTarget.primaryTargetTable = 50>
	<cfset maxlength_PrimaryTarget.primaryTargetKey = 50>
	<cfset maxlength_PrimaryTarget.primaryTargetName = 100>
	<cfset maxlength_PrimaryTarget.primaryTargetDescription = 255>

	<cfreturn maxlength_PrimaryTarget>
</cffunction>

<cffunction Name="insertPrimaryTarget" Access="public" Output="No" ReturnType="boolean" Hint="Inserts new primary target (table). Returns True.">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="primaryTargetTable" Type="string" Required="Yes">
	<cfargument Name="primaryTargetKey" Type="string" Required="Yes">
	<cfargument Name="primaryTargetName" Type="string" Required="No" Default="">
	<cfargument Name="primaryTargetDescription" Type="string" Required="No" Default="">
	<cfargument Name="primaryTargetStatus" Type="numeric" Required="No" Default="1">

	<cfinvoke component="#Application.billingMapping#data.PrimaryTarget" method="maxlength_PrimaryTarget" returnVariable="maxlength_PrimaryTarget" />

	<cfquery Name="qry_insertPrimaryTarget" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avPrimaryTarget
		(
			userID, primaryTargetTable, primaryTargetKey, primaryTargetName, primaryTargetDescription,
			primaryTargetStatus, primaryTargetDateCreated, primaryTargetDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.primaryTargetTable#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_PrimaryTarget.primaryTargetTable#">,
			<cfqueryparam Value="#Arguments.primaryTargetKey#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_PrimaryTarget.primaryTargetKey#">,
			<cfqueryparam Value="#Arguments.primaryTargetName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_PrimaryTarget.primaryTargetName#">,
			<cfqueryparam Value="#Arguments.primaryTargetDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_PrimaryTarget.primaryTargetDescription#">,
			<cfqueryparam Value="#Arguments.primaryTargetStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="checkPrimaryTargetTableIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Checks whether primary target table name is already being used.">
	<cfargument Name="primaryTargetID" Type="numeric" Required="No" Default="0">
	<cfargument Name="primaryTargetTable" Type="string" Required="Yes">

	<cfset var qry_checkPrimaryTargetTableIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkPrimaryTargetTableIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT primaryTargetID
		FROM avPrimaryTarget
		WHERE primaryTargetTable = <cfqueryparam Value="#Arguments.primaryTargetTable#" cfsqltype="cf_sql_varchar">
			<cfif StructKeyExists(Arguments, "primaryTargetID") and Application.fn_IsIntegerPositive(Arguments.primaryTargetID)>
				AND primaryTargetID <> <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkPrimaryTargetTableIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="checkPrimaryTargetKeyIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Checks whether primary target primary key field is already being used.">
	<cfargument Name="primaryTargetID" Type="numeric" Required="No" Default="0">
	<cfargument Name="primaryTargetKey" Type="string" Required="Yes">

	<cfset var qry_checkPrimaryTargetKeyIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkPrimaryTargetKeyIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT primaryTargetID
		FROM avPrimaryTarget
		WHERE primaryTargetKey = <cfqueryparam Value="#Arguments.primaryTargetKey#" cfsqltype="cf_sql_varchar">
			<cfif StructKeyExists(Arguments, "primaryTargetID") and Application.fn_IsIntegerPositive(Arguments.primaryTargetID)>
				AND primaryTargetID <> <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkPrimaryTargetKeyIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="updatePrimaryTarget" Access="public" Output="No" ReturnType="boolean" Hint="Update existing primary target (table). Returns True.">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="primaryTargetTable" Type="string" Required="No">
	<cfargument Name="primaryTargetKey" Type="string" Required="No">
	<cfargument Name="primaryTargetName" Type="string" Required="No">
	<cfargument Name="primaryTargetDescription" Type="string" Required="No">
	<cfargument Name="primaryTargetStatus" Type="numeric" Required="No">

	<cfinvoke component="#Application.billingMapping#data.PrimaryTarget" method="maxlength_PrimaryTarget" returnVariable="maxlength_PrimaryTarget" />

	<cfquery Name="qry_updatePrimaryTarget" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avPrimaryTarget
		SET 
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>
				userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			</cfif>
			<cfif StructKeyExists(Arguments, "primaryTargetTable") and Trim(Arguments.primaryTargetTable) is not "">
				primaryTargetTable = <cfqueryparam Value="#Arguments.primaryTargetTable#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_PrimaryTarget.primaryTargetTable#">,
			</cfif>
			<cfif StructKeyExists(Arguments, "primaryTargetKey") and Trim(Arguments.primaryTargetKey) is not "">
				primaryTargetKey = <cfqueryparam Value="#Arguments.primaryTargetKey#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_PrimaryTarget.primaryTargetKey#">,
			</cfif>
			<cfif StructKeyExists(Arguments, "primaryTargetName") and Trim(Arguments.primaryTargetName) is not "">
				primaryTargetName = <cfqueryparam Value="#Arguments.primaryTargetName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_PrimaryTarget.primaryTargetName#">,
			</cfif>
			<cfif StructKeyExists(Arguments, "primaryTargetDescription")>
				primaryTargetDescription = <cfqueryparam Value="#Arguments.primaryTargetDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_PrimaryTarget.primaryTargetDescription#">,
			</cfif>
			<cfif StructKeyExists(Arguments, "primaryTargetStatus") and ListFind("0,1", Arguments.primaryTargetStatus)>
				primaryTargetStatus = <cfqueryparam Value="#Arguments.primaryTargetStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			</cfif>
			primaryTargetDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectPrimaryTarget" Access="public" Output="No" ReturnType="query" Hint="Select existing primary target.">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">

	<cfset var qry_selectPrimaryTarget = QueryNew("blank")>

	<cfquery Name="qry_selectPrimaryTarget" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT userID, primaryTargetTable, primaryTargetKey,
			primaryTargetName, primaryTargetDescription, primaryTargetStatus,
			primaryTargetDateCreated, primaryTargetDateUpdated
		FROM avPrimaryTarget
		WHERE primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectPrimaryTarget>
</cffunction>

<cffunction Name="selectPrimaryTargetList" Access="public" Output="No" ReturnType="query" Hint="Select existing primary targets.">
	<cfargument Name="queryOrderBy" Type="string" Required="No" Default="primaryTargetTable">
	<cfargument Name="primaryTargetID" Type="string" Required="No">
	<cfargument Name="primaryTargetKey" Type="string" Required="No">
	<cfargument Name="primaryTargetStatus" Type="numeric" Required="No">

	<cfset var qry_selectPrimaryTargetList = QueryNew("blank")>
	<cfset var displayAnd = False>

	<cfquery Name="qry_selectPrimaryTargetList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avPrimaryTarget.userID, avPrimaryTarget.primaryTargetID,
			avPrimaryTarget.primaryTargetTable, avPrimaryTarget.primaryTargetKey,
			avPrimaryTarget.primaryTargetName, avPrimaryTarget.primaryTargetDescription,
			avPrimaryTarget.primaryTargetStatus, avPrimaryTarget.primaryTargetDateCreated,
			avPrimaryTarget.primaryTargetDateUpdated,
			avUser.firstName, avUser.lastName, avUser.userID_custom
		FROM avPrimaryTarget LEFT OUTER JOIN avUser
			ON avPrimaryTarget.userID = avUser.userID
		<cfif StructKeyExists(Arguments, "primaryTargetID") and Application.fn_IsIntegerList(Arguments.primaryTargetID)>
			<cfif displayAnd is True>AND<cfelse>WHERE</cfif>
			avPrimaryTarget.primaryTargetID IN (<cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			<cfset displayAnd = True>
		</cfif>
		<cfif StructKeyExists(Arguments, "primaryTargetKey") and Trim(Arguments.primaryTargetKey) is not "">
			<cfif displayAnd is True>AND<cfelse>WHERE</cfif>
			avPrimaryTarget.primaryTargetKey IN (<cfqueryparam Value="#Arguments.primaryTargetKey#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)
			<cfset displayAnd = True>
		</cfif>
		<cfif StructKeyExists(Arguments, "primaryTargetStatus") and ListFind("0,1", Arguments.primaryTargetStatus)>
			<cfif displayAnd is True>AND<cfelse>WHERE</cfif>
			avPrimaryTarget.primaryTargetStatus = <cfqueryparam Value="#Arguments.primaryTargetStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			<cfset displayAnd = True>
		</cfif>
		ORDER BY 
		<cfswitch expression="#Arguments.queryOrderBy#">
		<cfcase value="primaryTargetID">avPrimaryTarget.primaryTargetID</cfcase>
		<cfcase value="primaryTargetID_d">avPrimaryTarget.primaryTargetID DESC</cfcase>
		<cfcase value="primaryTargetTable">avPrimaryTarget.primaryTargetTable</cfcase>
		<cfcase value="primaryTargetTable_d">avPrimaryTarget.primaryTargetTable DESC</cfcase>
		<cfcase value="primaryTargetKey">avPrimaryTarget.primaryTargetKey</cfcase>
		<cfcase value="primaryTargetKey_d">avPrimaryTarget.primaryTargetKey DESC</cfcase>
		<cfcase value="primaryTargetName">avPrimaryTarget.primaryTargetName</cfcase>
		<cfcase value="primaryTargetName_d">avPrimaryTarget.primaryTargetName DESC</cfcase>
		<cfcase value="primaryTargetStatus">avPrimaryTarget.primaryTargetStatus DESC, avPrimaryTarget.primaryTargetTable</cfcase>
		<cfcase value="primaryTargetStatus_d">avPrimaryTarget.primaryTargetStatus, avPrimaryTarget.primaryTargetTable</cfcase>
		<cfcase value="primaryTargetDateCreated">avPrimaryTarget.primaryTargetDateCreated</cfcase>
		<cfcase value="primaryTargetDateCreated_d">avPrimaryTarget.primaryTargetDateCreated DESC</cfcase>
		<cfcase value="primaryTargetDateUpdated">avPrimaryTarget.primaryTargetDateUpdated</cfcase>
		<cfcase value="primaryTargetDateUpdated_d">avPrimaryTarget.primaryTargetDateUpdated DESC</cfcase>
		<cfcase value="lastName">avUser.lastName, avUser.firstName</cfcase>
		<cfcase value="lastName_d">avUser.lastName DESC, avUser.firstName DESC</cfcase>
		<cfdefaultcase>avPrimaryTarget.primaryTargetName</cfdefaultcase>
		</cfswitch>
	</cfquery>

	<cfreturn qry_selectPrimaryTargetList>
</cffunction>

</cfcomponent>

