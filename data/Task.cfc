<cfcomponent DisplayName="Task" Hint="Manages creating, viewing and updating tasks (to-do items)">

<cffunction name="maxlength_Task" access="public" output="no" returnType="struct">
	<cfset var maxlength_Task = StructNew()>

	<cfset maxlength_Task.taskMessage = 500>

	<cfreturn maxlength_Task>
</cffunction>

<cffunction Name="insertTask" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new task into database and returns taskID">
	<cfargument Name="userID_author" Type="numeric" Required="Yes">
	<cfargument Name="userID_agent" Type="numeric" Required="Yes">
	<cfargument Name="companyID_agent" Type="numeric" Required="Yes">
	<cfargument Name="userID_target" Type="numeric" Required="Yes">
	<cfargument Name="companyID_target" Type="numeric" Required="Yes">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="targetID" Type="numeric" Required="Yes">
	<cfargument Name="taskStatus" Type="numeric" Required="Yes">
	<cfargument Name="taskCompleted" Type="numeric" Required="Yes">
	<cfargument Name="taskMessage" Type="string" Required="Yes">
	<cfargument Name="taskDateScheduled" Type="date" Required="Yes">

	<cfset var qry_insertTask = QueryNew("blank")>

	<cfquery Name="qry_insertTask" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avTask
		(
			userID_author, userID_agent, companyID_agent, userID_target, companyID_target,
			primaryTargetID, targetID, taskStatus, taskCompleted, taskMessage,
			taskDateScheduled, taskDateCreated, taskDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID_agent#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.companyID_agent#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID_target#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.companyID_target#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.taskStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.taskCompleted#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.taskMessage#" cfsqltype="cf_sql_longvarchar">,
			<cfqueryparam Value="#Arguments.taskDateScheduled#" cfsqltype="cf_sql_timestamp">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "taskID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertTask.primaryKeyID>
</cffunction>

<cffunction Name="updateTask" Access="public" Output="No" ReturnType="boolean" Hint="Update existing task">
	<cfargument Name="taskID" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="numeric" Required="No">
	<cfargument Name="userID_agent" Type="numeric" Required="No">
	<cfargument Name="primaryTargetID" Type="numeric" Required="No">
	<cfargument Name="targetID" Type="numeric" Required="No">
	<cfargument Name="taskStatus" Type="numeric" Required="No">
	<cfargument Name="taskCompleted" Type="numeric" Required="No">
	<cfargument Name="taskMessage" Type="string" Required="No">
	<cfargument Name="taskDateScheduled" Type="date" Required="No">

	<cfquery Name="qry_updateTask" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avTask
		SET
			<cfif StructKeyExists(Arguments, "userID_author") and Application.fn_IsIntegerNonNegative(Arguments.userID_author)>
				userID_author = <cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,
			</cfif>
			<cfif StructKeyExists(Arguments, "userID_agent") and Application.fn_IsIntegerNonNegative(Arguments.userID_agent)>
				userID_agent = <cfqueryparam Value="#Arguments.userID_agent#" cfsqltype="cf_sql_integer">,
			</cfif>
			<cfif StructKeyExists(Arguments, "primaryTargetID") and Application.fn_IsIntegerNonNegative(Arguments.primaryTargetID)>
				primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">,
			</cfif>
			<cfif StructKeyExists(Arguments, "targetID") and Application.fn_IsIntegerNonNegative(Arguments.targetID)>
				targetID = <cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">,
			</cfif>
			<cfif StructKeyExists(Arguments, "taskStatus") and ListFind("0,1", Arguments.taskStatus)>
				taskStatus = <cfqueryparam Value="#Arguments.taskStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			</cfif>
			<cfif StructKeyExists(Arguments, "taskCompleted") and ListFind("0,1", Arguments.taskCompleted)>
				taskCompleted = <cfqueryparam Value="#Arguments.taskCompleted#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			</cfif>
			<cfif StructKeyExists(Arguments, "taskMessage")>
				taskMessage = <cfqueryparam Value="#Arguments.taskMessage#" cfsqltype="cf_sql_longvarchar">,
			</cfif>
			<cfif StructKeyExists(Arguments, "taskDateScheduled") and IsDate(Arguments.taskDateScheduled)>
				taskDateScheduled = <cfqueryparam Value="#Arguments.taskDateScheduled#" cfsqltype="cf_sql_timestamp">,
			</cfif>
			taskDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE taskID = <cfqueryparam Value="#Arguments.taskID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectTask" Access="public" Output="No" ReturnType="query" Hint="Selects existing task">
	<cfargument Name="taskID" Type="numeric" Required="Yes">

	<cfset var qry_selectTask = QueryNew("blank")>

	<cfquery Name="qry_selectTask" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT userID_author, userID_agent, companyID_agent,
			userID_target, companyID_target, primaryTargetID, targetID,
			taskStatus, taskCompleted, taskMessage, taskDateScheduled,
			taskDateCreated, taskDateUpdated
		FROM avTask
		WHERE taskID = <cfqueryparam Value="#Arguments.taskID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectTask>
</cffunction>

<cffunction Name="checkTaskPermission" Access="public" Output="No" ReturnType="boolean" Hint="Validate user has permission for task">
	<cfargument Name="taskID" Type="numeric" Required="Yes">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="targetID" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="numeric" Required="No">
	<cfargument Name="userID_agent" Type="numeric" Required="No">
	<cfargument Name="companyID_agent" Type="numeric" Required="No">
	<cfargument Name="userID_target" Type="numeric" Required="No">
	<cfargument Name="companyID_target" Type="numeric" Required="No">

	<cfset var qry_checkTaskPermission = QueryNew("blank")>

	<cfquery Name="qry_checkTaskPermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT userID_author, userID_target, companyID_target
		FROM avTask
		WHERE taskID = <cfqueryparam Value="#Arguments.taskID#" cfsqltype="cf_sql_integer">
			AND primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
			AND targetID = <cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfif qry_checkTaskPermission.RecordCount is 0>
		<cfreturn False>
	<cfelse>
		<cfreturn True>
	</cfif>
</cffunction>

<cffunction Name="deleteTask" Access="public" Output="No" ReturnType="boolean" Hint="Delete existing task">
	<cfargument Name="taskID" Type="numeric" Required="Yes">

	<cfquery Name="qry_deleteTask" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		DELETE FROM avTask
		WHERE taskID = <cfqueryparam Value="#Arguments.taskID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectTaskList" Access="public" ReturnType="query" Hint="Select list of tasks">
	<cfargument Name="companyID_agent" Type="string" Required="Yes">
	<cfargument Name="userID_author" Type="string" Required="No">
	<cfargument Name="userID_agent" Type="string" Required="No">
	<cfargument Name="userID_target" Type="string" Required="No">
	<cfargument Name="companyID_target" Type="string" Required="No">
	<cfargument Name="taskDateScheduledIsNull" Type="boolean" Required="No">
	<cfargument Name="taskDateScheduled_from" Type="date" Required="No">
	<cfargument Name="taskDateScheduled_to" Type="date" Required="No">
	<cfargument Name="taskDateCreated_from" Type="date" Required="No">
	<cfargument Name="taskDateCreated_to" Type="date" Required="No">
	<cfargument Name="taskDateUpdated_from" Type="date" Required="No">
	<cfargument Name="taskDateUpdated_to" Type="date" Required="No">
	<cfargument Name="taskStatus" Type="numeric" Required="No">
	<cfargument Name="taskCompleted" Type="string" Required="No">
	<cfargument Name="primaryTargetID" Type="string" Required="No">
	<cfargument Name="targetID" Type="string" Required="No">
	<cfargument Name="taskMessage" Type="string" Required="no">
	<cfargument Name="taskDate_from" Type="date" Required="no">
	<cfargument Name="taskDate_to" Type="date" Required="no">
	<cfargument Name="userID_agentIsNull" Type="boolean" Required="no">
	<cfargument Name="queryOrderBy" Type="string" Required="No" Default="">
	<cfargument Name="queryDisplayPerPage" Type="numeric" Required="No" Default="0">
	<cfargument Name="queryPage" Type="numeric" Required="No" Default="1">

	<cfset var qry_selectTaskList = QueryNew("blank")>
	<cfset var queryParameters_orderBy = "">
	<cfset var queryParameters_orderBy_noTable = "">

	<cfswitch expression="#Arguments.queryOrderBy#">
	<cfcase value="taskDateScheduled,taskDateUpdated"><cfset queryParameters_orderBy = "avTask.#Arguments.queryOrderBy#"></cfcase>
	<cfcase value="taskDateScheduled_d,taskDateUpdated_d"><cfset queryParameters_orderBy = "avTask.#ListFirst(Arguments.queryOrderBy, '_')# DESC"></cfcase>
	<cfcase value="taskID,taskDateCreated"><cfset queryParameters_orderBy = "avTask.taskID"></cfcase>
	<cfcase value="taskID_d,taskDateCreated_d"><cfset queryParameters_orderBy = "avTask.taskID DESC"></cfcase>
	<cfcase value="taskCompleted"><cfset queryParameters_orderBy = "avTask.taskCompleted, avTask.taskDateScheduled DESC"></cfcase>
	<cfcase value="taskCompleted_d"><cfset queryParameters_orderBy = "avTask.taskCompleted DESC, avTask.taskDateScheduled DESC"></cfcase>
	<cfcase value="authorLastName"><cfset queryParameters_orderBy = "AuthorUser.lastName, AuthorUser.firstName"><cfset queryParameters_orderBy_noTable = "AuthorUser.authorLastName, AuthorUser.authorFirstName"></cfcase>
	<cfcase value="authorLastName_d"><cfset queryParameters_orderBy = "AuthorUser.lastName DESC, AuthorUser.firstName DESC"><cfset queryParameters_orderBy_noTable = "AuthorUser.authorLastName DESC, AuthorUser.authorFirstName DESC"></cfcase>
	<cfcase value="agentLastName"><cfset queryParameters_orderBy = "AgentUser.lastName, AgentUser.firstName"><cfset queryParameters_orderBy_noTable = "AgentUser.agentLastName, AgentUser.agentFirstName"></cfcase>
	<cfcase value="agentLastName_d"><cfset queryParameters_orderBy = "AgentUser.lastName DESC, AgentUser.firstName DESC"><cfset queryParameters_orderBy_noTable = "AgentUser.agentLastName DESC, AgentUser.agentFirstName DESC"></cfcase>
	<cfcase value="targetLastName"><cfset queryParameters_orderBy = "TargetUser.lastName, TargetUser.firstName"><cfset queryParameters_orderBy_noTable = "TargetUser.targetLastName, TargetUser.targetFirstName"></cfcase>
	<cfcase value="targetLastName_d"><cfset queryParameters_orderBy = "TargetUser.lastName DESC, TargetUser.firstName DESC"><cfset queryParameters_orderBy_noTable = "TargetUser.targetLastName DESC, TargetUser.targetFirstName DESC"></cfcase>
	<cfcase value="targetCompanyName"><cfset queryParameters_orderBy = "TargetCompany.companyName, TargetUser.lastName, TargetUser.firstName"><cfset queryParameters_orderBy_noTable = "TargetCompany.targetCompanyName, TargetUser.targetLastName, TargetUser.targetFirstName"></cfcase>
	<cfcase value="targetCompanyName_d"><cfset queryParameters_orderBy = "TargetCompany.companyName DESC, TargetUser.lastName DESC, TargetUser.firstName DESC"><cfset queryParameters_orderBy_noTable = "TargetCompany.targetCompanyName DESC, TargetUser.targetLastName DESC, TargetUser.targetFirstName DESC"></cfcase>
	<cfdefaultcase><cfset queryParameters_orderBy = "avTask.taskDateScheduled DESC"></cfdefaultcase>
	</cfswitch>

	<cfif queryParameters_orderBy_noTable is "">
		<cfset queryParameters_orderBy_noTable = queryParameters_orderBy>
	</cfif>
	<cfloop index="table" list="avTask,AuthorUser,AgentUser,TargetUser,TargetCompany">
		<cfset queryParameters_orderBy_noTable = Replace(queryParameters_orderBy_noTable, "#table#.", "", "ALL")>
	</cfloop>

	<cfquery Name="qry_selectTaskList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT
			<cfif Application.billingDatabase is "MSSQLServer">
				* FROM (SELECT row_number() OVER (ORDER BY #queryParameters_orderBy#) as rowNumber,
			</cfif>
			avTask.taskID, avTask.userID_author, avTask.userID_agent, avTask.companyID_agent, avTask.userID_target, avTask.companyID_target,
			avTask.primaryTargetID, avTask.targetID, avTask.taskStatus, avTask.taskCompleted, avTask.taskMessage, avTask.taskDateScheduled,
			avTask.taskDateCreated, avTask.taskDateUpdated,
			AuthorUser.firstName AS authorFirstName, AuthorUser.lastName AS authorLastName, AuthorUser.userID_custom AS authorUserID_custom,
			AgentUser.firstName AS agentFirstName, AgentUser.lastName AS agentLastName, AgentUser.userID_custom AS agentUserID_custom,
			TargetUser.firstName AS targetFirstName, TargetUser.lastName AS targetLastName, TargetUser.userID_custom AS targetUserID_custom,
			TargetCompany.companyName AS targetCompanyName, TargetCompany.companyID_custom AS targetCompanyID_custom
		FROM avTask
			LEFT OUTER JOIN avUser AS AuthorUser ON avTask.userID_author = AuthorUser.userID
			LEFT OUTER JOIN avUser AS AgentUser ON avTask.userID_agent = AgentUser.userID
			LEFT OUTER JOIN avUser AS TargetUser ON avTask.userID_target = TargetUser.userID
			LEFT OUTER JOIN avCompany AS TargetCompany ON avTask.companyID_target = TargetCompany.companyID
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectTaskList.cfm">
		<cfif Application.billingDatabase is "MSSQLServer">
			) AS T
			<cfif Arguments.queryDisplayPerPage gt 0>WHERE rowNumber BETWEEN #IncrementValue(Arguments.queryDisplayPerPage * DecrementValue(Arguments.queryPage))# AND #Val(Arguments.queryDisplayPerPage * Arguments.queryPage)#</cfif>
			ORDER BY #queryParameters_orderBy_noTable#
		<cfelseif Arguments.queryDisplayPerPage gt 0 and Application.billingDatabase is "MySQL">
			ORDER BY #queryParameters_orderBy#
			LIMIT #DecrementValue(Arguments.queryPage) * Arguments.queryDisplayPerPage#, #Arguments.queryDisplayPerPage#
		</cfif>
	</cfquery>

	<cfreturn qry_selectTaskList>
</cffunction>

<cffunction Name="selectTaskCount" Access="public" ReturnType="numeric" Hint="Select total number of tasks in list">
	<cfargument Name="companyID_agent" Type="string" Required="Yes">
	<cfargument Name="userID_author" Type="string" Required="No">
	<cfargument Name="userID_agent" Type="string" Required="No">
	<cfargument Name="userID_target" Type="string" Required="No">
	<cfargument Name="companyID_target" Type="string" Required="No">
	<cfargument Name="taskDateScheduledIsNull" Type="boolean" Required="No">
	<cfargument Name="taskDateScheduled_from" Type="date" Required="No">
	<cfargument Name="taskDateScheduled_to" Type="date" Required="No">
	<cfargument Name="taskDateCreated_from" Type="date" Required="No">
	<cfargument Name="taskDateCreated_to" Type="date" Required="No">
	<cfargument Name="taskDateUpdated_from" Type="date" Required="No">
	<cfargument Name="taskDateUpdated_to" Type="date" Required="No">
	<cfargument Name="taskStatus" Type="numeric" Required="No">
	<cfargument Name="taskCompleted" Type="string" Required="No">
	<cfargument Name="primaryTargetID" Type="string" Required="No">
	<cfargument Name="targetID" Type="string" Required="No">
	<cfargument Name="taskMessage" Type="string" Required="no">
	<cfargument Name="taskDate_from" Type="date" Required="no">
	<cfargument Name="taskDate_to" Type="date" Required="no">
	<cfargument Name="userID_agentIsNull" Type="boolean" Required="no">

	<cfset var qry_selectTaskCount = QueryNew("blank")>

	<cfquery Name="qry_selectTaskCount" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT Count(taskID) AS totalRecords
		FROM avTask
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectTaskList.cfm">
	</cfquery>

	<cfreturn qry_selectTaskCount.totalRecords>
</cffunction>

</cfcomponent>

