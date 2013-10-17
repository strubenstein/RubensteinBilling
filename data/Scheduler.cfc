<cfcomponent DisplayName="Scheduler" Hint="Manages inserting, updating, and viewing scheduled tasks.">

<cffunction name="maxlength_Scheduler" access="public" output="no" returnType="struct">
	<cfset var maxlength_Scheduler = StructNew()>

	<cfset maxlength_Scheduler.schedulerName = 150>
	<cfset maxlength_Scheduler.schedulerDescription = 255>
	<cfset maxlength_Scheduler.schedulerURL = 255>
	<cfset maxlength_Scheduler.schedulerInterval = 10>

	<cfreturn maxlength_Scheduler>
</cffunction>

<cffunction Name="insertScheduler" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new scheduled task. Returns schedulerID.">
	<cfargument Name="companyID" Type="numeric" Required="No" Default="0">
	<cfargument Name="userID" Type="numeric" Required="No" Default="0">
	<cfargument Name="schedulerStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="schedulerName" Type="string" Required="Yes">
	<cfargument Name="schedulerDescription" Type="string" Required="Yes">
	<cfargument Name="schedulerURL" Type="string" Required="Yes">
	<cfargument Name="schedulerDateBegin" Type="string" Required="No" Default="">
	<cfargument Name="schedulerDateEnd" Type="string" Required="No" Default="">
	<cfargument Name="schedulerInterval" Type="string" Required="No" Default="daily">
	<cfargument Name="schedulerRequestTimeOut" Type="numeric" Required="No" Default="0">

	<cfset var qry_insertScheduler = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.Scheduler" method="maxlength_Scheduler" returnVariable="maxlength_Scheduler" />

	<cfquery Name="qry_insertScheduler" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avScheduler
		(
			companyID, userID, schedulerStatus, schedulerName, schedulerDescription, schedulerURL, schedulerDateBegin,
			schedulerDateEnd, schedulerInterval, schedulerRequestTimeOut, schedulerDateCreated, schedulerDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.schedulerStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.schedulerName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Scheduler.schedulerName#">,
			<cfqueryparam Value="#Arguments.schedulerDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Scheduler.schedulerDescription#">,
			<cfqueryparam Value="#Arguments.schedulerURL#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Scheduler.schedulerURL#">,
			<cfif Not IsDate(Arguments.schedulerDateBegin)>NULL<cfelse><cfqueryparam Value="#Arguments.schedulerDateBegin#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfif Not IsDate(Arguments.schedulerDateEnd)>NULL<cfelse><cfqueryparam Value="#Arguments.schedulerDateEnd#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfqueryparam Value="#Arguments.schedulerInterval#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Scheduler.schedulerInterval#">,
			<cfqueryparam Value="#Arguments.schedulerRequestTimeOut#" cfsqltype="cf_sql_smallint">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "schedulerID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertScheduler.primaryKeyID>
</cffunction>

<cffunction Name="updateScheduler" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing scheduled task. Returns True.">
	<cfargument Name="schedulerID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="schedulerStatus" Type="numeric" Required="No">
	<cfargument Name="schedulerName" Type="string" Required="No">
	<cfargument Name="schedulerDescription" Type="string" Required="No">
	<cfargument Name="schedulerURL" Type="string" Required="No">
	<cfargument Name="schedulerDateBegin" Type="string" Required="No">
	<cfargument Name="schedulerDateEnd" Type="string" Required="No">
	<cfargument Name="schedulerInterval" Type="string" Required="No">
	<cfargument Name="schedulerRequestTimeOut" Type="numeric" Required="No">

	<cfinvoke component="#Application.billingMapping#data.Scheduler" method="maxlength_Scheduler" returnVariable="maxlength_Scheduler" />

	<cfquery Name="qry_updateScheduler" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avScheduler
		SET
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "schedulerStatus") and ListFind("0,1", Arguments.schedulerStatus)>schedulerStatus = <cfqueryparam Value="#Arguments.schedulerStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "schedulerName")>schedulerName = <cfqueryparam Value="#Arguments.schedulerName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Scheduler.schedulerName#">,</cfif>
			<cfif StructKeyExists(Arguments, "schedulerDescription")>schedulerDescription = <cfqueryparam Value="#Arguments.schedulerDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Scheduler.schedulerDescription#">,</cfif>
			<cfif StructKeyExists(Arguments, "schedulerURL")>schedulerURL = <cfqueryparam Value="#Arguments.schedulerURL#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Scheduler.schedulerURL#">,</cfif>
			<cfif StructKeyExists(Arguments, "schedulerDateBegin")>
				<cfif Arguments.schedulerDateBegin is "">schedulerDateBegin = NULL,<cfelseif IsDate(Arguments.schedulerDateBegin)>schedulerDateBegin = <cfqueryparam Value="#Arguments.schedulerDateBegin#" cfsqltype="cf_sql_timestamp">,</cfif>
			</cfif>
			<cfif StructKeyExists(Arguments, "schedulerDateEnd")>
				<cfif Arguments.schedulerDateEnd is "">schedulerDateEnd = NULL,<cfelseif IsDate(Arguments.schedulerDateEnd)>schedulerDateEnd = <cfqueryparam Value="#Arguments.schedulerDateEnd#" cfsqltype="cf_sql_timestamp">,</cfif>
			</cfif>
			<cfif StructKeyExists(Arguments, "schedulerInterval")>schedulerInterval = <cfqueryparam Value="#Arguments.schedulerInterval#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Scheduler.schedulerInterval#">,</cfif>
			<cfif StructKeyExists(Arguments, "schedulerRequestTimeOut") and Application.fn_IsIntegerNonNegative(Arguments.schedulerRequestTimeOut)>schedulerRequestTimeOut = <cfqueryparam Value="#Arguments.schedulerRequestTimeOut#" cfsqltype="cf_sql_smallint">,</cfif>
			schedulerDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE schedulerID = <cfqueryparam Value="#Arguments.schedulerID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="checkSchedulerNameIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Check scheduled task name is unique">
	<cfargument Name="schedulerName" Type="string" Required="Yes">
	<cfargument Name="schedulerID" Type="numeric" Required="No">

	<cfset var qry_checkSchedulerNameIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkSchedulerNameIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT schedulerID
		FROM avScheduler
		WHERE schedulerName = <cfqueryparam Value="#Arguments.schedulerName#" cfsqltype="cf_sql_varchar">
			<cfif StructKeyExists(Arguments, "schedulerID") and Application.fn_IsIntegerNonNegative(Arguments.schedulerID)>
				AND schedulerID <> <cfqueryparam Value="#Arguments.schedulerID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkSchedulerNameIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="selectScheduler" Access="public" Output="No" ReturnType="query" Hint="Select existing scheduled task">
	<cfargument Name="schedulerID" Type="numeric" Required="Yes">

	<cfset var qry_selectScheduler = QueryNew("blank")>

	<cfquery Name="qry_selectScheduler" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT companyID, userID, schedulerStatus, schedulerName, schedulerDescription, schedulerURL,
			schedulerDateBegin, schedulerDateEnd, schedulerInterval, schedulerRequestTimeOut,
			schedulerDateCreated, schedulerDateUpdated
		FROM avScheduler
		WHERE schedulerID = <cfqueryparam Value="#Arguments.schedulerID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectScheduler>
