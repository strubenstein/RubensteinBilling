<cfset errorMessage_fields = StructNew()>

<cfif Not Application.fn_IsIntegerNonNegative(Form.statusOrder) or Form.statusOrder gt qry_selectStatusList.RecordCount>
	<cfset errorMessage_fields.statusOrder = Variables.lang_insertUpdateStatus.statusOrder>
</cfif>

<cfloop Index="field" List="statusStatus,statusDisplayToCustomer">
	<cfif Not ListFind("0,1", Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_insertUpdateStatus[field]>
	</cfif>
</cfloop>

<cfif Len(Form.statusDescription) gt maxlength_Status.statusDescription>
	<cfset errorMessage_fields.statusDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateStatus.statusDescription_maxlength, "<<MAXLENGTH>>", maxlength_Status.statusDescription, "ALL"), "<<LEN>>", Len(Form.statusDescription), "ALL")>
</cfif>

<cfif Trim(Form.statusName) is "">
	<cfset errorMessage_fields.statusName = Variables.lang_insertUpdateStatus.statusName_blank>
<cfelseif Len(Form.statusName) gt maxlength_Status.statusName>
	<cfset errorMessage_fields.statusName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateStatus.statusName_maxlength, "<<MAXLENGTH>>", maxlength_Status.statusName, "ALL"), "<<LEN>>", Len(Form.statusName), "ALL")>
<cfelse>
	<cfset Variables.statusRow = ListFind(ValueList(qry_selectStatusList.statusName), Form.statusName)>
	<cfif Variables.statusRow is not 0 and qry_selectStatusList.statusID[Variables.statusRow] is not URL.statusID>
		<cfset errorMessage_fields.statusName = Variables.lang_insertUpdateStatus.statusName_unique>
	</cfif>
</cfif>

<cfif Form.statusID_custom is not "">
	<cfif Len(Form.statusID_custom) gt maxlength_Status.statusID_custom>
		<cfset errorMessage_fields.statusID_custom = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateStatus.statusID_custom_maxlength, "<<MAXLENGTH>>", maxlength_Status.statusID_custom, "ALL"), "<<LEN>>", Len(Form.statusID_custom), "ALL")>
	<cfelse>
		<cfset Variables.statusRow = ListFind(ValueList(qry_selectStatusList.statusID_custom), Form.statusID_custom)>
		<cfif Variables.statusRow is not 0 and qry_selectStatusList.statusID[Variables.statusRow] is not URL.statusID>
			<cfset errorMessage_fields.statusID_custom = Variables.lang_insertUpdateStatus.statusID_custom_unique>
		</cfif>
	</cfif>
</cfif>

<cfif Trim(Form.statusTitle) is "">
	<cfset errorMessage_fields.statusTitle = Variables.lang_insertUpdateStatus.statusTitle_blank>
<cfelseif Len(Form.statusTitle) gt maxlength_Status.statusTitle>
	<cfset errorMessage_fields.statusTitle = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateStatus.statusTitle_maxlength, "<<MAXLENGTH>>", maxlength_Status.statusTitle, "ALL"), "<<LEN>>", Len(Form.statusTitle), "ALL")>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif URL.statusID is 0>
		<cfset errorMessage_title = Variables.lang_insertUpdateStatus.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertUpdateStatus.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateStatus.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdateStatus.errorFooter>
</cfif>

