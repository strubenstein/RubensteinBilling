<cfset errorMessage_fields = StructNew()>

<cfif Variables.doAction is "insertScheduler">
	<cfif Not Application.fn_IsIntegerNonNegative(Form.companyID)>
		<cfset errorMessage_fields.companyID = Variables.lang_insertUpdateScheduler.companyID>
	</cfif>
</cfif>

<cfif Not ListFind("0,1", Form.schedulerStatus)>
	<cfset errorMessage_fields.schedulerStatus = Variables.lang_insertUpdateScheduler.schedulerStatus>
</cfif>

<cfif Trim(Form.schedulerName) is "">
	<cfset errorMessage_fields.schedulerName = Variables.lang_insertUpdateScheduler.schedulerName_blank>
<cfelseif Len(Form.schedulerName) gt maxlength_Scheduler.schedulerName>
	<cfset errorMessage_fields.schedulerName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateScheduler.schedulerName_maxlength, "<<MAXLENGTH>>", maxlength_Scheduler.schedulerName, "ALL"), "<<LEN>>", Len(Form.schedulerName), "ALL")>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Scheduler" Method="checkSchedulerNameIsUnique" ReturnVariable="isSchedulerNameUnique">
		<cfinvokeargument Name="schedulerName" Value="#Form.schedulerName#">
		<cfif Variables.doAction is "updateScheduler">
			<cfinvokeargument Name="schedulerID" Value="#URL.schedulerID#">
		</cfif>
	</cfinvoke>

	<cfif isSchedulerNameUnique is False>
		<cfset errorMessage_fields.schedulerName = Variables.lang_insertUpdateScheduler.schedulerName_unique>
	</cfif>
</cfif>

<cfif Trim(Form.schedulerURL) is "" or Form.schedulerURL is Application.billingUrl
		or Form.schedulerURL is "#Application.billingUrl#/scheduled/">
	<cfset errorMessage_fields.schedulerURL = Variables.lang_insertUpdateScheduler.schedulerURL_blank>
<cfelseif Find(Application.billingUrl, Form.schedulerURL) is not 1 and Find(Application.billingSecureUrl, Form.schedulerURL) is not 1>
	<cfset errorMessage_fields.schedulerURL = Variables.lang_insertUpdateScheduler.schedulerURL_server>
<cfelseif Find(" ", Form.schedulerURL)>
	<cfset errorMessage_fields.schedulerURL = Variables.lang_insertUpdateScheduler.schedulerURL_valid>
<cfelseif Not Find(".cfm", Form.schedulerURL)>
	<cfset errorMessage_fields.schedulerURL = Variables.lang_insertUpdateScheduler.schedulerURL_cfm>
<cfelseif Len(Form.schedulerURL) gt maxlength_Scheduler.schedulerURL>
	<cfset errorMessage_fields.schedulerURL = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateScheduler.schedulerURL_maxlength, "<<MAXLENGTH>>", maxlength_Scheduler.schedulerURL, "ALL"), "<<LEN>>", Len(Form.schedulerURL), "ALL")>
<cfelse><!--- validate that file exists on server --->
	<cfset Variables.scheduledDirectory = Replace(Replace(Form.schedulerURL, Application.billingUrl, "", "ONE"), Application.billingSecureUrl, "", "ONE")>
	<cfset Variables.scheduledDirectory = ListFirst(Replace(Variables.scheduledDirectory, "/", Application.billingFilePathSlash, "ALL"), "?")>
	<cfif Not FileExists(Application.billingFilePath & Variables.scheduledDirectory)>
		<cfset errorMessage_fields.schedulerURL = Variables.lang_insertUpdateScheduler.schedulerURL_exist>
	</cfif>
</cfif>

<cfif Len(Form.schedulerDescription) gt maxlength_Scheduler.schedulerDescription>
	<cfset errorMessage_fields.schedulerDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateScheduler.schedulerDescription_maxlength, "<<MAXLENGTH>>", maxlength_Scheduler.schedulerDescription, "ALL"), "<<LEN>>", Len(Form.schedulerDescription), "ALL")>
</cfif>

<cfif Not IsNumeric(Form.schedulerRequestTimeOut)>
	<cfset Form.schedulerRequestTimeOut = 500>
<cfelseif Not Application.fn_IsIntegerNonNegative(Form.schedulerRequestTimeOut)>
	<cfset errorMessage_fields.schedulerRequestTimeOut = Variables.lang_insertUpdateScheduler.schedulerRequestTimeOut_valid>
<cfelseif Form.schedulerRequestTimeOut gt 500>
	<cfset errorMessage_fields.schedulerRequestTimeOut = Variables.lang_insertUpdateScheduler.schedulerRequestTimeOut_maximum>
</cfif>

<cfif Form.schedulerInterval_method is not "">
	<cfif Not ListFind("once,daily,weekly,monthly", Form.schedulerInterval_method)>
		<cfset errorMessage_fields.schedulerInterval_method = Variables.lang_insertUpdateScheduler.schedulerInterval_method_valid>
	<cfelse>
		<cfset Form.schedulerInterval = Form.schedulerInterval_method>
	</cfif>
