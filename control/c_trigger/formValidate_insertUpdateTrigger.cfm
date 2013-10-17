<cfset errorMessage_fields = StructNew()>

<cfif Not ListFind("0,1", Form.triggerStatus)>
	<cfset errorMessage_fields.triggerStatus = Variables.lang_insertUpdateTrigger.triggerStatus>
</cfif>

<cfif Len(Form.triggerDescription) gt maxlength_Trigger.triggerDescription>
	<cfset errorMessage_fields.triggerDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateTrigger.triggerDescription_maxlength, "<<MAXLENGTH>>", maxlength_Trigger.triggerDescription, "ALL"), "<<LEN>>", Len(Form.triggerDescription), "ALL")>
</cfif>

<cfif Form.triggerDateBegin is not "" and Not IsDate(Form.triggerDateBegin)>
	<cfset errorMessage_fields.triggerDateBegin = Variables.lang_insertUpdateTrigger.triggerDateBegin>
</cfif>

<cfif Form.triggerDateEnd is not "" and Not IsDate(Form.triggerDateEnd)>
	<cfset errorMessage_fields.triggerDateEnd = Variables.lang_insertUpdateTrigger.triggerDateEnd>
<cfelseif IsDate(Form.triggerDateEnd) and IsDate(Form.triggerDateBegin) and DateCompare(Form.triggerDateBegin,Form.triggerDateEnd) is -1>
	<cfset errorMessage_fields.triggerDateBeginEnd = Variables.lang_insertUpdateTrigger.triggerDateBeginEnd>
</cfif>

<cfif Trim(Form.triggerFilename) is "">
	<cfset errorMessage_fields.triggerFilename = Variables.lang_insertUpdateTrigger.triggerFilename_blank>
<cfelseif Len(Form.triggerFilename) gt maxlength_Trigger.triggerFilename>
	<cfset errorMessage_fields.triggerFilename = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateTrigger.triggerFilename_maxlength, "<<MAXLENGTH>>", maxlength_Trigger.triggerFilename, "ALL"), "<<LEN>>", Len(Form.triggerFilename), "ALL")>
<cfelseif ListFindNoCase("Application.cfm,index.cfm,OnRequestEnd.cfm,Application.cfc", Form.triggerFilename)>
	<cfset errorMessage_fields.triggerFilename = Variables.lang_insertUpdateTrigger.triggerFilename_reserved>
<cfelseif Not FileExists(triggerDirStruct.companyTriggerDirectoryPath & Application.billingFilePathSlash & Form.triggerFilename)>
	<cfset errorMessage_fields.triggerFilename = Variables.lang_insertUpdateTrigger.triggerFilename_exist>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
	<cfif Form.triggerDateBegin is not "">
		<cfset Form.triggerDateBegin = CreateDateTime(Year(Form.triggerDateBegin), Month(Form.triggerDateBegin), Day(Form.triggerDateBegin), 00, 00, 00)>
	</cfif>
	<cfif Form.triggerDateEnd is not "">
		<cfset Form.triggerDateEnd = CreateDateTime(Year(Form.triggerDateEnd), Month(Form.triggerDateEnd), Day(Form.triggerDateEnd), 23, 59, 00)>
	</cfif>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertTrigger">
		<cfset errorMessage_title = Variables.lang_insertUpdateTrigger.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertUpdateTrigger.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateTrigger.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdateTrigger.errorFooter>
</cfif>
