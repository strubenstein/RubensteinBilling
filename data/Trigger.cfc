<cfcomponent DisplayName="Trigger" Hint="Manages inserting, updating and viewing triggers">

<cffunction name="maxlength_Trigger" access="public" output="no" returnType="struct">
	<cfset var maxlength_Trigger = StructNew()>

	<cfset maxlength_Trigger.triggerAction = 50>
	<cfset maxlength_Trigger.triggerFilename = 50>
	<cfset maxlength_Trigger.triggerDescription = 255>

	<cfreturn maxlength_Trigger>
</cffunction>

<!--- Trigger --->
<cffunction Name="insertTrigger" Access="public" Output="No" ReturnType="boolean" Hint="Inserts new trigger. Returns True.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="triggerStatus" Type="numeric" Required="No" Default="0">
	<cfargument Name="triggerAction" Type="string" Required="Yes">
	<cfargument Name="triggerFilename" Type="string" Required="Yes">
	<cfargument Name="triggerDescription" Type="string" Required="No" Default="">
	<cfargument Name="triggerDateBegin" Type="string" Required="No" Default="">
	<cfargument Name="triggerDateEnd" Type="string" Required="No" Default="">

	<cfinvoke component="#Application.billingMapping#data.Trigger" method="maxlength_Trigger" returnVariable="maxlength_Trigger" />

	<cfquery Name="qry_insertTrigger" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avTrigger
		(
			companyID, userID, triggerStatus, triggerAction, triggerFilename, triggerDescription,
			triggerDateBegin, triggerDateEnd, triggerDateCreated, triggerDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.triggerStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.triggerAction#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Trigger.triggerAction#">,
			<cfqueryparam Value="#Arguments.triggerFilename#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Trigger.triggerFilename#">,
			<cfqueryparam Value="#Arguments.triggerDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Trigger.triggerDescription#">,
			<cfif Not IsDate(Arguments.triggerDateBegin)>#Application.billingSql.sql_nowDateTime#<cfelse><cfqueryparam Value="#CreateODBCDateTime(Arguments.triggerDateBegin)#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfif Not IsDate(Arguments.triggerDateEnd)>NULL<cfelse><cfqueryparam Value="#CreateODBCDateTime(Arguments.triggerDateEnd)#" cfsqltype="cf_sql_timestamp"></cfif>,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateTrigger" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing trigger. Returns True.">
	<cfargument Name="triggerID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="triggerStatus" Type="numeric" Required="No">
	<cfargument Name="triggerFilename" Type="string" Required="No">
	<cfargument Name="triggerDescription" Type="string" Required="No" Default="">
	<cfargument Name="triggerDateBegin" Type="string" Required="No">
	<cfargument Name="triggerDateEnd" Type="string" Required="No">

	<cfinvoke component="#Application.billingMapping#data.Trigger" method="maxlength_Trigger" returnVariable="maxlength_Trigger" />

	<cfquery Name="qry_updateTrigger" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avTrigger
		SET
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "triggerStatus") and ListFind("0,1", Arguments.triggerStatus)>triggerStatus = <cfqueryparam Value="#Arguments.triggerStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "triggerFilename")>triggerFilename = <cfqueryparam Value="#Arguments.triggerFilename#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Trigger.triggerFilename#">,</cfif>
			<cfif StructKeyExists(Arguments, "triggerDescription")>triggerDescription = <cfqueryparam Value="#Arguments.triggerDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Trigger.triggerDescription#">,</cfif>
			<cfif StructKeyExists(Arguments, "triggerDateBegin") and IsDate(Arguments.triggerDateBegin)>triggerDateBegin = <cfqueryparam Value="#CreateODBCDateTime(Arguments.triggerDateBegin)#" cfsqltype="cf_sql_timestamp">,</cfif>
			<cfif StructKeyExists(Arguments, "triggerDateEnd") and (Arguments.triggerDateEnd is "" or IsDate(Arguments.triggerDateEnd))>triggerDateEnd = <cfif Not IsDate(Arguments.triggerDateEnd)>NULL<cfelse><cfqueryparam Value="#CreateODBCDateTime(Arguments.triggerDateEnd)#" cfsqltype="cf_sql_timestamp"></cfif>,</cfif>
			triggerDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE triggerID = <cfqueryparam Value="#Arguments.triggerID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="checkTriggerIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Check that trigger is unique for company/action">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="triggerAction" Type="string" Required="Yes">

	<cfset var qry_checkTriggerIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkTriggerIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT triggerID
		FROM avTrigger
		WHERE triggerAction = <cfqueryparam Value="#Arguments.triggerAction#" CFSQLType="cf_sql_varchar">
			AND companyID <> <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfif qry_checkTriggerIsUnique.RecordCount is not 0>
		<cfreturn False>
	<cfelse>
		<cfreturn True>
	</cfif>
</cffunction>

<cffunction Name="selectTrigger" Access="public" Output="No" ReturnType="query" Hint="Selects existing trigger">
	<cfargument Name="triggerID" Type="numeric" Required="Yes">

	<cfset var qry_selectTrigger = QueryNew("blank")>

	<cfquery Name="qry_selectTrigger" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT companyID, triggerStatus, triggerAction, triggerFilename, triggerDescription,
			userID, triggerDateBegin, triggerDateEnd, triggerDateCreated, triggerDateUpdated
		FROM avTrigger
		WHERE triggerID = <cfqueryparam Value="#Arguments.triggerID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectTrigger>
</cffunction>

<cffunction Name="selectTriggerList" Access="public" Output="No" ReturnType="query" Hint="Selects list of existing triggers">
	<cfargument Name="triggerAction" Type="string" Required="No">
	<cfargument Name="companyID" Type="numeric" Required="No">
	<cfargument Name="triggerActionStatus" Type="numeric" Required="No">
	<cfargument Name="triggerActionSuperuserOnly" Type="numeric" Required="No">
	<cfargument Name="triggerIsActive" Type="boolean" Required="No" Default="False">

	<cfset var qry_selectTriggerList = QueryNew("blank")>

	<cfquery Name="qry_selectTriggerList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT triggerID, companyID, userID, triggerStatus, triggerAction, triggerFilename,
			triggerDescription, triggerDateBegin, triggerDateEnd, triggerDateCreated, triggerDateUpdated
		FROM avTrigger
		WHERE triggerID > <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "triggerStatus") and ListFind("0,1", Arguments.triggerStatus)>
				AND triggerStatus = <cfqueryparam Value="#Arguments.triggerStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<cfif StructKeyExists(Arguments, "triggerAction") and Trim(Arguments.triggerAction) is not "">
				AND triggerAction IN (<cfqueryparam Value="#Arguments.triggerAction#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)
			</cfif>
			<cfif StructKeyExists(Arguments, "companyID") and Application.fn_IsIntegerList(Arguments.companyID)>
				AND companyID IN (<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
			<cfif StructKeyExists(Arguments, "triggerIsActive") and Arguments.triggerIsActive is True>
				AND triggerDateBegin <= <cfqueryparam Value="#CreateODBCDateTime(Now())#" cfsqltype="cf_sql_timestamp">
				AND (triggerDateEnd IS NULL OR triggerDateEnd >= <cfqueryparam Value="#CreateODBCDateTime(Now())#" cfsqltype="cf_sql_timestamp">)
			</cfif>
		ORDER BY companyID, triggerAction
	</cfquery>

	<cfreturn qry_selectTriggerList>
</cffunction>

</cfcomponent>
