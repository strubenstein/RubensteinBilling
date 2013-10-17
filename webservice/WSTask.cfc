<cfcomponent DisplayName="WSTask" Hint="Manages all task web services">

<cffunction Name="insertTask" Access="remote" Output="No" ReturnType="numeric" Hint="Inserts task. Returns taskID.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="userID_agent" Type="numeric">
	<cfargument Name="userID_agent_custom" Type="string">
	<cfargument Name="userID_target" Type="numeric">
	<cfargument Name="userID_target_custom" Type="string">
	<cfargument Name="companyID_target" Type="numeric">
	<cfargument Name="companyID_target_custom" Type="string">
	<cfargument Name="primaryTargetKey" Type="string">
	<cfargument Name="targetID" Type="numeric">
	<cfargument Name="targetID_custom" Type="string">
	<cfargument Name="taskStatus" Type="boolean">
	<cfargument Name="taskCompleted" Type="boolean">
	<cfargument Name="taskMessage" Type="string">
	<cfargument Name="taskDateScheduled" Type="date">

	<cfset var returnValue = -1>
	<cfset var returnError = "">
	<cfset var companyID_agent = 0>
	<cfset var primaryTargetID = 0>
	<cfset var targetUseCustomIDFieldList = "">
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>
	<cfset var dateBeginResponse = "">
	<cfset var insertUpdateTaskForOthers = False>
	<cfset var qry_selectUserCompanyList_company = QueryNew("userID")>
	<cfset var wsSessionUserID = 0>

	<cfinclude template="ws_task/ws_insertTask.cfm">
	<cfreturn returnValue>
</cffunction>

</cfcomponent>