</cffunction>

<cffunction Name="selectSchedulerList" Access="public" Output="No" ReturnType="query" Hint="Select existing scheduled tasks">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="schedulerStatus" Type="numeric" Required="No">
	<cfargument Name="schedulerID" Type="string" Required="No">

	<cfset var qry_selectSchedulerList = QueryNew("blank")>

	<cfquery Name="qry_selectSchedulerList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avScheduler.schedulerID, avScheduler.companyID, avScheduler.userID, avScheduler.schedulerStatus,
			avScheduler.schedulerName, avScheduler.schedulerDescription, avScheduler.schedulerURL,
			avScheduler.schedulerDateBegin, avScheduler.schedulerDateEnd, avScheduler.schedulerInterval,
			avScheduler.schedulerRequestTimeOut, avScheduler.schedulerDateCreated, avScheduler.schedulerDateUpdated,
			avCompany.companyName, avCompany.companyID_custom,
			avUser.firstName, avUser.lastName, avUser.userID_custom
		FROM avScheduler
			LEFT OUTER JOIN avCompany ON avScheduler.companyID = avCompany.companyID
			LEFT OUTER JOIN avUser ON avScheduler.userID = avUser.userID
		WHERE avScheduler.schedulerID > <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "companyID") and Application.fn_IsIntegerList(Arguments.companyID)>
				AND avScheduler.companyID IN (<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
			<cfif StructKeyExists(Arguments, "schedulerID") and Application.fn_IsIntegerList(Arguments.schedulerID)>
				AND avScheduler.schedulerID IN (<cfqueryparam Value="#Arguments.schedulerID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
			<cfif StructKeyExists(Arguments, "schedulerStatus") and ListFind("0,1", Arguments.schedulerStatus)>
				AND avScheduler.schedulerStatus = <cfqueryparam Value="#Arguments.schedulerStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
		ORDER BY avCompany.companyName, avScheduler.schedulerName
	</cfquery>

	<cfreturn qry_selectSchedulerList>
</cffunction>

</cfcomponent>
