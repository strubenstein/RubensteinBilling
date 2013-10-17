<cfinclude template="wslang_task.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = -1>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("insertTask", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = -1>
	<cfset returnError = Variables.wslang_task.insertTask>
<cfelse>
	<cfloop Index="field" List="taskStatus,taskCompleted">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfset returnValue = 0>
	<!--- userID_agent: user responsible for completing task --->
	<cfset Arguments.userID_agent = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID_agent, Arguments.userID_agent_custom, Arguments.useCustomIDFieldList)>
	<cfif Arguments.userID_agent is 0>
		<cfset returnValue = -1>
		<cfset returnError = Variables.wslang_task.invalidUser>
	<cfelse>
		<!--- determine companyID_agent via userID_agent --->
		<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectUserAgent">
			<cfinvokeargument Name="userID" Value="#Arguments.userID_agent#">
		</cfinvoke>

		<cfset companyID_agent = qry_selectUserAgent.companyID>
	</cfif>

	<!--- validate target company --->
	<cfif returnValue is 0 and (Arguments.companyID_target is not 0 or ListFind(Arguments.useCustomIDFieldList, "companyID_target") or ListFind(Arguments.useCustomIDFieldList, "companyID_target_custom"))>
		<cfset Arguments.companyID_target = Application.objWebServiceSecurity.ws_checkCompanyPermission(qry_selectWebServiceSession.companyID_author, Arguments.companyID_target, Arguments.companyID_target_custom, Arguments.useCustomIDFieldList)>
		<cfif Arguments.companyID_target is 0>
			<cfset returnValue = -1>
			<cfset returnError = Variables.wslang_task.invalidTargetCompany>
		</cfif>
	</cfif>

	<!--- validate target user --->
	<cfif returnValue is 0 and (Arguments.userID_target is not 0 or ListFind(Arguments.useCustomIDFieldList, "userID_target") or ListFind(Arguments.useCustomIDFieldList, "userID_target_custom"))>
		<cfset Arguments.userID_target = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID_target, Arguments.userID_target_custom, Arguments.useCustomIDFieldList)>

		<!--- ensure userID_target is in companyID_target --->
		<cfif Arguments.userID_target is 0>
			<cfset returnValue = -1>
			<cfset returnError = Variables.wslang_task.invalidTargetUser>
		<cfelse>
			<!--- determine companyID_agent via userID_agent --->
			<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectUserTarget">
				<cfinvokeargument Name="userID" Value="#Arguments.userID_target#">
			</cfinvoke>

			<cfif Arguments.companyID_target is 0>
				<cfset Arguments.companyID_target = qry_selectUserTarget.companyID>
			<cfelseif qry_selectUserTarget.companyID is not Arguments.companyID_target>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_task.invalidTargetCompany>
			</cfif>
		</cfif>
	</cfif>

	<cfif returnValue is 0>
		<!--- validate target type and target --->
		<cfif Trim(Arguments.primaryTargetKey) is not "">
			<cfif Application.fn_GetPrimaryTargetID(Arguments.primaryTargetKey) is 0>
				<cfset primaryTargetID = -1>
			<cfelse>
				<cfinclude template="wsact_validateTaskTarget.cfm">
				<cfif Arguments.targetID is 0>
					<cfset primaryTargetID = -1>
				</cfif>
			</cfif>
		</cfif>

		<cfif primaryTargetID is -1>
			<cfset returnValue = -1>
			<cfset returnError = Variables.wslang_task.invalidTarget>
		</cfif>
	</cfif>

	<cfif returnValue is 0>
		<cfif Not IsDefined("fn_FormValidateDateTime")>
			<cfinclude template="../../include/function/fn_datetime.cfm">
		</cfif>

		<cfset Form = Arguments>
		<cfset Variables.doAction = "insertTask">
		<cfinvoke component="#Application.billingMapping#data.Task" method="maxlength_Task" returnVariable="maxlength_Task" />

		<cfset Form.taskDateScheduled_date = DateFormat(Arguments.taskDateScheduled, "mm/dd/yyyy")>
		<cfset Form.taskDateScheduled_hh = ListFirst(fn_ConvertFrom24HourFormat(Hour(Arguments.taskDateScheduled)), '|')>
		<cfset Form.taskDateScheduled_mm = Minute(Arguments.taskDateScheduled)>
		<cfset Form.taskDateScheduled_tt = TimeFormat(Arguments.taskDateScheduled, "tt")>

		<cfif Not Application.objWebServiceSession.isUserAuthorizedWS("insertTaskForOthers", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
			<cfset insertUpdateTaskForOthers = False>
		<cfelse>
			<cfset insertUpdateTaskForOthers = True>
			<!--- <cfset qry_selectUserCompanyList_company = QueryNew("userID")> --->
			<cfset temp = QueryAddRow(qry_selectUserCompanyList_company, 1)>
			<cfset temp = QuerySetCell(qry_selectUserCompanyList_company, "userID", ToString(Arguments.userID_agent), 1)>
		</cfif>

		<cfset wsSessionUserID = qry_selectWebServiceSession.userID>
		<cfinclude template="../../view/v_task/lang_insertUpdateTask.cfm">
		<cfinclude template="../../control/c_task/formValidate_insertUpdateTask.cfm">

		<cfif isAllFormFieldsOk is False>
			<cfset returnValue = -1>
			<cfset returnError = "">
			<cfloop Collection="#errorMessage_fields#" Item="field">
				<cfset returnError = ListAppend(returnError, StructFind(errorMessage_fields, field), Chr(10))>
			</cfloop>
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.Task" Method="insertTask" ReturnVariable="newTaskID">
				<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
				<cfinvokeargument Name="userID_agent" Value="#Arguments.userID_agent#">
				<cfinvokeargument Name="companyID_agent" Value="#companyID_agent#">
				<cfinvokeargument Name="userID_target" Value="#Arguments.userID_target#">
				<cfinvokeargument Name="companyID_target" Value="#Arguments.companyID_target#">
				<cfinvokeargument Name="primaryTargetID" Value="#primaryTargetID#">
				<cfinvokeargument Name="targetID" Value="#Arguments.targetID#">
				<cfinvokeargument Name="taskMessage" Value="#Arguments.taskMessage#">
				<cfinvokeargument Name="taskStatus" Value="#Arguments.taskStatus#">
				<cfinvokeargument Name="taskCompleted" Value="#Arguments.taskCompleted#">
				<!--- validate actually creates Arguments.taskDateScheduled, but using Arguments anyway since it is now validated --->
				<cfinvokeargument Name="taskDateScheduled" Value="#Arguments.taskDateScheduled#">
			</cfinvoke>

			<cfset returnValue = newTaskID>
		</cfif><!--- task is valid --->
	</cfif><!--- /target and target type are valid --->
</cfif><!--- user has permission to insert task --->

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

