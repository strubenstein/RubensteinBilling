<!--- <cfset errorMessage_fields = StructNew()> --->

<cfif IsDefined("Form.userID_author") and Trim(Form.userID_author) is not "" and Not Application.fn_IsIntegerList(Form.userID_author)>
	<cfset errorMessage_fields.userID_author = lang_listNotes.userID_author>
</cfif>

<cfloop Index="field" List="noteDateCreated_from,noteDateCreated_to,noteDateUpdated_from,noteDateUpdated_to">
	<cfif IsDefined("Form.#field#") and Form[field] is not "" and Not IsDate(Form[field])>
		<cfset errorMessage_fields[field] = lang_listNotes[field]>
	</cfif>
</cfloop>

<cfset Form.noteDateCreated_from = "">
<cfset methodStruct.dateBeginResponse = fn_FormValidateDateTime("begin", "noteDateFrom_date", Form.noteDateFrom_date, "noteDateFrom_hh", Form.noteDateFrom_hh, "noteDateFrom_mm", Form.noteDateFrom_mm, "noteDateFrom_tt", Form.noteDateFrom_tt)>
<cfif IsDate(methodStruct.dateBeginResponse)>
	<cfset Form.noteDateCreated_from = methodStruct.dateBeginResponse>
<cfelseif IsStruct(methodStruct.dateBeginResponse)>
	<cfloop Collection="#methodStruct.dateBeginResponse#" Item="field">
		<cfset errorMessage_fields[field] = StructFind(methodStruct.dateBeginResponse, field)>
	</cfloop>
</cfif>

<cfset Form.noteDateCreated_to = "">
<cfset methodStruct.dateEndResponse = fn_FormValidateDateTime("end", "noteDateTo_date", Form.noteDateTo_date, "noteDateTo_hh", Form.noteDateTo_hh, "noteDateTo_mm", Form.noteDateTo_mm, "noteDateTo_tt", Form.noteDateTo_tt)>
<cfif IsDate(methodStruct.dateEndResponse)>
	<cfset Form.noteDateCreated_to = methodStruct.dateEndResponse>
<cfelseif IsStruct(methodStruct.dateEndResponse)>
	<cfloop Collection="#methodStruct.dateEndResponse#" Item="field">
		<cfset errorMessage_fields[field] = StructFind(methodStruct.dateEndResponse, field)>
	</cfloop>
</cfif>

<!--- check that end begin date/time is before end date/time --->
<cfif StructIsEmpty(errorMessage_fields) and IsDate(Form.noteDateCreated_from) and IsDate(Form.noteDateCreated_to)
		and DateCompare(Form.noteDateCreated_from, Form.noteDateCreated_to) is not -1>
	<cfset errorMessage_fields.noteDateTo = lang_listNotes.noteDateTo>
</cfif>

<cfif IsDefined("Form.noteStatus") and Form.noteStatus is not "" and Not ListFind("0,1", Form.noteStatus)>
	<cfset errorMessage_fields.noteStatus = lang_listNotes.noteStatus>
</cfif>

<cfif Not Application.fn_IsIntegerPositive(Form.queryDisplayPerPage)>
	<cfset errorMessage_fields.queryDisplayPerPage = lang_listNotes.queryDisplayPerPage>
</cfif>

<cfif Not Application.fn_IsIntegerPositive(Form.queryPage)>
	<cfset errorMessage_fields.queryPage = lang_listNotes.queryPage>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset methodStruct.isAllFormFieldsOk = True>
<cfelse>
	<cfset methodStruct.isAllFormFieldsOk = False>
	<cfset errorMessage_title = lang_listNotes.errorTitle>
	<cfset errorMessage_header = lang_listNotes.errorHeader>
	<cfset errorMessage_footer = lang_listNotes.errorFooter>
</cfif>

