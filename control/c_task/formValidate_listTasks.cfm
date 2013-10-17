<!--- <cfset errorMessage_fields = StructNew()> --->

<cfif IsDefined("Form.userID_agent") and Trim(Form.userID_agent) is not "" and Not Application.fn_IsIntegerList(Form.userID_agent)>
	<cfset errorMessage_fields.userID_agent = lang_listTasks.userID_agent>
</cfif>

<cfif IsDefined("Form.userID_author") and Trim(Form.userID_author) is not "" and Not Application.fn_IsIntegerList(Form.userID_author)>
	<cfset errorMessage_fields.userID_author = lang_listTasks.userID_author>
</cfif>

<cfloop Index="field" List="taskDateCreated_from,taskDateCreated_to,taskDateUpdated_from,taskDateUpdated_to,taskDateScheduled_from,taskDateScheduled_to">
	<cfif IsDefined("Form.#field#") and Form[field] is not "" and Not IsDate(Form[field])>
		<cfset errorMessage_fields[field] = lang_listTasks[field]>
	</cfif>
</cfloop>

<cfset Form.taskDateFrom = "">
<cfset methodStruct.dateBeginResponse = fn_FormValidateDateTime("begin", "taskDateFrom_date", Form.taskDateFrom_date, "taskDateFrom_hh", Form.taskDateFrom_hh, "taskDateFrom_mm", Form.taskDateFrom_mm, "taskDateFrom_tt", Form.taskDateFrom_tt)>
<cfif IsDate(methodStruct.dateBeginResponse)>
	<cfset Form.taskDateFrom = methodStruct.dateBeginResponse>
<cfelseif IsStruct(methodStruct.dateBeginResponse)>
	<cfloop Collection="#methodStruct.dateBeginResponse#" Item="field">
		<cfset errorMessage_fields["#field#"] = StructFind(methodStruct.dateBeginResponse, field)>
	</cfloop>
</cfif>

<cfset Form.taskDateTo = "">
<cfset methodStruct.dateEndResponse = fn_FormValidateDateTime("end", "taskDateTo_date", Form.taskDateTo_date, "taskDateTo_hh", Form.taskDateTo_hh, "taskDateTo_mm", Form.taskDateTo_mm, "taskDateTo_tt", Form.taskDateTo_tt)>
<cfif IsDate(methodStruct.dateEndResponse)>
	<cfset Form.taskDateTo = methodStruct.dateEndResponse>
<cfelseif IsStruct(methodStruct.dateEndResponse)>
	<cfloop Collection="#methodStruct.dateEndResponse#" Item="field">
		<cfset errorMessage_fields["#field#"] = StructFind(methodStruct.dateEndResponse, field)>
	</cfloop>
</cfif>

<!--- check that end begin date/time is before end date/time --->
<cfif StructIsEmpty(errorMessage_fields) and IsDate(Form.taskDateFrom) and IsDate(Form.taskDateTo)
		and DateCompare(Form.taskDateFrom, Form.taskDateTo) is not -1>
	<cfset errorMessage_fields.taskDateTo = lang_listTasks.taskDateTo>
</cfif>

<cfloop Index="field" List="taskStatus,taskCompleted,taskAll,taskAllForThisUser,taskAllForThisCompany">
	<cfif IsDefined("Form.#field#") and Form[field] is not "" and Not ListFind("0,1", Form[field])>
		<cfset errorMessage_fields["#field#"] = lang_listTasks["#field#"]>
	</cfif>
</cfloop>

<cfif Not Application.fn_IsIntegerPositive(Form.queryDisplayPerPage)>
	<cfset errorMessage_fields.queryDisplayPerPage = lang_listTasks.queryDisplayPerPage>
</cfif>

<cfif Not Application.fn_IsIntegerPositive(Form.queryPage)>
	<cfset errorMessage_fields.queryPage = lang_listTasks.queryPage>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset methodStruct.isAllFormFieldsOk = True>
<cfelse>
	<cfset methodStruct.isAllFormFieldsOk = False>
	<cfset errorMessage_title = lang_listTasks.errorTitle>
	<cfset errorMessage_header = lang_listTasks.errorHeader>
	<cfset errorMessage_footer = lang_listTasks.errorFooter>
</cfif>

