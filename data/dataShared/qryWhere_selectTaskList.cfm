<cfoutput>
avTask.companyID_agent IN (<cfqueryparam value="#Arguments.companyID_agent#" cfsqltype="cf_sql_integer" list="yes">)
<cfloop index="field" list="taskID,userID_author,userID_target,companyID_target,primaryTargetID,targetID">
	<cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])> AND avTask.#field# IN (<cfqueryparam value="#Arguments[field]#" cfsqltype="cf_sql_integer" list="yes">) </cfif>
</cfloop>
<cfloop index="field" list="taskStatus">
	<cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])> AND avTask.#field# = <cfqueryparam value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#"> </cfif>
</cfloop>
<cfloop index="field" list="taskCompleted">
	<cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])> AND avTask.#field# IN (<cfqueryparam Value="#Arguments[field]#" cfsqltype="cf_sql_tinyint" list="yes">) </cfif>
</cfloop>
<cfif StructKeyExists(Arguments, "userID_agentIsNull")>AND avTask.userID_agent <cfif Arguments.userID_agentIsNull is True> = 0 <cfelse> <> 0 </cfif> </cfif>
<cfloop index="field" list="taskDateScheduled,taskDateCreated,taskDateUpdated,taskDateSort">
	<cfif StructKeyExists(Arguments, "#field#IsNull")>
		AND avTask.#field# <cfif Arguments["#field#IsNull"] is True> IS NULL <cfelse> IS NOT NULL </cfif>
	<cfelseif StructKeyExists(Arguments, "#field#_from") and StructKeyExists(Arguments, "#field#_to")>
		AND avTask.#field# BETWEEN <cfqueryparam value="#Arguments['#field#_from']#" cfsqltype="cf_sql_timestamp"> AND <cfqueryparam value="#Arguments['#field#_to']#" cfsqltype="cf_sql_timestamp">
	<cfelseif StructKeyExists(Arguments, "#field#_from")>
		AND avTask.#field# >= <cfqueryparam value="#Arguments['#field#_from']#" cfsqltype="cf_sql_timestamp">
	<cfelseif StructKeyExists(Arguments, "#field#_to")>
		AND avTask.#field# <= <cfqueryparam value="#Arguments['#field#_to']#" cfsqltype="cf_sql_timestamp">
	</cfif>
</cfloop>
<cfif StructKeyExists(Arguments, "userID_agent") and Application.fn_IsIntegerList(Arguments.userID_agent)>
	AND avTask.userID_agent IN (<cfqueryparam value="#Arguments.userID_agent#" cfsqltype="cf_sql_integer" list="yes">)
</cfif>
<cfif StructKeyExists(Arguments, "taskDate_from") and StructKeyExists(Arguments, "taskDate_to")>
	AND avTask.taskDateScheduled IS NOT NULL
	AND avTask.taskDateScheduled BETWEEN <cfqueryparam value="#Arguments.taskDate_from#" cfsqltype="cf_sql_timestamp"> AND <cfqueryparam value="#Arguments.taskDate_to#" cfsqltype="cf_sql_timestamp">
<cfelseif StructKeyExists(Arguments, "taskDate_from")>
	AND avTask.taskDateScheduled IS NOT NULL
	AND avTask.taskDateScheduled >= <cfqueryparam value="#Arguments.taskDate_from#" cfsqltype="cf_sql_timestamp">
<cfelseif StructKeyExists(Arguments, "taskDate_to")>
	AND avTask.taskDateScheduled IS NOT NULL
	AND avTask.taskDateScheduled <= <cfqueryparam value="#Arguments.taskDate_to#" cfsqltype="cf_sql_timestamp">
</cfif>
</cfoutput>