<cfelse>
	<cfset Form.schedulerInterval = 0>
	<cfif Form.schedulerInterval_hours is not "">
		<cfif Not Application.fn_IsIntegerNonNegative(Form.schedulerInterval_hours)>
			<cfset errorMessage_fields.schedulerInterval_hours = Variables.lang_insertUpdateScheduler.schedulerInterval_hours_valid>
		<cfelseif Form.schedulerInterval_hours gt 23>
			<cfset errorMessage_fields.schedulerInterval_hours = Variables.lang_insertUpdateScheduler.schedulerInterval_hours_maximum>
		<cfelse>
			<cfset Form.schedulerInterval = Form.schedulerInterval + (Form.schedulerInterval_hours * 60 * 60)>
		</cfif>
	</cfif>

	<cfif Form.schedulerInterval_minutes is not "">
		<cfif Not Application.fn_IsIntegerNonNegative(Form.schedulerInterval_minutes)>
			<cfset errorMessage_fields.schedulerInterval_minutes = Variables.lang_insertUpdateScheduler.schedulerInterval_minutes_valid>
		<cfelseif Form.schedulerInterval_minutes gt 59>
			<cfset errorMessage_fields.schedulerInterval_minutes = Variables.lang_insertUpdateScheduler.schedulerInterval_minutes_maximum>
		<cfelse>
			<cfset Form.schedulerInterval = Form.schedulerInterval + (Form.schedulerInterval_minutes * 60)>
		</cfif>
	</cfif>

	<cfif Form.schedulerInterval_seconds is not "">
		<cfif Not Application.fn_IsIntegerNonNegative(Form.schedulerInterval_seconds)>
			<cfset errorMessage_fields.schedulerInterval_seconds = Variables.lang_insertUpdateScheduler.schedulerInterval_seconds_valid>
		<cfelseif Form.schedulerInterval_seconds gt 59>
			<cfset errorMessage_fields.schedulerInterval_seconds = Variables.lang_insertUpdateScheduler.schedulerInterval_seconds_maximum>
		<cfelse>
			<cfset Form.schedulerInterval = Form.schedulerInterval + Form.schedulerInterval_seconds>
		</cfif>
	</cfif>

	<cfif Form.schedulerInterval is 0>
		<cfset errorMessage_fields.schedulerInterval = Variables.lang_insertUpdateScheduler.schedulerInterval_zero>
	</cfif>
</cfif>

<cfset Form.schedulerDateBegin = "">
<cfset Variables.dateBeginResponse = fn_FormValidateDateTime("begin", "schedulerDateBegin_date", Form.schedulerDateBegin_date, "schedulerDateBegin_hh", Form.schedulerDateBegin_hh, "schedulerDateBegin_mm", Form.schedulerDateBegin_mm, "schedulerDateBegin_tt", Form.schedulerDateBegin_tt)>
<cfif Variables.dateBeginResponse is "" or IsDate(Variables.dateBeginResponse)>
	<cfset Form.schedulerDateBegin = Now()>
<cfelse><!--- IsStruct(Variables.dateBeginResponse) --->
	<cfloop Collection="#Variables.dateBeginResponse#" Item="field">
		<cfset errorMessage_fields["#field#"] = StructFind(Variables.dateBeginResponse, field)>
	</cfloop>
</cfif>

<cfset Form.schedulerDateEnd = "">
<cfset Variables.dateEndResponse = fn_FormValidateDateTime("end", "schedulerDateEnd_date", Form.schedulerDateEnd_date, "schedulerDateEnd_hh", Form.schedulerDateEnd_hh, "schedulerDateEnd_mm", Form.schedulerDateEnd_mm, "schedulerDateEnd_tt", Form.schedulerDateEnd_tt)>
<cfif Variables.dateEndResponse is "" or IsDate(Variables.dateEndResponse)>
	<cfset Form.schedulerDateEnd = Variables.dateEndResponse>
<cfelse><!--- IsStruct(Variables.dateEndResponse) --->
	<cfloop Collection="#Variables.dateEndResponse#" Item="field">
		<cfset errorMessage_fields["#field#"] = StructFind(Variables.dateEndResponse, field)>
	</cfloop>
</cfif>

<!--- check that end begin date/time is before end date/time --->
<cfif StructIsEmpty(errorMessage_fields) and IsDate(Form.schedulerDateBegin) and IsDate(Form.schedulerDateEnd)
	 	and DateCompare(Form.schedulerDateBegin, Form.schedulerDateEnd) is not -1>
	<cfset errorMessage_fields.schedulerDateEnd = Variables.lang_insertUpdateScheduler.schedulerDateEnd>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertScheduler">
		<cfset errorMessage_title = Variables.lang_insertUpdateScheduler.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertUpdateScheduler.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateScheduler.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdateScheduler.errorFooter>
</cfif>

