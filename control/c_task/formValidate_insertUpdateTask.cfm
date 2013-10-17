<cfif Not IsDefined("errorMessage_fields")>
	<cfset errorMessage_fields = StructNew()>
</cfif>

<cfif Form.userID_agent is not wsSessionUserID and Form.userID_agent is not 0
		and (Not IsDefined("qry_selectUserList") or Not ListFind(ValueList(qry_selectUserList.userID), Form.userID_agent))>
	<cfset errorMessage_fields.userID_agent = lang_insertUpdateTask.userID_agent>
</cfif>

<cfif Trim(Form.taskMessage) is "">
	<cfset errorMessage_fields.taskMessage = lang_insertUpdateTask.taskMessage_blank>
<cfelseif Len(Form.taskMessage) gt maxlength_Task.taskMessage>
	<cfset errorMessage_fields.taskMessage = ReplaceNoCase(ReplaceNoCase(lang_insertUpdateTask.taskMessage_maxlength, "<<MAXLENGTH>>", maxlength_Task.taskMessage, "ALL"), "<<LEN>>", Len(Form.taskMessage), "ALL")>
</cfif>

<cfif Not ListFind("0,1", Form.taskStatus)>
	<cfset errorMessage_fields.taskStatus = lang_insertUpdateTask.taskStatus>
</cfif>

<cfif Not ListFind("0,1", Form.taskCompleted)>
	<cfset errorMessage_fields.taskCompleted = lang_insertUpdateTask.taskCompleted>
</cfif>

<cfset Form.taskDateScheduled = "">
<cfset dateBeginResponse = fn_FormValidateDateTime("task", "taskDateScheduled_date", Form.taskDateScheduled_date, "taskDateScheduled_hh", Form.taskDateScheduled_hh, "taskDateScheduled_mm", Form.taskDateScheduled_mm, "taskDateScheduled_tt", Form.taskDateScheduled_tt)>
<cfif IsDate(dateBeginResponse)>
	<cfset Form.taskDateScheduled = dateBeginResponse>
<cfelse><!--- IsStruct(dateBeginResponse) --->
	<cfloop Collection="#dateBeginResponse#" Item="field">
		<cfset errorMessage_fields["#field#"] = StructFind(dateBeginResponse, field)>
	</cfloop>
</cfif>

<cfif IsDate(Form.taskDateScheduled) and DateCompare(Now(), Form.taskDateScheduled) is not -1>
	<cfset errorMessage_fields.taskDateScheduled = lang_insertUpdateTask.taskDateScheduled>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset taskStruct.isAllFormFieldsOk = True>
<cfelse>
	<cfset taskStruct.isAllFormFieldsOk = False>
	<cfif taskStruct.doAction is "insertTask">
		<cfset errorMessage_fields.errorMessage_title = lang_insertUpdateTask.errorTitle_insert>
	<cfelse><!--- updateTask --->
		<cfset errorMessage_fields.errorMessage_title = lang_insertUpdateTask.errorTitle_update>
	</cfif>
	<cfset errorMessage_fields.errorMessage_header = lang_insertUpdateTask.errorHeader>
	<cfset errorMessage_fields.errorMessage_footer = lang_insertUpdateTask.errorFooter>
</cfif>
