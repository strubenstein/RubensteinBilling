<cfcomponent DisplayName="StatusTarget" Hint="Manages export options for each target of custom status options">

<cffunction name="maxlength_StatusTarget" access="public" output="no" returnType="struct">
	<cfset var maxlength_StatusTarget = StructNew()>

	<cfset maxlength_StatusTarget.statusTargetExportXmlName = 100>
	<cfset maxlength_StatusTarget.statusTargetExportTabName = 100>
	<cfset maxlength_StatusTarget.statusTargetExportHtmlName = 100>

	<cfreturn maxlength_StatusTarget>
</cffunction>

<!--- Status Target: Primarily for export options --->
<cffunction Name="insertStatusTarget" Access="public" Output="No" ReturnType="boolean" Hint="Inserts new status target option. Returns True.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No" Default="0">
	<cfargument Name="statusTargetExportXmlStatus" Type="numeric" Required="No" Default="">
	<cfargument Name="statusTargetExportXmlName" Type="string" Required="No" Default="0">
	<cfargument Name="statusTargetExportTabStatus" Type="numeric" Required="No" Default="0">
	<cfargument Name="statusTargetExportTabName" Type="string" Required="No" Default="">
	<cfargument Name="statusTargetExportHtmlStatus" Type="numeric" Required="No" Default="0">
	<cfargument Name="statusTargetExportHtmlName" Type="string" Required="No" Default="">

	<cfinvoke component="#Application.billingMapping#data.StatusTarget" method="maxlength_StatusTarget" returnVariable="maxlength_StatusTarget" />

	<cfquery Name="qry_insertStatusTarget" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avStatusTarget
		(
			companyID, primaryTargetID, statusTargetExportXmlStatus, statusTargetExportXmlName, statusTargetExportTabStatus,
			statusTargetExportTabName, statusTargetExportHtmlStatus, statusTargetExportHtmlName, userID,
			statusTargetDateCreated, statusTargetDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.statusTargetExportXmlStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.statusTargetExportXmlName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_StatusTarget.statusTargetExportXmlName#">,
			<cfqueryparam Value="#Arguments.statusTargetExportTabStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.statusTargetExportTabName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_StatusTarget.statusTargetExportTabName#">,
			<cfqueryparam Value="#Arguments.statusTargetExportHtmlStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.statusTargetExportHtmlName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_StatusTarget.statusTargetExportHtmlName#">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateStatusTarget" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing status target option. Returns True.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="statusTargetExportXmlStatus" Type="numeric" Required="No">
	<cfargument Name="statusTargetExportXmlName" Type="string" Required="No">
	<cfargument Name="statusTargetExportTabStatus" Type="numeric" Required="No">
	<cfargument Name="statusTargetExportTabName" Type="string" Required="No">
	<cfargument Name="statusTargetExportHtmlStatus" Type="numeric" Required="No">
	<cfargument Name="statusTargetExportHtmlName" Type="string" Required="No">

	<cfinvoke component="#Application.billingMapping#data.StatusTarget" method="maxlength_StatusTarget" returnVariable="maxlength_StatusTarget" />

	<cfquery Name="qry_updateStatusTarget" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avStatusTarget
		SET
			<cfif StructKeyExists(Arguments, "statusTargetExportXmlStatus") and ListFind("0,1", Arguments.statusTargetExportXmlStatus)>statusTargetExportXmlStatus = <cfqueryparam Value="#Arguments.statusTargetExportXmlStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "statusTargetExportXmlName")>statusTargetExportXmlName = <cfqueryparam Value="#Arguments.statusTargetExportXmlName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_StatusTarget.statusTargetExportXmlName#">,</cfif>
			<cfif StructKeyExists(Arguments, "statusTargetExportTabStatus") and ListFind("0,1", Arguments.statusTargetExportTabStatus)>statusTargetExportTabStatus = <cfqueryparam Value="#Arguments.statusTargetExportTabStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "statusTargetExportTabName")>statusTargetExportTabName = <cfqueryparam Value="#Arguments.statusTargetExportTabName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_StatusTarget.statusTargetExportTabName#">,</cfif>
			<cfif StructKeyExists(Arguments, "statusTargetExportHtmlStatus") and ListFind("0,1", Arguments.statusTargetExportHtmlStatus)>statusTargetExportHtmlStatus = <cfqueryparam Value="#Arguments.statusTargetExportHtmlStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "statusTargetExportHtmlName")>statusTargetExportHtmlName = <cfqueryparam Value="#Arguments.statusTargetExportHtmlName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_StatusTarget.statusTargetExportHtmlName#">,</cfif>
			<cfif StructKeyExists(Arguments, "") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			statusTargetDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectStatusTarget" Access="public" Output="No" ReturnType="query" Hint="Select existing status target option.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">

	<cfset var qry_selectStatusTarget = QueryNew("blank")>

	<cfquery Name="qry_selectStatusTarget" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT statusTargetExportXmlStatus, statusTargetExportXmlName, statusTargetExportTabStatus, statusTargetExportTabName,
			statusTargetExportHtmlStatus, statusTargetExportHtmlName, userID, statusTargetDateCreated, statusTargetDateUpdated
		FROM avStatusTarget
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectStatusTarget>
</cffunction>

<cffunction Name="selectStatusTargetList" Access="public" Output="No" ReturnType="query" Hint="Select existing status target options.">
	<cfargument Name="companyID" Type="numeric" Required="No">
	<cfargument Name="primaryTargetID" Type="numeric" Required="No">
	<cfargument Name="statusTargetExportXmlStatus" Type="numeric" Required="No">
	<cfargument Name="statusTargetExportTabStatus" Type="numeric" Required="No">
	<cfargument Name="statusTargetExportHtmlStatus" Type="numeric" Required="No">

	<cfset var qry_selectStatusTargetList = QueryNew("blank")>

	<cfquery Name="qry_selectStatusTargetList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT companyID, primaryTargetID, userID, statusTargetExportXmlStatus, statusTargetExportXmlName,
			statusTargetExportTabStatus, statusTargetExportTabName, statusTargetExportHtmlStatus, statusTargetExportHtmlName,
			statusTargetDateCreated, statusTargetDateUpdated
		FROM avStatusTarget
		WHERE companyID > 0
			<cfloop Index="field" List="companyID,primaryTargetID">
				<cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])>
					AND #field# IN (<cfqueryparam Value="#Arguments[field]#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				</cfif>
			</cfloop>
			<cfloop Index="field" List="statusTargetExportXmlStatus,statusTargetExportTabStatus,statusTargetExportHtmlStatus">
				<cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])>
					AND #field# = <cfqueryparam Value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				</cfif>
			</cfloop>
		ORDER BY companyID
	</cfquery>

	<cfreturn qry_selectStatusTargetList>
</cffunction>

</cfcomponent>
